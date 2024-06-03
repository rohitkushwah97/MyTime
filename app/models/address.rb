class Address < ApplicationRecord
  belongs_to :addressable, polymorphic: true
  validates :latitude, presence: true
  validates :longitude, presence: true
  # reverse_geocoded_by :latitude, :longitude, address: :address
  # after_validation :reverse_geocode
end
