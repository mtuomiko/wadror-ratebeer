class AddStyleIdToBeers < ActiveRecord::Migration[6.0]
  def change
    add_column :beers, :style_id, :integer
    # Check existing beers for style_old variable and use it to set new Style
    Beer.all.each do |b|
      style = Style.all.find_by name: b.style_old
      b.style = style if style
      b.save
    end
  end
end
