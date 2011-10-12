require 'active_record/fixtures'
desc "copy fixtures for enju_circulation"
task :enju_circulation => :environment do
  path = File.expand_path(File.dirname(__FILE__)) + '/../../db/fixtures/'
  Dir.glob(path + '*.yml').each do |file|
    ActiveRecord::Fixtures.create_fixtures(path, File.basename(file, '.*'))
  end
end
