class AwsCCal < Formula
  desc "AWS Crypto Abstraction Layer"
  homepage "https://github.com/awslabs/aws-c-cal"
  url "https://mirror.ghproxy.com/https://github.com/awslabs/aws-c-cal/archive/refs/tags/v0.9.6.tar.gz"
  sha256 "4bb8a55a9e542ee191317f15ad88392fc145443fe1aa71c9f1b6f3c40c4f38f8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "70223ca654f92dc737a6189e65fd9bf33a8386648292cb2fceb48db368486567"
    sha256 cellar: :any,                 arm64_sequoia: "fa6e0a775703d209fabbd978b9c37dc4126eb3ea7ea50ffa2876fb0f135fb4e9"
    sha256 cellar: :any,                 arm64_sonoma:  "15499ee6c8944ba514c4b33b080614ba5c13044d74bdc87856438c5b20c8aad9"
    sha256 cellar: :any,                 sonoma:        "9e3caecd829c62685e401faac431cf894266b3b9c354d7aec641656faa7c76e5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aa2085c9dcb5116e365ce68ed5322dc5f399e6b9778b739fa77b10c387aa6c6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dad1a8d7f4d09e034b1c9f161d2645c634c0896160d54edc54df853ef97a8866"
  end

  depends_on "cmake" => :build
  depends_on "aws-c-common"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    args = ["-DBUILD_SHARED_LIBS=ON"]
    args << "-DUSE_OPENSSL=ON" if OS.linux?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <aws/cal/cal.h>
      #include <aws/cal/hash.h>
      #include <aws/common/allocator.h>
      #include <aws/common/byte_buf.h>
      #include <aws/common/error.h>
      #include <assert.h>

      int main(void) {
        struct aws_allocator *allocator = aws_default_allocator();
        aws_cal_library_init(allocator);

        struct aws_hash *hash = aws_sha256_new(allocator);
        assert(NULL != hash);
        struct aws_byte_cursor input = aws_byte_cursor_from_c_str("a");

        for (size_t i = 0; i < 1000000; ++i) {
          assert(AWS_OP_SUCCESS == aws_hash_update(hash, &input));
        }

        uint8_t output[AWS_SHA256_LEN] = {0};
        struct aws_byte_buf output_buf = aws_byte_buf_from_array(output, sizeof(output));
        output_buf.len = 0;
        assert(AWS_OP_SUCCESS == aws_hash_finalize(hash, &output_buf, 0));

        uint8_t expected[] = {
          0xcd, 0xc7, 0x6e, 0x5c, 0x99, 0x14, 0xfb, 0x92, 0x81, 0xa1, 0xc7, 0xe2, 0x84, 0xd7, 0x3e, 0x67,
          0xf1, 0x80, 0x9a, 0x48, 0xa4, 0x97, 0x20, 0x0e, 0x04, 0x6d, 0x39, 0xcc, 0xc7, 0x11, 0x2c, 0xd0,
        };
        struct aws_byte_cursor expected_buf = aws_byte_cursor_from_array(expected, sizeof(expected));
        assert(expected_buf.len == output_buf.len);
        for (size_t i = 0; i < expected_buf.len; ++i) {
          assert(expected_buf.ptr[i] == output_buf.buffer[i]);
        }

        aws_hash_destroy(hash);
        aws_cal_library_clean_up();
        return 0;
      }
    C
    system ENV.cc, "test.c", "-o", "test", "-L#{lib}", "-laws-c-cal",
                   "-L#{Formula["aws-c-common"].opt_lib}", "-laws-c-common"
    system "./test"
  end
end
