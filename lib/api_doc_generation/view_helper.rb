# encoding: utf-8

module ApiDocGeneration; class ViewHelper
  def self.render(template, args = {}, file_path = '')
    template.result(self.new(args).obj_binding)

  rescue => e
    e.backtrace[0].gsub!(/^\(erb\)/, file_path)
    
    raise e
  end


  # {:a => 1, :b => 2}
  def initialize(args)
    @args = args
    
    args.each do |key, val|
      self.instance_variable_set("@#{key}", val)
    end
  end


  def obj_binding
    binding
  end




  ################## View Helper ###################

  def render(path, opts = {})
    path = "templates/_#{path}.*.erb"
    file_path = Dir[File.expand_path(path, ROOT_PATH)].first
    raise "no found file '#{path}'" unless file_path

    template = ERB.new(File.read(file_path))

    self.class.render(template, @args.merge(opts), file_path)
  end



  ################## Helper #######################
  def action_identifer(controller_name, action_name)
    "action-#{Digest::MD5.hexdigest(controller_name)}-#{action_name}"
  end


  def controller_identifer(controller_name)
    "controller-#{Digest::MD5.hexdigest(controller_name)}"
  end


  def format_param(param)
    return unless param['val'].to_s =~ /^\s*$/

    case param['name']
    when 'app_uname'
      param['type'] = 'String'
      param['val'] = 'app的唯一标识名，表明调用此api是在哪个app下'
    when 'access_token'
      param['type'] = 'String'
      param['val'] = '请求的唯一标识，用于识别用户，用户登陆返回或是使用refresh_token换取'
    when 'refresh_token'
      param['type'] = 'String'
      param['val'] = '用户登陆时返回，使用此token来取得新的access_token'
    when 'page'
      param['type'] = 'Integer'
      param['val'] = '返回所有数据中的第几页'
    when 'perpage'
      param['type'] = 'Integer'
      param['val'] = '返回数据每页多少条'
    end
  end


  def format_response_param(param)
    return unless param['val'].to_s =~ /^\s*$/

    case param['name']
    when 'current_page'
      param['type'] = 'Integer'
      param['val'] = '当前返回数据是第几页'
    when 'perpage'
      param['type'] = 'Integer'
      param['val'] = '每页返回的数据量'
    when 'count'
      param['type'] = 'Integer'
      param['val'] = '数据总数量'
    when 'items'
      param['type'] = 'Array'
      param['val'] = '数组中存放当前页的数据'
    when 'total_pages'
      param['type'] = 'Integer'
      param['val'] = '数据的总页数'
    end
  end


  def format_other_param(param)
    
  end
end; end
