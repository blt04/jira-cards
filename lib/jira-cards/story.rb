module JiraCards
class Story

  # Valid values: "feature", "bug", "chore"
  attr_accessor :type

  # Get a story's content from the JIRA instance and create a PDF from it
  def self.fetch(id)
    # Use GET request to get the story from JIRA
    #
    
  end

  # Defines the colors that mark this kind of story
  def border_color
    case type
    when "feature"
      "#52D017"
    when "bug"
      "FF0000"
    when "chore"
      "FFFF00"
    else
      fail "invalid story type"  
    end
  end

end
end
