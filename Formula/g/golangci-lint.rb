class GolangciLint < Formula
  desc "Fast linters runner for Go"
  homepage "https://golangci-lint.run/"
  url "https://github.com/golangci/golangci-lint.git",
      tag:      "v2.3.1",
      revision: "5256574b81bcedfbcae9099f745f6aee9335da10"
  license "GPL-3.0-only"
  revision 1
  head "https://github.com/golangci/golangci-lint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d488b703e57f539550047b81367e81b96108da09ab1e665147fd4cf269fbc2d8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5a7f856bac75a5c47950834c090d0a6a545657f02cfa127f61d32b0ea7d10cc8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a9c7beb3ff1f3e92a961ab294f5ad153c05c8d6ce3a84ce69f26a88dd9d24b0d"
    sha256 cellar: :any_skip_relocation, sonoma:        "8ff8635826201371657db74b86753caac5e0c4e2357992c8333df651d2346f86"
    sha256 cellar: :any_skip_relocation, ventura:       "1cee317bd3af0af2ff4a9bef9671bc958d7cb6094d1f673ee3eb0e43750ebed9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "57193b6735d93660871adcf92bd746d168fd1c70c498bfdf7d0906cfa93f3c54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2bb8cf6c09b853a71c4405c3248c139590dcdfa0964d8ea9041cc30d4e486963"
  end

  depends_on "go"

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_short_head(length: 7)}
      -X main.date=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/golangci-lint"

    generate_completions_from_executable(bin/"golangci-lint", "completion")
  end

  test do
    str_version = shell_output("#{bin}/golangci-lint --version")
    assert_match(/golangci-lint has version #{version} built with go(.*) from/, str_version)

    str_help = shell_output("#{bin}/golangci-lint --help")
    str_default = shell_output(bin/"golangci-lint")
    assert_equal str_default, str_help
    assert_match "Usage:", str_help
    assert_match "Available Commands:", str_help

    (testpath/"try.go").write <<~GO
      package try

      func add(nums ...int) (res int) {
        for _, n := range nums {
          res += n
        }
        clear(nums)
        return
      }
    GO

    args = %w[
      --color=never
      --default=none
      --issues-exit-code=0
      --output.text.print-issued-lines=false
      --enable=unused
    ].join(" ")

    ok_test = shell_output("#{bin}/golangci-lint run #{args} #{testpath}/try.go")
    expected_message = "try.go:3:6: func add is unused (unused)"
    assert_match expected_message, ok_test
  end
end
