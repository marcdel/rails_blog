require 'delegate'

# Functionality common to all exhibit objects
class Exhibit < SimpleDelegator
  def initialize(model, context)
    @context = context
    super(model)
  end

  def self.exhibit(model, context)
    exhibits.reduce(model) do |object, exhibit|
      exhibit.exhibit_if_applicable(object, context)
    end
  end

  def self.exhibit_if_applicable(object, context)
    if applicable_to?(object)
      new(object, context)
    else
      object
    end
  end

  def self.applicable_to?(_object)
    false
  end

  def self.exhibits
    [TextPostExhibit, PicturePostExhibit]
  end

  def to_model
    __getobj__
  end

  def class
    __getobj__.class
  end
end
