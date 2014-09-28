require 'virtus'

class Post
  include Virtus.value_object

  values do
    attribute :title,  String
    attribute :date,   Time                        # [The GMT date and time of the post, as a string]
    attribute :slug,   String
    attribute :body,   String
    attribute :tags,   Array                       # [Comma-separated tags for this post]
    attribute :state,  String,  default: 'private' # [published, draft, queue, private]
    attribute :type,   String,  default: 'text'    # [text, photo, quote, link, chat, audio, video]
    attribute :format, String,  default: 'html'    # [html, markdown]
    attribute :tweet,  Boolean, default: false     # [off to disable auto tweeting]
  end

  def self.from_xml_element(xml_elem)
    p_state = case xml_elem.xpath('wp:status').first.children.text
              when 'draft'   then 'draft'
              when 'publish' then 'published'
              else 'private'
              end

    p_tags  = xml_elem.xpath('category[@domain="tag"]').map{ |e| e.children.text }
    p_date  = Time.parse(xml_elem.xpath('wp:post_date_gmt').first.children.text + ' UTC')
    p_slug  = xml_elem.xpath('wp:post_name').first.children.text
    p_title = xml_elem.xpath('title').first.children.text
    p_body  = xml_elem.xpath('content:encoded').first.children.text

    new type: 'text',
        state: p_state,
        tags: p_tags,
        tweet: false,
        date: p_date,
        format: 'html',
        slug: p_slug,
        title: p_title,
        body: p_body
  end

  def to_request_params
    attribute_names.each_with_object({}) do |attr, hash|
      attr_method_name = "#{attr}_to_request_param"
      attr_method      = respond_to?(attr_method_name, :private) ? attr_method_name : attr

      value = send(attr_method)
      hash[attr] = value if value
    end
  end

  private

  def tags_to_request_param
    tags.to_a.join(', ')
  end

  def tweet_to_request_param
    !!tweet ? nil : 'off'
  end

  def date_to_request_param
    date.utc.to_s
  end

  def attribute_names
    self.class.attribute_set.map(&:name)
  end
end
