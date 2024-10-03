class Cnats < Formula
  desc "C client for the NATS messaging system"
  homepage "https://github.com/nats-io/nats.c"
  url "https://mirror.ghproxy.com/https://github.com/nats-io/nats.c/archive/refs/tags/v3.9.0.tar.gz"
  sha256 "82fd3cdc732f091859f5840c968ba489bc5c91b94454040b8011c1d61fd973a8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a14732dbe1970ee79a82bf82284fe48a36593d9f4524bd165555575b2e86d737"
    sha256 cellar: :any,                 arm64_sonoma:  "46bdd45de7cebfbf7fee0efa4f25a8e75ff1259b4eeeab1fd2b83499125614c8"
    sha256 cellar: :any,                 arm64_ventura: "99eccf1867487b76254b99869d48f04e76ff1487abc73df1a061d3cd0ce27128"
    sha256 cellar: :any,                 sonoma:        "d9d34eb8f6e01a652fdb5995210d39dfaa179103534e54f6c470e0579d2607f5"
    sha256 cellar: :any,                 ventura:       "7d21fc311bed3729fe965047ce7d2d6f8a083623bdd42a065d2a475a21417ab6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bdee6d48ec5d0cd2a128a4072947881d4df68516830c33a3445531403fdbc466"
  end

  depends_on "cmake" => :build
  depends_on "libevent"
  depends_on "libuv"
  depends_on "openssl@3"
  depends_on "protobuf-c"

  # patch the version suffix for release builds, upstream build patch, https://github.com/nats-io/nats.c/pull/810
  patch :DATA

  def install
    args = %W[
      -DCMAKE_INSTALL_PREFIX=#{prefix}
      -DBUILD_TESTING=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <nats/nats.h>
      #include <stdio.h>
      int main() {
        printf("%s\\n", nats_GetVersion());
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lnats", "-o", "test"
    assert_equal version, shell_output("./test").strip
  end
end

__END__
diff --git a/CMakeLists.txt b/CMakeLists.txt
index 7b87592..4a725bf 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -254,7 +254,7 @@ endif(NATS_BUILD_WITH_TLS)
 set(NATS_VERSION_MAJOR  3)
 set(NATS_VERSION_MINOR  9)
 set(NATS_VERSION_PATCH  0)
-set(NATS_VERSION_SUFFIX "-beta")
+set(NATS_VERSION_SUFFIX "")
 
 set(NATS_VERSION_REQUIRED_NUMBER 0x030900)
 
diff --git a/src/version.h b/src/version.h
index e06ea35..7ece7b8 100644
--- a/src/version.h
+++ b/src/version.h
@@ -25,7 +25,7 @@ extern "C" {
 #define NATS_VERSION_MINOR  9
 #define NATS_VERSION_PATCH  0
 
-#define NATS_VERSION_STRING "3.9.0-beta"
+#define NATS_VERSION_STRING "3.9.0"
 			 				  
 #define NATS_VERSION_NUMBER ((NATS_VERSION_MAJOR << 16) | \
                              (NATS_VERSION_MINOR <<  8) | \
