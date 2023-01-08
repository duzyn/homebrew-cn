class Jabba < Formula
  desc "Cross-platform Java Version Manager"
  # fork blessed by previous maintener https://github.com/shyiko/jabba/issues/833#issuecomment-1338648294
  homepage "https://github.com/Jabba-Team/jabba"
  url "https://github.com/Jabba-Team/jabba/archive/0.12.0.tar.gz"
  sha256 "15a142239869733d7f0fe8c0cc0cd99f619e5bc8121ebabc9c28c382333b89c0"
  license "Apache-2.0"
  head "https://github.com/Jabba-Team/jabba.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a6431563103faa406dc4bc0ea3d9a8d97b8e02e22c67f5f448e07c8107d24856"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "beb1e7acd78d6e3ab04cb1d98b7045b42a70af5ced6f34096daa98704b0c96c0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4846627d06d372eb89b275cccac2f85bff819bcb068c085b9888ad6cdc55f68e"
    sha256 cellar: :any_skip_relocation, ventura:        "ee179c5bbbcc71b1f4192dc471518052b96c38d3184f7c5e7dfc6970f92af81e"
    sha256 cellar: :any_skip_relocation, monterey:       "a2e759461d50f1aa0ef24624b125034a1948c54bb1f5db0addcf9b89e1d471c0"
    sha256 cellar: :any_skip_relocation, big_sur:        "6467a598138deac8c95fcf8a67eca914f70bbfe18f87e5791f749c0237d5be0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a430d6738094766cae7f66f08522789d1df1b29265fe58b475fabd94a285018a"
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "auto"
    dir = buildpath/"src/github.com/Jabba-Team/jabba"
    dir.install buildpath.children
    cd dir do
      ldflags = "-X main.version=#{version}"
      system "go", "build", *std_go_args(ldflags: ldflags)
    end
  end

  test do
    jdk_version = "zulu@17"
    version_check ='openjdk version "17'

    ENV["JABBA_HOME"] = testpath/"jabba_home"

    system bin/"jabba", "install", jdk_version
    jdk_path = shell_output("#{bin}/jabba which #{jdk_version}").strip
    jdk_path += "/Contents/Home" if OS.mac?
    assert_match version_check,
                 shell_output("#{jdk_path}/bin/java -version 2>&1")
  end
end
