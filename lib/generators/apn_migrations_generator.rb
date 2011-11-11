require 'rails/generators/active_record'
# Generates the migrations necessary for APN on Rails.
# This should be run upon install and upgrade of the 
# APN on Rails gem.
# 
#   $ rails g apn_migrations
class ApnMigrationsGenerator < Rails::Generators::Base
  source_root File.join(File.dirname(__FILE__), 'templates')
  argument :name, :default => "migration"
  
  @timestamp = Time.now.utc.strftime("%Y%m%d%H%M%S")
  include Rails::Generators::Migration
  
  def self.next_migration_number(dirname)
    @timestamp = @timestamp.succ
    @timestamp
  end
  
  def create_migrations
    Dir.glob(File.join(File.dirname(__FILE__), 'templates', 'apn_migrations', '*.rb')).sort.each do |file|
      filename = Pathname.new(file).basename.to_s.gsub(/^\d+_/, '')
      migration_template file, "db/migrate/#{filename}"
    end
  end
  
end