require 'digest'

require "api_doc_generation/version"
require 'api_doc_generation/view_helper'


if defined? Rake
  require "rake/api_doc_generation"
end

require 'api_doc_generation/generation'


module ApiDocGeneration
  ROOT_PATH = File.expand_path('../../', __FILE__)
end
