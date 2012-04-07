# WordPress Tools

A command line tool to help manage your WordPress sites.

## Installation

    gem install wordpress_tools

## Usage

Create a new WordPress site in directory `mysite`. This downloads the latest stable release of WordPress (you can also specify a locale):

    wordpress new mysite
    wordpress new mysite --locale=fr_FR

Get some help:

    wordpress help

## Caveats

- If you attempt to download a WordPress localization that's outdated, the latest English version will be downloaded instead.
- Only tested on Mac OS X

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Add some specs
4. Commit your changes (`git commit -am 'Added some feature'`)
5. Push to the branch (`git push origin my-new-feature`)
6. Create new Pull Request
