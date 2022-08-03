# Not going to refactor this away at this point
# rubocop:disable Style/OpenStructUse
class Place < OpenStruct
  def self.rendered_fields
    [:id, :name, :status, :street, :city, :zip, :country, :overall]
  end
end
# rubocop:enable Style/OpenStructUse
