require "mock_redis_pubsub/version"
require "mock_redis_pubsub/publish"
require "mock_redis_pubsub/subscribe"

module MockRedisPubsub

  class Redis
    include Publish
    include Subscribe


    attr_writer :channels

    def initialize
      @channels = {}
    end
  end
end
