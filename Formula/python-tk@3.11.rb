class PythonTkAT311 < Formula
  desc "Python interface to Tcl/Tk"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.11.1/Python-3.11.1.tgz"
  sha256 "baed518e26b337d4d8105679caf68c5c32630d702614fc174e98cb95c46bdfa4"
  license "Python-2.0"

  livecheck do
    formula "python@3.11"
  end

  bottle do
    sha256 cellar: :any, arm64_ventura:  "cedda31687b1f1182cdcb77aafd58c086ac0c5cc68e38afc9bb143576f12e400"
    sha256 cellar: :any, arm64_monterey: "066755d455f363bb825bdd250840082f87a16d66c1a9f416898da0fb65e07011"
    sha256 cellar: :any, arm64_big_sur:  "73fd264a3a733a188e4b37384f2a6ffc124d3211d7282128e350cf65b64ea2c3"
    sha256 cellar: :any, ventura:        "ccd264491fa691e08f2aa91dd6722de445d8e9b872a3e5fd0d9a301b846db007"
    sha256 cellar: :any, monterey:       "1311880c233f1768077885d1274fd504d89dbd0d3bb8ef7370a3676085ba9a3e"
    sha256 cellar: :any, big_sur:        "9ac6a3e1218095727c3b362bb34015c60164dce82704e96a64288ae9c97073b9"
    sha256               x86_64_linux:   "dc6a3e1253284f7823bb8dc3ff8a0d3542fc441eff0a549b7896edfba0423816"
  end

  depends_on "python@3.11"
  depends_on "tcl-tk"

  def python3
    "python3.11"
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
      rm_r libexec.glob("*.egg-info")
    end
  end

  test do
    system python3, "-c", "import tkinter"

    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system python3, "-c", "import tkinter; root = tkinter.Tk()"
  end
end
