class Post < ApplicationRecord
  has_many_attached :images, dependent: :destroy
  belongs_to :user, optional: true
  belongs_to :category, optional: true
  enum status: %i[universal contacts]
  validates :caption, presence: true
end
