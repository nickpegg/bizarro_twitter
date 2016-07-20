require 'thor'
require 'yaml'

require 'bizarro_twitter/markov'
require 'bizarro_twitter/twitter'

module BizarroTwitter
  # CLI for BizarroTwitter
  class Cli < Thor
    class_option :secrets,
                 desc: 'YAML file that contains twitter secrets',
                 type: :string,
                 default: 'secrets.yml'

    class_option :users,
                 desc: 'Users to pull tweets from for Markov chain seeding',
                 type: :array

    class_option :dry_run,
                 desc: "Don't post to Twitter",
                 type: :boolean,
                 default: false

    class_option :f,
                 desc: 'Post to Twitter no matter what',
                 type: :boolean,
                 default: false

    desc 'tweet', 'Tweet nonsense'
    def tweet
      validate_users

      source_tweets = []
      options[:users].each do |user|
        source_tweets += twitter.timeline(user)
      end

      # Get a suitably-sized tweet
      tweet = ''
      while tweet.length == 0 || tweet.length > 140
        tweet = markov_chain.make_tweet(source_tweets)
      end

      if should_post?
        twitter.client.update tweet
      else
        puts "Would tweet: #{tweet}"
      end
    end

    no_commands do
      def secrets
        @secrets ||= begin
          YAML.load(File.read(options[:secrets]))
        rescue
          puts "Unable to load secrets at: #{options[:secrets]}"
          exit 1
        end
      end

      def twitter
        @twitter ||= BizarroTwitter::Twitter.new(secrets)
      end

      def markov_chain
        @markov_chain ||= BizarroTwitter::Markov.new
      end

      # Only tweet if they have a tweet newer than ours
      def should_post?
        doit = true
        # doit &&= twitter.their_last_tweet(options[:user]) > twitter.our_last_tweet
        doit &&= !options[:dry_run]
        doit ||= options[:f]
        doit
      end

      def validate_users
        bail 'You gotta specify a user to seed from!' if options[:users].nil?
        bail 'You gotta specify a user to seed from!' if options[:users].empty?

        non_string_users = options[:users].select { |u| !u.is_a?(String) }
        bail "The following users are invalid: #{non_string_users}" unless non_string_users.empty?
      end

      def bail(message)
        puts message
        exit 1
      end
    end
  end
end
