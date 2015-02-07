module WordPressTools
  module CLIHelper

    def shell
      @shell ||= Thor::Shell::Color.new
    end

    def info(message)
      shell.say message
    end

    def error(message)
      shell.say message, :red
      exit
    end

    def success(message)
      shell.say message, :green
    end

    def yes?(message)
      shell.yes?(message)
    end

    def warning(message)
      shell.say message, :yellow
    end

    def ask(message, options = {})
      shell.ask(message, options)
    end

    def download(url, destination)
      begin
        f = open(destination, "wb")
        f.write(open(url).read) ? true : false
      rescue
        false
      ensure
        f.close
      end
    end

    def unzip(file, destination)
      system("unzip #{file} -d #{destination}")
    end

    def git_installed?
      # http://stackoverflow.com/questions/4597490/platform-independent-way-of-detecting-if-git-is-installed
      system "git --version >>#{void} 2>&1"
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
  end
end
