##############################################################################
# File::    database.rb
# Purpose:: Database for SubMon app
#
# Author::    Jeff McAffee 12/09/2016
# Copyright:: Copyright (c) 2016, kTech Systems LLC. All rights reserved.
# Website::   http://ktechsystems.com
##############################################################################

require 'sequel'

module Submon
  class Database

    attr_accessor :filename
    attr_accessor :filepath

    def initialize(in_memory = false)
      @in_memory = in_memory
    end

    def filename
      'submon.db'
    end

    def filepath
      @filepath ||= File.join(Submon.app_data_path, filename)
    end

    def database
      if closed?
        @database = connect
      end

      @database
    end

    def connect
      return Sequel.sqlite(filepath) unless @in_memory
      Sequel.sqlite
    end

    def close
      unless @database.nil?
        @database.disconnect
        @database = nil
      end
    end

    def closed?
      @database.nil?
    end

    def create_database
      Schema.create_base_schema self
    end

    def schema_version
      database.pragma_get('user_version')
    end

    def drop_all

    end

    def upgrade
      Schema.perform_migrations self
    end

    def execute(sql)
      database.run sql
    end

    def create(data)
      dataset = database[:users]
      dataset.insert(data)
    end

    def read(query)
      dataset = database
    end

    def update(data)

    end

    def delete(query)

    end
    class Schema

      # Update SCHEMA_VERSION when new migrations are added.
      SCHEMA_VERSION = 1 unless defined?(SCHEMA_VERSION)

      def self.create_base_schema(db)
        schema = <<-EOQ
          -- Create the tables
          CREATE TABLE IF NOT EXISTS users (
            id INTEGER PRIMARY KEY,
            name TEXT,
            ign TEXT,
            created TEXT,
            modified TEXT,
            source TEXT,
            status TEXT
          );
        EOQ

        db.execute(schema)

        # Update trigger
        schema = <<-EOQ
          CREATE TRIGGER IF NOT EXISTS update_users AFTER UPDATE ON users
          BEGIN

            UPDATE users SET modified = DATETIME('NOW')
              WHERE rowid = NEW.rowid;

          END;
        EOQ

        db.execute(schema)

        # Insert trigger
        schema = <<-EOQ
          CREATE TRIGGER IF NOT EXISTS insert_users AFTER INSERT ON users
          BEGIN

            UPDATE users SET created = DATETIME('NOW')
              WHERE rowid = NEW.rowid;

            UPDATE users SET modified = DATETIME('NOW')
              WHERE rowid = NEW.rowid;

          END;
        EOQ

        db.execute(schema)

        # Set the schema version
        schema = <<-EOQ
          PRAGMA user_version = 1;
        EOQ

        db.execute(schema)
      end

      def self.perform_migrations(db)
        return unless db.schema_version < SCHEMA_VERSION
        # migrate_to_v2(db)
      end
    end
  end
end
