class AddActivityToBrewery < ActiveRecord::Migration[6.0]
  def change
    add_column :breweries, :active, :boolean
    # Set existing breweries as active
    Brewery.all.each do |b|
      b.active = true
      b.save
    end
  end
end
