require 'nokogiri'

class BlogHuParser

  attr_reader :posts, :xml_file

  def self.posts_from(xml_file_name)
    new(xml_file_name).posts
  end

  def initialize(xml_file_name)
    @posts = []
    @xml_file = load_file(xml_file_name)
    return if @xml_file.nil?

    populate_posts_from_xml!
  end

  private

  def populate_posts_from_xml!
    blog_hu_posts = Nokogiri::XML(xml_file).xpath('//item')

    @posts = blog_hu_posts.map{ |elem| Post.from_xml_element elem }
  end

  def load_file(file_name)
    File.read(file_name)
  rescue Errno::ENOENT
    puts 'No such file!'
  end

end
