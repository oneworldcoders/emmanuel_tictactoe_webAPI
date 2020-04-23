ENV['RACK_ENV'] ||= 'test'

Dir['./spec/support/**/*.rb'].sort.each { |f| require f }
require 'database_cleaner/active_record'
require 'rspec'
require 'rack/test'
require_relative '../lib/app'
