class PythonTkAT310 < Formula
  desc "Python interface to Tcl/Tk"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.10.9/Python-3.10.9.tgz"
  sha256 "4ccd7e46c8898f4c7862910a1703aa0e63525913a519abb2f55e26220a914d88"
  license "Python-2.0"

  livecheck do
    formula "python@3.10"
  end

  bottle do
    sha256 cellar: :any, arm64_ventura:  "daea00f0d9b71d4bbb907a6c4dac1dac9db202742e8ae3ed410a317e813b5b5e"
    sha256 cellar: :any, arm64_monterey: "1d19d48d0d73b857f08f05be298a947a38f58ea0238d34350d9051497586a0ec"
    sha256 cellar: :any, arm64_big_sur:  "8a217c67508f3ac5a3ef09697730730a61b81b27c9d46ec4004e53ca58be6e74"
    sha256 cellar: :any, ventura:        "298225670b560465a5f90d605559f47ae14635c6e5a8524c73ac364db514fa95"
    sha256 cellar: :any, monterey:       "65ca4f1766f5318a78ba9d3509bd9a04027b53d1e8c54a6ef603476cccc1cb3a"
    sha256 cellar: :any, big_sur:        "5077e2c4e630e10ba2fd9a9e7867ebf3923f7cde29693ba1b854cc654d604992"
    sha256               x86_64_linux:   "27ba1fb44bb618d124bd4526073b5d4e9e8271829c02c6551883b8cff7629fb9"
  end

  keg_only :versioned_formula

  depends_on "python@3.10"
  depends_on "tcl-tk"

  def python3
    "python3.10"
  end

  def install
    cd "Modules" do
      tcltk_version = Formula["tcl-tk"].any_installed_version.major_minor
      (Pathname.pwd/"setup.py").write <<~EOS
        from setuptools import setup, Extension

        setup(name="tkinter",
              description="#{desc}",
              version="#{version}",
              ext_modules = [
                Extension("_tkinter", ["_tkinter.c", "tkappinit.c"],
                          define_macros=[("WITH_APPINIT", 1)],
                          include_dirs=["#{Formula["tcl-tk"].opt_include}"],
                          libraries=["tcl#{tcltk_version}", "tk#{tcltk_version}"],
                          library_dirs=["#{Formula["tcl-tk"].opt_lib}"])
              ]
        )
      EOS
      system python3, *Language::Python.setup_install_args(libexec, python3),
                      "--install-lib=#{libexec}"
      rm_r Dir[libexec/"*.egg-info"]
    end
  end

  test do
    system python3, "-c", "import tkinter"

    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system python3, "-c", "import tkinter; root = tkinter.Tk()"
  end
end
