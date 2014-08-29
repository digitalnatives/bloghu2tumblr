require 'spec_helper'

describe BlogHuParser do
  let(:xml_file) { File.read("/dev/null") }
  context 'Parsing XML' do

    it "should read an XML file" do

    end

  end
  context "has attributes" do
    subject { BlogHuParser.new(xml_file) }
    it { subject.respond_to?(:posts) }
  end
end
