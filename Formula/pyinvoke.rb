class Pyinvoke < Formula
  include Language::Python::Virtualenv

  desc "Pythonic task management & command execution"
  homepage "https://www.pyinvoke.org/"
  license "BSD-2-Clause"
  revision 1
  head "https://github.com/pyinvoke/invoke.git", branch: "main"

  stable do
    url "https://files.pythonhosted.org/packages/2b/8d/9aec496bbd200589397b4cd6d546576c296465c1bdeb28c1ea1019e75a1f/invoke-1.7.3.tar.gz"
    sha256 "41b428342d466a82135d5ab37119685a989713742be46e42a3a399d685579314"

    # Backport support for Python 3.11. Remove in the next release.
    patch do
      url "https://github.com/pyinvoke/invoke/commit/406a45e854f6e8df4aa0de01e3b731fea2b1f1ec.patch?full_index=1"
      sha256 "f052fb5c0a79fa2e7508b37e3e1d866ae0a86d81d20699871510f903b0838c15"
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e4254961d8b57fe582e30b38b4e39ea0d8ea53401a1a485511ae12f2c545c94b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e4254961d8b57fe582e30b38b4e39ea0d8ea53401a1a485511ae12f2c545c94b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e4254961d8b57fe582e30b38b4e39ea0d8ea53401a1a485511ae12f2c545c94b"
    sha256 cellar: :any_skip_relocation, ventura:        "191044f6ed007f1ed00dfe9b6b35f1a58df53850ba341dd37c8b64b7dfdabda0"
    sha256 cellar: :any_skip_relocation, monterey:       "191044f6ed007f1ed00dfe9b6b35f1a58df53850ba341dd37c8b64b7dfdabda0"
    sha256 cellar: :any_skip_relocation, big_sur:        "191044f6ed007f1ed00dfe9b6b35f1a58df53850ba341dd37c8b64b7dfdabda0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "808c3ca90ec453fe65718449286422063d57e342f08a06cdf38d49799115d162"
  end

  depends_on "python@3.11"

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"tasks.py").write <<~EOS
      from invoke import run, task

      @task
      def clean(ctx, extra=''):
          patterns = ['foo']
          if extra:
              patterns.append(extra)
          for pattern in patterns:
              run("rm -rf {}".format(pattern))
    EOS
    (testpath/"foo"/"bar").mkpath
    (testpath/"baz").mkpath
    system bin/"invoke", "clean"
    refute_predicate testpath/"foo", :exist?, "\"pyinvoke clean\" should have deleted \"foo\""
    assert_predicate testpath/"baz", :exist?, "pyinvoke should have left \"baz\""
    system bin/"invoke", "clean", "--extra=baz"
    refute_predicate testpath/"foo", :exist?, "\"pyinvoke clean-extra\" should have still deleted \"foo\""
    refute_predicate testpath/"baz", :exist?, "pyinvoke clean-extra should have deleted \"baz\""
  end
end
