module ApplicationHelper
  def stimulus_actions(action_hash)
    action_hash.map { |event, controller_function| "#{event}->#{controller_function}"}.join(' ')
  end
end
