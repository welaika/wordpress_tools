require 'spec_helper'

describe WordPressTools::CLIHelper do
  let(:cli) { WordPressTools::WordPressCLI.new }

  context "::download" do
    let(:valid_url) { "http://www.example.com/test" }
    let(:tempfile) { Tempfile.new("download_test") }

    before(:each) do
      FakeWeb.register_uri(:get, valid_url, :body => "Download test")
    end

    it "downloads a file to the specified location" do
      cli.download(valid_url, tempfile.path)
      open(tempfile.path).read.should eq("Download test")
    end

    it "returns true on success" do
      cli.download(valid_url, tempfile.path).should eq true
    end

    it "returns false on failure" do
      cli.download("http://an.invalid.url", tempfile.path).should eq false
    end
  end

  context "::unzip" do
    let(:path) { File.expand_path('spec/fixtures/zipped_file.zip') }
    let(:destination) { "tmp/unzip" }

    it "unzips a file" do
      cli.should_receive(:run_command).with("unzip #{path} -d #{destination}")
      cli.unzip(path, destination)
    end
  end

  context "::info" do
    let(:message) { "I am an info" }

    it "displays an info" do
      cli.should_receive(:log_message).with(message)
      cli.info(message)
    end
  end

  context "::error" do
    let(:message) { "I am an error" }

    it "displays an error" do
      cli.should_receive(:log_message).with(message, :red)
      cli.should_receive(:exit)
      cli.error(message)
    end
  end

  context "::success" do
    let(:message) { "I am a success message" }

    it "displays a success message" do
      cli.should_receive(:log_message).with(message, :green)
      cli.success(message)
    end
  end

  context "::warning" do
    let(:message) { "I am a warning" }

    it "displays a warning" do
      cli.should_receive(:log_message).with(message, :yellow)
      cli.warning(message)
    end
  end
end

