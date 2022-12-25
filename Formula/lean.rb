class Lean < Formula
  desc "Theorem prover"
  homepage "https://leanprover-community.github.io/"
  url "https://github.com/leanprover-community/lean/archive/v3.50.2.tar.gz"
  sha256 "57d4bdab94a4ad6fe1c252be0d49ff9522a3baaa5280a606d86ceeb955873f80"
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
    sha256 cellar: :any,                 arm64_ventura:  "4edcb304294ec17a2ea3dfd52656325ad4e5f6ed30c950d507f559b9a2028d31"
    sha256 cellar: :any,                 arm64_monterey: "8777f08aa3dcd2acd5ba76a000345e9b90d067b7dda9c12beeb78f9c18812c68"
    sha256 cellar: :any,                 arm64_big_sur:  "29c5b0a734be1a67694ddd583ff5817c62dc951703b7d85121d0442c8d4a6e78"
    sha256 cellar: :any,                 ventura:        "e5e6e965347ac20c4e6fa7048b70dbd6d8b54d6ad22b163d0545df063d71ffdf"
    sha256 cellar: :any,                 monterey:       "982044cec3404d21620f434ad2504dd43ee5e956ca543ba8afcdbc771c5c2ac5"
    sha256 cellar: :any,                 big_sur:        "a0a9ede8d767a88c9af3492014a02c0a639d3e7dee31475f47fc1108dc8f262c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d67f8ebbf98696842d039aa557f496917c137aea4b609501a065c84148bbc976"
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
