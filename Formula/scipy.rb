class Scipy < Formula
  desc "Software for mathematics, science, and engineering"
  homepage "https://www.scipy.org"
  url "https://files.pythonhosted.org/packages/d6/bd/2d13a273d95f7b7d9903c906c486040b0aebb85e008f93a5dd0891f21f1f/scipy-1.10.0.tar.gz"
  sha256 "c8b3cbc636a87a89b770c6afc999baa6bcbb01691b5ccbbc1b1791c7c0a07540"
  license "BSD-3-Clause"
  head "https://github.com/scipy/scipy.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a8cca8494182a1eaeecc7d35b7944c6fcbe5f8632319d1460bb5273620d60c48"
    sha256 cellar: :any,                 arm64_monterey: "6e54e369b57e99cddd7305ee818408a9878e0b5160b870cb02095bd16b42e5ae"
    sha256 cellar: :any,                 arm64_big_sur:  "b7a08f2a0811da0fffb2b96a6bf5391816770867824765befe1fbd2352f59b47"
    sha256 cellar: :any,                 ventura:        "5a6ddba0640bae403908adb4d0619630cf9148b86f956dfa55a934962eaeb74c"
    sha256 cellar: :any,                 monterey:       "04202ac10975c9545b2acab246ddb258a60cec4683bd6b7f6ca47664b64fae4e"
    sha256 cellar: :any,                 big_sur:        "c5fb74fb1346d25ced9302b6294cff228cd1b9a57928cd5fbe16f92b7628f4c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c09025ec76ca4c3226b66235ce60db52a00032ce6c0ae43cba2231c1f469dc78"
  end

  depends_on "libcython" => :build
  depends_on "pythran" => :build
  depends_on "swig" => :build
  depends_on "gcc" # for gfortran
  depends_on "numpy"
  depends_on "openblas"
  depends_on "pybind11"
  depends_on "python@3.11"

  cxxstdlib_check :skip

  fails_with gcc: "5"

  def python3
    "python3.11"
  end

  def install
    openblas = Formula["openblas"]
    ENV["ATLAS"] = "None" # avoid linking against Accelerate.framework
    ENV["BLAS"] = ENV["LAPACK"] = openblas.opt_lib/shared_library("libopenblas")

    config = <<~EOS
      [DEFAULT]
      library_dirs = #{HOMEBREW_PREFIX}/lib
      include_dirs = #{HOMEBREW_PREFIX}/include
      [openblas]
      libraries = openblas
      library_dirs = #{openblas.opt_lib}
      include_dirs = #{openblas.opt_include}
    EOS

    Pathname("site.cfg").write config

    site_packages = Language::Python.site_packages(python3)
    ENV.prepend_path "PYTHONPATH", Formula["libcython"].opt_libexec/site_packages
    ENV.prepend_path "PYTHONPATH", Formula["pythran"].opt_libexec/site_packages
    ENV.prepend_path "PYTHONPATH", Formula["numpy"].opt_prefix/site_packages
    ENV.prepend_create_path "PYTHONPATH", site_packages

    system python3, "setup.py", "build", "--fcompiler=gfortran", "--parallel=#{ENV.make_jobs}"
    system python3, *Language::Python.setup_install_args(prefix, python3)
  end

  # cleanup leftover .pyc files from previous installs which can cause problems
  # see https://github.com/Homebrew/homebrew-python/issues/185#issuecomment-67534979
  def post_install
    rm_f Dir["#{HOMEBREW_PREFIX}/lib/python*.*/site-packages/scipy/**/*.pyc"]
  end

  test do
    (testpath/"test.py").write <<~EOS
      from scipy import special
      print(special.exp10(3))
    EOS
    assert_equal "1000.0", shell_output("#{python3} test.py").chomp
  end
end
