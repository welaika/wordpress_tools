describe WordPressTools::WPCLICore do

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

  let(:cli) { WordPressTools::WPCLICore.new }

  context "#install" do
    let(:fixture_path) { File.expand_path('../spec/fixtures/wp-cli.phar') }
    let(:install_path) { './wp-cli' }

    before do
      FakeWeb.register_uri(
        :get,
        WordPressTools::Configuration.for(:wp_cli_download_url),
        body: fixture_path
      )
      allow(cli).to receive(:install_path).and_return(install_path)
    end

    context "overwite existing file" do
      before do
        allow(cli).to receive(:overwrite?).and_return(true)
      end

      it "downloads wp-cli" do
        cli.install
        expect(FileUtils.compare_file(fixture_path, install_path)).to eq(true)
        expect(File.executable?(install_path)).to eq(true)
      end
    end

    context "do not overwite existing file" do
      before do
        allow(cli).to receive(:overwrite?).and_return(false)
      end

      it "doesn't download wp-cli" do
        cli.install
        expect(File.exist?(install_path)).to eq(false)
      end
    end
  end
end
