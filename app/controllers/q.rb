require 'singleton'
require 'uri'
require 'json'

module QurayolaQuran
  module Controllers
    class Q
      include Singleton

      def get_surah_and_verses( text )
        surah = ""
        verses = ""

        text.split(' ').each do |value|
          splits = value.split(':')

          if splits.length > 1
            surah = splits[0]
            verses = splits[1]
          end
        end

        [ surah, verses ]
      end

      def get_start_and_end_verse( text )
        text.split('-')
      end

      def get_text( qurans, surah_id, start_verse, end_verse )
        text = {}

        if surah_id && start_verse
          verse = QurayolaQuran::Models::Verse.new
          qurans.each do |quran|
            verses = verse.get_verses( quran[:table], surah_id, start_verse, end_verse )
            verses.push({
              :text => quran[:version],
            })

            text[quran[:version]] = verses
          end
        end

        text
      end

      def get_attachments( verse_text )
        attachments = []
        ts = Time.now().to_i # timestamp since epoch

        verse_text.each do |key, value|
          attachment = {}
          attachment[:title] = key

          txt = ""
          value.each do |line|
            if line[:verse]
              txt += "#{line[:verse]} #{line[:text]}\n"
            else
              attachment[:title] = line[:text]
            end
          end

          attachment[:text] = txt
          attachment[:ts] = ts

          attachments.push attachment
        end

        attachments
      end

      def handle
        lambda do
          request.body.rewind
          data = JSON.parse( Hash[URI.decode_www_form( request.body.read )].to_json )

          controller = Q.instance

          # No params sent, just let it fall through to the 404 handler which randomizes
          pass unless data["text"] != ""

          surah, verses = controller.get_surah_and_verses( data["text"] )
          start_verse, end_verse = controller.get_start_and_end_verse( verses )

          quran_db = QurayolaQuran::Models::Quran.new
          qurans = quran_db.get_all_qurans

          verse_text = controller.get_text( qurans, surah, start_verse, end_verse )

          content_type :json
          JSON.generate({
            :response_type => "in_channel",
            :text => "☪ There is no God but God, and Muhammed is God's messenger. ☪",
            :attachments => controller.get_attachments( verse_text )
          })
        end
      end
    end
  end
end