class Onnxruntime < Formula
  desc "Cross-platform, high performance scoring engine for ML models"
  homepage "https://github.com/microsoft/onnxruntime"
  url "https://github.com/microsoft/onnxruntime.git",
      tag:      "v1.20.1",
      revision: "5c1b7ccbff7e5141c1da7a9d963d660e5741c319"
  license "MIT"
  revision 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ebfd468f95f087645049ffe7a1d2a2e843998dec9528c7e642e5df0e9c603b3c"
    sha256 cellar: :any,                 arm64_sonoma:  "c7c329085d36a72f9dd8313992e15929dc70cb0ca3c3d4ae2ec60b949a7a45e4"
    sha256 cellar: :any,                 arm64_ventura: "2894a827b91d5b8319c15883373e1fefbe7fbda8459f16c6ab944523c824315c"
    sha256 cellar: :any,                 sonoma:        "d84c6192b877d6638c4db00ec835f116298dd624e125c13eae59ddba11298e35"
    sha256 cellar: :any,                 ventura:       "f79c5899acf7b627c9ee4e89eec91ebb99f9f953ce341a7f2d85adc09cf25dcc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a0df3f93a5c5a5db780c11af3ecdf2712ec147882191233d05023966f76f09dc"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "cpp-gsl" => :build
  depends_on "flatbuffers" => :build # NOTE: links to static library
  depends_on "howard-hinnant-date" => :build
  depends_on "nlohmann-json" => :build
  depends_on "python@3.13" => :build
  depends_on "safeint" => :build
  depends_on "abseil"
  depends_on "nsync"
  depends_on "onnx"
  depends_on "protobuf"
  depends_on "re2"

  # Need newer than stable `eigen` after https://github.com/microsoft/onnxruntime/pull/21492
  # element_wise_ops.cc:708:32: error: no matching member function for call to 'min'
  #
  # https://github.com/microsoft/onnxruntime/blob/v#{version}/cmake/deps.txt#L25
  resource "eigen" do
    url "https://gitlab.com/libeigen/eigen/-/archive/e7248b26a1ed53fa030c5c459f7ea095dfd276ac/eigen-e7248b26a1ed53fa030c5c459f7ea095dfd276ac.tar.bz2"
    sha256 "a3f1724de1dc7e7f74fbcc206ffcaeba27fd89b37dc71f9c31e505634d0c1634"
  end

  # https://github.com/microsoft/onnxruntime/blob/v#{version}/cmake/deps.txt#L52
  resource "pytorch_cpuinfo" do
    url "https://mirror.ghproxy.com/https://github.com/pytorch/cpuinfo/archive/ca678952a9a8eaa6de112d154e8e104b22f9ab3f.tar.gz"
    sha256 "c8f43b307fa7d911d88fec05448161eb1949c3fc0cb62f3a7a2c61928cdf2e9b"
  end

  # Backport fix for build on Linux
  patch do
    url "https://github.com/microsoft/onnxruntime/commit/4d614e15bd9e6949bc3066754791da403e00d66c.patch?full_index=1"
    sha256 "76f9920e591bc52ea80f661fa0b5b15479960004f1be103467b219e55c73a8cc"
  end

  # Backport support for Protobuf 26+
  patch do
    url "https://github.com/microsoft/onnxruntime/commit/704523c2d8a142f723a5cc242c62f5b20afa4944.patch?full_index=1"
    sha256 "68a0300b02f1763a875c7f890c4611a95233b7ff1f7158f4328d5f906f21c84d"
  end

  def install
    python3 = which("python3.13")

    # Workaround to use brew `nsync`. Remove in future release with
    # https://github.com/microsoft/onnxruntime/commit/88676e62b966add2cc144a4e7d8ae1dbda1148e8
    inreplace "cmake/external/onnxruntime_external_deps.cmake" do |s|
      s.gsub!(/ NAMES nsync unofficial-nsync$/, " NAMES nsync_cpp")
      s.gsub!(/\bunofficial::nsync::nsync_cpp\b/, "nsync_cpp")
    end

    resources.each do |r|
      (buildpath/"build/_deps/#{r.name}-src").install r
    end

    args = %W[
      -DHOMEBREW_ALLOW_FETCHCONTENT=ON
      -DFETCHCONTENT_FULLY_DISCONNECTED=ON
      -DFETCHCONTENT_SOURCE_DIR_PYTORCH_CLOG=#{buildpath}/build/_deps/pytorch_cpuinfo-src
      -DFETCHCONTENT_TRY_FIND_PACKAGE_MODE=ALWAYS
      -DPYTHON_EXECUTABLE=#{python3}
      -DONNX_CUSTOM_PROTOC_EXECUTABLE=#{Formula["protobuf"].opt_bin}/protoc
      -Donnxruntime_BUILD_SHARED_LIB=ON
      -Donnxruntime_BUILD_UNIT_TESTS=OFF
      -Donnxruntime_GENERATE_TEST_REPORTS=OFF
      -Donnxruntime_RUN_ONNX_TESTS=OFF
      -Donnxruntime_USE_FULL_PROTOBUF=ON
    ]

    # Regenerate C++ bindings to use newer `flatbuffers`
    flatc = Formula["flatbuffers"].opt_bin/"flatc"
    system python3, "onnxruntime/core/flatbuffers/schema/compile_schema.py", "--flatc", flatc
    system python3, "onnxruntime/lora/adapter_format/compile_schema.py", "--flatc", flatc

    system "cmake", "-S", "cmake", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <onnxruntime/onnxruntime_c_api.h>
      #include <stdio.h>
      int main()
      {
        printf("%s\\n", OrtGetApiBase()->GetVersionString());
        return 0;
      }
    C
    system ENV.cc, "-I#{include}", "test.c", "-L#{lib}", "-lonnxruntime", "-o", "test"
    assert_equal version, shell_output("./test").strip
  end
end
