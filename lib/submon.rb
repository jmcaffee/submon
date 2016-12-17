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

module Submon

  APPNAME = "submon" unless defined? APPNAME

  class << self
    attr_accessor :configuration
  end

  def self.system_data_path
    # See [XDG Specs](https://specifications.freedesktop.org/basedir-spec/basedir-spec-0.6.html)
    # for info regarding XDG system directories.
    path = ENV['XDG_DATA_HOME']
    path ||= File.join(Dir.home, '.local', 'share')
  end

  def self.app_data_path(create = false)
    path = File.join(Submon.system_data_path, APPNAME)
    FileUtils.mkdir_p(path) if create
    path
  end

  def self.system_config_path
    path = ENV['XDG_CONFIG_HOME']
    path ||= File.join(Dir.home, '.config')
  end

  def self.app_config_path(create = false)
    path = File.join(Submon.system_config_path, APPNAME)
    FileUtils.mkdir_p(path) if create
    path
  end

  def self.config_file_path
    File.join(Submon.app_config_path(true), 'config.yml')
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration) if block_given?
  end

  def self.load_configuration cfg_file = nil
    cfg_file ||= Submon.config_file_path

    if File.exist? cfg_file
      @configuration = YAML.load_file(cfg_file)
    end
  end

  def self.save_configuration cfg_file = nil
    cfg_file ||= Submon.config_file_path

    raise ArgumentError, 'Directory provided. Need file path' if File.directory?(cfg_file)

    File.open(cfg_file, 'w') do |out|
      YAML.dump(self.configuration, out)
    end
  end


  class Configuration
    attr_accessor :version
    attr_accessor :app_path
    attr_accessor :logging
    attr_accessor :max_log_size
    attr_accessor :log_dir
    attr_accessor :user_sheet_id
    attr_accessor :user_sheet_url
    attr_accessor :admin_sheet_id
    attr_accessor :admin_sheet_url

    def initialize
      @version = 1
    end
  end
end # module

Submon.configure do |config|
  config.app_path = File.absolute_path(File.join(__dir__, ".."))
  #config.log_dir = Submon.app_data_path
  config.log_dir = config.app_path
end

# Require each lib file
#
require 'gamewisp'

require_relative 'submon/sheets'
require_relative 'submon/database'
require_relative 'submon/setup'

Gamewisp.appname = Submon::APPNAME

