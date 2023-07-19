# frozen_string_literal: true

require "zeitwerk"
require "nokogiri"
require "pry-rails"
require "active_support/all"

loader = Zeitwerk::Loader.for_gem
loader.collapse("#{__dir__}/request_api_logger")
loader.setup

module RequestApiLogger
  class Error < StandardError; end

  extend Dry::Configurable


end
