##############################################################################
# File::    admin_sheet.rb
# Purpose:: Google spreadsheet admin sheet
# 
# Author::    Jeff McAffee 12/13/2016
# Copyright:: Copyright (c) 2016, kTech Systems LLC. All rights reserved.
# Website::   http://ktechsystems.com
##############################################################################

module Submon
  module Sheets
    class AdminSheet < Sheet

      attr_reader :header
      attr_reader :full_range
      attr_reader :data_range
      attr_reader :id

      def initialize(spreadsheet_id)
        @header = ["Username", "Minecraft IGN", "Source (gw, p, etc.)", "Type (user, op, etc.)", "Status (active, inactive, deleted)", "Action (c, r, u, d)", "Processing Status"]
        @full_range = 'Sheet1!A1:D'
        @data_range = 'Sheet1!A2:D'
        @id = spreadsheet_id
      end

      def reset
        super.reset(header)
      end

    end
  end
end
