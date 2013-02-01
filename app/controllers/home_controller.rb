class HomeController < ApplicationController
  def index
    @classes = VerbnetClass.all.asc(:name)
  end

  def ingest
    require 'crack'
    puts "Ingesting Selectional Restriction Types"
    SelectionalRestrictionType.delete_all
    f = "#{Rails.root}/data/verbnet/vn_schema-3.xsd"
    file = open f
    data = Crack::XML.parse file

    data['xsd:schema']['xsd:simpleType'][6]['xsd:restriction']['xsd:enumeration'].each do |srt|
      puts srt
      SelectionalRestrictionType.create(value: srt["value"], parent: srt["parent"], senses: srt["wn"].to_a)
    end

    puts "Ingesting VerbNet Classes"
    VerbnetClass.delete_all
    files = Dir.glob("#{Rails.root}/data/verbnet/*.xml")
    files.each do |f|
      file = open f
      data = Crack::XML.parse file

      ingester = Ingesters::VerbnetClassIngester.new
      ingester.ingest data

    end
    redirect_to root_path
  end
end
