class IdeaCategory < ActiveRecord::Base
	has_many :ideas, :dependent => :destroy, :foreign_key => :category_id, conditions: ['parent_id IS NULL']
	has_many :colaborations, :dependent => :destroy, :foreign_key => :category_id, conditions: ['parent_id IS NOT NULL']

	validates_presence_of :name


  def to_param
   "#{self.id}-#{self.name.parameterize}"
  end


  def badge
    result = case self.id
             when 1 then "/assets/badges/tisa.png"
             when 2 then "/assets/badges/agv.png"
             when 3 then "/assets/badges/cremer.png"
             when 4 then "/assets/badges/morenarosa.png"
             when 5 then "/assets/badges/omega.png"
             when 6 then "/assets/badges/manguetarpon.png"
             else "/assets/badges/tisa.png"
             end
  end

end
