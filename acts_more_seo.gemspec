# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{acts_more_seo}
  s.version = "0.3.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = [%q{Maciej Mensfeld}]
  s.date = %q{2011-11-28}
  s.description = %q{Gem makes your ActiveRecord models more SEO friendly. Changes URL to look way better}
  s.email = %q{maciej@mensfeld.pl}
  s.extra_rdoc_files = [%q{CHANGELOG.rdoc}, %q{README.md}, %q{lib/acts_more_seo.rb}, %q{lib/string_ext.rb}]
  s.files = [%q{CHANGELOG.rdoc}, %q{Gemfile}, %q{MIT-LICENSE}, %q{Manifest}, %q{README.md}, %q{Rakefile}, %q{acts_more_seo.gemspec}, %q{init.rb}, %q{lib/acts_more_seo.rb}, %q{lib/string_ext.rb}, %q{spec/acts_more_seo_spec.rb}, %q{spec/spec_helper.rb}]
  s.homepage = %q{https://github.com/mensfeld/Css-Image-Embedder}
  s.rdoc_options = [%q{--line-numbers}, %q{--inline-source}, %q{--title}, %q{Acts_more_seo}, %q{--main}, %q{README.md}]
  s.require_paths = [%q{lib}]
  s.rubyforge_project = %q{acts_more_seo}
  s.rubygems_version = %q{1.8.5}
  s.summary = %q{Gem makes your ActiveRecord models more SEO friendly. Changes URL to look way better}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<babosa>, [">= 0"])
      s.add_development_dependency(%q<rspec>, [">= 2.0.0"])
      s.add_development_dependency(%q<active_record>, [">= 0"])
    else
      s.add_dependency(%q<babosa>, [">= 0"])
      s.add_dependency(%q<rspec>, [">= 2.0.0"])
      s.add_dependency(%q<active_record>, [">= 0"])
    end
  else
    s.add_dependency(%q<babosa>, [">= 0"])
    s.add_dependency(%q<rspec>, [">= 2.0.0"])
    s.add_dependency(%q<active_record>, [">= 0"])
  end
end
