class AddColumnContactAndNotificationStatusInUser < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :contact_status, :boolean, default: true
    add_column :users, :notification_status, :boolean, default: true
  end
end
