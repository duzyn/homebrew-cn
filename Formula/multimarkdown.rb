class Multimarkdown < Formula
  desc "Turn marked-up plain text into well-formatted documents"
  homepage "https://fletcher.github.io/MultiMarkdown-6/"
  url "https://ghproxy.com/https://github.com/fletcher/MultiMarkdown-6/archive/6.7.0.tar.gz"
  sha256 "aa386f54631dbc4e0beeb6b9cf9eb769db95a3f505a69b663140a80008cf0595"
  license "MIT"
  head "https://github.com/fletcher/MultiMarkdown-6.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d889681d3fd0ed644c4a80e951aed473b5ad9d26256e7e8f2f1922d0f2673b15"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "10659d4c872d03814f36e999ec7db8a2340272bbab6ecf190726a727be05caf4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cbb095b60ddeae5e2062aad184841505442c118b47f4ac374f9862e9a944e13d"
    sha256 cellar: :any_skip_relocation, ventura:        "ff9c00f98d2eac80faa49cef2f404b05edf2ac7ba43c1b8dc4c411c61ce4cd8b"
    sha256 cellar: :any_skip_relocation, monterey:       "67847004a22109bbc67413b0d1f407414338fe0b353ab8ac8e85726928eecb08"
    sha256 cellar: :any_skip_relocation, big_sur:        "c457aa21210a34ebbb29cc09df87a3bb56dbf80e7dca3f5ecd744f97668af195"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1b80ef1a499056e60b9a189b3afbbd7beefc2091578dc8699ad87d6d405ea2e5"
  end

  depends_on "cmake" => :build

  conflicts_with "mtools", because: "both install `mmd` binaries"
  conflicts_with "markdown", because: "both install `markdown` binaries"
  conflicts_with "discount", because: "both install `markdown` binaries"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      bin.install "multimarkdown"
    end

    bin.install Dir["scripts/*"].reject { |f| f.end_with?(".bat") }
  end

  test do
    assert_equal "<p>foo <em>bar</em></p>\n", pipe_output(bin/"multimarkdown", "foo *bar*\n")
    assert_equal "<p>foo <em>bar</em></p>\n", pipe_output(bin/"mmd", "foo *bar*\n")
  end
end
