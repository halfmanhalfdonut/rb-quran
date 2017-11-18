module QurayolaQuran
  module Models
    class Quran
      include QurayolaQuran::Config::DbConnected

      def get_all_qurans
        qurans = []

        @db.execute "select \"table\", \"version\" from versions" do |row|
          qurans.push({
            :table => row[0],
            :version => row[1]
          })
        end

        qurans
      end

      def get_random_quran
        qurans = get_all_qurans()
        qurans[rand( qurans.length )]
      end
    end
  end
end