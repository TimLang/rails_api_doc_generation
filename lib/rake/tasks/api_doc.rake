
namespace :doc do
  task :api => :environment do
    require 'api_doc_generation'

    out_format = ENV['OUT_FORMAT'] || 'detailed_html'
    codes_path = ENV['CODES_PATH'] || File.expand_path('app/controllers/api', Rails.root)
    level = ENV['LEVEL'] ? ENV['LEVEL'].split(',') : nil
    title = ENV['TITLE']

    puts "Template: #{out_format}"
    generation = ApiDocGeneration::Generation.new(codes_path, title, {
      :show_base => ENV['SHOW_BASE'].to_s == 'true' ? true : false
    })

    puts generation.controller_documents if ENV['SHOW_DOCS']
    
    case out_format
    when 'simple_html'
      path = "./tmp/api_doc.html"
      puts "out_path: #{path}"

      File.open(path, "w+") do |f|
        f.write(generation.generate_html_string(:level => level))
      end
    when 'detailed_html'
      path = "./tmp/api_doc.html"
      puts "Out path: #{path}"

      File.open(path, 'w+') do |f|
        f.write(generation.generate_detailed_html_string(:level => level))
      end
    else
      puts "undefined OUT_FORMAT: '#{out_format}'"
    end
  end
end