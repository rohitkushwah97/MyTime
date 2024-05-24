class PostSerializer < ActiveModel::Serializer
  attributes :id, :caption, :status, :category_id, :user, :view_count, :images

  def images
    formatted_images = object.images.map do |image|
      {
        id: image.id,
        url: ENV['BASE_URL'] + Rails.application.routes.url_helpers.rails_blob_url(image, only_path: true)
      }
    end
  end
end
