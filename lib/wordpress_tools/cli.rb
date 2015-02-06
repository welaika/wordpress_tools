require 'thor'
require 'wordpress_tools/wordpress_cli'
require 'wordpress_tools/config'
require 'active_support'
require 'active_support/all'

module WordPressTools
  class CLI < Thor
    include Thor::Actions

    desc "new [DIR_NAME]", "download the latest stable version of WordPress in a new directory with specified name (default is wordpress)"
    method_option :locale, :aliases => "-l", :desc => "WordPress locale (default is en_US)"
    method_option :bare, :aliases => "-b", :desc => "Remove default themes and plugins"

    def new(dir_name = 'wordpress')
      user_parameters
      WordPressCLI.new(options, dir_name, self).download!
      
    end

    private

    def user_parameters
      @user_parameters ||= {
        admin_email: ask_for("Insert wordpress admin email", :admin_email),
        admin_password: ask_for("Insert wordpress admin password", :admin_password),
        db_user: ask_for("Insert MySQL user", :db_user),
        db_password: ask_for("Insert MySQL password", :db_password)
      }
    end

    def ask_for(message, option)
      ask("#{message}: [#{WordPressTools.config_for(option)}]").presence || WordPressTools.config_for(option)
    end

  end
end

