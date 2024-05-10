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

end
