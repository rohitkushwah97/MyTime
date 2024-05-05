class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :phone_number, :full_name, :about_as, :created_at, :updated_at
end
