class EnjuCirculation::SetupGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)

  def copy_setup_files
    directory("db/fixtures", "db/fixtures/enju_circulation")
    rake("enju_circulation_engine:install:migrations")
  end
end
