require "rack"
require "action_dispatch"

class MyApp
  def call(env)
    @env = env
    [200, {}, ["Hello World"]]
  end

  def request
    @request ||= Rack::Request.new(@env)
  end
end

RSpec.describe InboundRequestsLoggerMiddleware do
  it "logs a request in the database" do
    app = InboundRequestsLoggerMiddleware.new(MyApp.new)
    request = Rack::MockRequest.new(app)
    response = request.post("/")
    expect(response.status).to eq(200)
    expect(response.body).to eq("Hello World")
  end
end
