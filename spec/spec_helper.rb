require 'rubygems'
gem 'rspec', '>=1.1.3'
require 'spec'
require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent + 'lib/dm-is-taggable'

def load_driver(name, default_uri)
  return false if ENV['ADAPTER'] != name.to_s

  lib = "do_#{name}"

  begin
    gem lib, '>=0.9.5'
    require lib
    DataMapper.setup(name, ENV["#{name.to_s.upcase}_SPEC_URI"] || default_uri)
    DataMapper::Repository.adapters[:default] =  DataMapper::Repository.adapters[name]
    true
  rescue Gem::LoadError => e
    warn "Could not load #{lib}: #{e}"
    false
  end
end

ENV['ADAPTER'] ||= 'mysql'

HAS_SQLITE3  = load_driver(:sqlite3,  'sqlite3::memory:')
HAS_MYSQL    = load_driver(:mysql,    'mysql://root@localhost/dm_is_taggable_test')
HAS_POSTGRES = load_driver(:postgres, 'postgres://maxime@localhost/dm_is_taggable_test')

require "dm-types"
require "dm-aggregates"

require Pathname(__FILE__).dirname.expand_path / 'data' / 'bot'
require Pathname(__FILE__).dirname.expand_path / 'data' / 'user'
require Pathname(__FILE__).dirname.expand_path / 'data' / 'picture'
require Pathname(__FILE__).dirname.expand_path / 'data' / 'article'
