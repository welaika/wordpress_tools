module WordPressTools
  class WPCLICore < Thor
    include CLIHelper

    desc "install", ""
    def install
      return unless overwrite?

      download
      move
      make_executable

      if installed?
        success "WP-CLI installed."
      else
        error "Could not install WP-CLI."
      end
    end

    no_tasks do
      def overwrite?
        if installed?
          yes? "WP-CLI already installed [#{install_path}]. Do you want to overwite it? [y]es, [N]o"
        else
          true
        end
      end

      def installed?
        run_command("which wp")
      end

      def download
        info "Downloading WP-CLI"
        get(download_url, download_path, verbose: false, force: true) || error("Could not download WP-CLI.")
      end

      def move
        info "Installing WP-CLI in [#{install_path}]"
        need_sudo = !File.writable?(install_dir)
        run_command(move_command(download_path, install_path, need_sudo))
      end

      def make_executable
        info "Make WP-CLI executable"
        need_sudo = !File.writable?(install_dir)
        run_command(executable_bit_command(install_path, need_sudo))
      end

      def download_url
        Configuration.for(:wp_cli_download_url)
      end

      def download_path
        @download_path ||= Tempfile.new('wp_cli').path
      end

      def install_path
        if installed?
          run("which wp", verbose: false, capture: true).strip
        else
          Configuration.for(:wp_cli_path)
        end
      end

      def install_dir
        File.dirname(install_path)
      end
    end
  end
end
