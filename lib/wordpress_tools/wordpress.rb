module WordPressTools
  class WordPress < Thor
    include CLIHelper
    include SharedOptions

    attr_reader :dir_name

    desc "download [DIR_NAME]", "download WordPress"
    add_method_options(shared_options)
    def download(dir_name = "wordpress")
      @dir_name = dir_name

      download_wordpress
      configure_bare
      initialize_git_repo
    end

    desc "setup [DIR_NAME]", "automatic '5 minutes' installation"
    add_method_options(shared_options)
    def setup(dir_name = "wordpress")
      @dir_name = dir_name

      inside(dir_name) do
        create_wp_config_file
        install
      end
    end

    no_tasks do
      def tempfile
        @tempfile ||= Tempfile.new('wordpress')
      end

      def download_wordpress
        download_url, version, locale = Net::HTTP.get('api.wordpress.org', "/core/version-check/1.5/?locale=#{options[:locale]}").split[2,3]

        info("Downloading WordPress #{version} (#{locale})...")
        get(download_url, tempfile.path, force: true, verbose: false) || error("Could not download WordPress")
        unzip(tempfile.path, dir_name) || error("Could not unzip WordPress")
        remove_nested_subdirectory

        success("Downloaded WordPress in directory '#{dir_name}'")
      end

      def remove_nested_subdirectory
        subdirectory = Dir["#{dir_name}/*/"].first # This is probably 'wordpress', but don't assume
        FileUtils.mv Dir["#{subdirectory}*"], dir_name # Remove unnecessary directory level
        Dir.delete subdirectory
      end

      def configure_bare
        if options[:bare]
          info("Removing default themes and plugins...")
          dirs = %w(themes plugins).map {|d| "#{dir_name}/wp-content/#{d}"}
          FileUtils.rm_rf dirs
          FileUtils.mkdir dirs
          dirs.each do |dir|
            FileUtils.cp "#{dir_name}/wp-content/index.php", dir
          end
          success("Removed default themes and plugins")
        end
      end

      def initialize_git_repo
        info("Initializing git repository...")
        if git_installed?
          if run_command("cd #{dir_name} && git init")
            success("Initialized git repository")
          else
            error("Could not initialize git repository")
          end
        else
          warning("Could not find git installation")
        end
      end

      def create_wp_config_file
        db_password = options[:db_password].present? ? "--dbpass='#{options[:db_password]}'" : ""
        info("Creating 'wp-config.php' file...")
        run_command("wp core config --dbname='#{dir_name}' --dbuser='#{options[:db_user]}' #{db_password} --locale='#{options[:locale]}'") || error("Cannot create 'wp-config.php' file")
        success("Created 'wp-config.php' file")
      end

      def install
        info("Running the 5 minutes installation...")
        run_command("wp core install --url='#{options[:site_url]}' --title='#{dir_name}' --admin_user='#{options[:admin_user]}' --admin_password='#{options[:admin_password]}' --admin_email='#{options[:admin_email]}'") || error("Cannot finish the 5-minutes installation")
        success("Finished the 5 minutes installation")
      end
    end
  end
end
