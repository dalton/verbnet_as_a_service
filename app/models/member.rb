class Member
  include Mongoid::Document
  field :name, type: String
  field :wordnet_keys, type: Array

end
