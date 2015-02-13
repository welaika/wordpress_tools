module WordPressTools
  class WPCLI < Thor
    include CLIHelper

    desc "install_core", ""
    def install_core
      return unless overwrite_wp_cli?

      download_wp_cli
      move_wp_cli
      make_wp_cli_executable

      if File.exist?(wp_cli_path)
        success "WP-CLI installed."
      else
        error "Could not install WP-CLI."
      end
    end

    desc "install_wp_server", ""
    def install_wp_server
      return unless overwrite_wp_server?

      remove_existing_wp_server
      download_wp_server
      configure_wp_server
    end

    no_tasks do

      def overwrite_wp_cli?
        if wp_cli_installed?
          yes? "WP-CLI already installed [#{wp_cli_path}]. Do you want to overwite it? [y]es, [N]o"
        else
          true
        end
      end

      def overwrite_wp_server?
        if wp_server_installed?
          yes? "WP-CLI server command already installed [#{wp_server_direcory}]. Do you want to overwite it? [y]es, [N]o"
        else
          true
        end
      end

      def wp_cli_installed?
        run_command("which wp")
      end

      def wp_server_installed?
        File.exist?(File.join(wp_server_direcory, 'command.php'))
      end

      def download_wp_cli
        info "Downloading WP-CLI"
        get(wp_cli_download_url, wp_cli_download_path, verbose: false, force: true) || error("Could not download WP-CLI.")
      end

      def move_wp_cli
        info "Installing WP-CLI in [#{wp_cli_path}]"
        need_sudo = !File.writable?(wp_cli_dir)
        run_command(move_command(wp_cli_download_path, wp_cli_path, need_sudo))
      end

      def make_wp_cli_executable
        info "Make WP-CLI executable"
        need_sudo = !File.writable?(wp_cli_dir)
        run_command(executable_bit_command(wp_cli_path, need_sudo))
      end

      def remove_existing_wp_server
        FileUtils.rm_rf([wp_server_direcory, wp_cli_config_path])
      end

      def download_wp_server
        info "Installing WP-CLI server command"
        get(wp_server_download_url, wp_server_download_path, verbose: false, force: true) || error("Cannot download WP-CLI server command")

        FileUtils.mkdir_p(wp_server_direcory)
        unzip(wp_server_download_path, wp_server_direcory, "-j")

        success "Installed WP-CLI server command in '#{wp_server_direcory}'"
      end

      def configure_wp_server
        FileUtils.mkdir_p(File.dirname(wp_cli_config_path))
        FileUtils.cp(File.expand_path("../../../templates/wp_cli_config.yml", __FILE__), wp_cli_config_path)
        success "WP-CLI server command configured"
      end

      def wp_cli_download_url
        Configuration.for(:wp_cli_download_url)
      end

      def wp_cli_download_path
        @wp_cli_download_path ||= Tempfile.new('wp_cli').path
      end

      def wp_server_download_path
        @wp_server_download_path ||= Tempfile.new('wp_server').path
      end

      def wp_cli_path
        if wp_cli_installed?
          run("which wp", verbose: false, capture: true).strip
        else
          Configuration.for(:wp_cli_path)
        end
      end

      def wp_cli_dir
        File.dirname(wp_cli_path)
      end

      def wp_server_download_url
        Configuration.for(:wp_server_download_url)
      end

      def wp_server_direcory
        Configuration.for(:wp_server_direcory)
      end

      def wp_cli_config_path
        Configuration.for(:wp_cli_config_path)
      end

    end
  end
end
