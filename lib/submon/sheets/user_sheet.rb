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

      def initialize(spreadsheet_id)
        super(spreadsheet_id, 'Sheet1!A1:B', 'Sheet1!A2:B')
        @header = ["GameWisp Username", "Minecraft IGN"]
      end

      def reset_sheet
        reset(header)
      end


    end
  end
end
