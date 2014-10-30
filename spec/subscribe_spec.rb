require "spec_helper"

RSpec.describe MockRedisPubsub do

  let(:min_channel) { {'event' => %w(message)} }
  let(:one_channel) { {'event' => %w(message two three)} }
  let(:two_channels) { {'event' => %w(message), 'event_two' => %w(my other message messageing)} }
  let(:pattern_channels) { {'hello' => ['hello'], 'hallo' => ['hallo'], 'hxllo' => ['hxllo'], 'hllo' => ['hllo'], 'heeello' => ['heeello']} }
  before :each do
    @pubsub = MockRedisPubsub::Redis.new
  end

  context ".subscribe" do
    it "allows objects to subscribe to a channel" do
      @pubsub.channels=one_channel
      expect {
        @pubsub.subscribe(one_channel.keys.first) {}
      }.to change {
        @pubsub.count one_channel.keys.first
      }.from(3).to(0)
    end

    it 'sends messages from subscribed channel' do
      @pubsub.channels=min_channel
      @pubsub.subscribe min_channel.keys.first do |on|
        on.message do |channel, message|
          expect(channel).to eq min_channel.keys.first
        end
      end
    end

    it 'sends ALL messages from subscribed channel' do
      @pubsub.channels=one_channel
      messages = []
      expected = %w(message two three)
      @pubsub.subscribe one_channel.keys.first do |on|
        on.message do |channel, message|
          messages << message
        end
      end
      expect(messages).to eq expected
    end
  end

  context '.psubscribe' do
    before(:each) do
      publish pattern_channels
    end


    it 'processes ?' do
      messages = []
      @pubsub.psubscribe("h?llo") do |on|
        on.message do |channel, message|
          messages << message
        end
      end
      expect(messages).to eq ['hello', 'hallo', 'hxllo']
    end

    it 'processes *' do
      messages = []
      @pubsub.psubscribe("h*llo") do |on|
        on.message do |channel, message|
          messages << message
        end
      end
      expect(messages).to eq ['hello', 'hallo', 'hxllo','hllo','heeello']
    end
    it 'processes []' do
      messages = []
      @pubsub.psubscribe("h[ea]llo") do |on|
        on.message do |channel, message|
          messages << message
        end
      end
      expect(messages).to eq ['hello', 'hallo']
    end
  end

  def publish channels
    channels.keys.each do |channel|
      channels[channel].each do |message|
        @pubsub.publish channel, message
      end
    end
  end

end
