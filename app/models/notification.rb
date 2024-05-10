class Notification < ApplicationRecord
  belongs_to :created_by, class_name: 'User', foreign_key: 'created_by', optional: true
  belongs_to :created_for, class_name: 'User', foreign_key: 'created_for', optional: true
  after_create :send_push_notification

  def send_push_notification
    if created_for.devices.present?
      fcm_client = FCM.new(FCM_CONFIG[:api_key])
      options = { priority: 'high',
                  data: {
                    title: title,
                    body: body,
                    account_id: created_for,
                    notifiaction_count: created_for.notifications_created_for.where(is_read: false).count
                  },
                  notification: {
                    title: title,
                    body: body,
                    notifiaction_count: created_for.notifications_created_for.where(is_read: false).count,
                    sound: 'default'
                  } }
      registration_ids = created_for.devices
      fcm_client.send(registration_ids, options)
    end
  rescue Exception => e
    e
  end
end
