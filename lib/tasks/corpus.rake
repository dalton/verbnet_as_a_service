namespace :corpus do
  desc "ingest verbnet"
  task :ingest => :environment do
    require 'crack'
    puts "Ingesting Selectional Restriction Types"
    SelectionalRestrictionType.delete_all
    f = "./data/verbnet/vn_schema-3.xsd"
    file = open f
    data = Crack::XML.parse file

    data['xsd:schema']['xsd:simpleType'][6]['xsd:restriction']['xsd:enumeration'].each do |srt|
      puts srt
      SelectionalRestrictionType.create(value: srt["value"], parent: srt["parent"], senses: srt["wn"].to_a)
    end

    puts "Ingesting VerbNet Classes"
    VerbnetClass.delete_all
    files = Dir.glob("./data/verbnet/*.xml")
    files.each do |f|
      file = open f
      data = Crack::XML.parse file

      ingester = Ingesters::VerbnetClassIngester.new
      ingester.ingest data

    end
  end

  desc "allow for ruby sequencing of syntax"
  task :sequence => :environment do
    file_names = Dir.glob("./data/verbnet/*.xml")

    file_names.each do |file_name|
      text = File.read(file_name)
      new_text = text.gsub(/<NP /, '<SU type="NP" ')
      new_text = new_text.gsub(/<\/NP/, '</SU')
      new_text = new_text.gsub(/<ADJ /, '<SU type="ADJ" ')
      new_text = new_text.gsub(/<\/ADJ/, '</SU')
      new_text = new_text.gsub(/<ADV /, '<SU type="ADV" ')
      new_text = new_text.gsub(/<\/ADV/, '</SU')
      new_text = new_text.gsub(/<PREP/, '<SU type="PREP" ')
      new_text = new_text.gsub(/<\/PREP/, '</SU')
      new_text = new_text.gsub(/<LEX /, '<SU type="LEX" ')
      new_text = new_text.gsub(/<\/LEX/, '</SU')
      new_text = new_text.gsub(/<VERB/, '<SU type="VERB" ')

      File.open(file_name, "w") { |file| file.puts new_text }
    end
  end


end
