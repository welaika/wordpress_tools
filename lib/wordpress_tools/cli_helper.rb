module WordPressTools
  module CLIHelper
    include Thor::Actions

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

    def unzip(file, destination)
      run_command("unzip #{file} -d #{destination}")
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
