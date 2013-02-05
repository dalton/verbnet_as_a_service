class ThematicRole
  include Mongoid::Document
  field :name, type: String
  embeds_one :selectional_restriction

  def prefers?(argument)
    selectional_restriction.accepts?(argument)
  end
end
