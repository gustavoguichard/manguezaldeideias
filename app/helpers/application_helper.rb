# coding: utf-8

module ApplicationHelper


  def new_idea_button(css_class = "")
    link_to t('buttons.new_idea'), new_idea_path, :class => css_class + ' start'
  end

  def link_to_partner(name, url, image, width=nil)
    link_to(url, :target => '_blank') do
      image_tag("partners/#{image}", :alt => name, :title => name, :width => width)
    end
  end

  def idea_fields_changed(original_idea, collaborated_idea)
    attributes = {
      :title => 'título',
      :headline => 'resumo',
      :description => 'descrição',
      :category_id => 'categoria'
    }
    fields = []
    attributes.each_pair { |attr, text|
      fields.push(text) if original_idea.send(attr) != collaborated_idea.send(attr)
    }
    return fields.join(", ")
  end
end 
