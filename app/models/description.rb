class Description
  include Mongoid::Document
  field :number, type: String
  field :primary, type: String
  field :secondary, type: String
  field :xtag, type: String
end
