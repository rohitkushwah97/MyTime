ActiveAdmin.register User do
  permit_params :email, :phone_number, :profile_image, :about_us, :full_name, address_attributes: [:id, :latitude, :longitude, :address]
  config.clear_action_items!
  form do |f|
    f.inputs "User Details" do
      f.input :email
      f.input :phone_number
		  f.input :profile_image, as: :file, hint: (f.object.profile_image.attached? ? image_tag(url_for(f.object.profile_image), height: '50') : content_tag(:span, "No Image"))
      f.input :about_us
      f.input :full_name
      f.inputs "Address" do
        f.semantic_fields_for :address do |address_form|
          address_form.input :latitude
          address_form.input :longitude
          address_form.input :address
        end
      end
    end
    f.actions
  end

  index do
    selectable_column
    id_column
    column :email
    column :phone_number
    column :profile_image do |logo|
      if logo.profile_image.attached?
        image_tag url_for(logo.profile_image), height: '50'
      else
        'No image'
      end
    end
    column :about_us
    column :full_name
    column :created_at
    actions
  end

  filter :email
  filter :phone_number
  filter :about_us
  filter :full_name
  filter :created_at
end
