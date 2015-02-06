require 'spec_helper'

describe WordPressTools::WordPress do

  before do
    @original_wd = Dir.pwd
    Dir.chdir('tmp')
    WordPressTools::Configuration.stub(:ask_user!)
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

    context "with wp-cli" do
      let(:wp_cli_path) { './wp-cli' }
      before do
        WordPressTools::WordPress.any_instance.stub(:wp_cli_installation_path).and_return(wp_cli_path)
        WordPressTools::WordPress.any_instance.stub(:wp_cli_installed?).and_return(false)
      end

      it "installs wp-cli" do
        WordPressTools::CLI.start ['new']
        (File.exists?(wp_cli_path)).should eq true
      end

      it "sets wp-cli as executable" do
        WordPressTools::CLI.start ['new']
        (File.executable?(wp_cli_path)).should eq true
      end
    end

  end
end

