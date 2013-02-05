require "net/http"
require "uri"
class SelectionalRestrictionType
  include Mongoid::Document
  field :value, type: String
  field :parent, type: String
  field :senses, type: Array

  def satisfied_by?(word)
    return true if senses.to_a.map do |sense|
      uri = URI.parse("http://localhost:3000/word/#{CGI.escape word}/check/#{CGI.escape sense}.json")
      response = Net::HTTP.get_response(uri)
      response.body == "true" ? true : false
    end.any?

    children_satisfied_by? word
  end

  private
  def children_satisfied_by?(word)
    SelectionalRestrictionType.where(parent: value).map do |child|
      child.satisfied_by?(word)
    end.any?
  end

end
