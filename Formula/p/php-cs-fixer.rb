class PhpCsFixer < Formula
  desc "Tool to automatically fix PHP coding standards issues"
  homepage "https://cs.symfony.com/"
  url "https://mirror.ghproxy.com/https://github.com/PHP-CS-Fixer/PHP-CS-Fixer/releases/download/v3.40.1/php-cs-fixer.phar"
  sha256 "957908474c688cce2d3b74bb2deb7c883143727d37c7066122c7431830256c9a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0420d44ac9cd535a6bbb81bd3d633fe6278635d949da434871008d0bfccc2c13"
  end

  depends_on "php"

  def install
    libexec.install "php-cs-fixer.phar"

    (bin/"php-cs-fixer").write <<~EOS
      #!#{Formula["php"].opt_bin}/php
      <?php require '#{libexec}/php-cs-fixer.phar';
    EOS
  end

  test do
    (testpath/"test.php").write <<~EOS
      <?php $this->foo(   'homebrew rox'   );
    EOS
    (testpath/"correct_test.php").write <<~EOS
      <?php

      $this->foo('homebrew rox');
    EOS

    system bin/"php-cs-fixer", "fix", "test.php"
    assert compare_file("test.php", "correct_test.php")
  end
end
