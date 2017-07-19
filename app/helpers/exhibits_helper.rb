# Returns the correct type of exhibit object
module ExhibitsHelper
  def exhibit(model, context)
    Exhibit.exhibit(model, context)
  end
end
