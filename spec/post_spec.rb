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
    let(:xml_file) {
      <<-XML
        <?xml version="1.0" encoding="UTF-8"?>
        <rss version="2.0" xmlns:content="http://purl.org/rss/1.0/modules/content/"
                          xmlns:wfw="http://wellformedweb.org/CommentAPI/"
                          xmlns:dc="http://purl.org/dc/elements/1.1/"
                          xmlns:wp="http://wordpress.org/export/1.0/">
          <channel>
            <item>
              <title><![CDATA[Post title]]></title>
              <link><![CDATA[http://example.com/2014/10/31/testing]]></link>
              <pubDate><![CDATA[Fri, 31 Dec  23:59:00 +0100]]></pubDate>
              <dc:creator><![CDATA[livia.rozsas]]></dc:creator>
              <dc:creator_id><![CDATA[872722]]></dc:creator_id>
              <category>Export</category>
              <category domain="tag"><![CDATA[tag 1]]></category>
              <category domain="tag"><![CDATA[tag 2]]></category>
              <guid isPermaLink="false"><![CDATA[http://digitalnatives.blog.hu/9999/12/31/devmeeting_at_dina_with_the_code_hulk]]></guid>
              <description><![CDATA[]]></description>
              <content:encoded><![CDATA[Body of the post]]></content:encoded>
              <wp:post_id><![CDATA[6493721]]></wp:post_id>
              <wp:post_date><![CDATA[2013-12-31 23:59:00]]></wp:post_date>
              <wp:post_date_gmt><![CDATA[2013-12-31 22:59:00]]></wp:post_date_gmt>
              <wp:comment_status><![CDATA[open]]></wp:comment_status>
              <wp:ping_status>open</wp:ping_status>
              <wp:post_name><![CDATA[devmeeting_at_dina_with_the_code_hulk]]></wp:post_name>
              <wp:status><![CDATA[draft]]></wp:status>
              <wp:post_parent><![CDATA[0]]></wp:post_parent>
              <wp:menu_order>0</wp:menu_order>
              <wp:post_type><![CDATA[post]]></wp:post_type>
            </item>
          </channel>
        </rss>
      XML
    }
    subject { described_class.from_xml_element(Nokogiri::XML(xml_file).xpath('//item').first) }
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
