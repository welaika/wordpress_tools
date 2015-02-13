module WordPressTools
  class Database < Thor
    include CLIHelper

    desc "create", ""
    def create(db_name, db_user, db_password)
      run_command("mysql --user='#{db_user}' --password='#{db_password}' --execute='CREATE DATABASE #{db_name}'")
    end

  end
end
