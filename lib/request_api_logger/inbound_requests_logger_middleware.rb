class InboundRequestsLoggerMiddleware
  attr_accessor :config

  def initialize(app)
    @app = app
    @config = RequestApiLogger.config
  end

  def call(env)
    request = ActionDispatch::Request.new(env)
    logging = log?(env, request)
    if logging
      env["INBOUND_REQUEST_LOG"] = InboundRequestLog.from_request(request)
      request.body.rewind
    end
    status, headers, body = @app.call(env)
    if logging
      env["INBOUND_REQUEST_LOG"].audit_request(
        response_body: parsed_body(body),
        response_code: status
      )
    end
    [status, headers, body]
  end

  private

  def log?(env, request)
    env["PATH_INFO"] =~ config.path_regexp && (!config.only_state_change || request_with_state_change?(request))
  end

  def parsed_body(body)
    return if body.blank?

    json_body = if body.respond_to?(:body)
                  body.body
                elsif body.respond_to?(:[])
                  body[0]
                else
                  body
                end

    parse_json(json_body)
  end

  def parse_json(json_body)
    JSON.parse(json_body)
  rescue JSON::ParserError
    json_body
  end

  def request_with_state_change?(request)
    request.post? || request.put? || request.patch? || request.delete?
  end
end
