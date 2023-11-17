class Uffizzi < Formula
  desc "Self-serve developer platforms in minutes, not months with k8s virtual clusters"
  homepage "https://uffizzi.com"
  url "https://mirror.ghproxy.com/https://github.com/UffizziCloud/uffizzi_cli/archive/refs/tags/v2.3.3.tar.gz"
  sha256 "72f60f25350803ecb71b3ca20020393f76914c0eeb1b59187d500fbfab89a1d1"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4ef2a015dd3e57f16e047a5fe1a1e1692a7c9aed929bab218b1c1e916cd11699"
    sha256 cellar: :any,                 arm64_ventura:  "36e0dea40a2c2f2d56aedb78705ce01f86b97e46607401bf7eb550abbbc1ca48"
    sha256 cellar: :any,                 arm64_monterey: "52e50652e58043d2126387db36fef4516887005b611809f1f25a6bd23d5b8e8f"
    sha256 cellar: :any,                 sonoma:         "97115fde484421689555322e357725e992e5932ab68b133336406a7681ecc860"
    sha256 cellar: :any,                 ventura:        "136303166850f0f28990e0a39c11ce3d302921ff4fdd0c70c294bb594a5ef695"
    sha256 cellar: :any,                 monterey:       "df3e5584e42c224e3dd3af78e85e5994fe78619b8d4ecdf9476f887191e71e0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2b75c4da477f060057f81da3dc0eae237ab310c1dcbf55652073e9f38c54cfe0"
  end

  depends_on "ruby@3.0"
  depends_on "skaffold"

  resource "activesupport" do
    url "https://rubygems.org/gems/activesupport-6.1.7.gem"
    sha256 "f9dee8a4cc315714e29228328428437c8779f58237749339afadbdcfb5c0b74c"
  end

  resource "awesome_print" do
    url "https://rubygems.org/gems/awesome_print-1.9.2.gem"
    sha256 "e99b32b704acff16d768b3468680793ced40bfdc4537eb07e06a4be11133786e"
  end

  resource "faker" do
    url "https://rubygems.org/gems/faker-3.2.1.gem"
    sha256 "d6b201b520213f6d985ac9f9f810154397a146ca22c1d3ff0a6504ef37c5517b"
  end

  resource "launchy" do
    url "https://rubygems.org/gems/launchy-2.5.2.gem"
    sha256 "8aa0441655aec5514008e1d04892c2de3ba57bd337afb984568da091121a241b"
  end

  resource "minitar" do
    url "https://rubygems.org/gems/minitar-0.9.gem"
    sha256 "23c0bebead35dbfe9e24088dc436c8a233d03f51d365a686b9a11dd30dc2d588"
  end

  resource "securerandom" do
    url "https://rubygems.org/gems/securerandom-0.2.2.gem"
    sha256 "5fcb3b8aa050bac5de93a5e22b69483856f70d43affeb883bce0c58d71360131"
  end

  resource "sentry-ruby" do
    url "https://rubygems.org/gems/sentry-ruby-5.12.0.gem"
    sha256 "2a8c161a9e5af6e8af251a778b5692fa3bfaf355a9cf83857eeef9f84e0e649a"
  end

  resource "thor" do
    url "https://rubygems.org/gems/thor-1.2.2.gem"
    sha256 "2f93c652828cba9fcf4f65f5dc8c306f1a7317e05aad5835a13740122c17f24c"
  end

  resource "tty-prompt" do
    url "https://rubygems.org/gems/tty-prompt-0.23.1.gem"
    sha256 "fcdbce905238993f27eecfdf67597a636bc839d92192f6a0eef22b8166449ec8"
  end

  resource "tty-spinner" do
    url "https://rubygems.org/gems/tty-spinner-0.9.3.gem"
    sha256 "0e036f047b4ffb61f2aa45f5a770ec00b4d04130531558a94bfc5b192b570542"
  end

  resource "uffizzi-cli" do
    url "https://rubygems.org/gems/uffizzi-cli-2.3.3.gem"
    sha256 "11f1edac8dd6d08f12a2fef3d4494a664f4948a052cb1830641ccd6a9bbc789b"
  end

  def install
    ENV["GEM_HOME"] = libexec
    ENV["GEM_PATH"] = libexec

    resources.each do |r|
      r.fetch
      system "gem", "install", r.cached_download, "--no-document", "--install-dir", libexec
    end

    bin.install Dir["#{libexec}/bin/*"]

    bin.env_script_all_files(libexec, GEM_HOME: ENV["GEM_HOME"], GEM_PATH: ENV["GEM_PATH"])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/uffizzi version")
    server_url = "https://example.com"
    system bin/"uffizzi config set server #{server_url}"
    assert_match server_url, shell_output("#{bin}/uffizzi config get-value server")
  end
end
