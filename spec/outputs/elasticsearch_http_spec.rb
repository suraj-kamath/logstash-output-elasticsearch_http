require "logstash/devutils/rspec/spec_helper"
require "logstash/outputs/elasticsearch_http"

describe LogStash::Outputs::ElasticsearchHTTP do
  subject { LogStash::Outputs::ElasticsearchHTTP }
  let(:options) { { "host" => "127.0.0.1" } }

  context "#register" do
    before do
      expect_any_instance_of(Cabin::Channel).to receive(:warn)
        .with(/The elasticsearch_http output is deprecated/)
    end

    it "display a deprecation warning" do
      subject.new(options)
    end

    it "warns that async replication is not supported" do
      options.merge!( { "replication" => "async" })
      expect_any_instance_of(Cabin::Channel).to receive(:warn)
        .with(/Ignoring the async replication/)
      subject.new(options)
    end
  end
end
