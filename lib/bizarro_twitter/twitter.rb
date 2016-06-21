require 'twitter'

module BizarroTwitter
  # Twitter wrapper
  class Twitter
    attr_reader :client

    def initialize(user, secrets = {})
      @user = user
      @client = ::Twitter::REST::Client.new do |tw_config|
        tw_config.consumer_key = secrets['consumer_key']
        tw_config.consumer_secret = secrets['consumer_secret']
        tw_config.access_token = secrets['access_token']
        tw_config.access_token_secret = secrets['access_token_secret']
      end
    end

    # Fetch tweets
    def timeline
      tweets = []
      keep_going = true
      max_id = nil
      options = { count: 200, include_rts: false }

      while keep_going
        begin
          options[:max_id] = max_id unless max_id.nil?
          response = @client.user_timeline(@user, options)

          if response.empty?
            keep_going = false
          else
            tweets += response.map(&:full_text)
            max_id = response.last.id - 1
          end
        rescue Twitter::Error::TooManyRequests => e
          sleep_time = e.rate_limit.reset_in + 1
          puts "Got rate-limited, sleeping for #{sleep_time} seconds"
          sleep sleep_time
        end
      end

      tweets
    end

    def our_last_tweet
      options = { count: 1, include_rts: false }
      response = @client.user_timeline(@client.user.screen_name, options)
      response.first.created_at
    end

    def their_last_tweet
      options = { count: 1, include_rts: false }
      response = @client.user_timeline(@user, options)
      response.first.created_at
    end
  end
end
