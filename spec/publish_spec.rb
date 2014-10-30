require "spec_helper"

RSpec.describe MockRedisPubsub do

  let(:event) { {event: 'event', message: 'message'} }

  let(:events) { { 'event'=> %w(message), 'event_two'=> %w(my other message messageing)}   }

  before :each do
    @pubsub = MockRedisPubsub::Redis.new
  end


  context ".count" do
    it "returns the number of messages published" do

      @pubsub.channels = events
      count = events.values.reduce(0) { |sum, val| sum+= val.length}
      expect(@pubsub.count).to eq count
    end
  end


  context ".publish" do
    it "allows messages to be sent to a queue" do
      expect {
        @pubsub.publish(*event.values)
      }.to change{@pubsub.count}.from(0).to(1)
    end
  end

  context ".channels" do
    it "provides a list of channels matching a pattern" do
      @pubsub.channels  = events
      expect(@pubsub.channels "event").to eq ['event']
    end

    it "provides a list of channels matching a pattern" do
      @pubsub.publish(*event.values)
      expect(@pubsub.channels /vent/).to eq [event.values.first]
    end

    it "returns all channels for a nil" do
      @pubsub.publish(*event.values)
      expect(@pubsub.channels).to eq [event.values.first]
    end


  end


  context ".messages" do
    it "returns the messages matching a value" do
      @pubsub.channels = events
      value = %w(message message)
      expect(@pubsub.messages /event/, 'message').to eq value
    end
    it "returns the messages matching a pattern" do
      @pubsub.channels = events
      value = %w(message message messageing)
      expect(@pubsub.messages /event/, /message/).to eq value
    end
  end

  context ".published?" do
    before(:each) do
      @pubsub.publish(*event.values)
    end
    it "returns true if exact" do
      expect(@pubsub.published? "event", "message").to eq true
    end

    it "returns true with regex on event and message" do
      expect(@pubsub.published?  /vent/, /sage/).to eq true
    end

    it "returns true with regex on event only" do
      expect(@pubsub.published?  /vent/).to eq true
    end

    it "returns true with regex on message only" do
      expect(@pubsub.published?  nil, /sage/).to eq true
    end

    it "returns false with wrong regex" do
      expect(@pubsub.published? /rah/, /yup/).to eq false
    end

    it "returns false with event correct and message wrong" do
      expect(@pubsub.published? /vent/, /yup/).to eq false
    end

  end



  # context ".psubscribe" do
  #   it 'subscribes to a channel' do
  #     @pubsub.psubscribe("test_channel")  {}
  #
  #     expect(@pubsub.subscribed_to? 'test_channel').to eq true
  #   end
  # end
end
