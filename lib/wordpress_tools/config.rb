module WordPressTools
  class Configuration
    DEFAULT_CONFIG = {
      wp_cli_download_url: "https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar",
      wp_cli_path: "/usr/local/bin/wp",
      admin_user: "admin",
      admin_email: "admin@example.com",
      admin_password: "password",
      db_user: "root",
      db_password: "",
      site_url: "http://localhost:8080",
      locale: "en_US"
    }.freeze

    def self.for(key)
      DEFAULT_CONFIG[key]
    end
  end
end
