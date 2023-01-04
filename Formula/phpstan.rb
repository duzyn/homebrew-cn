class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://ghproxy.com/github.com/phpstan/phpstan/releases/download/1.9.6/phpstan.phar"
  sha256 "e92a272d3791ff8776da7cd14c404c43ae05ce6e9aea32b2b3748c522c77d3db"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7df40e93ec60fe5f0aff2b4eb170247fac37aab03c1b54ebb2fb388a3c09830c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7df40e93ec60fe5f0aff2b4eb170247fac37aab03c1b54ebb2fb388a3c09830c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7df40e93ec60fe5f0aff2b4eb170247fac37aab03c1b54ebb2fb388a3c09830c"
    sha256 cellar: :any_skip_relocation, ventura:        "dbb54b3d50c67c11250449232768b912ae55cf6b496a8e413f56cc1ce2920e05"
    sha256 cellar: :any_skip_relocation, monterey:       "dbb54b3d50c67c11250449232768b912ae55cf6b496a8e413f56cc1ce2920e05"
    sha256 cellar: :any_skip_relocation, big_sur:        "dbb54b3d50c67c11250449232768b912ae55cf6b496a8e413f56cc1ce2920e05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7df40e93ec60fe5f0aff2b4eb170247fac37aab03c1b54ebb2fb388a3c09830c"
  end

  depends_on "php" => :test

  # Keg-relocation breaks the formula when it replaces `/usr/local` with a non-default prefix
  on_macos do
    on_intel do
      pour_bottle? only_if: :default_prefix
    end
  end

  def install
    bin.install "phpstan.phar" => "phpstan"
  end

  test do
    (testpath/"src/autoload.php").write <<~EOS
      <?php
      spl_autoload_register(
          function($class) {
              static $classes = null;
              if ($classes === null) {
                  $classes = array(
                      'email' => '/Email.php'
                  );
              }
              $cn = strtolower($class);
              if (isset($classes[$cn])) {
                  require __DIR__ . $classes[$cn];
              }
          },
          true,
          false
      );
    EOS

    (testpath/"src/Email.php").write <<~EOS
      <?php
        declare(strict_types=1);

        final class Email
        {
            private string $email;

            private function __construct(string $email)
            {
                $this->ensureIsValidEmail($email);

                $this->email = $email;
            }

            public static function fromString(string $email): self
            {
                return new self($email);
            }

            public function __toString(): string
            {
                return $this->email;
            }

            private function ensureIsValidEmail(string $email): void
            {
                if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
                    throw new InvalidArgumentException(
                        sprintf(
                            '"%s" is not a valid email address',
                            $email
                        )
                    );
                }
            }
        }
    EOS
    assert_match(/^\n \[OK\] No errors/,
      shell_output("#{bin}/phpstan analyse --level max --autoload-file src/autoload.php src/Email.php"))
  end
end
