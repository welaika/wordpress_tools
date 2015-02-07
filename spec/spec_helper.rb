require 'fakeweb'
require 'pry-byebug'
require 'pathname'

require (Pathname.new(__FILE__).dirname + '../lib/wordpress_tools').expand_path

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.warnings = true

  if config.files_to_run.one?
    config.default_formatter = 'doc'
  end

  config.order = :random
end

FakeWeb.allow_net_connect = false
WP_API_RESPONSE = <<-eof
    upgrade
    http://wordpress.org/download/
    http://wordpress.org/wordpress-3.6.zip
    3.6
    en_US
    5.2.4
    5.0
eof
FakeWeb.register_uri(:get, %r|http://api.wordpress.org/core/version-check/1.5/.*|, :body => WP_API_RESPONSE)
FakeWeb.register_uri(:get, "http://wordpress.org/wordpress-3.6.zip", :body => File.expand_path('spec/fixtures/wordpress_stub.zip'))
FakeWeb.register_uri(:get, "https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar", :body => File.expand_path('spec/fixtures/wp-cli.phar'))
