# coding: utf-8
ActiveAdmin.register User do
  menu label: "Usuários do Facebook", priority: 1, parent: "Usuários"
  scope "Não aprovados", :not_approved

  index do
    column :name
    column :email
    column :approved, sortable: :approved do |user|
      if user.approved then "Sim" else "Não" end
    end
    default_actions
  end

  form do |f|
    f.inputs do
      f.input :name, as: :string
      f.input :email, as: :string
      # f.input :notifications_read_at
      # f.input :email_notifications
      f.input :approved
    end
    f.buttons
  end
  
  show title: :name do |user|
    attributes_table do
      row :name
      row :email
      row :email_notifications do |user|
        if user.email_notifications then "Sim" else "Não" end
      end
      row :approved do |user|
        if user.approved then "Sim" else "Não" end
      end
      row :created_at
      row :updated_at
    end
  end

end
