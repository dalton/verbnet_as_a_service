class ThematicRole
  include Mongoid::Document
  field :name, type: String
  embeds_one :selectional_restriction
end
