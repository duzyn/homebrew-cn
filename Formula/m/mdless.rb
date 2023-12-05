class Mdless < Formula
  desc "Provides a formatted and highlighted view of Markdown files in Terminal"
  homepage "https://github.com/ttscoff/mdless"
  url "https://mirror.ghproxy.com/https://github.com/ttscoff/mdless/archive/refs/tags/2.1.24.tar.gz"
  sha256 "c80957f8cb638e18a2e7e4fe8fad7341329c1fcecc7fc2f1f6ec644f5151a5d9"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "7a553d2c087b5f93390f444ba896ca0375caa8faf741f1fc782a086007697a00"
    sha256 cellar: :any,                 arm64_ventura:  "3d8c12febd4cbfaed7bd859b19b171156f4820406bb83f9b8bbf7e6433f3ee4c"
    sha256 cellar: :any,                 arm64_monterey: "9cee44158ad9c975b55e80ec19f0e8e88cb6c759ba162976ef5658e1895426ce"
    sha256 cellar: :any,                 sonoma:         "0e1494eb780ccf3a73a24a14e185ffe67527d480d7a7997c6af45fc30bb77350"
    sha256 cellar: :any,                 ventura:        "4ff6222dc57a1386021c65ffe60896a320bbe18295eb47cc7c8d4eec04780078"
    sha256 cellar: :any,                 monterey:       "a14bea20686b39221f0c7adf27ef896d9b23d5c44aacd7ae0e428d40326bd970"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "34bfebc0580673559fe9bc061cdef74d2aba31894e0773265913ebc5ad476237"
  end

  # Requires Ruby >= 2.7
  depends_on "ruby"

  def install
    ENV["GEM_HOME"] = libexec
    system "gem", "build", "#{name}.gemspec"
    system "gem", "install", "#{name}-#{version}.gem"
    bin.install libexec/"bin/#{name}"
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
  end

  test do
    assert_match "mdless #{version}", shell_output("#{bin}/mdless --version")
    (testpath/"test.md").write <<~EOS
      # title first level
      ## title second level
    EOS
    out = shell_output("#{bin}/mdless --no-color -P test.md")
    assert_match(/^title first level =+$/, out)
    assert_match(/^title second level -+$/, out)
  end
end
