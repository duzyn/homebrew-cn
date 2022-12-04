class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau-lang.org"
  url "https://github.com/Roblox/luau/archive/0.555.tar.gz"
  sha256 "b48e4d3e72e37dfafb9591cd6c76c8df64e56f746a8b95d166b62f424d4f63c6"
  license "MIT"
  head "https://github.com/Roblox/luau.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f4fa15f39bcb4ed51f89919196b584e0ea44bb41c0d5a517767441dc4b0127ac"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "00183c5a8d4f89484c27a46aa2e085ef27556977f5e7caa3092e2c04fa2e34d5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f19f8c6b06fad693494bf1797008d9479687276f0a9c7736d15b5e4f886e21f1"
    sha256 cellar: :any_skip_relocation, ventura:        "530cf22f9136c741f640d4344981317ee9342671343e391822878a3c87b161d3"
    sha256 cellar: :any_skip_relocation, monterey:       "ff8ca2c495629104c23de9a74c68de6d7ccd1bb238e4be73ac7166aca9be8c66"
    sha256 cellar: :any_skip_relocation, big_sur:        "82ad54f36f3bbd5289341ec744b4fea116cfc9299c6670b0154013e0034c285a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e880d28fccda80d7dfb9c03f56480e07ec5ce7754c71793c5e08c57a417aa504"
  end

  depends_on "cmake" => :build

  fails_with gcc: "5"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DLUAU_BUILD_TESTS=OFF", *std_cmake_args
    system "cmake", "--build", "build"
    bin.install "build/luau", "build/luau-analyze"
  end

  test do
    (testpath/"test.lua").write "print ('Homebrew is awesome!')\n"
    assert_match "Homebrew is awesome!", shell_output("#{bin}/luau test.lua")
  end
end
