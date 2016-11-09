##############################################################################
# File::    submon.rb
# Purpose:: Include file for submon (Subscription Monitor)
# 
# Author::    Jeff McAffee 11/07/2016
# Copyright:: Copyright (c) 2016, kTech Systems LLC. All rights reserved.
# Website::   http://ktechsystems.com
##############################################################################

require 'logger'
require_relative 'submon/version'
require 'gamewisp'

module Submon
  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration) if block_given?
  end

  def self.load_configuration cfg_file
    if File.exist? cfg_file
      @configuration = YAML.load_file(cfg_file)
    end
  end

  def self.save_configuration cfg_file = nil
    if cfg_file.nil?
      if configuration.app_path.nil? || configuration.app_path.to_s.empty?
        raise ArgumentError, 'Filename must be provided if app_path not provided'
      end

      cfg_file = File.join(configuration.app_path, 'config.yml')
    end

    raise ArgumentError, 'Directory provided. Need file path' if File.directory?(cfg_file)

    File.open(cfg_file, 'w') do |out|
      YAML.dump(configuration, out)
    end
  end


  class Configuration
    attr_accessor :version
    attr_accessor :app_path
    attr_accessor :logging
    attr_accessor :max_log_size
    attr_accessor :log_dir

    def initialize
      @version = 1
    end
  end
end # module

Submon.configure do |config|
  config.app_path = File.join(ENV['HOME'], '.submon')
  config.log_dir = config.app_path
end

# Require each lib file
#
#require_relative 'submon/asdfasdf'

