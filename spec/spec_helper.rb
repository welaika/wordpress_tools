$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'fakeweb'
require 'pry-byebug'
require 'priscilla'

require 'wordpress_tools'

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
    https://wordpress.org/download/
    https://downloads.wordpress.org/release/wordpress-4.3.zip
    4.3
    en_US
    5.2.4
    5.0
eof
FakeWeb.register_uri(:get, %r|https://api.wordpress.org/core/version-check/1.5/.*|, body: WP_API_RESPONSE)
FakeWeb.register_uri(:get, "https://downloads.wordpress.org/release/wordpress-4.3.zip", body: File.expand_path('spec/fixtures/wordpress_stub.zip'))
