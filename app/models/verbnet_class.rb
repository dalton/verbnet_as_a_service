class VerbnetClass
  include Mongoid::Document
  recursively_embeds_many
  field :name, type: String
  embeds_many :members
  embeds_many :thematic_roles
  embeds_many :frames

  def self.named(n)
    return all.to_a unless n
    parts = n.split("-")
    name = parts.shift
    number = parts.join("-")
    VerbnetClass.or(
        {'name' => /^#{name}-#{number}/i},
        {"child_verbnet_classes.name" => /^#{name}-#{number}/i},
        {"child_verbnet_classes.child_verbnet_classes.name" => /^#{name}-#{number}/i}
    ).collect do |vc|
      vc.named_classes(n)
    end.flatten
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

  def self.search(query)
    {members: with_members(query).sort, classes: named(query).sort}
  end

  def self.name_search(query)
    result = search(query)
    {members: result[:members].collect(&:name), classes: result[:classes].collect(&:name)}
  end

  def response_to_arguments(arguments)
    response = arguments.map do |k, v|
      role = thematic_roles.where(name: k).first
      if role
        role.prefers?(v)
      else
        self.parent_verbnet_clas.nil? ? true :( self.parent_verbnet_clas.response_to_arguments({k => v}) == 'preferred')
      end
    end

    response.all? ? 'preferred' : 'violation'
  end

  def named_classes(n)
    results = []
    results << self if self.name.include?(n)
    results << self.child_verbnet_classes.collect { |c| c.named_classes(n) }
  end

  def class_members(n)
    results = []
    results << self if self.members.where('name' => n).count > 0
    results << self.child_verbnet_classes.collect { |c| c.class_members(n) }
  end

  def <=>(o)
    self.name <=> o.name
  end
end
