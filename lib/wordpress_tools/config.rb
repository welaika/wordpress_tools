module WordPressTools

  CONFIG = {
    admin_email: "admin@example.com",
    admin_password: "password",
    db_user: "root",
    db_password: ""
  }.freeze

  def self.config_for(key)
    CONFIG[key]
  end

end
