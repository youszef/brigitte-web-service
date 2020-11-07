class TableChannel < ApplicationCable::Channel
  def subscribed
    stream_for "table_#{params[:table]}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
