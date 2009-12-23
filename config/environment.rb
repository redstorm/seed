# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.5' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  
  config.plugin_paths += ["#{RAILS_ROOT}/vendor/plugins/seed"]

  config.gem 'will_paginate', :version => '~> 2.3.11', :lib => 'will_paginate', 
      :source => 'http://gemcutter.org'

  config.gem 'RedCloth'

  config.time_zone = 'UTC'

  config.action_controller.session = {
    :session_key => '_seed_session',
    :secret      => 'ce5eae87cde88001a43bd0a4ae9aeabc3ba441f35a50d3d73a771d8efe245f028cd626f230081073d9360d0b15fdc30f167cbcd62d194437cabac056589b956d'
  }

  config.action_controller.session_store = :active_record_store

  config.active_record.observers = :user_observer
  
  config.load_paths << "#{RAILS_ROOT}/app/sweepers"
end

ActionController::Base.prepend_view_path("vendor/plugins/#{APP_CONFIG[:app_name]}_engine/app/views")

require 'seed_stylesheets'
