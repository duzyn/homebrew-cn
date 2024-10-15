class Ocicl < Formula
  desc "OCI-based ASDF system distribution and management tool for Common Lisp"
  homepage "https://github.com/ocicl/ocicl"
  url "https://mirror.ghproxy.com/https://github.com/ocicl/ocicl/archive/refs/tags/v2.5.8.tar.gz"
  sha256 "4a888dda7428e0fe0833d640da6d738ed46bfedc8be5a5b9488303df1747f433"
  license "MIT"

  bottle do
    sha256 arm64_sequoia: "32d3605fd09324659d8f3cc380b5e98bab4765ad0bebf1dc0197debeec545412"
    sha256 arm64_sonoma:  "20fe6b21b02047ed5086f2c8132e72295640fc2e4237a600406610b228e84194"
    sha256 arm64_ventura: "ad522f30cb8c8d04c001793ae57932174f5fd6854efd86edbaa3d871d129c927"
    sha256 sonoma:        "70f9b8fa3c23f4517a338d19a0c8ea43b889725a56264e572680cf8ef4dd5601"
    sha256 ventura:       "8e9daf240555fbcc41859cf761ee6e78dace1e4787baf4973755b1684f35e28c"
    sha256 x86_64_linux:  "ed6544a9e276bef1e90b3282ac6a8c3b96f22bb1b1aeaa02e73450c0fba0a561"
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
