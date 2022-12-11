class Protobuf < Formula
  desc "Protocol buffers (Google's data interchange format)"
  homepage "https://github.com/protocolbuffers/protobuf/"
  license "BSD-3-Clause"

  stable do
    url "https://ghproxy.com/github.com/protocolbuffers/protobuf/releases/download/v21.11/protobuf-all-21.11.tar.gz"
    sha256 "f045f136e61e367a9436571b6676b94e5e16631a06c864146688c3aaf7df794b"

    # Fix build with Python 3.11. Remove in the next release.
    patch do
      url "https://github.com/protocolbuffers/protobuf/commit/da973aff2adab60a9e516d3202c111dbdde1a50f.patch?full_index=1"
      sha256 "911925e427a396fa5e54354db8324c0178f5c602b3f819f7d471bb569cc34f53"
    end
  end

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "5392b989b4660a68ee47bbb95dbd4ffa9b6c019642c0722dc605e2dcf81de179"
    sha256 cellar: :any,                 arm64_monterey: "8ddce7d80d51d4c035fbcd0cdcc388ab0021769754d81e32d10bd49efeed6074"
    sha256 cellar: :any,                 arm64_big_sur:  "8c45d48cbe9c0d03b8ad0c5c2e0e368ed8c260da4953bb224e03f43f21378d3a"
    sha256 cellar: :any,                 ventura:        "3f6e43a8d77dbd3969422b661109f15cc72fd448a29c143d679c9dad80ca985a"
    sha256 cellar: :any,                 monterey:       "ed9607dabe5177d68498a3c8ff4628c7c696f9877b9a480a513ad6f398f7eee1"
    sha256 cellar: :any,                 big_sur:        "b0898c861f63253147ea75daf9c41e451b9162398930cdd41ce0b7a9f8349f99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "094baa93a426d067785b737b3c89a08aa825646618cd96ccd58b9383ec62f647"
  end

  head do
    url "https://github.com/protocolbuffers/protobuf.git", branch: "main"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "python@3.10" => [:build, :test]
  depends_on "python@3.11" => [:build, :test]

  uses_from_macos "zlib"

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.match?(/^python@\d\.\d+$/) }
        .map { |f| f.opt_libexec/"bin/python" }
  end

  def install
    # Don't build in debug mode. See:
    # https://github.com/Homebrew/homebrew/issues/9279
    # https://github.com/protocolbuffers/protobuf/blob/5c24564811c08772d090305be36fae82d8f12bbe/configure.ac#L61
    ENV.prepend "CXXFLAGS", "-DNDEBUG"
    ENV.cxx11

    system "./autogen.sh" if build.head?
    system "./configure", *std_configure_args, "--with-zlib", "--with-pic"
    system "make"
    system "make", "check"
    system "make", "install"

    # Install editor support and examples
    pkgshare.install "editors/proto.vim", "examples"
    elisp.install "editors/protobuf-mode.el"

    ENV.append_to_cflags "-I#{include}"
    ENV.append_to_cflags "-L#{lib}"

    cd "python" do
      pythons.each do |python|
        system python, *Language::Python.setup_install_args(prefix, python), "--cpp_implementation"
      end
    end
  end

  test do
    testdata = <<~EOS
      syntax = "proto3";
      package test;
      message TestCase {
        string name = 4;
      }
      message Test {
        repeated TestCase case = 1;
      }
    EOS
    (testpath/"test.proto").write testdata
    system bin/"protoc", "test.proto", "--cpp_out=."

    pythons.each do |python|
      system python, "-c", "import google.protobuf"
    end
  end
end
