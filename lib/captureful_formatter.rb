require 'captureful_formatter/capturer'
require 'captureful_formatter/formatter'
require 'captureful_formatter/notifications'
require 'captureful_formatter/printer'
require 'captureful_formatter/structures'
require 'captureful_formatter/version'
require 'logger'

module CapturefulFormatter
  @@configuration = nil
  class << self

    def configure
      yield configuration if block_given?

      configuration
    end

    def configuration
      @@configuration ||= Configuration.new
    end
  end

  class Configuration
    attr_accessor :project_name

    attr_accessor :output_directory

    # what types to take screenshot
    #
    # @see http://rubydoc.info/gems/rspec-core/RSpec/Core/Metadata
    attr_accessor :target_type

    attr_accessor :template_path

    def logger
      @logger ||= default_logger
    end

    def capturers
      @captures ||= []
    end

    private

    def default_logger
      log = Logger.new($stderr)
      log.level = Logger::INFO

      log
    end
  end
end

CapturefulFormatter.configure do |c|
  c.project_name     = "Your Project"
  c.output_directory = "./.captureful_formatter"
  c.target_type      = [:feature]
  c.template_path    = File.join(File.dirname(__FILE__), "/../templates/test_report.html.erb")
  c.capturers << CapturefulFormatter::Capturer::ScreenShot.new
  c.capturers << CapturefulFormatter::Capturer::Page.new
end

require 'captureful_formatter/rspec_ext/rspec_core_reporter'
require 'captureful_formatter/turnip_ext/turnip_rspec_execute'
