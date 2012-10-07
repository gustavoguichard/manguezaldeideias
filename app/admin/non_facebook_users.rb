# coding: utf-8
ActiveAdmin.register NonFacebookUser do
  menu label: "Não-usuários do Facebook", parent: "Usuários", priority: 2

  index do
    column :email
    # column "Aprovado", :approved, sortable: :approved do |user|
    #   if user.approved then "Sim" else "Não" end
    # end
    default_actions
  end
end

