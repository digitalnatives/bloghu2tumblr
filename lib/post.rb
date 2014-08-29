class Post
  ATTRIBUTES = [:state, :tags, :tweet, :date, :format, :slug, :title, :body]
  attr_accessor :type   # String  [text, photo, quote, link, chat, audio, video]
  attr_accessor :state  # String  [published, draft, queue, private]
  attr_accessor :tags   # Array   [Comma-separated tags for this post]
  attr_accessor :tweet  # Boolean [off to disable auto tweeting]
  attr_accessor :date   # Time    [The GMT date and time of the post, as a string]
  attr_accessor :format # String  [html, markdown]
  attr_accessor :slug   # String
  attr_accessor :title  # String
  attr_accessor :body   # String

  def to_request_params
    ATTRIBUTES.each_with_object({}) do |attr, hash|
      attr_method_name = "#{attr}_to_request_param"
      attr_method      = respond_to?(attr_method_name) ? attr_method_name : attr

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
    date.to_s
  end
end
