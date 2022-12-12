class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https://github.com/google/libphonenumber"
  url "https://github.com/google/libphonenumber/archive/v8.13.2.tar.gz"
  sha256 "54cfc482c712646d825fd4ee82f72767e74ce2595154da8e1c0bf7c5dad70bb1"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "5ffd692ef0e9569962bda787b890c528dc9242cb44af56463328dd16fdccb497"
    sha256 cellar: :any,                 arm64_monterey: "51aaf924b5c7bf862971cca25f1b170e401bed2262eb146fca12b654ea3a64c4"
    sha256 cellar: :any,                 arm64_big_sur:  "ff5d9e621a181e2afa34832d41e89fb49f38ccf2fc4024b9aab168dde80c5a70"
    sha256 cellar: :any,                 ventura:        "61c74df22757e6c57ff51bb00bb39eddf7dcab25082c556b809d950afc323977"
    sha256 cellar: :any,                 monterey:       "a5861d2f1cee61a759324239e8c10ff06b6222506d275eca1fd4a8c244ab42f8"
    sha256 cellar: :any,                 big_sur:        "1f015118e7a4b952cc1e6191afaad2bc6a687da4f919e296ea7886973ca18e1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "99eeea3689e93620cba34899b804906dcbb10b610da5702aebaea898242fb916"
  end

  depends_on "cmake" => :build
  depends_on "googletest" => :build
  depends_on "openjdk" => :build
  depends_on "abseil"
  depends_on "boost"
  depends_on "icu4c"
  depends_on "protobuf"
  depends_on "re2"

  fails_with gcc: "5" # For abseil and C++17

  def install
    ENV.append_to_cflags "-Wno-sign-compare" # Avoid build failure on Linux.
    system "cmake", "-S", "cpp", "-B", "build",
                    "-DCMAKE_CXX_STANDARD=17", # keep in sync with C++ standard in abseil.rb
                    "-DGTEST_INCLUDE_DIR=#{Formula["googletest"].opt_include}",
                     *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <phonenumbers/phonenumberutil.h>
      #include <phonenumbers/phonenumber.pb.h>
      #include <iostream>
      #include <string>

      using namespace i18n::phonenumbers;

      int main() {
        PhoneNumberUtil *phone_util_ = PhoneNumberUtil::GetInstance();
        PhoneNumber test_number;
        string formatted_number;
        test_number.set_country_code(1);
        test_number.set_national_number(6502530000ULL);
        phone_util_->Format(test_number, PhoneNumberUtil::E164, &formatted_number);
        if (formatted_number == "+16502530000") {
          return 0;
        } else {
          return 1;
        }
      }
    EOS
    system ENV.cxx, "-std=c++17", "test.cpp", "-L#{lib}", "-lphonenumber", "-o", "test"
    system "./test"
  end
end
