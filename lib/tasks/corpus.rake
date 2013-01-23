require_relative '../../app/ingesters/verbnet_class_ingester'


namespace :corpus do
  desc "ingest verbnet"
  task :ingest => :environment do
    require 'crack'
    VerbnetClass.delete_all
    puts "Ingesting VerbNet Classes"
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

      File.open(file_name, "w") {|file| file.puts new_text}
    end
  end


end
