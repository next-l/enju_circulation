class EnjuCirculation::SetupGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)
  argument :file, type: :string, default: "all"

  def copy_setup_files
    directory("db/fixtures", "db/fixtures/enju_circulation")
    return if file == 'fixture'
    rake("enju_message_engine:install:migrations")
    rake("enju_event_engine:install:migrations")
    rake("enju_circulation_engine:install:migrations")
    generate("enju_message:setup")
    generate("enju_event:setup")
    inject_into_class "app/controllers/application_controller.rb", ApplicationController do
      "  include EnjuCirculation::Controller\n"
    end
    inject_into_class 'app/models/user.rb', User do
      "  include EnjuCirculation::EnjuUser\n"
    end
    append_to_file "app/models/user.rb", <<EOS
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
