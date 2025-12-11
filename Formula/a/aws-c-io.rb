class AwsCIo < Formula
  desc "Event driven framework for implementing application protocols"
  homepage "https://github.com/awslabs/aws-c-io"
  url "https://mirror.ghproxy.com/https://github.com/awslabs/aws-c-io/archive/refs/tags/v0.23.4.tar.gz"
  sha256 "b2d0b784b88250f6c44c1c45cf54c0981c9a9ac9c1f9ff0054b02c6ffae35701"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4a3f273d3ec19585490973ef55f5a40ea57590d25b3efc768fd1a2d20b9211f5"
    sha256 cellar: :any,                 arm64_sequoia: "01dd9a8a83779929de3f5ecf5eaa9974597932cf30a4a2adf0ed1518d6d6a021"
    sha256 cellar: :any,                 arm64_sonoma:  "53d428591bb97381840d26d16121ae82d249d2200c4c3b2204b86cc1f5e3a9fc"
    sha256 cellar: :any,                 sonoma:        "a9d3087632ac33394922787cde7b4a9d033f69c0399d2bdb43df644a8c30e355"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9900d147be1593b1d7a85a5d902fa4bb6234b6738a12bfb937465d80980733da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "15cd4d35ad68760ac943dca1bf5e48fabd7e41c4ed6d2c8357ff649220abc7bf"
  end

  depends_on "cmake" => :build
  depends_on "aws-c-cal"
  depends_on "aws-c-common"

  on_linux do
    depends_on "s2n"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <aws/io/io.h>
      #include <aws/io/retry_strategy.h>
      #include <aws/common/allocator.h>
      #include <aws/common/error.h>
      #include <assert.h>

      int main(void) {
        struct aws_allocator *allocator = aws_default_allocator();
        aws_io_library_init(allocator);

        struct aws_retry_strategy *retry_strategy = aws_retry_strategy_new_no_retry(allocator, NULL);
        assert(NULL != retry_strategy);

        int rv = aws_retry_strategy_acquire_retry_token(retry_strategy, NULL, NULL, NULL, 0);
        assert(rv == AWS_OP_ERR);
        assert(aws_last_error() == AWS_IO_RETRY_PERMISSION_DENIED);

        aws_retry_strategy_release(retry_strategy);
        aws_io_library_clean_up();
        return 0;
      }
    C
    system ENV.cc, "test.c", "-o", "test", "-L#{lib}", "-laws-c-io",
                   "-L#{Formula["aws-c-common"].opt_lib}", "-laws-c-common"
    system "./test"
  end
end
