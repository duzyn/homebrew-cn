class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  # aws-sdk-cpp should only be updated every 10 releases on multiples of 10
  url "https://github.com/aws/aws-sdk-cpp.git",
      tag:      "1.10.10",
      revision: "9a68056cb0a7fe3f5a25ada48e3f1ce20501ce56"
  license "Apache-2.0"
  head "https://github.com/aws/aws-sdk-cpp.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "3750aeb21958c2b30c12ba143a0aaa1552a3f67bd92db063154936cebff57b53"
    sha256 cellar: :any,                 arm64_monterey: "f5a126e9f7ecfbfa7053cf7f8d5e6ae3b64228b35c3554e14c378250149f6e27"
    sha256 cellar: :any,                 arm64_big_sur:  "f11756cb3bcbc70d361e5931e9bffde99b91e1990ed23248e4bcb9028efc8bd1"
    sha256 cellar: :any,                 ventura:        "8245e9c5bc9c5e68cf8364479bbcd61b882885101372770b54196c142fc584cb"
    sha256 cellar: :any,                 monterey:       "03fcf2e9371a3a2e8ebde497fdc117116045bae4dde34723912e74ed52b06efe"
    sha256 cellar: :any,                 big_sur:        "90d301492c02a0341f09ead42ae7ca1bf3b486c633a9f1edd21fd23baa3d3f77"
    sha256 cellar: :any,                 catalina:       "a853a9456f19d5c75c04fb23965bab5ffc3484adb0983c97ddad9441294bdea2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "79bd04aa5b8a03c78417f1e3eaf8357f89bfd83264317d881a506dd375dd1813"
  end

  depends_on "cmake" => :build

  uses_from_macos "curl"

  fails_with gcc: "5"

  def install
    ENV.append "LDFLAGS", "-Wl,-rpath,#{rpath}"
    mkdir "build" do
      args = %w[
        -DENABLE_TESTING=OFF
      ]
      system "cmake", "..", *std_cmake_args, *args
      system "make"
      system "make", "install"
    end

    lib.install Dir[lib/"mac/Release/*"].select { |f| File.file? f }
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <aws/core/Version.h>
      #include <iostream>

      int main() {
          std::cout << Aws::Version::GetVersionString() << std::endl;
          return 0;
      }
    EOS
    system ENV.cxx, "-std=c++11", "test.cpp", "-L#{lib}", "-laws-cpp-sdk-core",
           "-o", "test"
    system "./test"
  end
end
