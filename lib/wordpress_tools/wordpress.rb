module WordPressTools
  class WordPress < Thor
    include CLIHelper
    attr_reader :dir_name

    method_option :locale, aliases: "-l", desc: "WordPress locale (default is en_US)"
    method_option :bare, aliases: "-b", desc: "Remove default themes and plugins"

    desc "install [DIR_NAME]", ""
    def install(dir_name = "wordpress")
      @dir_name = dir_name
      download_wordpress
      configure_bare_install
      initialize_git_repo
    end

    no_tasks do

      def tempfile
        @tempfile ||= Tempfile.new('wordpress')
      end

      def download_wordpress
        download_url, version, locale = Net::HTTP.get('api.wordpress.org', "/core/version-check/1.5/?locale=#{options[:locale]}").split[2,3]

        info "Downloading WordPress #{version} (#{locale})..."
        get(download_url, tempfile.path, force: true, verbose: false) || error("Could not download WordPress.")
        unzip(tempfile.path, dir_name) || error("Could not unzip WordPress.")
        remove_nested_subdirectory

        success %Q{Installed WordPress in directory "#{dir_name}".}
      end

      def remove_nested_subdirectory
        subdirectory = Dir["#{dir_name}/*/"].first # This is probably 'wordpress', but don't assume
        FileUtils.mv Dir["#{subdirectory}*"], dir_name # Remove unnecessary directory level
        Dir.delete subdirectory
      end

      def configure_bare_install
        if options[:bare]
          dirs = %w(themes plugins).map {|d| "#{dir_name}/wp-content/#{d}"}
          FileUtils.rm_rf dirs
          FileUtils.mkdir dirs
          dirs.each do |dir|
            FileUtils.cp "#{dir_name}/wp-content/index.php", dir
          end
          success "Removed default themes and plugins."
        end
      end

      def initialize_git_repo
        if git_installed?
          if run_command("cd #{dir_name} && git init")
            success "Initialized git repository."
          else
            error "Could not initialize git repository."
          end
        else
          warning "Could not find git installation."
        end
      end

      def git_installed?
        run_command("git --version")
      end

    end
  end
end
