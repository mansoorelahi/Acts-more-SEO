# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{acts_more_seo}
  s.version = "0.1.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Maciej Mensfeld"]
  s.cert_chain = ["/home/mencio/.cert_keys/gem-public_cert.pem"]
  s.date = %q{2011-04-17}
  s.description = %q{Gem makes your ActiveRecord models more SEO friendly. Changes URL to look way better}
  s.email = %q{maciej@mensfeld.pl}
  s.extra_rdoc_files = ["CHANGELOG.rdoc", "README.md", "lib/acts_more_seo.rb", "lib/string_ext.rb"]
  s.files = ["CHANGELOG.rdoc", "Gemfile", "MIT-LICENSE", "Manifest", "README.md", "Rakefile", "acts_more_seo.gemspec", "init.rb", "lib/acts_more_seo.rb", "lib/string_ext.rb", "spec/acts_more_seo_spec.rb", "spec/spec_helper.rb"]
  s.homepage = %q{https://github.com/mensfeld/Css-Image-Embedder}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Acts_more_seo", "--main", "README.md"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{acts_more_seo}
  s.rubygems_version = %q{1.5.2}
  s.signing_key = %q{/home/mencio/.cert_keys/gem-private_key.pem}
  s.summary = %q{Gem makes your ActiveRecord models more SEO friendly. Changes URL to look way better}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rspec>, [">= 2.0.0"])
      s.add_development_dependency(%q<active_record>, [">= 0"])
    else
      s.add_dependency(%q<rspec>, [">= 2.0.0"])
      s.add_dependency(%q<active_record>, [">= 0"])
    end
  else
    s.add_dependency(%q<rspec>, [">= 2.0.0"])
    s.add_dependency(%q<active_record>, [">= 0"])
  end
end
