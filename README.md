# BizarroTwitter
Make a bizarro Twitter account using Markov chains. Currently hack-level-quality code (look ma, no tests!).

Example: https://twitter.com/realnickpegg

## Usage
```
$ bizarro_twitter
Commands:
  bizarro_twitter help [COMMAND]  # Describe available commands or one specific command
  bizarro_twitter test            # test command do not use
  bizarro_twitter tweet           # Tweet nonsense

Options:
  [--secrets=SECRETS]          # YAML file that contains twitter secrets
                               # Default: secrets.yml
  [--user=USER]                # User to pull tweets from for Markov chain seeding
  [--dry-run]                  # Don't post to Twitter
```

It's meant to be ran as a cronjob, like every 5 minutes. By default it only
tweets if the seed account has a tweet newer than the bizarro account. I think
it's more weird that way, like the bot's stalking that user.

## Setup
You gotta bundle install first!
```
bundle install --path .bundle
```

1. Head over to twitter
2. Create a bizarro account
3. Sign up for API access
4. Get yourself an access token as the bizarro user


Drop the access token, consumer key, and secrets into a YAML file. `secrets.yml` is where the tool looks first. It should look like this:

```yaml
---
consumer_key: 'git'
consumer_secret: 'outta'
access_token: 'here'
access_token_secret: 'punk'
```
