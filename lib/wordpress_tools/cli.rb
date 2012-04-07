require 'thor'
# require 'thor/shell/basic'
require 'net/http'
require 'rbconfig'
require 'tempfile'
require 'wordpress_tools/cli_helper'

module WordPressTools
  class CLI < Thor
    include Thor::Actions
    include WordPressTools::CLIHelper
    
    @@lib_dir = File.expand_path(File.dirname(__FILE__))
    
    desc "new [DIR_NAME]", "download the latest stable version of WordPress in a new directory with specified name (default is wordpress)"
    method_option :locale, :aliases => "-l", :desc => "WordPress locale (default is en_US)"
    method_option :bare, :aliases => "-b", :desc => "Remove default themes and plugins"
    def new(dir_name = 'wordpress')
      download_url, version, locale = Net::HTTP.get('api.wordpress.org', "/core/version-check/1.5/?locale=#{options[:locale]}").split[2,3]
      downloaded_file = Tempfile.new('wordpress')
      begin
        puts "Downloading WordPress #{version} (#{locale})..."

        unless download(download_url, downloaded_file.path)
          error "Couldn't download WordPress."
          return
        end
        
        unless unzip(downloaded_file.path, dir_name)
          error "Couldn't unzip WordPress."
          return
        end
        
        subdirectory = Dir["#{dir_name}/*/"].first # This is probably 'wordpress', but don't assume
        FileUtils.mv Dir["#{subdirectory}*"], dir_name # Remove unnecessary directory level
        Dir.delete subdirectory
      ensure
         downloaded_file.close
         downloaded_file.unlink
      end
      
      success %Q{Installed WordPress in directory "#{dir_name}".}
      
      if options[:bare]
        dirs = %w(themes plugins).map {|d| "#{dir_name}/wp-content/#{d}"}
        FileUtils.rm_rf dirs
        FileUtils.mkdir dirs
        dirs.each do |dir|
          FileUtils.cp "#{dir_name}/wp-content/index.php", dir
        end
        success "Removed default themes and plugins."
      end
      
      if git_installed?
        if run "cd #{dir_name} && git init", :verbose => false, :capture => true
          success "Initialized git repository."
        else
          error "Couldn't initialize git repository."
        end
      else
        warning "Didn't initialize git repository because git isn't installed."
      end
    end
  end
end
