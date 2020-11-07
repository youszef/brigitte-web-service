module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      if cookies.encrypted[:user_id]
        self.current_user = cookies.encrypted[:user_id]
      else
        reject_unauthorized_connection
      end
    end
  end
end
