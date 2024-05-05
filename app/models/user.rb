class User < ApplicationRecord
	has_secure_password

  has_one_attached :profile_image
  
  has_one :address
  accepts_nested_attributes_for :address, update_only: true
	
  validates :email, uniqueness: true, presence: true
	validates :phone_number, uniqueness: true, presence: true
  validates :password, presence: true,
                       length: { minimum: 8, message: 'must be minimum 8 characters' }, on: :create
  validates_format_of :email, multiline: true,
                              with: /^(|(([A-Za-z0-9]+_+)|([A-Za-z0-9]+-+)|([A-Za-z0-9]+\.+)|([A-Za-z0-9]+\++))*[A-Za-z0-9]+@((\w+-+)|(\w+\.))*\w{1,63}\.[a-zA-Z]{2,6})$/i

end
