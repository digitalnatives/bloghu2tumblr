require 'nokogiri'

class BlogHuParser

  attr_accessor :posts
  attr_reader :xml_file

  def initialize(file_name)
    @posts = []
    @xml_file = load_file(file_name)
    @xml_file.nil? ? puts('No file') : parse
  end

  def parse
  end

  private

  def load_file(file_name)
    File.read(file_name)
  rescue Errno::ENOENT => e
    puts "No file"
  end

end
