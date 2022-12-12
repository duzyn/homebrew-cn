class Vale < Formula
  desc "Syntax-aware linter for prose"
  homepage "https://docs.errata.ai/"
  url "https://github.com/errata-ai/vale/archive/v2.21.3.tar.gz"
  sha256 "09a64bff873134d794888615af3131a441d6b3763bdcb76d45162587386026df"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c4f7eddb865e8647e9802c4af3477d115d53fc332bb13844138c71758b199351"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "428b5f125ca1c2968ff317c7d2af86dee7c26b5e8d22604148d09932e9f4cded"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3a3ab6390d6a2eeb7249a338f6138934563254e81f73abda11937b34f3254d32"
    sha256 cellar: :any_skip_relocation, ventura:        "f6a908333cad800846c322b9b74335effe1424c4b6a94d44533be11ba367aeef"
    sha256 cellar: :any_skip_relocation, monterey:       "d85bdf59c44f6804718952683bdb3d7011879c5d215e76b41c536d2da91cb2bc"
    sha256 cellar: :any_skip_relocation, big_sur:        "8bbf319ea8e6546650ab006595c5ef864d8bdab1ba1a435d6e593ea566ece81a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4de684a2919b07345bb809167c08a7a491494a9060edf050e9ececd8aba16c08"
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
