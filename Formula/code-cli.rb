class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https://github.com/microsoft/vscode"
  url "https://github.com/microsoft/vscode/archive/refs/tags/1.74.1.tar.gz"
  sha256 "ba730c6af17aee820cf99d83df9adf3c253a5a2229f6b0124aff000f2343d325"
  license "MIT"
  head "https://github.com/microsoft/vscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0eb4e9c76206bbc93ddcf1e4df950e7389f59d8a69a4edb0604d7af8bf65550d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4f4e984a258099a43f00117b3b832e4ebc6bd0287c1d99d9d22021eb53312857"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a4d035b90174590825ecad5cc92b5e6de1c8d45df980065b2456609cf832d55a"
    sha256 cellar: :any_skip_relocation, ventura:        "601e4d478db8ece804e1188fc877c35adc62a6cf09fe51a6fccc857800a0fafd"
    sha256 cellar: :any_skip_relocation, monterey:       "8de45563591739b21f7f2a04a499f1072250a377636e0d4d15c76c1e1929b5a1"
    sha256 cellar: :any_skip_relocation, big_sur:        "97076f45396fc6259b3e67963fe430c6e12e56ee82d2efd6a09dd771b95d4ebf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a679485c0194153a090e661496601bc00020af709bcbf0d7aa70b35346a9747c"
  end

  depends_on "rust" => :build

  conflicts_with cask: "visual-studio-code"

  def install
    ENV["VSCODE_CLI_NAME_LONG"] = "Code OSS"
    ENV["VSCODE_CLI_VERSION"] = version

    cd "cli" do
      system "cargo", "install", *std_cargo_args
    end
  end

  test do
    assert_match "Successfully removed all unused servers",
      shell_output("#{bin}/code tunnel prune")
    assert_match version.to_s, shell_output("#{bin}/code --version")
  end
end
