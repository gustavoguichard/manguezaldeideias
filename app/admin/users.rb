# coding: utf-8
ActiveAdmin.register User do
  menu label: "Usuários do Facebook", priority: 1, parent: "Usuários"
  scope "Não aprovados", :not_approved

  index do
    column "Nome", :name
    column :email
    column "Aprovado", :approved, sortable: :approved do |user|
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
  
end
