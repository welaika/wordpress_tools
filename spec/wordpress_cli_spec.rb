require 'spec_helper'

describe WordPressTools::CLIHelper do
  let(:cli) { WordPressTools::WordPressCLI.new({}, 'wordpress', Thor.new) }

  context "#install_wp_cli" do
    context "if wp-cli is already installed" do
      before do
        cli.stub(:download_wordpress)
        cli.stub(:configure_bare_install)
        cli.stub(:initialize_git_repo)

        cli.stub(:wp_cli_installed?).and_return(true)
      end

      it "does not install it again" do
        cli.should_not_receive(:install_wp_cli)
        cli.download!
      end
    end

  end
end
