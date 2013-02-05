class VerbnetClass
  include Mongoid::Document
  recursively_embeds_many
  field :name, type: String
  embeds_many :members
  embeds_many :thematic_roles
  embeds_many :frames

  def self.named(n)
    VerbnetClass.or(
        {'name' => n},
        {"child_verbnet_classes.name" => n},
        {"child_verbnet_classes.child_verbnet_classes.name" => n}
    ).collect do |vc|
      vc.named_classes(n)
    end.flatten.first
  end

  def self.with_members(m)
    VerbnetClass.or(
        {'members.name' => m},
        {"child_verbnet_classes.members.name" => m},
        {"child_verbnet_classes.child_verbnet_classes.members.name" => m}
    ).collect do |vc|
      vc.class_members(m)
    end.flatten
  end

  def response_to_arguments(arguments)
    response = arguments.map do |k,v|
      thematic_roles.where(name: k).first.prefers?(v)
    end

    response.all? ? 'preferred' : 'violation'
  end

  def named_classes(n)
    results = []
    results << self if self.name == n
    results << self.child_verbnet_classes.collect { |c| c.named_classes(n) }
  end
  def class_members(n)
    results = []
    results << self if self.members.where('name' => n).count > 0
    results << self.child_verbnet_classes.collect { |c| c.class_members(n) }
  end
end
