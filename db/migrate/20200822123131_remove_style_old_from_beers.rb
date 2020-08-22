class RemoveStyleOldFromBeers < ActiveRecord::Migration[6.0]
  def change
    remove_column :beers, :style_old, :string
  end
end
