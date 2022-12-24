class Lean < Formula
  desc "Theorem prover"
  homepage "https://leanprover-community.github.io/"
  url "https://github.com/leanprover-community/lean/archive/v3.50.1.tar.gz"
  sha256 "07a02eccfb8d1f171edafacd25dd4c0d799779eb051981a740953872a450baef"
  license "Apache-2.0"
  head "https://github.com/leanprover-community/lean.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :git do |tags, regex|
      tags.map do |tag|
        version = tag[regex, 1]
        next if version == "9.9.9" # Omit a problematic version tag

        version
      end
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "701d88fc2ce63d167ee4e51d825acb9e8613556f74aa57c4fe2d94e3c9eb9933"
    sha256 cellar: :any,                 arm64_monterey: "f2219fedd1017a37bb35275d95a522ace9a7a8ae1fc93720aa023178115b04ad"
    sha256 cellar: :any,                 arm64_big_sur:  "ac380d003d07f3578b043d069efef9634d3e0b84a6bea99b3837a24593cf87f5"
    sha256 cellar: :any,                 ventura:        "39b0284946ee955d8a63f77027923c17ea9e055cb5c4bb7d2c93f884cdb9443c"
    sha256 cellar: :any,                 monterey:       "3f9dc8a9a3d0b0f45e34fba98b748c7a51c385a5cb34508eb2396bc33435fa97"
    sha256 cellar: :any,                 big_sur:        "26435011615d798ab7ea3119a206188aa01e8625d6c46f931f9d1b604fadf307"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5d76e023ef11a1c1266226be35f0638619bdf52401ddb3abf0e00def4e158924"
  end

  depends_on "cmake" => :build
  depends_on "coreutils"
  depends_on "gmp"
  depends_on "jemalloc"
  depends_on macos: :mojave

  conflicts_with "elan-init", because: "`lean` and `elan-init` install the same binaries"

  fails_with gcc: "5"

  def install
    args = std_cmake_args + %w[
      -DCMAKE_CXX_FLAGS='-std=c++14'
    ]

    system "cmake", "-S", "src", "-B", "src/build", *args
    system "cmake", "--build", "src/build"
    system "cmake", "--install", "src/build"
  end

  test do
    (testpath/"hello.lean").write <<~EOS
      def id' {α : Type} (x : α) : α := x

      inductive tree (α : Type) : Type
      | node : α → list tree → tree

      example (a b : Prop) : a ∧ b -> b ∧ a :=
      begin
          intro h, cases h,
          split, repeat { assumption }
      end
    EOS
    system bin/"lean", testpath/"hello.lean"
    system bin/"leanpkg", "help"
  end
end
