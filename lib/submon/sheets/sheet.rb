##############################################################################
# File::    sheets.rb
# Purpose:: Provide API access to google sheets
# 
# Author::    Jeff McAffee 12/07/2016
# Copyright:: Copyright (c) 2016, kTech Systems LLC. All rights reserved.
# Website::   http://ktechsystems.com
##############################################################################

require_relative 'sheets_api'

module Submon
  module Sheets
    class Sheet

      attr_reader :spreadsheet_id
      attr_reader :range_data
      attr_reader :range_full
      attr_reader :api

      def initialize id, full_range, data_range
        @spreadsheet_id = id
        @range_full = full_range
        @range_data = data_range
        @api = SheetsApi.new
      end

      def service
        api.service
      end

      ##
      # Read the spreadsheet data range
      #
      # @return [Array] Array of row data. Empty array if no data.
      def read_data
        response = service.get_spreadsheet_values(spreadsheet_id, range_data)
        if response.values.nil? or response.values.empty?
          # Let response values be an empty array to avoid nil errors.
          response.values = []
        end

        response.values
      end

      ##
      # Write data to the spreadsheet
      #
      # @param range [string] In the form of "Sheetname!A1:B"
      # @param data [Array of Arrays]
      #
      # @return response
      def write_data data, range = range_data
        response = service.update_spreadsheet_value(spreadsheet_id, range, value_range_object(range, data), value_input_option: "RAW")
      end

      ##
      # Clear the entire usernames spreadsheet (including headers)
      #
      # @return response
      def clear
        response = service.clear_values(spreadsheet_id, range_full)
      end

      ##
      # Clear the entire usernames spreadsheet (including headers), then
      # rewrite the headers.
      #
      # @return response
      def reset header
        clear

        new_data = [
          Array(header),
        ]

        response = write_data new_data, range_full
      end

      def value_range_object range, rows
        Google::Apis::SheetsV4::ValueRange.new({range: range, major_dimension: "ROWS", values: rows})
      end
    end
  end
end
