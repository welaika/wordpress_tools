require 'spec_helper'

describe WordPressTools::WordPress do

  before do
    @original_wd = Dir.pwd
    Dir.chdir('tmp')
  end

  after do
    Dir.chdir(@original_wd)
    Dir["tmp/*"].each do |dir|
      FileUtils.rm_rf(dir) if File.directory? dir
    end
  end

  context "#install" do
    context "with no arguments" do
      it "downloads WordPress and initializes a git repo" do
        WordPressTools::WordPress.start ['install']
        expect(File.exist?('wordpress/wp-content/index.php')).to eq(true)
        expect(File.directory?('wordpress/wordpress')).to eq(false)
        expect(File.directory?('wordpress/.git')).to eq(true)
      end
    end

    context "with a custom directory name" do
      it "downloads a copy of WordPress in directory 'myapp'" do
        WordPressTools::WordPress.start ['install', 'myapp']
        expect(File.exist?('myapp/wp-content/index.php')).to eq(true)
      end
    end

    context "with the 'bare' option" do
      it "downloads a copy of WordPress and removes default plugins and themes" do
        WordPressTools::WordPress.start ['install', '--bare']
        expect(
          File.exist?('wordpress/wp-content/plugins/hello.php') ||
          File.directory?('wordpress/wp-content/themes/twentyeleven')
        ).to eq(false)
      end
    end
  end
end
