class GoogleJavaFormat < Formula
  include Language::Python::Shebang

  desc "Reformats Java source code to comply with Google Java Style"
  homepage "https://github.com/google/google-java-format"
  url "https://mirror.ghproxy.com/https://github.com/google/google-java-format/releases/download/v1.20.0/google-java-format-1.20.0-all-deps.jar"
  sha256 "cc57a88cf2e018c0d724e7257af3132e7748fe01a4bc19fd3c7e83a32c848780"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "302820639ed8a43e34b16c711726131f1c5a85878937c37438d2b867402bbae1"
  end

  depends_on "openjdk"
  depends_on "python@3.12"

  resource "google-java-format-diff" do
    url "https://mirror.ghproxy.com/https://raw.githubusercontent.com/google/google-java-format/v1.20.0/scripts/google-java-format-diff.py"
    sha256 "aa9621c0f0859e1112231a7d44ce8d21854f6915ca643a0d53a119f4d1aa8488"
  end

  def install
    libexec.install "google-java-format-#{version}-all-deps.jar" => "google-java-format.jar"
    bin.write_jar_script libexec/"google-java-format.jar", "google-java-format"
    resource("google-java-format-diff").stage do
      bin.install "google-java-format-diff.py" => "google-java-format-diff"
      rewrite_shebang detected_python_shebang, bin/"google-java-format-diff"
    end
  end

  test do
    (testpath/"foo.java").write "public class Foo{\n}\n"
    assert_match "public class Foo {}", shell_output("#{bin}/google-java-format foo.java")
    (testpath/"bar.java").write <<~BAR
      class Bar{
        int  x;
      }
    BAR
    patch = <<~PATCH
      --- a/bar.java
      +++ b/bar.java
      @@ -1,0 +2 @@ class Bar{
      +  int x  ;
    PATCH
    `echo '#{patch}' | #{bin}/google-java-format-diff -p1 -i`
    assert_equal <<~BAR, File.read(testpath/"bar.java")
      class Bar{
        int x;
      }
    BAR
    assert_equal version, resource("google-java-format-diff").version
  end
end
