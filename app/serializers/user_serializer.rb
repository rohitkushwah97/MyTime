class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :phone_number, :full_name, :about_us, :profile_image, :devices, :address, :contact_status, :notification_status, :posts, :created_at, :updated_at

  def profile_image
    return unless object.profile_image.attached?
    {
      id: object.profile_image.id,
      url: ENV['BASE_URL'] + Rails.application.routes.url_helpers.rails_blob_url(
        object.profile_image, only_path: true
      )
    }
  end

  def address
    {
      latitude: object.address&.latitude,
      longitude: object.address&.longitude,
      address: object.address&.address
    }
  end

  def posts
    ActiveModelSerializers::SerializableResource.new(object.posts, each_serializer: PostSerializer)
  end

end
