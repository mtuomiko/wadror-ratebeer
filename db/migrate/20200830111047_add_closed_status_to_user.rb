class AddClosedStatusToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :closed, :boolean
    # Set existing users as not closed
    User.all.each do |u|
      # Bypass user password validation with update_attribute
      u.update_attribute(:closed, false)
    end
  end
end
