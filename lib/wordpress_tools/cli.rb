module WordPressTools
  class CLI < Thor
    include CLIHelper
    include SharedOptions

    desc "new [DIR_NAME]", "download the latest stable version of WordPress in a new directory with specified name (default is wordpress)"
    add_method_options(shared_options)
    def new(dir_name = 'wordpress')
      if File.exist?(dir_name)
        say "Directory #{dir_name} already exists.", :red
        exit
      end

      info("Starting...")

      WPCLICore.new.invoke :install, [], options
      WPCLIServer.new.invoke :install, [], options
      Database.new.invoke :create, [dir_name], options
      WordPress.new.invoke :download, [dir_name], options
      WordPress.new.invoke :setup, [dir_name], options

      success("All done. Run 'wp server' inside '#{dir_name}' and visit '#{options[:site_url]}'")
    end
  end
end

