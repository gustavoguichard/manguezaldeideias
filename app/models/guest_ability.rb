class GuestAbility
  include CanCan::Ability
  def initialize
    cannot :read, :all
  end
end

