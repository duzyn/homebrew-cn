class Dafny < Formula
  desc "Verification-aware programming language"
  homepage "https://github.com/dafny-lang/dafny/blob/master/README.md"
  url "https://mirror.ghproxy.com/https://github.com/dafny-lang/dafny/archive/refs/tags/v4.8.1.tar.gz"
  sha256 "9037067dbd2704e04a93805cb7b1c431e56703c7f43e499f058ad863afd3e443"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "64688cc708b1ac3bb80885d6dde63f5637adf26afcef0a63df1c0aad94ff9b4e"
    sha256 cellar: :any_skip_relocation, sonoma:       "d9be42d9d26b9c95351b3537a0e6f2322a8f28127fe42ee569e2388b03ec217d"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "978706911bd498d135fd0c3c2909697c345f4819be29a3eb0ce8213f95b1af6d"
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
