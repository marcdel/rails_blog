require 'spec_helper_lite'
require 'active_model'
require 'date'
stub_module 'ActiveModel::Conversion'
stub_module 'ActiveModel::Naming'

require_relative '../../app/models/post'
require_relative '../../app/models/blog'

RSpec.describe Post do
  subject { Post.new(title: 'mytitle', body: 'mybody') }

  it 'starts with blank attributes' do
    subject = Post.new
    expect(subject.title).to be_nil
    expect(subject.body).to be_nil
  end

  it 'supports reading and writing of a title' do
    subject.title = 'foo'
    expect(subject.title).to eq('foo')
  end

  it 'supports reading and writing of a body' do
    subject.body = 'foo'
    expect(subject.body).to eq('foo')
  end

  it 'supports reading and writing of a blog reference' do
    subject.blog = 'foo'
    expect(subject.blog).to eq('foo')
  end

  it 'supports setting attributes in the initializer' do
    expect(subject.title).to eq('mytitle')
    expect(subject.body).to eq('mybody')
  end

  it 'is not valid with a blank title' do
    [nil, '', ' '].each do |bad_title|
      subject.title = bad_title
      expect(subject).not_to be_valid
    end
  end

  it 'is valid with a non-blank title' do
    subject.title = 'x'
    expect(subject).to be_valid
  end

  describe '#publish' do
    let(:blog) { double }
    before(:each) do
      subject.blog = blog
      allow(blog).to receive(:add_entry)
    end

    it 'adds the post to the blog' do
      expect(blog).to receive(:add_entry).with(subject)
      subject.publish
    end

    context 'given an invalid post' do
      before(:each) { subject.title = nil }

      it 'wont add the post to the blog' do
        expect(blog).not_to receive(:add_entry)
        subject.publish
      end

      it 'retuns false' do
        expect(subject.publish).to be_falsey
      end
    end
  end

  describe '#pubdate' do
    context 'before publishing' do
      it 'is blank' do
        expect(subject.pubdate).to be_nil
      end
    end

    context 'after publishing' do
      let(:now) { DateTime.now } # Pin the current time so we can assert on it.

      before(:each) do
        blog = double
        allow(blog).to receive(:add_entry)
        subject.blog = blog

        clock = double
        allow(clock).to receive(:now).and_return(now)
        subject.publish(clock)
      end

      it 'is a datetime' do
        expect(subject.pubdate.class).to eq(DateTime)
      end

      it 'is the current time' do
        expect(subject.pubdate).to eq(now)
      end
    end
  end
end
