require 'open-uri'

module WordPressTools
  module CLIHelper
    def info(message)
      log_message message
    end

    def error(message)
      log_message message, :red
      exit
    end

    def success(message)
      log_message message, :green
    end

    def warning(message)
      log_message message, :yellow
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

    def download_with_curl(url, destionation, options = {})
      sudo = options[:sudo]
      command = "curl '#{url}' -o '#{destionation}'"
      command = "sudo #{command}" if sudo == true

      run_command command
    end

    def unzip(file, destination)
      run_command "unzip #{file} -d #{destination}"
    end

    def git_installed?
      # http://stackoverflow.com/questions/4597490/platform-independent-way-of-detecting-if-git-is-installed
      system "git --version >>#{void} 2>&1"
    end

    def wp_cli_installed?
      system("which wp-cli >>#{void} 2>&1") || system("which wp >>#{void} 2>&1")
    end

    private

    def void
      RbConfig::CONFIG['host_os'] =~ /msdos|mswin|djgpp|mingw/ ? 'NUL' : '/dev/null'
    end

    def log_message(message, color = nil)
      say message, color
    end

    def run_command(command)
      run command, verbose: false, capture: true
    end

  end
end
