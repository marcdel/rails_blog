require_relative '../rails_helper'
# require_relative '../spec_helper_lite'
require_relative '../../app/helpers/exhibits_helper'

# stub_class 'PicturePostExhibit'
# stub_class 'TextPostExhibit'
# stub_class 'Post'

describe ExhibitsHelper do
  subject { Object.new }
  let(:context) { double }

  before(:each) do
    subject.extend ExhibitsHelper
  end

  it 'decorates picture posts with a PicturePostExhibit' do
    post = Post.new
    allow(post).to receive(:picture?).and_return(true)
    expect(subject.exhibit(post, context)).to be_a(PicturePostExhibit)
  end

  it 'decorates text posts with a TextPostExhibit' do
    post = Post.new
    allow(post).to receive(:picture?).and_return(false)
    expect(subject.exhibit(post, context)).to be_a(TextPostExhibit)
  end

  it 'leaves objects it doesnt know about alone' do
    model = Object.new
    expect(subject.exhibit(model, context)).to be(model)
  end
end
