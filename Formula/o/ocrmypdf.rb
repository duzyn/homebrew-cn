class Ocrmypdf < Formula
  include Language::Python::Virtualenv

  desc "Adds an OCR text layer to scanned PDF files"
  homepage "https://ocrmypdf.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/9d/b0/fe7180c229089785fdf0093ceb827c63307d5a5b1f45e579ce22abb8dbb9/ocrmypdf-15.0.2.tar.gz"
  sha256 "138d34da16784bb1ccb1759fb44714c05b9c93a13d0be8fe76b8bae3b6a94f36"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2380ffc26fe7c1e0426a8e60368ec221f0de9921bd1d44bf7955c7aff8bad392"
    sha256 cellar: :any,                 arm64_ventura:  "841bf1d88f11dbcf39e2a450a1f397c78396d31b936697e804d7baf21d3f7ed1"
    sha256 cellar: :any,                 arm64_monterey: "297a8f287130db1516756c5b93b2b8822e1acdf1a35ddb73f7ef5fc3edf78bc2"
    sha256 cellar: :any,                 sonoma:         "275cca8e0b334344e7345ee220076a0cf9c2b7ca9f6ffdad712aa881ac81db42"
    sha256 cellar: :any,                 ventura:        "6bef4440e2e802763f1b889b890bb01b5cc38e49e06b4a1f8c1f627849e7080b"
    sha256 cellar: :any,                 monterey:       "bf12542248c0b625bd3f1507eecae0fca1a341d0c946e33a9cd11d5da2076eba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "79a5c91a945a18dfd656e1926dbd1ce2d9cdfc7913527a43dd427abf12ea0abb"
  end

  depends_on "cffi"
  depends_on "freetype"
  depends_on "ghostscript"
  depends_on "jbig2enc"
  depends_on "libpng"
  depends_on "pillow"
  depends_on "pngquant"
  depends_on "pybind11"
  depends_on "pycparser"
  depends_on "python-cryptography"
  depends_on "python-packaging"
  depends_on "python@3.11"
  depends_on "qpdf"
  depends_on "tesseract"
  depends_on "unpaper"

  uses_from_macos "libffi", since: :catalina
  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  fails_with gcc: "5"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/2a/53/cf0a48de1bdcf6ff6e1c9a023f5f523dfe303e4024f216feac64b6eb7f67/charset-normalizer-3.2.0.tar.gz"
    sha256 "3bb3d25a8e6c0aedd251753a79ae98a093c7e7b471faa3aa9a93a81431987ace"
  end

  resource "deprecation" do
    url "https://files.pythonhosted.org/packages/5a/d3/8ae2869247df154b64c1884d7346d412fed0c49df84db635aab2d1c40e62/deprecation-2.1.0.tar.gz"
    sha256 "72b3bde64e5d778694b0cf68178aed03d15e15477116add3fb773e581f9518ff"
  end

  resource "img2pdf" do
    url "https://files.pythonhosted.org/packages/95/b5/f933f482a811fb9a7b3707f60e28f2925fed84726e5a6283ba07fdd54f49/img2pdf-0.4.4.tar.gz"
    sha256 "8ec898a9646523fd3862b154f3f47cd52609c24cc3e2dc1fb5f0168f0cbe793c"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/30/39/7305428d1c4f28282a4f5bdbef24e0f905d351f34cf351ceb131f5cddf78/lxml-4.9.3.tar.gz"
    sha256 "48628bd53a426c9eb9bc066a923acaa0878d1e86129fd5359aee99285f4eed9c"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/38/71/3b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0/markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "pdfminer-six" do
    url "https://files.pythonhosted.org/packages/ac/6e/89c532d108e362cbaf76fdb972e7a5e85723c225f08e1646fb86878d4f7f/pdfminer.six-20221105.tar.gz"
    sha256 "8448ab7b939d18b64820478ecac5394f482d7a79f5f7eaa7703c6c959c175e1d"
  end

  resource "pikepdf" do
    url "https://files.pythonhosted.org/packages/0a/81/c29a09060c763b2a5479b64223f8c9f3565d73a5a35118c709295cf7b88b/pikepdf-8.4.1.tar.gz"
    sha256 "3f8b46875426a307585f64b97c1937c9d488982f832793387ee2836a594b8ddf"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/36/51/04defc761583568cae5fd533abda3d40164cbdcf22dee5b7126ffef68a40/pluggy-1.3.0.tar.gz"
    sha256 "cf61ae8f126ac6f7c451172cf30e3e43d3ca77615509771b3a984a0730651e12"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/d6/f7/4d461ddf9c2bcd6a4d7b2b139267ca32a69439387cc1f02a924ff8883825/Pygments-2.16.1.tar.gz"
    sha256 "1daff0494820c69bc8941e407aa20f577374ee88364ee10a98fdbe0aece96e29"
  end

  resource "reportlab" do
    url "https://files.pythonhosted.org/packages/10/ec/4a423a97e53399c05889cd12f789ab9175f2498c77b47cc006b6482b71c1/reportlab-4.0.5.tar.gz"
    sha256 "9c68f277736f585c5c9938755b826dd57c877fcaeb203e21cefea12b3b1db4f5"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/1d/d6/9773d48804d085962c4f522db96f6a9ea9bd2e0480b3959a929176d92f01/rich-13.5.3.tar.gz"
    sha256 "87b43e0543149efa1253f485cd845bb7ee54df16c9617b8a893650ab84b4acb6"
  end

  def install
    venv = virtualenv_create(libexec, "python3.11")
    resource("reportlab").stage do
      (Pathname.pwd/"local-setup.cfg").write <<~EOS
        [FREETYPE_PATHS]
        lib=#{Formula["freetype"].opt_lib}
        inc=#{Formula["freetype"].opt_include}
      EOS
      venv.pip_install Pathname.pwd
    end
    venv.pip_install resources.reject { |r| r.name == "reportlab" }
    venv.pip_install_and_link buildpath

    bash_completion.install "misc/completion/ocrmypdf.bash" => "ocrmypdf"
    fish_completion.install "misc/completion/ocrmypdf.fish"
  end

  test do
    system "#{bin}/ocrmypdf", "-f", "-q", "--deskew",
                              test_fixtures("test.pdf"), "ocr.pdf"
    assert_predicate testpath/"ocr.pdf", :exist?
  end
end
