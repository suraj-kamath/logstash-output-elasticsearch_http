require "logstash/devutils/rspec/spec_helper"
require "logstash/outputs/elasticsearch_http"
require_relative "../support/helpers"

describe LogStash::Outputs::ElasticsearchHTTP do
  subject { LogStash::Outputs::ElasticsearchHTTP }
  let(:options) { { "host" => "127.0.0.1" } }
  let(:logger) { MockLogger.new }

  context "#register" do
    before do
      expect(Cabin::Channel).to receive(:get).at_least(1).with(LogStash).and_return(logger)
    end

    it "warns that async replication is not supported" do
      options.merge!( { "replication" => "async" })
      subject.new(options)

      expect(logger.content).to match(/Ignoring the async replication option/)
    end

    it 'transform your config into the new format' do
      subject.new(options)
      config = %r[
elasticsearch {
    host => \["127.0.0.1"\]
\tcodec => "plain"
\tworkers => 1
\tindex => "logstash-%{+YYYY.MM.dd}"
\tmanage_template => true
\ttemplate_name => "logstash"
\ttemplate_overwrite => false
\tport => 9200
\tflush_size => 100
\tidle_flush_time => 1
\tprotocol => "http"
}]
      expect(logger.content).to match(config)
    end
  end
end
