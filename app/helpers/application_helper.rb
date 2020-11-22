module ApplicationHelper
  def stimulus_actions(action_hash)
    action_hash.compact.map { |event, controller_function| "#{event}->#{controller_function}"}.join(' ')
  end
end
