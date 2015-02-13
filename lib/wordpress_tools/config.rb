module WordPressTools
  class Configuration

    DEFAULT_CONFIG = {
      wp_cli_download_url: "https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar",
      wp_cli_path: "/usr/local/bin/wp"
    }.freeze

    def self.for(key)
      DEFAULT_CONFIG[key]
    end

  end
end
