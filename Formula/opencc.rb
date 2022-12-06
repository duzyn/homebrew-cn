class Opencc < Formula
  desc "Simplified-traditional Chinese conversion tool"
  homepage "https://github.com/BYVoid/OpenCC"
  url "https://github.com/BYVoid/OpenCC/archive/ver.1.1.5.tar.gz"
  sha256 "7de5b1fd9e3950c1eb05e306aaa7cbf1f92f813748514eb2b447700795a64e02"
  license "Apache-2.0"

  bottle do
    sha256 arm64_ventura:  "eeae70706562a63dc89a912d57234130a511511b311a5fc31eaee2bbe1f3216a"
    sha256 arm64_monterey: "97327a1895a86ae788e7bd27575bc50723ae79a9ac149bbfa729592df2f77657"
    sha256 arm64_big_sur:  "2509f98dc98b5b798b4851d7cd4dba1a120203a577257d744cc58dd6a85891ca"
    sha256 ventura:        "c83f219d28eb3c71cc353f43375be0405d004c25e3fe3356d74c7e475fd9da86"
    sha256 monterey:       "5e73c45b4cd222c049d4510741c473a004bb9a242da8eeca01833877698c1f5c"
    sha256 big_sur:        "426088efdaf9c7a3c8489fd3dd9cee9a8d828193608a1519cca6be7b1219523a"
    sha256 x86_64_linux:   "6685369238570d1418b06da4a8df29b07030609d1506ce469fb87ffc1aaafde9"
  end

  depends_on "cmake" => :build
  uses_from_macos "python" => :build

  def install
    ENV.cxx11
    args = std_cmake_args + %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DPYTHON_EXECUTABLE=#{which("python3")}
    ]
    mkdir "build" do
      system "cmake", "..", *args
      system "make"
      system "make", "install"
    end
  end

  test do
    input = "中国鼠标软件打印机"
    output = pipe_output("#{bin}/opencc", input)
    output = output.force_encoding("UTF-8") if output.respond_to?(:force_encoding)
    assert_match "中國鼠標軟件打印機", output
  end
end
