module WordPressTools
  module CLIHelper
    extend ActiveSupport::Concern
    include Thor::Actions

    class_methods do
      def shared_options
        [
          [:locale, { aliases: "-l", desc: "WordPress locale (default is en_US)"}],
          [:bare, {aliases: "-b", desc: "Remove default themes and plugins"}],
          [:admin_user, { desc: "WordPress admin user", default: Configuration.for(:admin_user)}],
          [:admin_email, {desc: "WordPress admin email", default: Configuration.for(:admin_email)}], 
          [:admin_password, {desc: "WordPress admin password", default: Configuration.for(:admin_password)}],
          [:db_user, {desc: "MySQL database user", default: Configuration.for(:db_user)}],
          [:db_password, {desc: "MySQL database pasword", default: Configuration.for(:db_password)}],
          [:site_url, {desc: "Wordpress site URL", default: Configuration.for(:site_url)}]
        ]
      end

      def add_method_options(options)
        options.each do |option|
          method_option(*option)
        end
      end
    end

    def info(message)
      say message
    end

    def error(message)
      say message, :red
      exit
    end

    def success(message)
      say message, :green
    end

    def warning(message)
      say message, :yellow
    end

    def git_installed?
      run_command("git --version")
    end

    def unzip(file, destination, extra_options = '')
      run_command("unzip #{extra_options} #{file} -d #{destination}")
    end

    def move_command(from, to, need_sudo = false)
      sudo = 'sudo' if need_sudo
      "#{sudo} mv '#{from}' '#{to}'"
    end

    def executable_bit_command(path, need_sudo = false)
      sudo = 'sudo' if need_sudo
      "#{sudo} chmod 755 '#{path}'"
    end

    def void
      RbConfig::CONFIG['host_os'] =~ /msdos|mswin|djgpp|mingw/ ? 'NUL' : '/dev/null'
    end

    def run_command(command)
      system("#{command} >>#{void} 2>&1")
    end
  end
end
