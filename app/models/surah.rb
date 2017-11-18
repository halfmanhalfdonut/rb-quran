module QurayolaQuran
  module Models
    class Surah
      include QurayolaQuran::Config::DbConnected

      TOTAL_SURAHS = 114

      def get_random_surah
        random_surah = {}

        @db.execute( "select \"id\", \"name\" from surahs where id = :id", :id => 1 + rand( TOTAL_SURAHS ) ) do |row|
          random_surah[:id] = row[0]
          random_surah[:name] = row[1]
        end

        random_surah
      end

      def get_surah_by_name( name )
        surah = {}

        @db.execute( "select \"id\", \"name\" from surahs where name = :name", :name => name )  do |row|
          surah[:id] = row[0]
          surah[:name] = row[1]
        end

        surah
      end
    end
  end
end