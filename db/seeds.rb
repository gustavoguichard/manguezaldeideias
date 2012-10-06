# coding: utf-8

# Categories
c1 = IdeaCategory.create(:name => "TISA", :description => "Sample description", :badge => "")
c2 = IdeaCategory.create(:name => "AGV", :description => "Sample description", :badge => "")
c3 = IdeaCategory.create(:name => "Cremer", :description => "Sample description", :badge => "")
c3 = IdeaCategory.create(:name => "Morena Rosa", :description => "Sample description", :badge => "")
c3 = IdeaCategory.create(:name => "Ômega", :description => "Sample description", :badge => "")
c3 = IdeaCategory.create(:name => "Mangue Tarpon", :description => "Sample description", :badge => "")

%W(miguxo@facebooksucks.com juquinha@amoorkut.com sem.idea@email.com).each do |email|
  NonFacebookUser.create(:email => email)
end
