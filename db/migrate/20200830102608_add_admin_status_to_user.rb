class AddAdminStatusToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :admin, :boolean
    # Set existing users as non-admins
    User.all.each do |u|
      # Bypass user password validation with update_attribute
      u.update_attribute(:admin, false)
    end
  end
end
