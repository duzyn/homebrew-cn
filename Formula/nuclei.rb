class Nuclei < Formula
  desc "HTTP/DNS scanner configurable via YAML templates"
  homepage "https://nuclei.projectdiscovery.io/"
  url "https://github.com/projectdiscovery/nuclei/archive/v2.8.6.tar.gz"
  sha256 "45127c8b0d9c716ab7cc03af76add98141b3d449bb2edbd7bf0c6d4b7f1e1b34"
  license "MIT"
  head "https://github.com/projectdiscovery/nuclei.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "637ecb34b181ca0068f83af01e220e170b473d09c0bd9d936a1a7f2d5afff9c3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7508899b91347df325007571dc3a2ea8cb6c6ab5dfe8481d48a9cfa22b6b1154"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "68f5f1eaa9e8ae59019404a651a7e67fdd9f4f912837f13524eac9d31ff0a05a"
    sha256 cellar: :any_skip_relocation, ventura:        "189385933c4b3be73f64473f35dbdcb2cb6ccabcbe43c496dfa102598e8cd851"
    sha256 cellar: :any_skip_relocation, monterey:       "2a19644f8b35fe32d664c0f4b73450722c944ec22d1f7301ef238f77a1189617"
    sha256 cellar: :any_skip_relocation, big_sur:        "d9e52cb601631326558cc3cf1df2246e61d0f310d1df9512d02b1c1004b26599"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d92d9c8eb9514eb4c75d2f8a15e8c8dcf6fa93f373e2ff238c03dbc766c26dbb"
  end

  depends_on "go" => :build

  def install
    cd "v2/cmd/nuclei" do
      system "go", "build", *std_go_args(ldflags: "-s -w"), "main.go"
    end
  end

  test do
    (testpath/"test.yaml").write <<~EOS
      id: homebrew-test

      info:
        name: Homebrew test
        author: bleepnetworks
        severity: INFO
        description: Check DNS functionality

      dns:
        - name: "{{FQDN}}"
          type: A
          class: inet
          recursion: true
          retries: 3
          matchers:
            - type: word
              words:
                - "IN\tA"
    EOS
    system "nuclei", "-target", "google.com", "-t", "test.yaml"
  end
end
