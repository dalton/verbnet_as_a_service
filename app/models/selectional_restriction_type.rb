require "net/http"
require "uri"
class SelectionalRestrictionType
  include Mongoid::Document
  field :value, type: String
  field :parent, type: String
  field :senses, type: Array

  def satisfied_by?(word)
    senses.to_a.map do |sense|
      uri = URI.parse("http://localhost:3000/word/#{CGI.escape word}/check/#{CGI.escape sense}.json")
      response = Net::HTTP.get_response(uri)
      response.body == "true" ? true : false
    end.any?

  end

end
