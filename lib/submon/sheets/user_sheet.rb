##############################################################################
# File::    user_sheet.rb
# Purpose:: Username Google Spreadsheet object
# 
# Author::    Jeff McAffee 12/13/2016
# Copyright:: Copyright (c) 2016, kTech Systems LLC. All rights reserved.
# Website::   http://ktechsystems.com
##############################################################################

module Submon
  module Sheets
    class UserSheet < Sheet

      attr_reader :header
      attr_reader :full_range
      attr_reader :data_range
      attr_reader :id

      def initialize(spreadsheet_id)
        @header = ["GameWisp Username", "Minecraft IGN"]
        @full_range = 'Sheet1!A1:B'
        @data_range = 'Sheet1!A2:B'
        @id = spreadsheet_id
      end

      def reset_sheet
        reset(header)
      end


    end
  end
end
