class Dafny < Formula
  desc "Verification-aware programming language"
  homepage "https://github.com/dafny-lang/dafny/blob/master/README.md"
  url "https://mirror.ghproxy.com/https://github.com/dafny-lang/dafny/archive/refs/tags/v4.8.0.tar.gz"
  sha256 "07799a0500bb45a5d57faebe181690a7fe93379706db2904552d236bd539491d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b98343389c54f29a8bc88b71594a17addaa4c82bf0fe2f7b0e2e94a587e5b655"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "36f6d698947d7dbee1c03156a329f53c4770d1038fc27d1a4b7172b5c92764d6"
    sha256 cellar: :any_skip_relocation, sonoma:         "abd78e9a8d15d585793a79039ee659beeef8aefb93144af098916829391797a7"
    sha256 cellar: :any_skip_relocation, monterey:       "2f98c4550316286c747157c067a608dab0a3dec08062fe87eb5fcc0c610c1882"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "37db21d113724ac2c4d1747894b88bd82e633bde21a7cd49bbb40ad914cf2709"
  end

  # Align deprecation with dotnet@6. Can be undeprecated if dependency is updated.
  # Issue ref: https://github.com/dafny-lang/dafny/issues/4948
  # PR ref: https://github.com/dafny-lang/dafny/pull/5322
  deprecate! date: "2024-11-12", because: "uses deprecated `dotnet@6`"

  depends_on "dotnet@6"
  # We use the latest Java version that is compatible with gradlew version in `dafny`.
  # https://github.com/dafny-lang/dafny/blob/v#{version}/Source/DafnyRuntime/DafnyRuntimeJava/gradle/wrapper/gradle-wrapper.properties
  # https://docs.gradle.org/current/userguide/compatibility.html
  depends_on "openjdk@17"
  depends_on "z3"

  def install
    system "make", "exe"
    libexec.install Dir["Binaries/*", "Scripts/quicktest.sh"]

    (bin/"dafny").write <<~EOS
      #!/bin/bash
      exec "#{Formula["dotnet@6"].opt_bin}/dotnet" "#{libexec}/Dafny.dll" "$@"
    EOS
  end

  test do
    (testpath/"test.dfy").write <<~EOS
      method Main() {
        var i: nat :| true;
        assert i as int >= -1;
        print "hello, Dafny\\n";
      }
    EOS
    assert_equal "\nDafny program verifier finished with 1 verified, 0 errors\n",
                  shell_output("#{bin}/dafny verify #{testpath}/test.dfy")
    assert_equal "\nDafny program verifier finished with 1 verified, 0 errors\nhello, Dafny\n",
                  shell_output("#{bin}/dafny run #{testpath}/test.dfy")
  end
end
