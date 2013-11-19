require 'active_record/fixtures'
namespace :enju_circulation do
  desc "create initial records for enju_circulation"
  task :setup => :environment do
    Dir.glob(Rails.root.to_s + '/db/fixtures/enju_circulation/*.yml').each do |file|
      ActiveRecord::Fixtures.create_fixtures('db/fixtures/enju_circulation', File.basename(file, '.*'))
    end

    Rake::Task['enju_event:setup'].invoke
    Rake::Task['enju_message:setup'].invoke

    puts 'initial fixture files loaded.'
  end

  desc 'Batch processing for circulation'
  task :stat => :environment do
    UserCheckoutStat.calculate_stat
    UserReserveStat.calculate_stat
    ManifestationCheckoutStat.calculate_stat
    ManifestationReserveStat.calculate_stat
  end

  task :expire => :environment do
    Reserve.expire
    Basket.expire
  end

  task :send_notification => :environment do
    Checkout.send_due_date_notification
    Checkout.send_overdue_notification
  end
end
