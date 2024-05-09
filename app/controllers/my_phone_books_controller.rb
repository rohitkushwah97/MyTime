class MyPhoneBooksController < ApplicationController
  def create
    contact_numbers = params['contact_numbers']
    if contact_numbers.present?
      device_contact = current_user.my_phone_books.pluck(:contact_number)
      contact_numbers -= device_contact
      phone_book_entries = contact_numbers.map do |number|
        MyPhoneBook.new(contact_number: number, user_id: current_user.id)
      end
      MyPhoneBook.import(phone_book_entries)
      render json: { success: true, message: 'Bulk contacts created successfully' }, status: :ok
    else
      render json: { success: false, message: 'No contact numbers provided' }, status: :unprocessable_entity
    end
  end

  def index
    contacts = current_user.my_phone_books
    app_contacts = User.where(phone_number: contacts.pluck(:contact_number))
    render json: {app_contacts: app_contacts, my_contacts: contacts - app_contacts}
  end
end
