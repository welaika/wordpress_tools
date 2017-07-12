# frozen_string_literal: true

describe WordPressTools::WordPress do
  before do
    @original_wd = Dir.pwd
    Dir.chdir('tmp')

    WP_API_RESPONSE = <<-eof
    upgrade
    https://wordpress.org/download/
    https://downloads.wordpress.org/release/wordpress-4.3.zip
    4.3
    en_US
    5.2.4
    5.0
eof

    WebMock
      .stub_request(:get, %r{https://api.wordpress.org/core/version-check/1.5/.*})
      .to_return(body: WP_API_RESPONSE)

    WebMock
      .stub_request(:get, "https://downloads.wordpress.org/release/wordpress-4.3.zip")
      .to_return(body: File.open(File.expand_path '../spec/fixtures/wordpress_stub.zip'))
  end

  after do
    Dir.chdir(@original_wd)
    Dir["tmp/*"].each do |dir|
      FileUtils.rm_rf(dir) if File.directory? dir
    end
  end

  context "#download" do
    context "with no arguments" do
      it "downloads WordPress and initializes a git repo" do
        WordPressTools::WordPress.start ['download']
        expect(File.exist?('wordpress/wp-content/index.php')).to eq(true)
        expect(File.directory?('wordpress/wordpress')).to eq(false)
        expect(File.directory?('wordpress/.git')).to eq(true)
      end
    end

    context "with a custom directory name" do
      it "downloads a copy of WordPress in directory 'myapp'" do
        WordPressTools::WordPress.start ['download', 'myapp']
        expect(File.exist?('myapp/wp-content/index.php')).to eq(true)
      end
    end

    context "with the 'bare' option" do
      it "downloads a copy of WordPress and removes default plugins and themes" do
        WordPressTools::WordPress.start ['download', '--bare']
        expect(
          File.exist?('wordpress/wp-content/plugins/hello.php') ||
          File.directory?('wordpress/wp-content/themes/twentyeleven')
        ).to eq(false)
      end
    end
  end
end
