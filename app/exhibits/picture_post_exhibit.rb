require_relative 'exhibit'

# Renders posts with pictures
class PicturePostExhibit < Exhibit
  def render_body
    @context.render(partial: '/posts/picture_body', locals: { post: self })
  end
end
