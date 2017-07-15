require 'spec_helper'
require 'ostruct'
require_relative '../../app/models/blog'

RSpec.describe Blog do
  subject { Blog.new }

  it 'has no entries' do
    expect(subject.entries).to be_empty
  end

  describe '#new_post' do
    let(:new_post) { OpenStruct.new }
    before(:each) { subject.post_source = -> { new_post } }

    it 'returns a new post' do
      expect(subject.new_post).to eq(new_post)
    end

    it "sets the post's blog reference to itself" do
      expect(subject.new_post.blog).to eq(subject)
    end

    it 'accepts an attribute hash on behalf of the post maker' do
      post_source = double
      subject.post_source = post_source
      expect(post_source)
        .to receive(:call)
        .with(x: 42, y: 'z')
        .and_return(new_post)

      subject.new_post(x: 42, y: 'z')
    end
  end

  describe '#add_entry' do
    it 'adds the entry to the blog' do
      entry = Object.new
      subject.add_entry(entry)
      expect(subject.entries).to include(entry)
    end
  end
end
