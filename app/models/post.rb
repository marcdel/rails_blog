# Represent a blog post
class Post
  extend ActiveModel::Naming
  include ActiveModel::Conversion

  attr_accessor :title, :body, :blog, :pubdate

  def initialize(attrs = {})
    attrs.each { |k, v| send("#{k}=", v) }
  end

  def publish(clock = DateTime)
    self.pubdate = clock.now
    blog.add_entry(self)
  end

  # Make rails form helpers happy
  def persisted?
    false
  end
end
