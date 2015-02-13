describe WordPressTools::WPCLI do

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

  let(:cli) { WordPressTools::WPCLI.new }

  context "#install_core" do
    let(:wp_cli_fixture_path) { File.expand_path('../spec/fixtures/wp-cli.phar') }
    let(:wp_cli_destination_path) { './wp-cli' }

    before do
      FakeWeb.register_uri(
        :get,
        WordPressTools::Configuration.for(:wp_cli_download_url),
        body: wp_cli_fixture_path
      )
      allow(cli).to receive(:wp_cli_path).and_return(wp_cli_destination_path)
    end

    context "overwite existing file" do
      before do
        allow(cli).to receive(:overwrite_wp_cli?).and_return(true)
      end

      it "downloads wp-cli" do
        cli.install_core
        expect(FileUtils.compare_file(wp_cli_fixture_path, wp_cli_destination_path)).to eq(true)
        expect(File.executable?(wp_cli_destination_path)).to eq(true)
      end
    end

    context "do not overwite existing file" do
      before do
        allow(cli).to receive(:overwrite_wp_cli?).and_return(false)
      end

      it "doesn't download wp-cli" do
        cli.install_core
        expect(File.exist?(wp_cli_destination_path)).to eq(false)
      end
    end
  end

  context "#install_wp_server" do
    let(:wp_cli_config_path) { "./wp-cli/config.yml" }
    let(:wp_server_destination_path) { "./wp-cli/commands/server" }
    let(:wp_server_fixture_path) { File.expand_path('../spec/fixtures/server-command-master.zip') }

    before do
      FakeWeb.register_uri(
        :get,
        WordPressTools::Configuration.for(:wp_server_download_url),
        body: wp_server_fixture_path
      )
      allow(cli).to receive(:wp_cli_config_path).and_return(wp_cli_config_path)
      allow(cli).to receive(:wp_server_direcory).and_return(wp_server_destination_path)
    end

    context "overwrite existing file" do
      before do
        allow(cli).to receive(:overwrite_wp_server?).and_return(true)
      end

      it "downloads wp-cli/server-command" do
        cli.install_wp_server
        expect(File.exist?(File.join(wp_server_destination_path, 'command.php'))).to eq(true)
        expect(File.exist?(wp_cli_config_path)).to eq(true)
        expect(IO.read(wp_cli_config_path)).to include("- commands/server/command.php")
      end
    end

    context "do not overwite existing file" do
      before do
        allow(cli).to receive(:overwrite_wp_server?).and_return(false)
      end

      it "doesn't download wp server" do
        cli.install_wp_server
        expect(File.exist?(File.join(wp_server_destination_path, 'command.php'))).to eq(false)
      end
    end
  end
end
