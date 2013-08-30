require 'thor'
require 'wordpress_tools/wordpress_cli'

module WordPressTools
  class CLI < Thor
    include Thor::Actions

    desc "new [DIR_NAME]", "download the latest stable version of WordPress in a new directory with specified name (default is wordpress)"
    method_option :locale, :aliases => "-l", :desc => "WordPress locale (default is en_US)"
    method_option :bare, :aliases => "-b", :desc => "Remove default themes and plugins"

    def new(dir_name = 'wordpress')
      WordPressCLI.new(options, dir_name, self).download!
    end
  end
end

