describe WordPressTools::WPCLIServer do

  before do
    @original_wd = Dir.pwd
    Dir["tmp/*"].each do |dir|
      FileUtils.rm_rf(dir)
    end
    Dir.chdir('tmp')
  end

  after do
    Dir.chdir(@original_wd)
    Dir["tmp/*"].each do |dir|
      FileUtils.rm_rf(dir)
    end
  end

  let(:cli) { WordPressTools::WPCLIServer.new }

  context "#install" do
    let(:wp_cli_config_path) { "./wp-cli/config.yml" }
    let(:install_dir) { "./wp-cli/commands/server" }
    let(:fixture_path) { File.expand_path('../spec/fixtures/server-command-master.zip') }

    before do
      FakeWeb.register_uri(
        :get,
        WordPressTools::Configuration.for(:wp_server_download_url),
        body: fixture_path
      )
      allow(cli).to receive(:wp_cli_config_path).and_return(wp_cli_config_path)
      allow(cli).to receive(:install_dir).and_return(install_dir)
    end

    context "overwrite existing file" do
      before do
        allow(cli).to receive(:overwrite?).and_return(true)
      end

      it "downloads wp-cli/server-command" do
        cli.install
        expect(File.exist?(File.join(install_dir, 'command.php'))).to eq(true)
        expect(File.exist?(wp_cli_config_path)).to eq(true)
        expect(IO.read(wp_cli_config_path)).to include("- commands/server/command.php")
      end
    end

    context "do not overwite existing file" do
      before do
        allow(cli).to receive(:overwrite?).and_return(false)
      end

      it "doesn't download wp server" do
        cli.install
        expect(File.exist?(File.join(install_dir, 'command.php'))).to eq(false)
      end
    end
  end
end
