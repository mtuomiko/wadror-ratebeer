class RenameBeersStyleColumn < ActiveRecord::Migration[6.0]
  def change
    rename_column :beers, :style, :style_old
  end
end
