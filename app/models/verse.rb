module QurayolaQuran
  module Models
    class Verse
      include QurayolaQuran::Config::DbConnected

      def get_random_verse( quran, surah_id )
        count = @db.get_first_value( "select count( \"verse_id\" ) from #{quran} where surah_id = :surah_id", :surah_id => surah_id )
        1 + rand( count )
      end

      def get_verse( quran, surah_id, verse_id )
        @db.get_first_row( "select \"text\" from #{quran} where surah_id = :surah_id and verse_id = :verse_id",
          :surah_id => surah_id,
          :verse_id => verse_id
        )[0]
      end

      def get_verses( quran, surah_id, start_verse_id, end_verse_id )
        verses = []

        if end_verse_id
          range = (start_verse_id .. end_verse_id).to_a
        else
          range = [ start_verse_id ]
        end

        rows = @db.execute( "select \"text\" from #{quran} where surah_id = :surah_id and verse_id in (#{range.join(', ')})", :surah_id => surah_id )

        rows.each_with_index do |row, index|
          verses.push({
            :verse => range[index],
            :text => row[0]
          })
        end

        verses
      end
    end
  end
end