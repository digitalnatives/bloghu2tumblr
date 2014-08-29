require 'spec_helper'

describe Post do


  context "has attributes" do
    subject { Post.new }
    it { subject.respond_to?(:type) }
    it { subject.respond_to?(:state) }
    it { subject.respond_to?(:tags) }
    it { subject.respond_to?(:tweet) }
    it { subject.respond_to?(:date) }
    it { subject.respond_to?(:format) }
    it { subject.respond_to?(:slug) }
    it { subject.respond_to?(:title) }
    it { subject.respond_to?(:body) }
  end
end
