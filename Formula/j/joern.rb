class Joern < Formula
  desc "Open-source code analysis platform based on code property graphs"
  homepage "https://joern.io/"
  url "https://mirror.ghproxy.com/https://github.com/joernio/joern/archive/refs/tags/v4.0.270.tar.gz"
  sha256 "b33ffe32a2e267d82453053b4d4aa67c01a4892a6369da3f773b768141883ce0"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle 10
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0bc73ebb77c44bcde42ef9722d118dc1bf641591c995783266b2cb66d7382695"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b607913ec8163e8154a356863092d271129e5c5696920ccbdd7984b7f3decad8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1a5de3e79c2424144df5b6990d358064794f82a9815528f30f4572ecfd855b9c"
    sha256 cellar: :any_skip_relocation, sonoma:        "8a34b94f09452af1b4835632845a7e9c54f5b709522a81a48f291e679bbd0c4f"
    sha256 cellar: :any_skip_relocation, ventura:       "d3e7f051da807ea06a82e553165e19f1ec3be869031187b90c7a395e4cdfd49e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bb587e930b3bb780930fb0082347aca01292739fbab2b021992f3a0b9013e770"
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
    assert_path_exists testpath/"cpg.bin"
  end
end
