module QurayolaQuran
  module Config
    module DbConnected
      def initialize
        @db = Database.instance.get_db
      end
    end
  end
end