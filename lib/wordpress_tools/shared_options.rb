module WordPressTools
  module SharedOptions
    extend ActiveSupport::Concern

    class_methods do
      def shared_options
        [
          [:force, {
            type: :boolean, desc: "Overwrite existing WP-CLI installation"
          }],
          [:locale, {
            aliases: "-l",
            desc: "WordPress locale",
            default: Configuration.for(:locale)
          }],
          [:bare, {
            type: :boolean,
            aliases: "-b",
            desc: "Remove default themes and plugins"
          }],
          [:admin_user, {
            desc: "WordPress admin user", default: Configuration.for(:admin_user)
          }],
          [:admin_email, {
            desc: "WordPress admin email", default: Configuration.for(:admin_email)
          }],
          [:admin_password, {
            desc: "WordPress admin password", default: Configuration.for(:admin_password)
          }],
          [:db_user, {
            desc: "MySQL database user", default: Configuration.for(:db_user)
          }],
          [:db_password, {
            desc: "MySQL database pasword", default: Configuration.for(:db_password)
          }],
          [:site_url, {
            desc: "Wordpress site URL", default: Configuration.for(:site_url)
          }]
        ]
      end

      def add_method_options(options)
        options.each do |option|
          method_option(*option)
        end
      end
    end
  end
end
