class VerbnetClass
  include Mongoid::Document
  recursively_embeds_many
  field :name, type: String
  embeds_many :members
  embeds_many :thematic_roles
  embeds_many :frames

  def self.search(f, q)
    a = VerbnetClass.where(f => q).all.to_a
    b = if VerbnetClass.where("child_verbnet_classes.#{f}" => q).count > 0
          VerbnetClass.where("child_verbnet_classes.#{f}" => q).all.map do |vnc|
            vnc.child_verbnet_classes.where(f => q).all.to_a
          end
        else
          []
        end
    c = if VerbnetClass.where("child_verbnet_classes.child_verbnet_classes.#{f}" => q).count > 0
          VerbnetClass.where("child_verbnet_classes.child_verbnet_classes.#{f}" => q).all.map do |vnc|
            vnc.child_verbnet_classes.where("child_verbnet_classes.#{f}" => q).all.map do |vnc2|
              vnc2.child_verbnet_classes.where(f => q).all.to_a
            end
          end
        else
          []
        end
    d = if VerbnetClass.where("child_verbnet_classes.child_verbnet_classes.child_verbnet_classes.#{f}" => q).count > 0
          VerbnetClass.where("child_verbnet_classes.child_verbnet_classes.child_verbnet_classes.#{f}" => q).all.map do |vnc|
            vnc.child_verbnet_classes.where("child_verbnet_classes.child_verbnet_classes.#{f}" => q).all.map do |vnc2|
              vnc2.child_verbnet_classes.where("child_verbnet_classes.#{f}" => q).all.map do |vnc3|

                vnc3.child_verbnet_classes.where(f => q).all.to_a
              end
            end
          end
        else
          []
        end
    (a + b + c +d).flatten

  end


  def response_to_arguments(arguments)
    return 'preferred' if arguments['Agent']
  end

  def self.each_matching_subclass(n, q)
    queries = 0.upto(n).collect { |l| level_n_query(l, q) }
    VerbnetClass.or(*queries).collect { |c| c.each_matching_subclass(q) }
  end

  # recursive, returns array of all subcomments that match q including self
  def each_matching_subclass(q)
    yield self if self.name =~ q
    self.child_verbnet_classes.each { |c| c.each_matching_subclass(q) }
  end

  private
  def self.level_n_query(n, q)
    key = (['child_verbnet_classes'] * n).join('.') + '.name'
    return {key => q}
  end

end
