class CreateMyPhoneBooks < ActiveRecord::Migration[7.1]
  def change
    create_table :my_phone_books do |t|
      t.string :contact_number
      t.bigint :user_id
      t.timestamps
    end
  end
end
