# coding: utf-8
ActiveAdmin::Dashboards.build do
  
  section "Ideias Recentes" do
    ul do
      Idea.recent(5).collect do |idea|
        li link_to(idea.title, admin_idea_path(idea))
      end
    end
  end


  section "Colaborações Recentes" do
    ul do
      Idea.where(['parent_id IS NOT NULL']).recent(5).collect do |idea|
        li link_to(idea.title, admin_idea_path(idea))
      end
    end
  end

  section "Usuários esperando aprovação" do
    table_for User.not_approved.limit(10) do
      column :name do |user|
        link_to user.name, [:admin, user]
      end
      column :email
    end
    # link_to "Ver todos", admin_users_path
  end
  
  
  # == Section Ordering
  # The dashboard sections are ordered by a given priority from top left to
  # bottom right. The default priority is 10. By giving a section numerically lower
  # priority it will be sorted higher. For example:
  #
  #   section "Recent Posts", :priority => 10
  #   section "Recent User", :priority => 1

end
