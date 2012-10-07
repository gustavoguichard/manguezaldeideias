# coding: utf-8
ActiveAdmin.register NonFacebookUser do
  menu parent: "Usuários", priority: 2

  index do
    column :email
    # column "Aprovado", :approved, sortable: :approved do |user|
    #   if user.approved then "Sim" else "Não" end
    # end
    default_actions
  end

  show title: :email do |user|
    attributes_table do
      row :email
      row :approved do |user|
        if user.approved then "Sim" else "Não" end
      end
      row :created_at
      row :updated_at
    end
  end
end

