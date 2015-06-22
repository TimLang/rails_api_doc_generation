
module ApiDocGeneration
  path = File.expand_path("../tasks", __FILE__)

  Dir.open(path).each do |ext|
    load File.expand_path(ext, path) if ext =~ /^\w+\.rake$/
  end
end
