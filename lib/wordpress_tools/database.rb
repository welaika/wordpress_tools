module WordPressTools
  class Database < Thor
    include CLIHelper
    include SharedOptions

    attr_reader :db_name

    desc "create [DB_NAME]", "create MySQL database for WordPress"
    add_method_options(shared_options)
    def create(db_name = "wordpress")
      @db_name = db_name

      info("Creating database '#{db_name}'...")
      test_login
      create_database
      success("Database #{db_name} created")
    end

    no_tasks do
      def create_database
        run_command(mysql_create_command) || error("Cannot create database '#{db_name}'. Already exists?")
      end

      def test_login
        run_command("#{mysql_command} --execute='QUIT'") || error("Cannot login to MySQL. Wrong credentials?")
      end

      def mysql_create_command
        "#{mysql_command} --execute='CREATE DATABASE #{db_name} DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;'"
      end

      def mysql_command
        "mysql --user='#{db_user}' --password='#{db_password}'"
      end

      def db_user
        options[:db_user]
      end

      def db_password
        options[:db_password]
      end
    end
  end
end
