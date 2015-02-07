module WordPressTools
  class WPCLI
    include WordPressTools::CLIHelper

    def install!
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

    private

    def overwrite?
      if wp_cli_installed?
        yes? "WP-CLI already installed. Do you want to overwite it? [y]es, [n]o"
      else
        true
      end
    end

    def wp_cli_installed?
      system("which wp >>#{void} 2>&1")
    end

    def download_wp_cli
      info "Downloading WP-CLI"
      download(wp_cli_download_url, download_path) || error("Could not download WP-CLI.")
    end

    def move_wp_cli
      info "Installing WP-CLI in [#{wp_cli_path}]"
      need_sudo = !File.writable?(wp_cli_dir)
      system(move_command(download_path, wp_cli_path, need_sudo))
    end

    def make_wp_cli_executable
      info "Make WP-CLI executable"
      need_sudo = !File.writable?(wp_cli_dir)
      system(executable_bit_command(wp_cli_path, need_sudo))
    end

    def wp_cli_download_url
      Configuration.for(:wp_cli_download_url)
    end

    def download_path
      @download_path ||= Tempfile.new('wp_cli').path
    end

    def wp_cli_path
      Configuration.for(:wp_cli_path)
    end

    def wp_cli_dir
      File.dirname(wp_cli_path)
    end
  end
end
