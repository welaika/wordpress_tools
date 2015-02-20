module WordPressTools
  class WPCLIServer < Thor
    include CLIHelper

    desc "install", ""
    def install
      return unless overwrite?

      remove_existing
      download
      configure
    end

    no_tasks do
      def overwrite?
        if installed?
          yes? "WP-CLI server command already installed [#{install_dir}]. Do you want to overwite it? [y]es, [N]o"
        else
          true
        end
      end

      def installed?
        File.exist?(File.join(install_dir, 'command.php'))
      end

      def remove_existing
        FileUtils.rm_rf([install_dir, wp_cli_config_path])
      end

      def download
        info "Installing WP-CLI server command"
        get(download_url, download_path, verbose: false, force: true) || error("Cannot download WP-CLI server command")

        FileUtils.mkdir_p(install_dir)
        unzip(download_path, install_dir, "-j")

        success "Installed WP-CLI server command in '#{install_dir}'"
      end

      def configure
        FileUtils.mkdir_p(File.dirname(wp_cli_config_path))
        FileUtils.cp(File.expand_path("../../../templates/wp_cli_config.yml", __FILE__), wp_cli_config_path)
        success "WP-CLI server command configured"
      end

      def download_url
        Configuration.for(:wp_server_download_url)
      end

      def install_dir
        @install_dir ||= File.expand_path(Configuration.for(:wp_server_directory))
      end

      def download_path
        @download_path ||= Tempfile.new('wp_server').path
      end

      def wp_cli_config_path
        File.expand_path(Configuration.for(:wp_cli_config_path))
      end
    end
  end
end
