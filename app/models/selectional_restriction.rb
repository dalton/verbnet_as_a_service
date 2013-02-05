class SelectionalRestriction
  include Mongoid::Document
  recursively_embeds_many
  field :value, type: String
  field :type, type: String
  field :logic, type: String

  def to_s
    return "#{value}#{type}" unless child_selectional_restrictions.any?
    "[#{child_selectional_restrictions.map { |sr| sr.to_s }.join(" #{symbol logic} ")}]"
  end

  def symbol(word)
    logic == "or" ? "|" : "&"
  end

  def satisfied_by?(word)
    accepts?(word)
  end

  def accepts?(argument)
    if child_selectional_restrictions.empty?
      srt = SelectionalRestrictionType.where(value: type).first
      srt.nil? ? true : srt.satisfied_by?(argument)
    else
      csr = child_selectional_restrictions.map { |sr| sr.accepts?(argument) }
      if logic == "or"
        csr.any?
      else
        csr.all?
      end
    end
  end
end
