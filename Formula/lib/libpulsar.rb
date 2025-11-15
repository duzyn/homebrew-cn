class Libpulsar < Formula
  desc "Apache Pulsar C++ library"
  homepage "https://pulsar.apache.org/"
  url "https://dlcdn.apache.org/pulsar/pulsar-client-cpp-3.8.0/apache-pulsar-client-cpp-3.8.0.tar.gz"
  mirror "https://archive.apache.org/dist/pulsar/pulsar-client-cpp-3.8.0/apache-pulsar-client-cpp-3.8.0.tar.gz"
  sha256 "e5abff91da01cbc19eb8c08002f1ba765f99ce5b7abe1b1689b320658603b70b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "667770f36de7000a1681d27f4100242d1b430fd8b47553c8a461dc2313de5306"
    sha256 cellar: :any,                 arm64_sequoia: "db9e4113dbdad0399cc644bfeaa85071ef247c127e9a30fc5a34ad77b11d8287"
    sha256 cellar: :any,                 arm64_sonoma:  "764b056325bb6d6273c79240c7d62300d0ae059ea5f2ee268bc6456d89cf78d4"
    sha256 cellar: :any,                 sonoma:        "bdaa7dda25b93f9f38a39c31acc0fc20c506fd44292648d8e3d612a72b6505a0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8aa2e58ad7d1bb9717b58909e5719ea293cf9ef3b3638fc9cdbd26f353395f47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b687a6b0a12b3273de8bb52c1867a8938053aec1c101639128ea8b9708002fb3"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  depends_on "openssl@3"
  depends_on "protobuf"
  depends_on "snappy"
  depends_on "zstd"

  uses_from_macos "curl"
  uses_from_macos "zlib"

  # Workaround for Protobuf 30+, issue ref: https://github.com/apache/pulsar-client-cpp/issues/478
  patch :DATA

  def install
    args = %W[
      -DBUILD_TESTS=OFF
      -DCMAKE_CXX_STANDARD=17
      -DOPENSSL_ROOT_DIR=#{Formula["openssl@3"].opt_prefix}
      -DUSE_ASIO=OFF
    ]
    # Avoid over-linkage to `abseil`.
    args << "-DCMAKE_SHARED_LINKER_FLAGS=-Wl,-dead_strip_dylibs" if OS.mac?

    system "cmake", "-S", ".", "build", *args, *std_cmake_args
    system "cmake", "--build", "build", "--target", "pulsarShared", "pulsarStatic"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cc").write <<~CPP
      #include <pulsar/Client.h>

      int main (int argc, char **argv) {
        pulsar::Client client("pulsar://localhost:#{free_port}");
        return 0;
      }
    CPP

    system ENV.cxx, "-std=gnu++11", "test.cc", "-L#{lib}", "-lpulsar", "-o", "test"
    system "./test"
  end
end

__END__
diff --git a/lib/ProtobufNativeSchema.cc b/lib/ProtobufNativeSchema.cc
index 5cddf74..4bf45cf 100644
--- a/lib/ProtobufNativeSchema.cc
+++ b/lib/ProtobufNativeSchema.cc
@@ -39,8 +39,8 @@ SchemaInfo createProtobufNativeSchema(const google::protobuf::Descriptor* descri
     }

     const auto fileDescriptor = descriptor->file();
-    const std::string& rootMessageTypeName = descriptor->full_name();
-    const std::string& rootFileDescriptorName = fileDescriptor->name();
+    const std::string rootMessageTypeName = std::string(descriptor->full_name());
+    const std::string rootFileDescriptorName = std::string(fileDescriptor->name());

     FileDescriptorSet fileDescriptorSet;
     internalCollectFileDescriptors(fileDescriptor, fileDescriptorSet);
