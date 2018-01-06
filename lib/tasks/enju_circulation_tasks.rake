require 'active_record/fixtures'
require 'tasks/checkout'
require 'tasks/circulation_status'
require 'tasks/reserve'
require 'tasks/use_restriction'

namespace :enju_circulation do
  desc 'create initial records for enju_circulation'
  task setup: :environment do
    ActiveRecord::FixtureSet.create_fixtures('db/fixtures/enju_circulation', 'checkout_types')
    Dir.glob(Rails.root.to_s + '/db/fixtures/enju_circulation/*.yml').each do |file|
      ActiveRecord::FixtureSet.create_fixtures('db/fixtures/enju_circulation', File.basename(file, '.*'))
    end

    Rake::Task['enju_event:setup'].invoke
    Rake::Task['enju_message:setup'].invoke

    puts 'initial fixture files loaded.'
  end

  desc 'Calculate stats'
  task :stat => :environment do
    UserCheckoutStat.calculate_stat
    UserReserveStat.calculate_stat
    #ManifestationCheckoutStat.calculate_stat
    ManifestationReserveStat.calculate_stat
  end

  desc 'Expire circulations and reservations'
  task :expire => :environment do
    Reserve.expire
    Basket.expire
  end

  desc 'Sending due date notifications'
  task :send_notification => :environment do
    Checkout.send_due_date_notification
    Checkout.send_overdue_notification
  end

  desc "upgrade enju_circulation"
  task :upgrade => :environment do
    Rake::Task['statesman:backfill_most_recent'].invoke('ManifestationCheckoutStat')
    Rake::Task['statesman:backfill_most_recent'].invoke('ManifestationReserveStat')
    Rake::Task['statesman:backfill_most_recent'].invoke('UserCheckoutStat')
    Rake::Task['statesman:backfill_most_recent'].invoke('UserReserveStat')
    Rake::Task['statesman:backfill_most_recent'].invoke('Reserve')
    puts 'enju_circulation: The upgrade completed successfully.'
  end

  desc "migrate old checkout records"
  task :migrate_old_checkout => :environment do
    Checkout.transaction do
      update_checkout
    end
  end
end
