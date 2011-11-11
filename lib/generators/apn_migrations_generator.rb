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
    Dir.glob(File.join(File.dirname(__FILE__), 'templates', 'apn_migrations', '*.rb')).sort.each do |f|
      migration_template f, "db/migrate"
    end
    # migration_template '001_create_apn_devices.rb', 'db/migrate/create_apn_devices.rb'
    # migration_template '002_create_apn_notifications.rb', 'db/migrate/create_apn_notifications.rb'
    # migration_template '003_alter_apn_devices.rb', 'db/migrate/alter_apn_devices.rb'
  end
    
  # def manifest # :nodoc:
  #   record do |m|
  #     timestamp = Time.now.utc.strftime("%Y%m%d%H%M%S")
  #     db_migrate_path = File.join('db', 'migrate')
  #     
  #     m.directory(db_migrate_path)
  #     
  #     Dir.glob(File.join(File.dirname(__FILE__), 'templates', 'apn_migrations', '*.rb')).sort.each_with_index do |f, i|
  #       f = File.basename(f)
  #       f.match(/\d+\_(.+)/)
  #       timestamp = timestamp.succ
  #       if Dir.glob(File.join(db_migrate_path, "*_#{$1}")).empty?
  #         m.file(File.join('apn_migrations', f), 
  #                File.join(db_migrate_path, "#{timestamp}_#{$1}"), 
  #                {:collision => :skip})
  #       end
  #     end
  #     
  #   end # record
  #   
  # end # manifest
  
end # ApnMigrationsGenerator