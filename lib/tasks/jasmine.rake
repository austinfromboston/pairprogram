require 'jasmine'

task :jasmine => ['jasmine:update_fixtures']
namespace :jasmine do
  task :update_fixtures => :environment do
    fixtures_folder_name = Rails.root.join('tmp/jasmine-dom-fixtures')
    raise "fixtures folder doesn't exist.  run rake spec?" unless File.exist?(fixtures_folder_name)
    fixtures_dir = Dir.new(fixtures_folder_name)
    fixtures = fixtures_dir.entries.inject({}) do |fixtures, file_name|
      next fixtures unless file_name =~ /html$/
      value = File.read( fixtures_folder_name.join(file_name))
      fixtures[file_name] = value
      fixtures
    end
    File.open('spec/javascripts/helpers/fixtures.js', 'w') do |f|
      f.puts "Fixtures = " + fixtures.to_json;
    end
  end
end
load 'jasmine/tasks/jasmine.rake'
