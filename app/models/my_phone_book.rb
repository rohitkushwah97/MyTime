class MyPhoneBook < ApplicationRecord
	belongs_to :user
	validates :contact_number, uniqueness: true, presence: true
end
