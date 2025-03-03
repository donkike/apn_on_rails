require 'socket'
require 'openssl'
require 'configatron'

module ApnOnRails
  class Railtie < Rails::Railtie
    root_path = File.expand_path(File.join(File.dirname(__FILE__), '../..'))
    initializer 'configuration' do |app|
      configatron.apn.set_default(:passphrase, '')
      configatron.apn.set_default(:port, 2195)

      configatron.apn.feedback.set_default(:passphrase, configatron.apn.passphrase)
      configatron.apn.feedback.set_default(:port, 2196)

      if Rails.env.production?
        configatron.apn.set_default(:host, 'gateway.push.apple.com')
        configatron.apn.set_default(:cert, File.join(Rails.root, 'config', 'apple_push_notification_production.pem'))

        configatron.apn.feedback.set_default(:host, 'feedback.push.apple.com')
        configatron.apn.feedback.set_default(:cert, configatron.apn.cert)
      else
        configatron.apn.set_default(:host, 'gateway.sandbox.push.apple.com')
        configatron.apn.set_default(:cert, File.join(Rails.root, 'config', 'apple_push_notification_development.pem'))

        configatron.apn.feedback.set_default(:host, 'feedback.sandbox.push.apple.com')
        configatron.apn.feedback.set_default(:cert, configatron.apn.cert)
      end
    end
    generators do
      require File.join(root_path, 'lib/generators/apn_migrations_generator')
    end
  end
end

module APN # :nodoc:
  
  module Errors # :nodoc:
    
    # Raised when a notification message to Apple is longer than 256 bytes.
    class ExceededMessageSizeError < StandardError
      
      def initialize(message) # :nodoc:
        super("The maximum size allowed for a notification payload is 256 bytes: '#{message}'")
      end
      
    end
    
    class MissingCertificateError < StandardError
      def initialize
        super("This app has no certificate")
      end
    end
    
  end # Errors
  
end # APN

base = File.join(File.dirname(__FILE__), 'app', 'models', 'apn', 'base.rb')
require base

Dir.glob(File.join(File.dirname(__FILE__), 'app', 'models', 'apn', '*.rb')).sort.each do |f|
  require f
end

%w{ models controllers helpers }.each do |dir| 
  path = File.join(File.dirname(__FILE__), 'app', dir)
  $LOAD_PATH << path 
  # puts "Adding #{path}"
  begin
    if ActiveSupport::Dependencies.respond_to? :autoload_paths
      ActiveSupport::Dependencies.autoload_paths << path
      ActiveSupport::Dependencies.autoload_once_paths.delete(path)
    else
      ActiveSupport::Dependencies.load_paths << path 
      ActiveSupport::Dependencies.load_once_paths.delete(path) 
    end
  rescue NameError
    Dependencies.load_paths << path 
    Dependencies.load_once_paths.delete(path) 
  end
end
