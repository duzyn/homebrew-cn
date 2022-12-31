class Igraph < Formula
  desc "Network analysis package"
  homepage "https://igraph.org/"
  url "https://ghproxy.com/github.com/igraph/igraph/releases/download/0.10.3/igraph-0.10.3.tar.gz"
  sha256 "5f72398c7847bb167f85159b7a9fe1fe69ce0f241c5de5d30b2b347f9dc3f7c6"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e65d77bd4f288265b5aab2d58afd9d74690fd0be88c48e6ca9544262dd44043e"
    sha256 cellar: :any,                 arm64_monterey: "5ea5b7330221a1ffe685732ed800a8563cdb0320f993723bfe6e65eeba21cb5c"
    sha256 cellar: :any,                 arm64_big_sur:  "44c366f9daf9fb29fa4c66c25d3b1f2735e19ed67d738865972129372322f637"
    sha256 cellar: :any,                 ventura:        "955d9e4aa2a733118848535096a33391f858403f011c02d6971052f8411e4797"
    sha256 cellar: :any,                 monterey:       "cd5f6e6414111f112ea9ab50b86d1b86ee7ddd0c84a6f5e39865dc44492a79a0"
    sha256 cellar: :any,                 big_sur:        "b9ac826537cf8ee920a266ad67c26d892ec4a1c4fa9481de4a069aa6282538db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b8f90f6e74e4ccfdd2245cfc5f4d6be102beeeff3288c4a6213f89d2f138966"
  end

  depends_on "cmake" => :build
  depends_on "arpack"
  depends_on "glpk"
  depends_on "gmp"
  depends_on "openblas"

  uses_from_macos "libxml2"

  def install
    mkdir "build" do
      # explanation of extra options:
      # * we want a shared library, not a static one
      # * link-time optimization should be enabled if the compiler supports it
      # * thread-local storage of global variables is enabled
      # * force the usage of external dependencies from Homebrew where possible
      # * GraphML support should be compiled in (needs libxml2)
      # * BLAS and LAPACK should come from OpenBLAS
      # * prevent the usage of ccache even if it is installed to ensure that we
      #    have a clean build
      system "cmake", "-G", "Unix Makefiles",
                      "-DBUILD_SHARED_LIBS=ON",
                      "-DIGRAPH_ENABLE_LTO=AUTO",
                      "-DIGRAPH_ENABLE_TLS=ON",
                      "-DIGRAPH_GLPK_SUPPORT=ON",
                      "-DIGRAPH_GRAPHML_SUPPORT=ON",
                      "-DIGRAPH_USE_INTERNAL_ARPACK=OFF",
                      "-DIGRAPH_USE_INTERNAL_BLAS=OFF",
                      "-DIGRAPH_USE_INTERNAL_GLPK=OFF",
                      "-DIGRAPH_USE_INTERNAL_GMP=OFF",
                      "-DIGRAPH_USE_INTERNAL_LAPACK=OFF",
                      "-DBLA_VENDOR=OpenBLAS",
                      "-DUSE_CCACHE=OFF",
                      "..", *std_cmake_args
      system "make"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <igraph.h>
      int main(void) {
        igraph_real_t diameter;
        igraph_t graph;
        igraph_rng_seed(igraph_rng_default(), 42);
        igraph_erdos_renyi_game(&graph, IGRAPH_ERDOS_RENYI_GNP, 1000, 5.0/1000, IGRAPH_UNDIRECTED, IGRAPH_NO_LOOPS);
        igraph_diameter(&graph, &diameter, 0, 0, 0, 0, IGRAPH_UNDIRECTED, 1);
        printf("Diameter = %f\\n", (double) diameter);
        igraph_destroy(&graph);
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}/igraph", "-L#{lib}",
                   "-ligraph", "-lm", "-o", "test"
    assert_match "Diameter = 8", shell_output("./test")
  end
end
