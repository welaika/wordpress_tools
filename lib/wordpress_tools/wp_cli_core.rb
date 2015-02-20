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
        success("WP-CLI installed")
        check_bash_path || warning("Please, add #{install_path} to your shell '$PATH'")
      else
        error("Could not install WP-CLI")
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
        File.exist?(install_path) && File.executable?(install_path)
      end

      def download
        info("Downloading WP-CLI...")
        get(download_url, download_path, verbose: false, force: true) || error("Cannot download WP-CLI")
        success("Downloaded WP-CLI")
      end

      def move
        info("Installing WP-CLI...")
        need_sudo = !File.writable?(install_dir)
        run_command(move_command(download_path, install_path, need_sudo)) || error("Cannot install WP-CLI in '#{install_path}'")
        success("Installed WP-CLI in '#{install_path}'")
      end

      def make_executable
        info("Making WP-CLI executable...")
        need_sudo = !File.writable?(install_dir)
        run_command(executable_bit_command(install_path, need_sudo)) || error("Cannot make WP-CLI executable")
        success("WP-CLI is now executable")
      end

      def download_url
        Configuration.for(:wp_cli_download_url)
      end

      def download_path
        @download_path ||= Tempfile.new('wp_cli').path
      end

      def install_path
        Configuration.for(:wp_cli_path)
      end

      def install_dir
        File.dirname(install_path)
      end

      def check_bash_path
        run_command("which wp")
      end
    end
  end
end
