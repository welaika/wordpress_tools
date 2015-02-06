require 'tempfile'
require 'net/http'
require 'open-uri'
require 'thor'
require 'active_support'
require 'active_support/all'

require 'wordpress_tools/cli_helper'
require 'wordpress_tools/wp_cli'
require 'wordpress_tools/wordpress'
require 'wordpress_tools/config'

module WordPressTools
  class CLI < Thor
    include Thor::Actions

    desc "new [DIR_NAME]", "download the latest stable version of WordPress in a new directory with specified name (default is wordpress)"
    method_option :locale, :aliases => "-l", :desc => "WordPress locale (default is en_US)"
    method_option :bare, :aliases => "-b", :desc => "Remove default themes and plugins"

    def new(dir_name = 'wordpress')
      if File.exists?(dir_name)
        say "Directory #{dir_name} already exists.", :red
        exit
      end

      Configuration.ask_user!
      WordPress.new(dir_name, options, self).install!
      WPCLI.new.install!
      # Database.new(user_parameters, self).create!
    end

  end
end

