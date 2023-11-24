module TopicsHelper

  def topic_creation_display_statuses
    Topic.statuses.except(:deactivated).keys.map {|status| [status.titleize, status]}
  end
end
