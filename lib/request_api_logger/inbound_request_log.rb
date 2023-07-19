class InboundRequestLog
  attr_accessor :request_body, :path, :request_method, :started_at, :response_body, :response_code, :service_name, :ended_at

  def initialize(attributes)
    @path = attributes[:path]
    @request_body = attributes[:request_body]
    @http_method = attributes[:http_method]
    @started_at = attributes[:started_at]
  end

  def self.from_request(request)
    request_body = (request.body.respond_to?(:read) ? request.body.read : request.body)
    body = request_body ? request_body.dup.force_encoding("UTF-8") : nil
    begin
      body = JSON.parse(body) if body.present?
    rescue JSON::ParserError
      body
    end

    self.new(path: request.path, request_body: body, request_method: request.method, started_at: Time.current)
  end

  def audit_request(response_body: nil, response_code: nil)
    config = RequestApiLogger.config

    @response_body = response_body
    @response_code = response_code
    @service_name = config.service_name
    @ended_at = Time.current

    begin
      kafka = Kafka.new([config.kafka_endpoint], client_id: config.kafka_client_id)
      producer = kafka.producer

      # Produce the message
      producer.produce(self.to_json, topic: config.kafka_logger_topic)

      # Deliver the message to Kafka
      producer.deliver_messages
    rescue Kafka::Error => e
      # Handle Kafka errors here
      puts "Error while delivering the message: #{e.message}"
    ensure
      producer&.shutdown
    end
  end
end
