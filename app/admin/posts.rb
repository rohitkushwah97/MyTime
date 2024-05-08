ActiveAdmin.register Post do
  permit_params :caption, :status, :user_id, :category_id, images: []

 form do |f|
    f.inputs 'Post Details' do
      f.input :caption
      f.input :status, as: :select, collection: Post.statuses.keys
      f.input :user, as: :select, collection: User.all.map { |u| [u.email, u.id] }, include_blank: 'Select User'
      f.input :category, as: :select, collection: Category.all.map { |c| [c.name, c.id] }, include_blank: 'Select Category'
      f.input :images, as: :file, input_html: { multiple: true }
    end
    f.actions
  end

  index do
    selectable_column
    id_column
    column :caption
    column :status
    column :user
    column :category
    column :created_at
    actions
  end

  filter :caption
  filter :status, as: :select, collection: Post.statuses.keys
  filter :user
  filter :category
  filter :created_at
end
