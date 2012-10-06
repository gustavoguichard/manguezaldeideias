class RemoveMinimunInvestmentFromIdeas < ActiveRecord::Migration
  def up
    remove_column :ideas, :minimum_investment
  end
  def down
    add_column :ideas, :minimum_investment, :decimal, :precision => 10, :scale => 2, :default => '0.00', :null => false
    Idea.update_all({ :minimum_investment => 0 }, { :minimum_investment => nil })
  end
end