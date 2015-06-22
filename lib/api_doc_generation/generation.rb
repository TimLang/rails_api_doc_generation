

require 'api_doc_generation/format_file'
require 'api_doc_generation/format_note'


module ApiDocGeneration; class Generation
  attr_reader :controller_documents

  def initialize(codes_path = nil, title = '', opts = {})
    codes_path ||= File.expand_path('app/controllers/api', Rails.root)
    @controller_documents = []
    @title = title
    @opts = opts

    each_api_controllers_file(codes_path) do |path|
      ctrl_doc = FormatFile.analyze_file(path)
      next if ctrl_doc['About']['Desc'].nil? || ctrl_doc['About']['Desc'].length == 0
      next if ctrl_doc['Actions'].length == 0
      @controller_documents << ctrl_doc
    end
  end


  def generate_html_string(opts = {})
    path = File.read(File.expand_path('templates/doc.html.erb', ROOT_PATH))

    ViewHelper.render(ERB.new(path), opts.merge({
      :documents => @controller_documents,
      :title => @title
    }), path)
  end


  def generate_detailed_html_string(opts = {})
    path = File.read(File.expand_path('templates/doc_detailed.html.erb', ROOT_PATH))

    ViewHelper.render(ERB.new(path), opts.merge({
      :documents => @controller_documents,
      :title => @title
    }), path)
  end


  private


  # API_CONTROLLERS_DIR = File.expand_path('app/controllers/api/**/*.rb', Rails.root)
  def each_api_controllers_file(codes_path, &block)
    paths = codes_path.end_with?('.rb') ? [codes_path] : Dir[codes_path + '/**/*.rb']
    paths.each do |path|
      next if path =~ /base_controller.*\.rb$/ && @opts[:show_base] != true
      block.call path
    end
  end
end; end

