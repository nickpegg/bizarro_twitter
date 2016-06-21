module BizarroTwitter
  # Markov chain nonsense
  class Markov
    def initialize(prefix_len = 1)
      @prefix_length = prefix_len
      @mentions = []

      # Words to throw away from tweets
      @bad_words = %w(RT)
    end

    # Generates a markov table based on the given tweets
    def markov_table(tweets)
      table = {}

      tweets.each do |string|
        prefix = [nil] * @prefix_length

        string.split.each do |word|
          next if @bad_words.include? word

          # Record mentions but don't include in table
          if word.include? '@'
            @mentions << word
            next
          end

          this_prefix = prefix.dup
          counts = table.fetch(this_prefix, Hash.new(0))
          counts[word] += 1

          table[this_prefix] = counts

          prefix.shift
          prefix << word
        end

        # End of the tweet, add a terminating nil
        this_prefix = prefix.dup
        counts = table.fetch(this_prefix, Hash.new(0))
        counts[nil] += 1
        table[this_prefix] = counts
      end

      # pp table
      table
    end

    # Generates a random nonsense tweet based on an Array of tweets
    def make_tweet(tweets)
      table = markov_table(tweets)
      tweet = ''
      prefix = [nil] * @prefix_length

      word = pick_word(table[prefix.dup])

      until word.nil?
        tweet << "#{word} "
        fail 'holy cow! long tweet' if tweet.length > 1000

        prefix.shift
        prefix << word
        word = pick_word(table[prefix.dup])
      end

      # at-mention someone 1/100 of the time
      tweet.prepend("#{@mentions.sample} ") if Random.rand(100) == 0

      tweet.strip
    end

    # Picks a word out of a markov table row
    # row should look like { 'word1': i, 'word2', j, ... }
    def pick_word(words)
      return nil if words.nil?

      weighted_words = []
      words.each_pair do |word, count|
        weighted_words += [word] * count
      end

      weighted_words.sample
    end
  end
end
