module WordPressTools
  class CLI < Thor
    include Thor::Actions

    desc "new [DIR_NAME]", "download the latest stable version of WordPress in a new directory with specified name (default is wordpress)"
    method_option :locale, aliases: "-l", desc: "WordPress locale (default is en_US)"
    method_option :bare, aliases: "-b", desc: "Remove default themes and plugins"
    method_option :admin_email, desc: "WordPress admin email", default: "admin@example.com"
    method_option :admin_password, desc: "WordPress admin password", default: "password"
    method_option :db_user, desc: "MySQL database user", default: "root"
    method_option :db_password, desc: "MySQL database pasword", default: ""

    def new(dir_name = 'wordpress')
      if File.exist?(dir_name)
        say "Directory #{dir_name} already exists.", :red
        exit
      end

      WPCLI.new.invoke :install_core, options
      # WPCLI.new.invoke :install_wp_server, options
      # Database.new.invoke :create, [dir_name], options
      # WordPress.new.invoke :download, [dir_name], options
      # WordPress.new.invoke :setup, [dir_name], options
    end
  end
end

