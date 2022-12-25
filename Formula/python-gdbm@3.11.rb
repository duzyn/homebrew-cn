class PythonGdbmAT311 < Formula
  desc "Python interface to gdbm"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.11.1/Python-3.11.1.tgz"
  sha256 "baed518e26b337d4d8105679caf68c5c32630d702614fc174e98cb95c46bdfa4"
  license "Python-2.0"

  livecheck do
    formula "python@3.11"
  end

  bottle do
    sha256 cellar: :any, arm64_ventura:  "184b4bea700a9361a3a841a04fb4a851ce5b282e01c36f22dc821a02e6cfd446"
    sha256 cellar: :any, arm64_monterey: "b886ae224404da8ad313f375ac29b8a3deebe64e0efd1ea650f18fd0af08a1de"
    sha256 cellar: :any, arm64_big_sur:  "ffae269cc139a6e30f3907d13c2aa9e15e969bd804566434160ca7971f6afa5e"
    sha256 cellar: :any, ventura:        "d469c9cb71dbc934d0dd17d1546be25d6fe4712e5da7fe417472acbf85a8ffff"
    sha256 cellar: :any, monterey:       "df8288e110b57bcc1206242b21c61fc95abf31ac368182465f3bfb68bbc7482b"
    sha256 cellar: :any, big_sur:        "d89241d66fb4ed5a22eaba413f202e11d939c163c986cef59d96e7941686a7ff"
    sha256               x86_64_linux:   "fd17701deb3f8b7614acc4b77b186402e238a6883da0caacaf93bcde8e510ac8"
  end

  depends_on "gdbm"
  depends_on "python@3.11"

  def python3
    "python3.11"
  end

  def install
    cd "Modules" do
      (Pathname.pwd/"setup.py").write <<~EOS
        from setuptools import setup, Extension

        setup(name="gdbm",
              description="#{desc}",
              version="#{version}",
              ext_modules = [
                Extension("_gdbm", ["_gdbmmodule.c"],
                          include_dirs=["#{Formula["gdbm"].opt_include}"],
                          libraries=["gdbm"],
                          library_dirs=["#{Formula["gdbm"].opt_lib}"])
              ]
        )
      EOS
      system python3, *Language::Python.setup_install_args(libexec, python3),
                      "--install-lib=#{libexec}"
      rm_r libexec.glob("*.egg-info")
    end
  end

  test do
    testdb = testpath/"test.db"
    system python3, "-c", <<~EOS
      import dbm.gnu

      with dbm.gnu.open("#{testdb}", "n") as db:
        db["testkey"] = "testvalue"

      with dbm.gnu.open("#{testdb}", "r") as db:
        assert db["testkey"] == b"testvalue"
    EOS
  end
end
