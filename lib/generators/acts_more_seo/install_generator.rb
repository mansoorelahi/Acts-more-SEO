module ActsMoreSeo
  class InstallGenerator < Rails::Generators::Base
    source_root File.expand_path("../templates", __FILE__)

    def add_my_migration
      timestamp = Time.now.strftime("%Y%m%d%H%M%S")
      source = "create_seo_history_migration.rb"
      target = "db/migrate/#{timestamp}_create_seo_history_migration.rb"
      copy_file source, target
    end

  end
end
