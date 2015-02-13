module WordPressTools
  class WPCLI < Thor
    include CLIHelper

    desc "install_core", ""
    def install_core
      return unless overwrite?

      download_wp_cli
      move_wp_cli
      make_wp_cli_executable

      if File.exist?(wp_cli_path)
        success "WP-CLI installed."
      else
        error "Could not install WP-CLI."
      end
    end

    desc "install_wpserver", ""
    def install_wpserver

    end

    no_tasks do

      def overwrite?
        if wp_cli_installed?
          yes? "WP-CLI already installed [#{wp_cli_path}]. Do you want to overwite it? [y]es, [N]o"
        else
          true
        end
      end

      def wp_cli_installed?
        run_command("which wp")
      end

      def download_wp_cli
        info "Downloading WP-CLI"
        get(wp_cli_download_url, download_path, verbose: false, force: true) || error("Could not download WP-CLI.")
      end

      def move_wp_cli
        info "Installing WP-CLI in [#{wp_cli_path}]"
        need_sudo = !File.writable?(wp_cli_dir)
        run_command(move_command(download_path, wp_cli_path, need_sudo))
      end

      def make_wp_cli_executable
        info "Make WP-CLI executable"
        need_sudo = !File.writable?(wp_cli_dir)
        run_command(executable_bit_command(wp_cli_path, need_sudo))
      end

      def wp_cli_download_url
        Configuration.for(:wp_cli_download_url)
      end

      def download_path
        @download_path ||= Tempfile.new('wp_cli').path
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
    end

  end
end
