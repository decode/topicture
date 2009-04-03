module TopicsHelper
  def parent_topic_column(record)
    unless record.parent_topic.nil? 
      link_to h(record.parent_topic.name), topic_path(record.parent_topic)
    else
      ' - '
    end
  end
end
