class Post < ApplicationRecord
  has_many_attached :images, dependent: :destroy
  belongs_to :user, optional: true
  belongs_to :category, optional: true
  enum status: %i[universal contacts]
  validates :caption, presence: true

  def self.search(query)
    posts_by_caption = where("caption LIKE ?", "%#{query}%")
    posts_by_user_about = joins(:user).where("users.about_us LIKE ?", "%#{query}%")
    search_results = posts_by_caption + posts_by_user_about
    search_results&.uniq
  end

  def distance_to_user_address(user_address)
    earth_radius = 6371 # Radius of the earth in kilometers
    lat1_rad = user_address.latitude.to_f * Math::PI / 180
    lat2_rad = self.user.address.latitude.to_f * Math::PI / 180
    delta_lat = (self.user.address.latitude.to_f - user_address.latitude.to_f) * Math::PI / 180
    delta_lon = (self.user.address.longitude.to_f - user_address.longitude.to_f) * Math::PI / 180

    a = Math.sin(delta_lat/2) * Math.sin(delta_lat/2) +
        Math.cos(lat1_rad) * Math.cos(lat2_rad) *
        Math.sin(delta_lon/2) * Math.sin(delta_lon/2)
    c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a))
    distance = earth_radius * c
    distance # Distance in kilometers
  end
end
