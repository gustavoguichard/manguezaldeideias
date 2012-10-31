class Idea < ActiveRecord::Base

  # Logs all changes on this model; who made it, what kind and associated models.
  # See https://github.com/collectiveidea/audited
  # By default, whenever an idea is created, updated or destroyed, a new audit is created.
  audited

  geocoded_by :ip_for_geocoding do |idea, results|
    if geo = results.first
      idea.latitude = geo.latitude
      idea.longitude = geo.longitude
      idea.city = geo.city
      idea.state = geo.state
      idea.country = geo.country
    end
  end
  after_validation :geocode

  require 'json'
  require 'open-uri'

  include AutoHtml
  include Rails.application.routes.url_helpers
  include PgSearch

  belongs_to :user
  belongs_to :category, :class_name => "IdeaCategory", :foreign_key => :category_id
  belongs_to :parent, :class_name => "Idea", :foreign_key => :parent_id
  belongs_to :original_parent, :class_name => "Idea", :foreign_key => :original_parent_id

  has_many :colaborations, class_name: "Idea", foreign_key: :parent_id, dependent: :destroy
  has_many :messages
  has_many :ramifications, class_name: "Idea", foreign_key: :original_parent_id, dependent: :restrict

  validates_presence_of :title, :description, :category_id, :user_id

  # Scope for colaborations

  scope :without_parent, where(parent_id: nil)
  scope :colaborations, where("parent_id IS NOT NULL").order("created_at DESC")
  scope :not_accepted, where(:accepted => nil).order('created_at DESC')
  scope :featured, where(:featured => true, :parent_id => nil).order('position DESC')
  scope :latest, where(:parent_id => nil).order('updated_at DESC')
  scope :recent, where(:parent_id => nil).order('created_at DESC')
  scope :popular, select("DISTINCT ON (ideas.id) ideas.*").joins("INNER JOIN ideas b ON b.parent_id = ideas.id").order("id")

  pg_search_scope :match_and_find, against: [:title, :description], associated_against: {user: :name}

  scope :new_collaborations, ->(user) { where(['parent_id IN (?)', user.ideas.map(&:id)]).order("created_at ASC") }

  scope :collaborations_status_changed, ->(user) { 
    where(['user_id = ? AND accepted IS NOT NULL AND parent_id IS NOT NULL', user.id]).order("updated_at DESC")
  }

  scope :collaborated_idea_changed, ->(user) {
    where(['EXISTS(
              SELECT true FROM ideas AS collaboration
              WHERE collaboration.parent_id = ideas.id
              AND collaboration.user_id = ?
          )', user.id]).order("updated_at DESC")
  }

  # Callbacks

  after_create :set_facebook_url
  #after_create :set_tokbox_settings

  attr_accessible :user_id, :parent_id, :title, :headline, :description, :featured, :recommend, :likes, :position, :category_id, :accepted, :facebook_url, :tokbox_session, :original_parent_id, :comment_count

  def cocreation_channel
    "cocreation-#{self.id}"
  end

  def self.ramify!(idea)
    idea.update_attributes! parent_id: nil, accepted: nil, original_parent_id: idea.parent_id
  end

  def rejected_colaborations
    self.colaborations.where(accepted: false)
  end

  def accepted_colaborations
    self.colaborations.where(accepted: true)
  end

  def self.create_colaboration(params = {})
    if params.has_key? :parent_id
      Idea.create(params)
      idea = Idea.where(parent_id: params[:parent_id])
    end
  end

  # Modify the json response
  def as_json(options={})
    {
      :id => id,
      :title => title,
      :headline => headline,
      :category => category,
      :user => user.id,
      :description => description,
      :description_html => description_html,
      :likes => likes,
      :colaborations => colaborations.count,
      :url => category_idea_path(category, self)
    }
  end

  def external_url
    self.facebook_url
  end

  # This affects links
  def to_param
    "#{id}-#{title.parameterize}"
  end

  # Convert the description text
  def description_html
    convert_html description
  end

  def convert_html(text)
    auto_html text do
      image
      youtube :width => 510, :height => 332
      vimeo :width => 510, :height => 332
      link :target => :_blank
      redcarpet :target => :_blank
    end
  end

  # Hook to update likes count when someone visits the #show page
  # of an idea
  
  def get_facebook_data(url)
    JSON.parse(open(url).read)
  end
  
  def update_facebook_likes
    facebook_query_url = 'https://api.facebook.com/method/fql.query?format=json&query=' 
    fql = "SELECT total_count, commentsbox_count FROM link_stat WHERE url='%s'"
    path = self.facebook_url
    facebook_data = self.get_facebook_data(facebook_query_url + URI.encode(fql % path))
    total_count = facebook_data.first["total_count"]
    comment_count = facebook_data.first["commentsbox_count"]
    self.update_attribute(:likes, total_count.to_i) if total_count
    self.update_attribute(:comment_count, comment_count.to_i) if comment_count
  end

  # When an idea is created, we set a default url for sharing likes e etc. 
  # Doing this, we avoid data losses (comments are URL-child, by this I mean:
  # You change an url, your comments are gone.

  def set_facebook_url
    url = category_idea_url(self.category, self, host: "manguezaldeideias.com.br")
    self.update_attribute(:facebook_url, url)
  end

  def set_tokbox_settings
    session = TOKBOX.create_session(self.external_url)
    self.update_attribute(:tokbox_session, session.session_id)
  end
  
  def after_audit
    Audit.pending.where(auditable_id: self.id).each do |pending_audit|
      pending_audit.set_timeline_and_notifications_data!
      pending_audit.users_to_notify.each do |user_to_notify|
        if user_to_notify.email_notifications and pending_audit.notification_text(user_to_notify)
          IdeaMailer.notification_email(pending_audit, user_to_notify).deliver
        end
      end
    end
  end
  
  def ip_for_geocoding
    audit = Audit.where(auditable_id: self.id).where("remote_address IS NOT NULL").order(:created_at).first
    audit.remote_address if audit
  end
  
end
