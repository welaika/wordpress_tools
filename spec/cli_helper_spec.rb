describe WordPressTools::CLIHelper do
  let(:cli) { WordPressTools::WordPress.new }

  context "::download" do
    let(:valid_url) { "http://www.example.com/test" }
    let(:tempfile) { Tempfile.new("download_test") }

    before(:each) do
      FakeWeb.register_uri(:get, valid_url, :body => "Download test")
    end

    it "downloads a file to the specified location" do
      cli.download(valid_url, tempfile.path)
      expect(open(tempfile.path).read).to eq("Download test")
    end

    it "returns true on success" do
      expect(cli.download(valid_url, tempfile.path)).to eq(true)
    end

    it "returns false on failure" do
      expect(cli.download("http://an.invalid.url", tempfile.path)).to eq(false)
    end
  end

  context "::unzip" do
    let(:path) { File.expand_path('spec/fixtures/zipped_file.zip') }
    let(:destination) { "tmp/unzip" }

    it "unzips a file" do
      expect(cli).to receive(:system).with("unzip #{path} -d #{destination}")
      cli.unzip(path, destination)
    end
  end

end

