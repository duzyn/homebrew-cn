class Mdless < Formula
  desc "Provides a formatted and highlighted view of Markdown files in Terminal"
  homepage "https://github.com/ttscoff/mdless"
  url "https://mirror.ghproxy.com/https://github.com/ttscoff/mdless/archive/refs/tags/2.0.17.tar.gz"
  sha256 "b8ce345061f45456fbb3146f489d14a7eb064e90e0a83a5ae39164721b9687c6"
  license "MIT"

  bottle do
    sha256                               arm64_sonoma:   "ecc5e42cc3fa109bce19ef97ed2da05e67987a14c8a62e6b8cd78911af59b329"
    sha256                               arm64_ventura:  "5bbd9f0e68687cbf7653ed730476d3d26007af162ac08e193221c8aedf13927c"
    sha256                               arm64_monterey: "d167e0cd6d82510d532c0b3954bbb18f8769f21cbc3fd54b8a1c51a8d7f77bc4"
    sha256                               sonoma:         "a2fcf02772672b586acd196e777b271e2d62332a013a9a059bbfe02efb035368"
    sha256                               ventura:        "2ba7e0740a223136b6860770e26c2d8da83642817683cfeac97ecf35b6adf67f"
    sha256                               monterey:       "b9a9ad3886399bc5a280eddb8b87869bcd02fe60f42ae6585e09e9db34474936"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c6cd551c8cf2e7f84f14b7277ca62e5f1fbe4a7ed21a0992db8d0a02aadd5713"
  end

  uses_from_macos "ruby"

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
