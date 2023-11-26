class Lemon < Formula
  desc "LALR(1) parser generator like yacc or bison"
  homepage "https://www.hwaci.com/sw/lemon/"
  url "https://www.sqlite.org/2023/sqlite-src-3440100.zip"
  version "3.44.0"
  sha256 "52aa53c59ec9be4c28e2d2524676cb2938558f11c2b4c00d8b1a546000453919"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f354fa0742dbc55417a46adc535e01dfde228369e2a04d578b0e7aa43b8125c9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fc6fa501c354c42f623d55456bca6a8d5d572a301ff404cbf6b37de4f3f3d801"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "15bff74dd79abae2fd52b5d00bf5712c95f45f8ba44d87cc5fce3ba9bc9b61a0"
    sha256 cellar: :any_skip_relocation, sonoma:         "ffe5ae038d7f8bcd2be452bf43994266eb20f8f4e88e004278cdee2a9c646c17"
    sha256 cellar: :any_skip_relocation, ventura:        "fbf27f95d3c76e859d764931a0eaf19d13f6213c2201f2e0af28ce5e734550bb"
    sha256 cellar: :any_skip_relocation, monterey:       "070b075074f7369cf286d8916a5acfb186a2719ccb52297fc0c585687e24e9d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d05fc3f03e2d617290ce24f407333d700a578fd494ade6dff7a0ceba0481dc7c"
  end

  # Submitted the patch via email to the upstream
  patch :DATA

  def install
    pkgshare.install "tool/lempar.c"

    # patch the parser generator to look for the 'lempar.c' template file where we've installed it
    inreplace "tool/lemon.c", "lempar.c", "#{pkgshare}/lempar.c"

    system ENV.cc, "-o", "lemon", "tool/lemon.c"
    bin.install "lemon"

    pkgshare.install "test/lemon-test01.y"
    doc.install "doc/lemon.html"
  end

  test do
    system "#{bin}/lemon", "-d#{testpath}", "#{pkgshare}/lemon-test01.y"
    system ENV.cc, "lemon-test01.c"
    assert_match "tests pass", shell_output("./a.out")
  end
end

__END__
diff --git a/test/lemon-test01.y b/test/lemon-test01.y
index 0fd514f..67a3752 100644
--- a/test/lemon-test01.y
+++ b/test/lemon-test01.y
@@ -54,8 +54,8 @@ all ::=  error B.
     Parse(&xp, 0, 0);
     ParseFinalize(&xp);
     testCase(200, 1, nSyntaxError);
-    testCase(210, 1, nAccept);
-    testCase(220, 0, nFailure);
+    testCase(210, 0, nAccept);
+    testCase(220, 3, nFailure);
     nSyntaxError = nAccept = nFailure = 0;
     ParseInit(&xp);
     Parse(&xp, TK_A, 0);
@@ -64,7 +64,7 @@ all ::=  error B.
     ParseFinalize(&xp);
     testCase(200, 1, nSyntaxError);
     testCase(210, 0, nAccept);
-    testCase(220, 0, nFailure);
+    testCase(220, 2, nFailure);
     if( nErr==0 ){
       printf("%d tests pass\n", nTest);
     }else{
