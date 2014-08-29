class Post
  attr_accessor :type   # String [text, photo, quote, link, chat, audio, video]
  attr_accessor :state  # String [published, draft, queue, private]
  attr_accessor :tags   # Array  [Comma-separated tags for this post]
  attr_accessor :tweet  # String [off to disable auto tweeting]
  attr_accessor :date   # String [The GMT date and time of the post, as a string]
  attr_accessor :format # String [html, markdown]
  attr_accessor :slug   # String
  attr_accessor :title  # String
  attr_accessor :body   # String
end
