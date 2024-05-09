class AddColumnInUser < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :devices, :text, array: true, default: []
    add_column :posts, :view_count, :string
  end
end
