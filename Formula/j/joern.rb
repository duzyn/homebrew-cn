class Joern < Formula
  desc "Open-source code analysis platform based on code property graphs"
  homepage "https://joern.io/"
  url "https://mirror.ghproxy.com/https://github.com/joernio/joern/archive/refs/tags/v4.0.210.tar.gz"
  sha256 "125e1d1a1f74eddf7ca149477f85ea4c755734d43c2f0bd0c4c744d1ac77a169"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle 10
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "62df2be9e0afb904a7308fde09ec988e77c2891bbfb22401f3286d53a791f5b9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "66b761c376465daf2d7b4a1b75c87480c72486cfd569ebe3594e87fe6377736d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "66b761c376465daf2d7b4a1b75c87480c72486cfd569ebe3594e87fe6377736d"
    sha256 cellar: :any_skip_relocation, sonoma:        "bb8234d12f75823035cdae5cf0b28932773141275087b5f34ab09ae20c5a8a02"
    sha256 cellar: :any_skip_relocation, ventura:       "ddbd43b8e83d5bb8ab254d09dbc7670a90d334bdc96e8a8226a96690e845ce22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8c133aeeb1a0d02d23554a627a2d3cbf6f07c083330f161f93280cdc4e716cca"
  end

  depends_on "sbt" => :build
  depends_on "astgen"
  depends_on "coreutils"
  depends_on "openjdk"
  depends_on "php"

  uses_from_macos "zlib"

  def install
    system "sbt", "stage"

    cd "joern-cli/target/universal/stage" do
      rm(Dir["**/*.bat"])
      libexec.install Pathname.pwd.children
    end

    # Remove incompatible pre-built binaries
    os = OS.mac? ? "macos" : OS.kernel_name.downcase
    astgen_suffix = Hardware::CPU.intel? ? [os] : ["#{os}-#{Hardware::CPU.arch}", "#{os}-arm"]
    libexec.glob("frontends/{csharp,go,js}src2cpg/bin/astgen/{dotnet,go,}astgen-*").each do |f|
      f.unlink unless f.basename.to_s.end_with?(*astgen_suffix)
    end

    libexec.children.select { |f| f.file? && f.executable? }.each do |f|
      (bin/f.basename).write_env_script f, Language::Java.overridable_java_home_env
    end
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <iostream>
      void print_number(int x) {
        std::cout << x << std::endl;
      }

      int main(void) {
        print_number(42);
        return 0;
      }
    CPP

    assert_match "Parsing code", shell_output("#{bin}/joern-parse test.cpp")
    assert_predicate testpath/"cpg.bin", :exist?
  end
end
