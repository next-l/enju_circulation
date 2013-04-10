require 'active_record/fixtures'
desc "create initial records for enju_circulation"
namespace :enju_circulation do
  task :setup => :environment do
    Dir.glob(Rails.root.to_s + '/db/fixtures/enju_circulation/*.yml').each do |file|
      ActiveRecord::Fixtures.create_fixtures('db/fixtures/enju_circulation', File.basename(file, '.*'))
    end

    Rake::Task['enju_event:setup'].invoke
    Rake::Task['enju_message:setup'].invoke

    puts 'initial fixture files loaded.'
  end
end
