class Fastgron < Formula
  desc "High-performance JSON to GRON converter"
  homepage "https://github.com/adamritter/fastgron"
  url "https://mirror.ghproxy.com/https://github.com/adamritter/fastgron/archive/refs/tags/v0.7.6.tar.gz"
  sha256 "f5ceb98c4f7646a0976307413437fb8e6b686b0c90aa9377f83b92465d2e6903"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f453a56cf3c9ac630da1bcac3823380afb44571f5b2231135231b2df4d92e304"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c86fc9a4fe8df410cfd5cec92f4245413bd1628b187ab0020f12ad0f193056ce"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e2ff4fe06a80809210b114fddb0cdd3c4e77260d4e98f28852c1926026bb91c3"
    sha256 cellar: :any_skip_relocation, sonoma:         "0240dcdd9a488a7ab3fd25c57e449c401f45ea32bfcc1fedf0064f4683d21b8d"
    sha256 cellar: :any_skip_relocation, ventura:        "ee90aa2af5bbdd0c866c29bfa327d5251cac96f73260d9b927393d1513a06bf8"
    sha256 cellar: :any_skip_relocation, monterey:       "d65d5f91cc8d5086a2851abe163ff6a8cae2585e9bab2c04cdc1db63187ab9e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e8d29cf954e504c7fd7e05bdc22cc7937c88e803f9b73f37bd3c1213a4695612"
  end

  depends_on "cmake" => :build

  uses_from_macos "curl"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    expected = <<~EOS
      json = []
      json[0] = 3
      json[1] = 4
      json[2] = 5
    EOS
    assert_equal expected, pipe_output(bin/"fastgron", "[3,4,5]")

    assert_match version.to_s, shell_output(bin/"fastgron --version 2>&1")
  end
end
