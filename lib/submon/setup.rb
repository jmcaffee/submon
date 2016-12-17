##############################################################################
# File::    setup.rb
# Purpose:: Submon Application Setup
#
# Author::    Jeff McAffee 12/12/2016
# Copyright:: Copyright (c) 2016, kTech Systems LLC. All rights reserved.
# Website::   http://ktechsystems.com
##############################################################################

module Submon
  class Setup

    def initialize

    end

    def execute
      puts "Setting up Submon"
      puts

      setup_db
      setup_gw
      setup_sheets_api
      setup_spreadsheets

      puts
      puts "Setup complete."
      puts
    end

    def setup_db
      puts "Creating database"
      db = Submon::Database.new
      if File.exist?(db.filepath)
        puts "  Database file already exists. Skipping creation..."
        puts "  Delete #{db.filepath} and run 'init' again to re-create it."
        puts
      else
        db.create_database
      end
    end

    def setup_gw
      Gamewisp.load_configuration

      unless Gamewisp.configuration.client_secret.nil?
        puts "It looks like you've already configured Gamewisp."
        puts "Do you want to re-configure Gamewisp? (y/n)"
        do_setup = get_input
        return unless do_setup.downcase == "y"
      end

      puts "Initializing Gamewisp client"

      require 'open-uri'
      extern_ip = open("http://ident.me").read
      print_gamewisp_instructions extern_ip

      puts "  Enter client ID:"
      client_id = get_input
      puts

      puts "  Enter client secret:"
      client_secret = get_input
      puts

      puts " Enter endpoint host (default: #{extern_ip}):"
      endpoint_host = get_input
      #endpoint_host ||= "localhost"
      endpoint_host ||= extern_ip
      puts

      puts "  Enter endpoint port (default: 8080):"
      endpoint_port = get_input
      endpoint_port ||= "8080"
      puts

      Gamewisp.configure do |config|
        config.client_id = client_id
        config.client_secret = client_secret
        config.endpoint_host = endpoint_host
        config.endpoint_port = endpoint_port
      end

      Gamewisp.save_configuration

      puts "ID: #{client_id}"
      puts "Secret: #{client_secret}"
      puts "Host: #{endpoint_host}"
      puts "Port: #{endpoint_port}"
      puts

      puts "Authorizing application..."

      client = Gamewisp::Client.new
      client.authorize
    end

    def print_gamewisp_instructions ip
      puts "= Gamewisp Setup ="
      puts
      puts "- Sign in to your Gamewisp account"
      puts "- Go to 'Channel Settings'"
      puts "- Go to 'API'"
      puts "- Enter '#{Submon::APPNAME}' for an Application Name"
      puts "- Enter 'http://#{ip}:8080' for a Redirect URL"
      puts "- Click Generate Application"
      puts
      puts "The Application Name and the Redirect URL must match exactly"
      puts "or Gamewisp will not consider the application requesting"
      puts "authentication to be valid."
      puts
      puts "Copy and paste the Identifier and Secret generated by Gamewisp"
      puts "into the following questions."
      puts
    end

    def setup_sheets_api
      puts "= Google Sheets API Setup ="
      puts
      puts "Generate credentials for the Google Sheets API"
      puts
      puts "On a computer with a browser, perform the following steps to create a"
      puts "'client_secret.json' file."
      puts
      puts "- Go to https://console.developers.google.com/start/api?id=sheets.googleapis.com"
      puts "- Click 'Continue', then 'Go to credentials'"
      puts "- On the 'Add credentials to your project' page, click the 'Cancel' button"
      puts "- At the top of the page, select the 'OAuth consent screen' tab"
      puts "  - Select an Email address, enter 'Submon' for a Product name"
      puts "    and click the Save button"
      puts "- Select the 'Credentials' tab"
      puts "  - click the 'Create credentials' button and select 'OAuth client ID'"
      puts "- Select the application type 'Other'"
      puts "  - enter the name 'Submon', and click the 'Create' button"
      puts "- Click 'OK' to dismiss the resulting dialog"
      puts "- Click the down arrow icon (Download JSON) button to the right of the client ID"
      puts "  - Save the 'client_secret_xxxxxxx.json' file"
      puts "  - Rename the 'client_secret_xxxxxxx.json' file to 'client_secret.json'"
      puts
      puts "Upload the saved 'client_secret.json' file to"
      puts "#{Submon.app_data_path} on this machine."
      puts
      puts "Setup will continue when file is detected, or type [q] to quit..."
      puts

      while ! client_secret_file_found
        if get_key_press == "q"
          puts "  Quitting..."
          return
        end
        sleep 1
      end

      puts "File detected..."
      puts
      puts "Press [Enter] to attempt authorization..."
      enter = get_input

      puts
      Submon::Sheets::SheetsApi.new.authorize
    end

    def client_secret_file_found
      secret_file = File.join(Submon.app_data_path, "client_secret.json")

      if File.exist?(secret_file)
        return true
      end

      return false
    end

    def setup_spreadsheets
      setup_username_spreadsheet
      setup_admin_spreadsheet

      puts "Initializing Username spreadsheet"
      user_sheet = Submon::Sheets::UserSheet.new(Submon.configuration.user_sheet_id)
      user_sheet.reset_sheet

      puts "Initializing Admin spreadsheet"
      admin_sheet = Submon::Sheets::AdminSheet.new(Submon.configuration.admin_sheet_id)
      admin_sheet.reset_sheet
    end

    def setup_username_spreadsheet
      puts "= Create Username Spreadsheet ="

      puts
      puts "Create an empty spreadsheet for users to enter their Gamewisp username"
      puts "and Minecraft IGN on."
      puts
      puts "- Go to https://docs.google.com/spreadsheets/u/0/"
      puts "- Click the 'Blank' sheet icon to create a new spreadsheet"
      puts "- Click the 'Share' button"
      puts "- Give the spreadsheet a name and click 'Save'"
      puts "- Select 'Advanced' (bottom right)"
      puts "  - Under 'Who has access', on the right, click 'Change...'"
      puts "  - Select 'On - Anyone with the link'"
      puts "  - For Access, select 'Can edit'"
      puts "  - Click 'Save' button"
      puts "- Copy the Link and paste it here:"

      link_data = capture_link("Username")
      Submon.configuration.user_sheet_url = link_data[0]
      Submon.configuration.user_sheet_id = link_data[1]
      Submon.save_configuration

      puts "  You will use this link to direct your users to this spreadsheet to enter their IGNs"
      # https://docs.google.com/spreadsheets/d/1igTHYXYS7ve7a17nSLy14wBwlf1-e0r0skXLq_K5e9g/edit?usp=sharing
      puts "- Under 'Owner settings'"
      puts "  - Check 'Prevent editors from changing access...'"
      puts "  - Check 'Disable options to download, print and copy...'"
      puts "  - Click 'Save changes'"
      puts "- Click 'Done'"
      puts
      puts "Hit [Enter] to continue"
      get_input
    end

    def setup_admin_spreadsheet
      puts "= Create Admin Spreadsheet ="

      puts
      puts "Create an empty spreadsheet for modifying/updating stored username data"
      puts
      puts "- Go to https://docs.google.com/spreadsheets/u/0/"
      puts "- Click the 'Blank' sheet icon to create a new spreadsheet"
      puts "- Click the 'Share' button"
      puts "- Give the spreadsheet a name and click 'Save'"
      puts "- Select 'Advanced' (bottom right)"
      puts "  - Under 'Who has access', verify 'Private-Only you can access' is selected"
      puts "- Copy the Link and paste it here:"

      link_data = capture_link("Admin")
      Submon.configuration.admin_sheet_url = link_data[0]
      Submon.configuration.admin_sheet_id = link_data[1]
      Submon.save_configuration

      puts "  You will use this link to edit your username list"
      # https://docs.google.com/spreadsheets/d/1C4wkSzZnNFEzAPcny2abXTYmq0xxX4F-5LCxRJy2YkY/edit?usp=sharing
      puts "- Under 'Owner settings'"
      puts "  - Check 'Prevent editors from changing access...'"
      puts "  - Check 'Disable options to download, print and copy...'"
      puts "  - Click 'Save changes'"
      puts "- Click 'Done'"
      puts
      puts "Hit [Enter] to continue"
      get_input
    end

    def capture_link(link_type)
      done = false
      re = /\/spreadsheets\/d\/([a-zA-Z0-9\-_]+)/
      data = []
      matches = []

      while ! done
        link = get_input
        matches = link.match re

        if matches.nil? || matches.size != 2
          puts "This doesn't seem to be a valid link [#{link}]."
          puts "Please paste your #{link_type} link again."
        else
          done = true
        end
      end

      data[0] = link
      data[1] = matches[1]

      data
    end

    def get_input
      input = $stdin.gets.chomp
      input.strip
      return nil if input.length <= 0
      input
    end

    def get_key_press
      $stdin.echo = false
      $stdin.raw!

      input = $stdin.getc.chr
      if input == "\e" then
        input << $stdin.read_nonblock(3) rescue nil
        input << $stdin.read_nonblock(2) rescue nil
      end
    ensure
      $stdin.echo = true
      $stdin.cooked!

      return input
    end
  end
end

