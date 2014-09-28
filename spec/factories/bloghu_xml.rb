FactoryGirl.define do
  factory :bloghu_xml, class: String do
    skip_create

    ignore do
      post_count 1
      post_arguments({})
    end
    posts { create_list :post_item, post_count, post_arguments }

    initialize_with {
      <<-XML
        <?xml version="1.0" encoding="UTF-8"?>
        <rss version="2.0"
              xmlns:content="http://purl.org/rss/1.0/modules/content/"
              xmlns:wfw="http://wellformedweb.org/CommentAPI/"
              xmlns:dc="http://purl.org/dc/elements/1.1/"
              xmlns:wp="http://wordpress.org/export/1.0/">
          <channel>
            <wp:wxr_version>1.1</wp:wxr_version>
            <title><![CDATA[Sample blog]]></title>
            <link><![CDATA[http://sample_blog.blog.hu/]]></link>
            <description><![CDATA[Sample description]]></description>
            <pubDate><![CDATA[Thu, 10 Jul 2014 17:08:10 +0200]]></pubDate>
            <generator>http://blog.hu</generator>
            <language>hu</language>
            <wp:category>
              <wp:category_nicename>export</wp:category_nicename>
              <wp:category_parent></wp:category_parent>
              <wp:cat_name>Export</wp:cat_name>
              <wp:category_description>Export</wp:category_description>
            </wp:category>
            #{posts.join("\n")}
          </channel>
        </rss>
      XML
    }
  end

  factory :post_item, class: String do
    skip_create

    title 'Post title'
    tags ['tag 1', 'tag 2']
    body 'Body of the post'
    status 'draft'

    initialize_with {
      <<-XML
        <item>
          <title><![CDATA[#{title}]]></title>
          <link><![CDATA[http://example.com/2014/10/31/testing]]></link>
          <pubDate><![CDATA[Fri, 31 Dec  23:59:00 +0100]]></pubDate>
          <dc:creator><![CDATA[livia.rozsas]]></dc:creator>
          <dc:creator_id><![CDATA[872722]]></dc:creator_id>
          <category>Export</category>
          #{tags.map {|t| "<category domain=\"tag\"><![CDATA[#{t}]]></category>" }.join("\n")}
          <guid isPermaLink="false"><![CDATA[http://digitalnatives.blog.hu/9999/12/31/devmeeting_at_dina_with_the_code_hulk]]></guid>
          <description><![CDATA[]]></description>
          <content:encoded><![CDATA[#{body}]]></content:encoded>
          <wp:post_id><![CDATA[6493721]]></wp:post_id>
          <wp:post_date><![CDATA[2013-12-31 23:59:00]]></wp:post_date>
          <wp:post_date_gmt><![CDATA[2013-12-31 22:59:00]]></wp:post_date_gmt>
          <wp:comment_status><![CDATA[open]]></wp:comment_status>
          <wp:ping_status>open</wp:ping_status>
          <wp:post_name><![CDATA[devmeeting_at_dina_with_the_code_hulk]]></wp:post_name>
          <wp:status><![CDATA[#{status}]]></wp:status>
          <wp:post_parent><![CDATA[0]]></wp:post_parent>
          <wp:menu_order>0</wp:menu_order>
          <wp:post_type><![CDATA[post]]></wp:post_type>
        </item>
      XML
    }
  end
end
