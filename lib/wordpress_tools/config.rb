module WordPressTools
  class Configuration
    include CLIHelper

    DEFAULT_CONFIG = {
      admin_email: "admin@example.com",
      admin_password: "password",
      db_user: "root",
      db_password: "",
      wp_cli_download_url: "https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar",
      wp_cli_path: "/usr/local/bin/wp"
    }.freeze

    class << self

      def ask_user!
        @user_parameters ||= {
          admin_email: ask_for("Insert wordpress admin email", :admin_email),
          admin_password: ask_for("Insert wordpress admin password", :admin_password),
          db_user: ask_for("Insert MySQL user", :db_user),
          db_password: ask_for("Insert MySQL password", :db_password)
        }
      end

      def for(key)
        @user_parameters[key].presence || DEFAULT_CONFIG[key]
      end

      def ask_for(message, option)
        Thor::Shell::Color.new.ask("#{message}: [#{DEFAULT_CONFIG[option]}]")
      end
    end
  end
end
