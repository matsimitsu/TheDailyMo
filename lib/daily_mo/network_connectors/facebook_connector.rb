module DailyMo
  module NetworkConnectors
    module FacebookConnector

      require 'mini_fb'

      def profile_picture_url
        "https://graph.facebook.com/#{oauth_uid}/picture?type=large"
      end

      def upload_profile_picture(photo, message = default_message)
        # oauth_uid is default (public) profile album...
        begin
          c = Curl::Easy.new("https://graph.facebook.com/#{oauth_uid}/photos")
          c.multipart_form_post = true
          c.http_post(
            Curl::PostField.file("file", photo.to_file.path),
            Curl::PostField.content('access_token', oauth_token),
            Curl::PostField.content('message', message)
          )
          self.message = message
          self.save!
        rescue Curl::Err => e
          raise e.inspect
        end
      end

      def post_message(message = default_message)
        true # Message is in the picture
      end

      def authenticate
        nil # NOP
      end

      def needs_profile_confimation
        "http://www.facebook.com/home.php?sk=myuploads"
      end

      def human_name
        "Facebook"
      end

    end
  end
end

DailyMo::NetworkConnectors.register_connector("Facebook")
