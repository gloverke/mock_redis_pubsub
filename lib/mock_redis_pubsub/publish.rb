
module MockRedisPubsub
  module Publish


    def publish(event, message)
      @channels[event] ||= []
      @channels[event] << message
    end

    def count event=nil
      event ? @channels[event].length : @channels.values.reduce(0) { |count, val| count += val.length}
    end

    def channels pattern=nil
      matcher = create_matcher pattern
      @channels.keys.select { |key| matcher.call(key)}
    end

    def messages channel = nil, message = nil
      matcher = create_matcher message
      channels(channel).map { |key|  @channels[key].select {|msg| matcher.call(msg)}}.flatten
    end

    def waiting_events
      @channels
    end

    def published? event = nil, message= nil

            messages(event,message).length > 0
    end

    protected
    def create_matcher pattern
      matcher = lambda { |channel| channel.eql?(pattern)} if pattern.is_a? String
      matcher = lambda { |channel| channel.gsub(pattern).count > 0} if pattern.is_a? Regexp
      matcher = lambda { |channel| channel.gsub(pattern)} if !matcher
      matcher
    end
  end
end

