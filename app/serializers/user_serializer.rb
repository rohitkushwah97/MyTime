class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :phone_number, :full_name, :about_as, :profile_image, :created_at, :updated_at, :address

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

end
