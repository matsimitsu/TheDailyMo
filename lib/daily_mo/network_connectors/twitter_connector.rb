# oauth = Twitter::OAuth.new(TWITTER[:key], TWITTER[:secret])
# oauth.authorize_from_access(TWITTER[account_type][:access_token], TWITTER[account_type][:access_secret])
# 
# tweeter = Twitter::Base.new(oauth)
# if tweeter.update(string)

module DailyMo
  module NetworkConnectors
    module TwitterConnector

      def profile_picture_url(big = true)
        img_url = details['profile_image_url']
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

      def upload_profile_picture(message = nil)
        url = URI.parse('http://twitter.com/account/update_profile_image.json')
        begin
          Net::HTTP.new(url.host, url.port).start do |http|
            req = Net::HTTP::Post.new(url.request_uri)
            add_multipart_data(req, :image => photos.last.photo.to_file)
            add_oauth(req)
            res = http.request(req)
            if 200 == res.code.to_i
              true
            elsif 401 == res.code.to_i
              raise OAuth::Unauthorized, res
            else
              raise "#{res.inspect}"
            end
          end
        rescue Net::HTTPBadGateway
          raise "Something went wrong while uploading your new profile picture (Twitter is over capacity). Please try again later!"
        end
      end

      def post_message(message = nil)
        reply = authenticate.update(message || default_message)
        self.message = reply["text"]
        self.message_link = "http://www.twitter.com/#{reply['user']['screen_name']}/status/#{reply['id']}"
        self.save!
        reply
      end

      def authenticate
        begin
          oauth
        rescue TwitterException => e
          raise ArgumentError, "Sorry, TwitterException occured: #{e}"
        end
      end

      def fill_details
        update_attributes(
          :name        => details['name'],
          :nickname    => details['screen_name'],
          :profile_url => "http://twitter.com/" + details['screen_name']
        )
      end

      def needs_profile_confimation
        false
      end

      def human_name
        "Twitter"
      end

    private

      def details
        @details ||= authenticate.info
      end

      def oauth
        @oauth ||= TwitterOAuth::Client.new(
          :consumer_key    => TWITTER[:key],
          :consumer_secret => TWITTER[:secret],
          :token           => oauth_access_token,
          :secret          => oauth_secret_token
        )
      end

      def consumer
        @consumer ||= OAuth::Consumer.new(TWITTER[:key], TWITTER[:secret], {:site=>'http://twitter.com'} )
      end

    end
  end
end

DailyMo::NetworkConnectors.register_connector("Twitter")