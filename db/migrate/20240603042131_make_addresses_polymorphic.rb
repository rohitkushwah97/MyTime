class MakeAddressesPolymorphic < ActiveRecord::Migration[7.1]
  def change
    add_reference :addresses, :addressable, polymorphic: true, index: true
    remove_column :addresses, :user_id
  end
end
