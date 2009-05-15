# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  # Get the distance word form now
  def distance_before_now(from, include_seconds = false)
    return distance_of_time_in_words_to_now(from, include_seconds) + I18n.translate('global.before')   
  end
  
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

  # Get sub topic list from parent topic
  def subtopic_path(topic)
    sub_topics = Topic.find :all, :conditions => "parent_id = #{topic.id}"
    return '' if sub_topics.count == 0
    content = "<ul>"
    for sub_topic in sub_topics
      content += "<li>"
      url = topic_path(sub_topic)
      path = "<a href=\"#{url}\">#{sub_topic.name}</a>"
      content += path
      content += subtopic_path(sub_topic)
      content += "</li>"
    end
    content += "</ul>"
    return content
  end

  # Generate a link to user's blog page
  def user_info(user)
    link_to user.login, "/user/#{user.login}"
  end

  def make_shorter(sentence)
    str = sentence
    if str.length > 20
      str = str[0,20] + "..."
    end
    return str
  end
  
end
