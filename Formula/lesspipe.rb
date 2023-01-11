class Lesspipe < Formula
  desc "Input filter for the pager less"
  homepage "https://www-zeuthen.desy.de/~friebel/unix/lesspipe.html"
  url "https://github.com/wofr06/lesspipe/archive/v2.07.tar.gz"
  sha256 "b6a591c053057c3968d0d1fbd32e4a0a8026cd5c27e861023e3542772eda1cba"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eab7ed95d12d5b9ccf4f2600e41ec76f771cf6efbce668e1be80497366029a1f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eab7ed95d12d5b9ccf4f2600e41ec76f771cf6efbce668e1be80497366029a1f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eab7ed95d12d5b9ccf4f2600e41ec76f771cf6efbce668e1be80497366029a1f"
    sha256 cellar: :any_skip_relocation, ventura:        "eab7ed95d12d5b9ccf4f2600e41ec76f771cf6efbce668e1be80497366029a1f"
    sha256 cellar: :any_skip_relocation, monterey:       "eab7ed95d12d5b9ccf4f2600e41ec76f771cf6efbce668e1be80497366029a1f"
    sha256 cellar: :any_skip_relocation, big_sur:        "eab7ed95d12d5b9ccf4f2600e41ec76f771cf6efbce668e1be80497366029a1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5569b10632037ead5f2f19b5c8b6328bbbac744dfe523da1cadfbd760ebe22ab"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    man1.mkpath
    system "make", "install"
  end

  def caveats
    <<~EOS
      Append the following to your #{shell_profile}:
      export LESSOPEN="|#{HOMEBREW_PREFIX}/bin/lesspipe.sh %s"
    EOS
  end

  test do
    touch "file1.txt"
    touch "file2.txt"
    system "tar", "-cvzf", "homebrew.tar.gz", "file1.txt", "file2.txt"

    assert_predicate testpath/"homebrew.tar.gz", :exist?
    assert_match "file2.txt", pipe_output(bin/"archive_color", shell_output("tar -tvzf homebrew.tar.gz"))
  end
end
