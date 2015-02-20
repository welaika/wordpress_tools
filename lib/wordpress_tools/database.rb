module WordPressTools
  class Database < Thor
    include CLIHelper

    desc "create", ""
    add_method_options(shared_options)
    def create(db_name = "wordpress")
      run_command("mysql --user='#{options[:db_user]}' --password='#{options[:db_password]}' --execute='CREATE DATABASE #{db_name}'")
    end
  end
end
