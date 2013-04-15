class EnjuCirculation::SetupGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)

  def copy_setup_files
    directory("db/fixtures", "db/fixtures/enju_circulation")
    rake("enju_circulation_engine:install:migrations")
    generate("enju_event:setup")
    generate("enju_message:setup")
    inject_into_file 'app/controllers/application_controller.rb',
      "  enju_circulation\n", :after => "enju_library\n"
    append_to_file("config/schedule.rb", File.open(File.expand_path('../templates', __FILE__) + '/config/schedule.rb').read)
  end
end
