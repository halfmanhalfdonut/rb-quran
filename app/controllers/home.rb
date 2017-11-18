require 'singleton'

module QurayolaQuran
  module Controllers
    class Home
      include Singleton

      def randomize
        quran = QurayolaQuran::Models::Quran.new
        random_quran = quran.get_random_quran
        quran_table = random_quran[:table]

        surah = QurayolaQuran::Models::Surah.new
        random_surah = surah.get_random_surah

        verse = QurayolaQuran::Models::Verse.new
        verse_id = verse.get_random_verse( quran_table, random_surah[:id] )
        verse_text = verse.get_verse( quran_table, random_surah[:id], verse_id )

        JSON.generate({
          :response_type => "in_channel",
          :text => "☪ There is no God but God, and Muhammed is God's messenger. ☪",
          :attachments => [
            {
              :title => random_quran[:version],
              :text => "#{random_quran[:version]}  ﷲ #{random_surah[:name]} #{random_surah[:id]}:#{verse_id}  ﷲ #{verse_text}",
              :ts => Time.now().to_i
            }
          ]
        })
      end

    end
  end
end