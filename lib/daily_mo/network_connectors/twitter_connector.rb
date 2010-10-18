module DailyMo
  module NetworkConnectors
    module TwitterConnector

      CRLF = "\r\n"

      def profile_picture_url(big = true)
        img_url = original_profile_pic_url
        img_url.gsub!(/http:\/\/.*\.twimg\.com\//, 'http://s3.amazonaws.com/twitter_production/')
        img_url.gsub!('_normal.', '.') if img_url =~ /_normal\./ && img_url !~ /static\.twitter/ && big
        img_url.gsub!('_bigger.', '.') if img_url =~ /_bigger\./ && img_url !~ /static\.twitter/ && big
        return img_url

        # # maybe a more reliable method in case of caching user data on twitters end
        # # (scrape the profile_image from html page)
        # doc = Hpricot(open("http://twitter.com/#{details['screen_name']}"))
        # # for public timelines
        # tmp = doc.search("//img[@id='profile-image']")
        # # for private timelines
        # tmp = doc.search("//img[@class='profile-img']") unless tmp.first
        # img = tmp.first.get_attribute(['src']) 

      end

      def upload_profile_picture(photo, message = nil)
        url = URI.parse('http://api.twitter.com/1/account/update_profile_image.json')
        begin
          Net::HTTP.new(url.host, url.port).start do |http|
            req = Net::HTTP::Post.new(url.request_uri)
            add_multipart_data(req, :image => photo)
            add_oauth(req)
            res = http.request(req)
            if 200 == res.code.to_i
              true
            elsif 401 == res.code.to_i
              # raise OAuth::Unauthorized, res
              raise res.body.inspect
            else
              raise "#{res.body.inspect} #{res.methods.sort.inspect}"
            end
          end && post_message(message)
        rescue Net::HTTPBadGateway
          raise "Something went wrong while uploading your new profile picture (Twitter is over capacity). Please try again later!"
        end
      end

      def post_message(message = nil)
        tweeter = Twitter::Base.new(authenticate)
        reply = tweeter.update(message || default_message)
        self.message = reply["text"]
        self.message_link = "http://www.twitter.com/#{reply['user']['screen_name']}/status/#{reply['id']}"
        self.save!
        reply
      end

      def authenticate
        oauth = Twitter::OAuth.new(*TheDailyMo::AuthKeys.network_keys_and_secret(:twitter))
        oauth.authorize_from_access(oauth_token, oauth_secret)
        oauth
      end

      def needs_profile_confimation
        false
      end

      def human_name
        "Twitter"
      end

      # Uses the OAuth gem to add the signed Authorization header
      def add_oauth(req)
        oauth = authenticate
        oauth.consumer.sign!(req, oauth.access_token)
      end

      def add_multipart_data(req, params)
        boundary = Time.now.to_i.to_s(16)
        req["Content-Type"] = "multipart/form-data; boundary=#{boundary}"
        req["User-Agent"] = 'curl/7.19.7 (universal-apple-darwin10.0) libcurl/7.1 00fa: 9.7 OpenSSL/0.9.8l zlib/1.2.3'
        body = ""
        params.each do |key,value|
          esc_key = CGI.escape(key.to_s)
          body << "--#{boundary}#{CRLF}"
          if value.respond_to?(:read)
            body << "Content-Disposition: form-data; name=\"#{esc_key}\"; filename=\"#{File.basename(value.path).gsub(',','_')}\"#{CRLF}"
            body << "Content-Type: #{mime_type(value.path)}#{CRLF*2}"
            body << value.read
          else
            body << "Content-Disposition: form-data; name=\"#{esc_key}\"#{CRLF*2}#{value}"
          end
          body << CRLF
        end
        body << "--#{boundary}--#{CRLF*2}"
        req.body = body
        req["Content-Length"] = req.body.size
      end

      # Quick and dirty method for determining mime type of uploaded file
      def mime_type(file)
        case
          when file =~ /\.jpg/ then 'image/jpeg'
          when file =~ /\.gif$/ then 'image/gif'
          when file =~ /\.png$/ then 'image/png'
          else 'application/octet-stream'
        end
      end

    end
  end
end

DailyMo::NetworkConnectors.register_connector("Twitter")
