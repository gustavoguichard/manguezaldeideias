require 'machinist/active_record'

AdminUser.blueprint do
  email { "email#{sn}@email.com" }
  password { "password" }
end

Service.blueprint do
  uid { "#{sn}" }
  provider { "facebook" }
  user
end

User.blueprint do
  name { "name#{sn}" }
  email { "email#{sn}@email.com" }
  notifications_read_at { Time.now }
  approved { true }
end

IdeaCategory.blueprint do
  name        { "Name #{sn}" }
  description { "Description #{sn}" }
  badge       { "test" }
end

Idea.blueprint do
  title       { "Title #{sn}" }
  headline    { "Headline #{sn}" }
  description { "Description #{sn}" }
  category { IdeaCategory.make! }
  user { Service.make!.user }
  parent_id { nil }
  accepted { nil }
end

Page.blueprint do 
  title     { "Title #{sn}" }
  body      { "<p>body</p>" }
  position  { sn }
end

NonFacebookUser.blueprint do 
  email { "email#{sn}@email.com" }
end

InstitutionalVideo.blueprint do 
  video_url { "http://www.youtube.com/watch?v=MX2ArQiavHU&feature=player_embedded" }
  visible { true }
end

Banner.blueprint do 
  title { "Title" }
  description { "Description" }
  link_text { "Link text" }
  link_url { "http://festivaldeideias.org.br/co-criacao" }
  image_url { "http://festivaldeideias.org.br/assets/pensar-junto.png" }
  visible { true }
end

Audit.blueprint do
  user { User.make! }
  idea { Idea.make! }
end