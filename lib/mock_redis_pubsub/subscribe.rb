module MockRedisPubsub
  module Subscribe

    def deliver(pattern, &block)
      channels(pattern).each do |channel|
        @channels[channel].each do |message|
          block.call Event.new(channel,message)
        end
        @channels.delete channel
      end
    end

    def subscribe(channel, &block)
      deliver(channel.to_s,&block)
    end

    def psubscribe(channel,&block)
      regex = Regexp.new ("\\A" + channel.sub('?','.').sub('*','.*') + "\\z")
      deliver(regex, &block)
    end

    def quit

    end
  end



  class Event
    def initialize event,message
      @event = event
      @message = message
    end
    def message &block
      block.call(@event,@message)
    end
  end

end

