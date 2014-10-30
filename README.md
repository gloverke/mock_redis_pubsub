# MockRedisPubsub

A gem for unit testing code which uses the redis publish/subscribe features.  It mocks out the following features

#### Publish
```
 redis.publish('mychannel.event', message.to_json)
```
#### Subscribe
```
redis.subscribe(["mychannel.event") do |on|
    on.pmessage do |event, data|
        #handle data
    end
end
```
#### Psubscribe
```
redis.psubscribe(["mychannel.*") do |on|
    on.pmessage do |event, data|
        if event.eql? 'mychannel.event'
            #handle data
        end
    end
end
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'mock_redis_pubsub', :git => 'https://github.com/gloverke/mock_redis_pubsub.git'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install mock_redis_pubsub

## Usage

TODO: Write usage instructions here

## Contributing

1. Fork it ( https://github.com/[my-github-username]/mock_redis_pubsub/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
