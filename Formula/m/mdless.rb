class Mdless < Formula
  desc "Provides a formatted and highlighted view of Markdown files in Terminal"
  homepage "https://github.com/ttscoff/mdless"
  url "https://mirror.ghproxy.com/https://github.com/ttscoff/mdless/archive/refs/tags/2.1.10.tar.gz"
  sha256 "a534a902be26860efd41018be29dce3402917cd2c923742cf59aacc69ca1eea1"
  license "MIT"

  bottle do
    sha256                               arm64_sonoma:   "5239cff3a3e64ce78d5318e7aad898678a6e154c48171143ec7e9258fd6dd626"
    sha256                               arm64_ventura:  "50d6f3de4d2e9594f60090f58799949e00aa80a3d239ccfe8f8a554372637375"
    sha256                               arm64_monterey: "31495325add808b41f8b9a17da72bebdf253fa4538da0e93515d6e41b0ee83b0"
    sha256                               sonoma:         "3e321cb039b96e6e97a40bd7cdf42595403b162dd4347a5760bc6ae7b6a53396"
    sha256                               ventura:        "a4a6f0583a3045ad0683a1d6a1140b179be9caea59ade4221b8eed45c7f24b93"
    sha256                               monterey:       "9f9d4aa1f0e6972e73fe597825c1f4b3673bd5227c21b1f776173f520c430a7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "24ec7f2eb334c5506915ce35dac2bb7251cf9a11df74f3102d231c86f2058edc"
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
