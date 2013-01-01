# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "acts_more_seo"
  s.version = "0.4.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Maciej Mensfeld"]
  s.date = "2013-01-01"
  s.description = "Gem makes your ActiveRecord models more SEO friendly. Changes URL to look way better"
  s.email = "maciej@mensfeld.pl"
  s.extra_rdoc_files = ["CHANGELOG.rdoc", "README.md", "lib/acts_more_seo.rb", "lib/generators/acts_more_seo/install_generator.rb", "lib/generators/acts_more_seo/templates/create_seo_history_migration.rb", "lib/seo_finder.rb", "lib/seo_formatter.rb", "lib/seo_history.rb", "lib/string_ext.rb"]
  s.files = ["CHANGELOG.rdoc", "Gemfile", "MIT-LICENSE", "Manifest", "README.md", "Rakefile", "acts_more_seo.gemspec", "init.rb", "lib/acts_more_seo.rb", "lib/generators/acts_more_seo/install_generator.rb", "lib/generators/acts_more_seo/templates/create_seo_history_migration.rb", "lib/seo_finder.rb", "lib/seo_formatter.rb", "lib/seo_history.rb", "lib/string_ext.rb", "spec/acts_more_seo_spec.rb", "spec/spec_helper.rb"]
  s.homepage = "https://github.com/mensfeld/Css-Image-Embedder"
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Acts_more_seo", "--main", "README.md"]
  s.require_paths = ["lib"]
  s.rubyforge_project = "acts_more_seo"
  s.rubygems_version = "1.8.10"
  s.summary = "Gem makes your ActiveRecord models more SEO friendly. Changes URL to look way better"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<babosa>, [">= 0"])
      s.add_development_dependency(%q<rspec>, [">= 2.0.0"])
      s.add_development_dependency(%q<activerecord>, [">= 0"])
    else
      s.add_dependency(%q<babosa>, [">= 0"])
      s.add_dependency(%q<rspec>, [">= 2.0.0"])
      s.add_dependency(%q<activerecord>, [">= 0"])
    end
  else
    s.add_dependency(%q<babosa>, [">= 0"])
    s.add_dependency(%q<rspec>, [">= 2.0.0"])
    s.add_dependency(%q<activerecord>, [">= 0"])
  end
end
