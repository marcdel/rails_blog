require 'spec_helper_lite'
require 'date'
stub_module 'ActiveModel::Conversion'
stub_module 'ActiveModel::Naming'

require_relative '../../app/models/post'
require_relative '../../app/models/blog'

RSpec.describe Post do
  subject { Post.new }

  it 'starts with blank attributes' do
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
    subject = Post.new(title: 'mytitle', body: 'mybody')
    expect(subject.title).to eq('mytitle')
    expect(subject.body).to eq('mybody')
  end

  describe '#publish' do
    let(:blog) { double }
    before(:each) { subject.blog = blog }

    it 'adds the post to the blog' do
      expect(blog).to receive(:add_entry).with(subject)
      subject.publish
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
