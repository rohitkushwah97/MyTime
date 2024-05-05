class CreateAddresses < ActiveRecord::Migration[7.1]
  def change
    create_table :addresses do |t|
      t.string :latitude
      t.string :longitude
      t.string :address
      t.bigint :user_id
      
      t.timestamps
    end
  end
end
