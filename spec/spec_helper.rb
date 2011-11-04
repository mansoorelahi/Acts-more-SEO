$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'rubygems'
require 'sqlite3'
require 'active_record'
require 'acts_more_seo'

ActiveRecord::Base.establish_connection(
  :adapter => "sqlite3",
  :database  => ":memory:",
  :encoding => 'utf8',
  :collation => 'utf8_general_ci'
)

ActiveRecord::Schema.define do
    create_table :cool_elements do |table|
      table.string :name
    end

    create_table :cooler_elements do |table|
      table.string :title
    end

    create_table :special_elements do |table|
      table.string :title
      table.string :name
      table.string :surname
    end

    create_table :better_elements do |table|
      table.string :title
      table.string :name
      table.string :surname
    end

    create_table :best_elements do |table|
      table.string :title
      table.string :name
      table.string :surname
      table.string :seo_url
    end
end

