require 'spec_helper'
require 'date'
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
      entry = double
      allow(entry).to receive(:pubdate)
      subject.add_entry(entry)
      expect(subject.entries).to include(entry)
    end
  end

  describe '#entries' do
    def stub_entry_with_date(date)
      OpenStruct.new(pubdate: DateTime.parse(date))
    end

    it 'is sorted in reverse chronological order' do
      oldest = stub_entry_with_date('20011-09-09')
      newest = stub_entry_with_date('20011-09-11')
      middle = stub_entry_with_date('20011-09-10')

      subject.add_entry(oldest)
      subject.add_entry(newest)
      subject.add_entry(middle)

      expect(subject.entries).to eq([newest, middle, oldest])
    end

    it 'is limited to 10 items' do
      10.times do |i|
        subject.add_entry(stub_entry_with_date("2011-09-#{i + 1}"))
      end
      oldest = stub_entry_with_date('2011-8-30')
      subject.add_entry(oldest)

      expect(subject.entries.size).to eq(10)
      expect(subject.entries).not_to include(oldest)
    end
  end
end
