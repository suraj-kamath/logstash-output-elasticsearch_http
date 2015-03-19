require "logstash/devutils/rspec/spec_helper"
require "logstash/outputs/elasticsearch_http"
require_relative "../support/helpers"

describe LogStash::Outputs::ElasticsearchHTTP do
  let(:options) { { "host" => "127.0.0.1" } }

  context "#register" do
    subject do
      LogStash::Outputs::ElasticsearchHTTP.new(options)
    end

    it 'should register' do
      expect { subject.register }.to_not raise_error
    end

    context 'transform and display current config into the new format ' do
      let(:logger) { MockLogger.new }
      before do
        expect(Cabin::Channel).to receive(:get).at_least(1).with(LogStash).and_return(logger)
      end

      subject do
        LogStash::Outputs::ElasticsearchHTTP.new(options)
        logger.content 
      end

      it "warns that async replication is not supported" do
        options.merge!( { "replication" => "async" })
        expect(subject).to match(/Ignoring the async replication option/)
      end

      # since we are trying to have the same config syntax and
      # Logstash's config isn't json I have to add this kind of guards
      it "uses the elasticsearch output" do
        expect(subject).to match(/elasticsearch {/)
      end

      it "contains host as array" do
        expect(subject).to match(/host => \["127.0.0.1"\]/)
      end

      it "contains the default plain codec" do
        expect(subject).to match(/codec => \"plain\"/)
      end

      it "defaults to one worker" do
        expect(subject).to match(/workers => 1/)
      end

      it "uses the logstash index" do
        expect(subject).to match(/index => \"logstash-%{\+YYYY\.MM\.dd}\"/)
      end

      it "define manages templates" do
        expect(subject).to match(/manage_template => true/)
      end

      it "defines template_name" do
        expect(subject).to match(/template_name => "logstash"/)
      end

      it "defines template_overwrite" do
        expect(subject).to match(/template_overwrite => false/)
      end

      it "defines port" do
        expect(subject).to match(/port => 9200/)
      end

      it "defines the flush_size" do
        expect(subject).to match(/flush_size => 100/)
      end

      it "defines the idle_flush_time" do
        expect(subject).to match(/idle_flush_time => 1/)
      end

      it "defines the protocol to http" do
        expect(subject).to match(/protocol => "http"/)
      end
    end
  end
end
