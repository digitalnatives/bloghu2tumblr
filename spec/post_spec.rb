require 'post'

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

  describe '#to_request_params' do
    subject { described_class.new({
      type:   'text',
      state:  'draft',
      tags:   %w[one two three],
      tweet:  false,
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
