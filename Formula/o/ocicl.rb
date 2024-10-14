class Ocicl < Formula
  desc "OCI-based ASDF system distribution and management tool for Common Lisp"
  homepage "https://github.com/ocicl/ocicl"
  url "https://mirror.ghproxy.com/https://github.com/ocicl/ocicl/archive/refs/tags/v2.5.7.tar.gz"
  sha256 "86858146849bc2f945477459a83f1e1564e124460f4a72bb5a5ca702838dea8d"
  license "MIT"

  bottle do
    sha256 arm64_sequoia: "8aa3f6b2f8ade905abc0f449af36bf220cf06a6f6078436620e023e56e85b13d"
    sha256 arm64_sonoma:  "cebd4d085aa61628bc26f3bf74cd225213a5aa76ea9235c711e0930e30d311c5"
    sha256 arm64_ventura: "fe5f3fbc658c0519927988c0c8c1af858ba3512727f47ebca5087844d96238d7"
    sha256 sonoma:        "60f556664fc4ec4ea4379578931d0a321ba0e5bfc46b0d17705cfecc2591eb4f"
    sha256 ventura:       "dd6ba192eebe4bffd3c509e3a6f4e28cd99c29fc612aa772428c64d99b9b60c8"
    sha256 x86_64_linux:  "de0387d107d3aea81f11cf8844d96b47bbe19b47526dd561d2766e9258433036"
  end

  depends_on "sbcl"
  depends_on "zstd"

  def install
    mkdir_p [libexec, bin]

    # ocicl's setup.lisp generates an executable that is the binding
    # of the sbcl executable to the ocicl image core.  Unfortunately,
    # on Linux, homebrew somehow manipulates the resulting ELF file in
    # such a way that the sbcl part of the binary can't find the image
    # cores.  For this reason, we are generating our own image core as
    # a separate file and loading it at runtime.
    system "sbcl", "--dynamic-space-size", "3072", "--no-userinit",
           "--eval", "(load \"runtime/asdf.lisp\")", "--eval", <<~LISP
             (progn
               (asdf:initialize-source-registry
                 (list :source-registry
                       :inherit-configuration (list :tree (uiop:getcwd))))
               (asdf:load-system :ocicl)
               (asdf:clear-source-registry)
               (sb-ext:save-lisp-and-die "#{libexec}/ocicl.core"))
           LISP

    # Write a shell script to wrap ocicl
    (bin/"ocicl").write <<~EOS
      #!/usr/bin/env -S sbcl --core #{libexec}/ocicl.core --script
      (uiop:restore-image)
      (ocicl:main)
    EOS
  end

  test do
    system bin/"ocicl", "install", "chat"
    assert_predicate testpath/"systems.csv", :exist?

    version_files = testpath.glob("systems/cl-chat*/_00_OCICL_VERSION")
    assert_equal 1, version_files.length, "Expected exactly one _00_OCICL_VERSION file"

    (testpath/"init.lisp").write shell_output("#{bin}/ocicl setup")
    system "sbcl", "--non-interactive", "--load", "init.lisp",
           "--eval", "(progn (asdf:load-system :chat) (sb-ext:quit))"
  end
end
