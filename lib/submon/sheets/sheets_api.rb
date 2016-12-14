##############################################################################
# File::    sheets.rb
# Purpose:: Provide API access to google sheets
# 
# Author::    Jeff McAffee 12/07/2016
# Copyright:: Copyright (c) 2016, kTech Systems LLC. All rights reserved.
# Website::   http://ktechsystems.com
##############################################################################

require 'google/apis/sheets_v4'
require 'googleauth'
require 'googleauth/stores/file_token_store'

require 'fileutils'

module Submon
  module Sheets
    class SheetsApi
      OOB_URI = 'urn:ietf:wg:oauth:2.0:oob'
      CLIENT_SECRETS_PATH = File.join(Submon.app_data_path, 'client_secret.json')
      CREDENTIALS_PATH = File.join(Submon.app_data_path,
                                  "sheets.googleapis.com-submon.yaml")
      #SCOPE = Google::Apis::SheetsV4::AUTH_SPREADSHEETS_READONLY
      SCOPE = Google::Apis::SheetsV4::AUTH_SPREADSHEETS

      ##
      # Ensure valid credentials, either by restoring from the saved credentials
      # files or intitiating an OAuth2 authorization. If authorization is required,
      # the user's default browser will be launched to approve the request.
      #
      # @return [Google::Auth::UserRefreshCredentials] OAuth2 credentials
      def authorize
        FileUtils.mkdir_p(File.dirname(CREDENTIALS_PATH))

        client_id = Google::Auth::ClientId.from_file(CLIENT_SECRETS_PATH)
        token_store = Google::Auth::Stores::FileTokenStore.new(file: CREDENTIALS_PATH)
        authorizer = Google::Auth::UserAuthorizer.new(
          client_id, SCOPE, token_store)
        user_id = 'default'
        credentials = authorizer.get_credentials(user_id)
        if credentials.nil?
          url = authorizer.get_authorization_url(
            base_url: OOB_URI)
          puts "Open the following URL in the browser and enter the " +
              "resulting code after authorization:"
          puts
          puts url
          puts
          puts "Paste auth code here:"
          code = gets
          credentials = authorizer.get_and_store_credentials_from_code(
            user_id: user_id, code: code, base_url: OOB_URI)
        end
        credentials
      end

      ##
      # Generate and return a service singleton object.
      # If authorization isn't already received, it will be requested.
      #
      # @return [Google::Apis::SheetsV4::SheetsService] service
      def service
        return @service unless @service.nil?
        # Initialize the API
        @service = Google::Apis::SheetsV4::SheetsService.new
        @service.client_options.application_name = Submon::APPNAME
        @service.authorization = authorize
        @service
      end

    def self.usernames_sheet
      id = '1qpd2aSfLi7Sp-JnaweW7hCvPqam0uSrD_y-anLZMCTM'
      full_range = 'Sheet1!A1:B'
      data_range = 'Sheet1!A2:B'

      sheet = Sheets.new(id, full_range, data_range)
    end
  end
end
