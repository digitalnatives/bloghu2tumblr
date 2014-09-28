require 'app_helper'
require 'blog_hu_parser'

describe BlogHuParser do
  let(:xml_file) { File.join(File.dirname(__FILE__), "fixtures/bloghu_digitalnatives_2014_07_10.xml") }
  subject { BlogHuParser.new(xml_file) }

  context 'Parsing XML' do
    context "no file" do
      let(:xml_file)  { "" }
      it "should put a warning if there is no file" do
        expect(subject.xml_file).to be_nil
      end
    end

    context "valid XML file" do
      it "should invoke parse" do
        expect(subject.xml_file).to_not be_nil
      end

      it "should fill posts" do
        expect(subject.posts).to_not be_empty
      end
    end

  end
  context "has attributes" do
    it { subject.respond_to?(:posts) }
  end
end
