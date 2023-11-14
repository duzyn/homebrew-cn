class Pymupdf < Formula
  desc "Python bindings for the PDF toolkit and renderer MuPDF"
  homepage "https://github.com/pymupdf/PyMuPDF"
  url "https://files.pythonhosted.org/packages/3a/75/743a7b990a56eaf4a870f0c6eb7ccd80a9ece040d56c89b851caba49cce0/PyMuPDF-1.23.6.tar.gz"
  sha256 "618b8e884190ac1cca9df1c637f87669d2d532d421d4ee7e4763c848dc4f3a1e"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2226a271abf94fe41e8a68a26fff0c65597bf2ecbb74e6e44269490e5c084145"
    sha256 cellar: :any,                 arm64_ventura:  "4a4b41618ad235e4b76a74931b75bc205beeb308034e1a752d9eedd0bf9de69e"
    sha256 cellar: :any,                 arm64_monterey: "28affaa5cb08e54001887c30e916025bfbdd097ce829e2a4c3aecd54830e8f2e"
    sha256 cellar: :any,                 sonoma:         "edba6e3eb02b41662ddd67de8e788cd2ba05e14b7b9daeb09a7c6ab41f92e0df"
    sha256 cellar: :any,                 ventura:        "8f2ee780f3433f80040406921b4f5f0133738b2e81da681451505413fb93c9d6"
    sha256 cellar: :any,                 monterey:       "80a2e8c5ca2632890df8bbe50243f5d940cce4dd644fccfd8a87f6418c3e6eea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "82e7bfb2805b78c6ac32e3c2c1125d0aa1e068cb3e4ff6e8d9f442eb5530ffaf"
  end

  depends_on "freetype" => :build
  depends_on "swig" => :build

  depends_on "mupdf"
  depends_on "python@3.11"

  on_linux do
    depends_on "gumbo-parser"
    depends_on "harfbuzz"
    depends_on "jbig2dec"
    depends_on "mujs"
    depends_on "openjpeg"
  end

  def python3
    "python3.11"
  end

  def install
    # Makes setup skip build stage for mupdf
    # https://github.com/pymupdf/PyMuPDF/blob/1.20.0/setup.py#L447
    ENV["PYMUPDF_SETUP_MUPDF_BUILD"] = ""
    # Builds only classic implementation
    # https://github.com/pymupdf/PyMuPDF/issues/2628
    ENV["PYMUPDF_SETUP_IMPLEMENTATIONS"] = "a"
    ENV["PYMUPDF_INCLUDES"] = "#{Formula["mupdf"].opt_include} -I#{Formula["freetype"].opt_include}/freetype2"
    ENV["PYMUPDF_MUPDF_LIB"] = Formula["mupdf"].opt_lib.to_s

    system python3, "-m", "pip", "install", *std_pip_args, "."
  end

  test do
    (testpath/"test.py").write <<~EOS
      import sys
      from pathlib import Path

      import fitz

      in_pdf = sys.argv[1]
      out_png = sys.argv[2]

      # Convert first page to PNG
      pdf_doc = fitz.open(in_pdf)
      pdf_page = pdf_doc.load_page(0)
      png_bytes = pdf_page.get_pixmap().tobytes()

      Path(out_png).write_bytes(png_bytes)
    EOS

    in_pdf = test_fixtures("test.pdf")
    out_png = testpath/"test.png"

    system python3, testpath/"test.py", in_pdf, out_png
    assert_predicate out_png, :exist?
  end
end
