module WordPressTools
  class WordPress
    include WordPressTools::CLIHelper
    attr_reader :dir_name, :options

    def initialize(dir_name = 'wordpress', options = {})
      @options = options
      @dir_name = dir_name
      @thor = thor
    end

    def install!
      download_wordpress
      configure_bare_install
      initialize_git_repo
    end

    private

    def tempfile
      @tempfile ||= Tempfile.new('wordpress')
    end

    def http_download(domain, string)
      Net::HTTP.get(domain, string)
    end

    def download_wordpress
      download_url, version, locale = http_download('api.wordpress.org', "/core/version-check/1.5/?locale=#{options[:locale]}").split[2,3]

      info "Downloading WordPress #{version} (#{locale})..."
      download(download_url, tempfile.path) || error("Could not download WordPress.")
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
        if system("cd #{dir_name} && git init")
          success "Initialized git repository."
        else
          error "Could not initialize git repository."
        end
      else
        warning "Could not find git installation."
      end
    end
  end
end
