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

      def initialize(spreadsheet_id)
        super(spreadsheet_id, 'Sheet1!A1:G', 'Sheet1!A2:G')
        @header = ["Username",
                   "Minecraft IGN",
                   "Source (gw, p, etc.)",
                   "Type (user, op, etc.)",
                   "Status (active, inactive, deleted)",
                   "Action (c, r, u, d)",
                   "Processing Status"]
      end

      def reset_sheet
        reset(header)
      end

    end
  end
end
