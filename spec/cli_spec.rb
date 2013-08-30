require 'spec_helper'

describe WordPressTools::CLI do
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

  context "#new" do
    context "with no arguments" do
      it "downloads WordPress and initializes a git repo" do
        WordPressTools::CLI.start ['new']
        File.exists?('wordpress/wp-content/index.php').should eq true
        File.directory?('wordpress/wordpress').should eq false
        File.directory?('wordpress/.git').should eq true
      end
    end

    context "with a custom directory name" do
      it "downloads a copy of WordPress in directory 'myapp'" do
        WordPressTools::CLI.start ['new', 'myapp']
        File.exists?('myapp/wp-content/index.php').should eq true
      end
    end

    context "with the 'bare' option" do
      it "downloads a copy of WordPress and removes default plugins and themes" do
        WordPressTools::CLI.start ['new', '--bare']
        (File.exists?('wordpress/wp-content/plugins/hello.php') || File.directory?('wordpress/wp-content/themes/twentyeleven')).should eq false
      end
    end
  end
end

