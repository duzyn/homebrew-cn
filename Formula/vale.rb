class Vale < Formula
  desc "Syntax-aware linter for prose"
  homepage "https://docs.errata.ai/"
  url "https://github.com/errata-ai/vale/archive/v2.22.0.tar.gz"
  sha256 "6b0ef559979c60f2bf7d7ac0e73ce1402208a05d0ea33987eb2dca5727db9aa7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cb6f2b9a4ab29bebce11b7a2a1dcd10363404441f4401fbe8ecae200f0504c6e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7258d1de3f83f2ce6aa1e52822daf77eba1f0dfca8a6246588e168551f38a22f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ed88f8e31d5c523bd25838c1bcbcd4191001b608f49f733847cdb2101cc9d7be"
    sha256 cellar: :any_skip_relocation, ventura:        "f5355a459ede4ed15ca8664c352bbe469e3a7488531b643bd9be3e054a8ab901"
    sha256 cellar: :any_skip_relocation, monterey:       "8cb3e63d8b9aa0389f81511c4cdfb341cce0a2d2cef2b6f27a351fc45f505bc1"
    sha256 cellar: :any_skip_relocation, big_sur:        "44ac720724d32eafc07a541fb8edfcafb9e26c3ef77717a146c453df33bb253a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6f7aac46aa634a5d206785bf195db68e588b4d221c9dd5f67832a4bf6d5b7595"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X main.version=#{version} -s -w"
    system "go", "build", *std_go_args, "-ldflags=#{ldflags}", "./cmd/vale"
  end

  test do
    mkdir_p "styles/demo"
    (testpath/"styles/demo/HeadingStartsWithCapital.yml").write <<~EOS
      extends: capitalization
      message: "'%s' should be in title case"
      level: warning
      scope: heading.h1
      match: $title
    EOS

    (testpath/"vale.ini").write <<~EOS
      StylesPath = styles
      [*.md]
      BasedOnStyles = demo
    EOS

    (testpath/"document.md").write("# heading is not capitalized")

    output = shell_output("#{bin}/vale --config=#{testpath}/vale.ini #{testpath}/document.md 2>&1")
    assert_match(/✖ .*0 errors.*, .*1 warning.* and .*0 suggestions.* in 1 file\./, output)
  end
end
