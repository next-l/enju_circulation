class EnjuCirculation::SetupGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)
  argument :file, :type => :string, :default => "all"

  def copy_setup_files
    directory("db/fixtures", "db/fixtures/enju_circulation")
    return if file == 'fixture'
    rake("enju_circulation_engine:install:migrations")
    rake("enju_event_engine:install:migrations")
    rake("enju_message_engine:install:migrations")
    generate("enju_event:setup")
    generate("enju_message:setup")
    inject_into_file 'app/controllers/application_controller.rb',
      "  enju_circulation\n", :after => "enju_library\n"
    inject_into_file 'app/models/user.rb',
      "  enju_circulation_user_model\n", :after => "enju_leaf_user_model\n"
    append_to_file "config/initilizers/enju_leaf.rb", <<EOS
Accept.include(EnjuCirculation::EnjuAccept)
Basket.include(EnjuCirculation::EnjuBasket)
CarrierType.include(EnjuCirculation::EnjuCarrierType)
Manifestation.include(EnjuCirculation::EnjuManifestation)
Item.include(EnjuCirculation::EnjuItem)
Profile.include(EnjuCirculation::EnjuProfile)
UserGroup.include(EnjuCirculation::EnjuUserGroup)
Withdraw.include(EnjuCirculation::EnjuWithdraw)
EOS
    append_to_file("config/schedule.rb", File.open(File.expand_path('../templates', __FILE__) + '/config/schedule.rb').read)
    append_to_file 'config/initializers/inflections.rb',  <<EOS
ActiveSupport::Inflector.inflections do |inflect|
  inflect.irregular 'reserve', 'reserves'
end
EOS
  end
end
