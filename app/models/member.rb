class Member
  include Mongoid::Document
  field :name, type: String
  field :wordnet_keys, type: Array


  def <=>(o)
    self.name <=> o.name
  end
end
