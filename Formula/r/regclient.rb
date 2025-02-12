class Regclient < Formula
  desc "Docker and OCI Registry Client in Go and tooling using those libraries"
  homepage "https://github.com/regclient/regclient"
  url "https://mirror.ghproxy.com/https://github.com/regclient/regclient/archive/refs/tags/v0.8.1.tar.gz"
  sha256 "44dabd31997bd6cc4ea7414ea52971e1a85b8db5dc07538a99b2f3aa524820cd"
  license "Apache-2.0"
  head "https://github.com/regclient/regclient.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "09f9a3c525838fdf581e7c7f14ada380c5f590bad457b42b57f743e4da5e832b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "09f9a3c525838fdf581e7c7f14ada380c5f590bad457b42b57f743e4da5e832b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "09f9a3c525838fdf581e7c7f14ada380c5f590bad457b42b57f743e4da5e832b"
    sha256 cellar: :any_skip_relocation, sonoma:        "929dfd05d195b8cef5c422ea321ec83d0addcfba789a5a7252fa186d941275a2"
    sha256 cellar: :any_skip_relocation, ventura:       "929dfd05d195b8cef5c422ea321ec83d0addcfba789a5a7252fa186d941275a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3db260b11f8444eae9fd4e6301fdcda382ac7b208e31ff0ee54438f6d11163eb"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/regclient/regclient/internal/version.vcsTag=#{version}"
    ["regbot", "regctl", "regsync"].each do |f|
      system "go", "build", *std_go_args(ldflags:, output: bin/f), "./cmd/#{f}"

      generate_completions_from_executable(bin/f, "completion")
    end
  end

  test do
    output = shell_output("#{bin}/regctl image manifest docker.io/library/alpine:latest")
    assert_match "docker.io/library/alpine:latest", output

    assert_match version.to_s, shell_output("#{bin}/regbot version")
    assert_match version.to_s, shell_output("#{bin}/regctl version")
    assert_match version.to_s, shell_output("#{bin}/regsync version")
  end
end
