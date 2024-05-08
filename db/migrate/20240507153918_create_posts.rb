class CreatePosts < ActiveRecord::Migration[7.1]
  def change
    create_table :posts do |t|
      t.bigint :user_id
      t.text :caption
      t.bigint :category_id
      t.integer :status
      t.timestamps
    end
  end
end
