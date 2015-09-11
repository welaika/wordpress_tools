# WordPress Tools

A command line tool to help manage your WordPress sites in development.

[![Build Status](https://travis-ci.org/welaika/wordpress_tools.png?branch=master)](https://travis-ci.org/welaika/wordpress_tools)
[![Code Climate](https://codeclimate.com/github/welaika/wordpress_tools/badges/gpa.svg)](https://codeclimate.com/github/welaika/wordpress_tools)
[![Gem Version](http://img.shields.io/gem/v/wordpress_tools.svg)](https://rubygems.org/gems/wordpress_tools)
[![License](http://img.shields.io/:license-mit-blue.svg)](http://www.mit-license.org)

## Installation

    gem install wordpress_tools

## Usage

    wordpress new mysite

It installs and configures [WP-CLI](http://wp-cli.org/), [WP-CLI/server-command](https://github.com/wp-cli/server-command) and, finally, the latest version of [WordPress](http://wordpress.org) in `mysite` directory.

Get some help:

    wordpress help new

```bash
Options:
      [--force]                          # Overwrite existing WP-CLI / WP-CLI Server installation
  -l, [--locale=LOCALE]                  # WordPress locale
                                         # Default: en_US
  -b, [--bare=BARE]                      # Remove default themes and plugins
      [--admin-user=ADMIN_USER]          # WordPress admin user
                                         # Default: admin
      [--admin-email=ADMIN_EMAIL]        # WordPress admin email
                                         # Default: admin@example.com
      [--admin-password=ADMIN_PASSWORD]  # WordPress admin password
                                         # Default: password
      [--db-user=DB_USER]                # MySQL database user
                                         # Default: root
      [--db-password=DB_PASSWORD]        # MySQL database pasword
      [--site-url=SITE_URL]              # Wordpress site URL
                                         # Default: http://localhost:8080
```

Example

    wordpress new mysite --locale=it_IT --bare

## Caveats

- Default db-password is no password
- If you attempt to download a WordPress localization that's outdated, the latest English version will be downloaded instead.
- Not tested on Windows.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Add some specs
4. Commit your changes (`git commit -am 'Added some feature'`)
5. Push to the branch (`git push origin my-new-feature`)
6. Create new Pull Request

## License

(The MIT License)

Copyright © 2013-2015 weLaika

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the ‘Software’), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED ‘AS IS’, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
