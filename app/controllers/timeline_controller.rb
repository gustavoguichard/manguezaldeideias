class TimelineController < ApplicationController
  
  before_filter :load_resources, :redirect_guest

  def index
    # authorize! :read, :timeline
    @audits = Audit.recent.all
    @maximum_ideas = 10
    @recent_liked_ideas = []
    @recent_commented_ideas = []
  end

  protected
  def load_resources
    @categories ||= IdeaCategory.all
    @users ||= User.includes(:services)
    @ideas_count ||= Idea.count
    @ideas_latest ||= Idea.latest
    @ideas_featured ||= Idea.featured
  end
  
end