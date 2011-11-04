# Acts more SEO

## Install

    gem install acts_more_seo

and in your Gemfile:
    
    gem 'acts_more_seo'

## About

Gem makes your ActiveRecord models more SEO friendly. Changes URLs to look way better. You need  to include `acts_more_seo` in your class declaration and you're ready to go. No other changes required.

## Example

First of all - remember to make URL fields uniq!

    class CoolElement < ActiveRecord::Base
        acts_more_seo :title
    end

    mod = CoolElement.create({:title => 'cool stuuf :)'})
    cool_element_path(mod) ===> cool_elements/12345-cool-stuff

You can also pass an array of columns like this

    class CoolElement < ActiveRecord::Base
        acts_more_seo :columns => [:name, :surname, :title]
    end

    mod = CoolElement.create({
            :name => 'Maciej',
            :surname => 'Mensfeld',
            :title => 'cool stuuf :)'
          })
    cool_element_path(mod) ===> cool_elements/12345-maciej-mensfeld-cool-stuff

Further more - if you don't want to use na ID in your urls, just set use_id param to false

    class CoolElement < ActiveRecord::Base
        acts_more_seo :columns => [:name, :surname, :title], :use_id => false
    end

    mod = CoolElement.create({
            :name => 'Maciej',
            :surname => 'Mensfeld',
            :title => 'cool stuuf :)'
          })
    cool_element_path(mod) ===> cool_elements/maciej-mensfeld-cool-stuff

However, if you do so - it is highly recommended to create string seo_url column in your model:

    add_column :model, :seo_url, :string

so you can search via find_by_seo_url method:

    CoolElement.find_by_seo_url(params[:id])

You don't need to update seo_url, gem will hook up with this field automatically if it exists.

## Note on Patches/Pull Requests
 
* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a future version unintentionally.
* Commit, do not mess with Rakefile, version, or history.
  (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

## Copyright

Copyright (c) 2011 Maciej Mensfeld. See LICENSE for details.
