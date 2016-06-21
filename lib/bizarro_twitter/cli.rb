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

    class_option :user,
                 desc: 'User to pull tweets from for Markov chain seeding',
                 type: :string

    class_option :dry_run,
                 desc: "Don't post to Twitter",
                 type: :boolean,
                 default: false

    desc 'tweet', 'Tweet nonsense'
    def tweet
      validate_user

      # Get a suitably-sized tweet
      tweet = ''
      while tweet.length == 0 || tweet.length > 140
        tweet = markov_chain.make_tweet(twitter.timeline)
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
        @twitter ||= BizarroTwitter::Twitter.new(options[:user], secrets)
      end

      def markov_chain
        @markov_chain ||= BizarroTwitter::Markov.new
      end

      # Only tweet if they have a tweet newer than ours
      def should_post?
        !options[:dry_run] && twitter.their_last_tweet > twitter.our_last_tweet
      end

      def validate_user
        if options[:user].nil?
          puts 'You gotta specify a user to seed from!'
          exit 1
        end
      end
    end
  end
end
