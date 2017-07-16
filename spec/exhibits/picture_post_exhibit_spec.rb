require 'spec_helper'
require 'ostruct'
require_relative '../../app/exhibits/picture_post_exhibit'

RSpec.describe PicturePostExhibit do
  subject { PicturePostExhibit.new(post, context) }
  let(:post) do
    OpenStruct.new(title: 'Title', body: 'Body', pubdate: 'Pubdate')
  end
  let(:context) { double }

  it 'delegates method calls to the post' do
    expect(subject.title).to eq('Title')
    expect(subject.body).to eq('Body')
    expect(subject.pubdate).to eq('Pubdate')
  end

  describe '#render_body' do
    it 'renders itself with the appropriate partial' do
      expect(context)
        .to receive(:render)
        .with(partial: '/posts/picture_body', locals: { post: subject })
        .and_return('THE_HTML')

      expect(subject.render_body).to eq('THE_HTML')
    end
  end
end
