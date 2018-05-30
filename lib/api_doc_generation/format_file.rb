

module ApiDocGeneration; module FormatFile; class << self
  def analyze_file(path)
    controller_path = path.split("app/controllers").last
    class_name = controller_path.gsub(/controller.*\.rb/, 'controller').classify

    klass = class_name.safe_constantize
    filelines = File.readlines(path)
    actions = klass.action_methods - klass.superclass.action_methods
    ctrl_about = get_controller_about(filelines, klass.to_s)

    actions = actions.map do |action|
      method = klass.instance_method action
      filepath, line = method.source_location

      note = FormatNote.analyze(filelines, line - 2)
      note["Level"] ||= ''
      note['Name'] = action.to_s

      unless note['Path']
        note = get_routes(klass, action).merge(note)
      else
        note['Path'] = note['Path'][0]['desc'] 
        note['Method'] = note['Method'][0]['desc'] rescue nil
      end

      note
    end

    actions.delete_if do |val|
      val['Return'].nil?
    end
    
    {
      'Path' => path,
      'Klass' => klass.to_s,
      'About' => ctrl_about,
      'Actions' => actions
    }
  end


  private

  def get_controller_about(filelines, class_name)
    filelines.each_with_index do |line, line_number|
      next if line =~ /^\s*(\#.*)?$/

      doc = FormatNote.analyze(filelines, line_number -1)

      doc.delete_if {|key, v| key =~ /encoding/ }

      return doc
    end

    return {}
  end


  def get_routes(klass, action)
    controller = klass.to_s.gsub(/Controller$/, '').underscore

    (@routes ||= rails_routes).each do |route|
      if route[:reqs].sub(/[[:blank:]]*{:format=\>[[:blank:]]*"json"}/,'') == "#{controller}##{action}"
        return {
          'Path' => route[:path].gsub('(.:format)', ''),
          'Method' => route[:verb]
        }
      end
    end

    {
      'Path' => "",
      'Method' => ""
    }
  end

#   all_routes = Rails.application.routes.routes
#   require 'action_dispatch/routing/inspector'
#   inspector = ActionDispatch::Routing::RoutesInspector.new(all_routes)
#   puts inspector.format(ActionDispatch::Routing::ConsoleFormatter.new, ENV['CONTROLLER'])

  def rails_routes
    Rails.application.reload_routes!
    all_routes = Rails.application.routes.routes

    if Rails.version < '4.0.0'
      require 'rails/application/route_inspector'
      inspector = Rails::Application::RouteInspector.new
      inspector.collect_routes(all_routes) +
        inspector.instance_variable_get(:@engines).values.flatten
    else
      require 'action_dispatch/routing/inspector'
      inspector = ActionDispatch::Routing::RoutesInspector.new(all_routes)

      inspector.send(:collect_routes, all_routes) +
        inspector.instance_variable_get(:@engines).values.flatten
    end
  end
end; end; end
