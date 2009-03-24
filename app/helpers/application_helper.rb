# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  # Get topic path from current to the base topic
  def full_topic_path(topic)
    return '' if topic.nil?
    path = add_path(topic)
    path.insert 0, "<a href=\"/topics\">Topic</a>"
    return path
  end

  # Recursive add topic links
  def add_path(topic)
    return '' if topic.nil?
    url = topic_path(topic)
    path = "<a href=\"#{url}\">#{topic.name}</a>"
    path.insert 0, ' > ' 
    path.insert 0, add_path(topic.parent_topic) unless topic.parent_topic.nil?
    return path
  end
  
  
end
