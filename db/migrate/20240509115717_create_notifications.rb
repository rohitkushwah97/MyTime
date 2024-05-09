class CreateNotifications < ActiveRecord::Migration[7.1]
  def change
    create_table :notifications do |t|
      t.string :title
      t.text :body
      t.string :notify_type
      t.bigint :created_by
      t.bigint :created_for
      t.boolean :is_read, default: false
      t.timestamps
    end
  end
end
