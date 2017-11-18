require 'sqlite3'
require 'singleton'

module QurayolaQuran
  module Config
    class Database
      include Singleton

      def initialize
        @db = SQLite3::Database.new ENV["QURAN_DB"]
      end

      def get_db
        @db
      end
    end
  end
end