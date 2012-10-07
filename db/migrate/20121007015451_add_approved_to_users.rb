class AddApprovedToUsers < ActiveRecord::Migration
  def change
    add_column :users, :approved, :boolean, default: false
    add_column :non_facebook_users, :approved, :boolean, default: false
  end
end
