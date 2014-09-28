require 'app_helper'
require 'post'
require 'nokogiri'

describe Post do
  specify { expect(subject).to respond_to(:type) }
  specify { expect(subject).to respond_to(:state) }
  specify { expect(subject).to respond_to(:tags) }
  specify { expect(subject).to respond_to(:tweet) }
  specify { expect(subject).to respond_to(:date) }
  specify { expect(subject).to respond_to(:format) }
  specify { expect(subject).to respond_to(:slug) }
  specify { expect(subject).to respond_to(:title) }
  specify { expect(subject).to respond_to(:body) }

  describe '.from_xml_element' do
    let(:xml_file) { build :bloghu_xml }
    let(:nokogiri) { Nokogiri::XML(xml_file) }
    let(:xml_element) { nokogiri.xpath('//item').first }
    subject { described_class.from_xml_element(xml_element) }

    specify { expect(subject.tags).to match_array ['tag 1', 'tag 2'] }
    specify { expect(subject.title).to eq 'Post title' }
    specify { expect(subject.body).to eq 'Body of the post' }
    specify { expect(subject.date).to eq Time.parse('2013-12-31 22:59:00 UTC') }
    specify { expect(subject.slug).to eq 'devmeeting_at_dina_with_the_code_hulk' }
    specify { expect(subject.state).to eq 'draft' }
    specify { expect(subject.type).to eq 'text' }
    specify { expect(subject.format).to eq 'html' }
    specify { expect(subject.tweet).to be false }
  end

  describe '#to_request_params' do
    let(:tweet) { false }
    subject { described_class.new({
      type:   'text',
      state:  'draft',
      tags:   %w[one two three],
      tweet:  tweet,
      date:   Time.at(0),
      format: 'html',
      slug:   'slug',
      title:  'title',
      body:   'body',
    }) }
    specify do
      expect(subject.to_request_params).to eq({
        type:   'text',
        state:  'draft',
        tags:   'one, two, three',
        tweet:  'off',
        date:   Time.at(0).utc.to_s,
        format: 'html',
        slug:   'slug',
        title:  'title',
        body:   'body',
      })
    end
  end
end
