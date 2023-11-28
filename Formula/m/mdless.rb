class Mdless < Formula
  desc "Provides a formatted and highlighted view of Markdown files in Terminal"
  homepage "https://github.com/ttscoff/mdless"
  url "https://mirror.ghproxy.com/https://github.com/ttscoff/mdless/archive/refs/tags/2.0.23.tar.gz"
  sha256 "154f132d66a0b88e8325c20c963c3703ffa60f03e3499afe2877a6677d4ca87e"
  license "MIT"

  bottle do
    sha256                               arm64_sonoma:   "eaba1f1a9ebeddd5ffd423215c733f6193368897e27fbec2cb313c7cd86d0f02"
    sha256                               arm64_ventura:  "3117637ebdd03359906900dcf562205caa70836409deefde41f9fba94b4c3a74"
    sha256                               arm64_monterey: "2dbffe5177740c680ece17800e215ddca06a4473c895a1a288d7649760884d63"
    sha256                               sonoma:         "9d8e5a4f376157caa6aae2ab7a48e71bb1e9bb351005c227c8c1e2ad6e68f87d"
    sha256                               ventura:        "5c15b177f85fe48c4125c4d8239f52fa8b6c9f29317803ef7aa4df727f86b14b"
    sha256                               monterey:       "0dcb96814abc9cc551240c5847bd315a328ca09f5683356aaf03f962d7c2d4dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a996bef177ebff31f490934de33609b6a463d5f3bad9ab785fcda44b4fe99c25"
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
