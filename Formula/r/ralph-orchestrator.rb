class RalphOrchestrator < Formula
  desc "Multi-agent orchestration framework for autonomous AI task completion"
  homepage "https://github.com/mikeyobrien/ralph-orchestrator"
  url "https://mirror.ghproxy.com/https://github.com/mikeyobrien/ralph-orchestrator/archive/refs/tags/v2.2.0.tar.gz"
  sha256 "576af276009cd02143a49799434fa32659494867f3222618a980b5b292c79976"
  license "MIT"
  head "https://github.com/mikeyobrien/ralph-orchestrator.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0653ebbb50acb06ae4ba88bbfbdc22f59baa04b038e0ef2e672c3f53a6e99c7a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "37bbd33151d96d9fb1fa5a971b82f1169632b00a9f94e86b6cdbfbf7259b18fc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "043bcb0fab71f9aad240af5dcacf91d7b687b06e62b5facf96833761f66ad232"
    sha256 cellar: :any_skip_relocation, sonoma:        "935c2a3045d2761fca84ea8f38122bea411c4c07323fe203465d6a6c4c011143"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "41e4b6a06dcc9f59fa57f7b6f77c7fdcef6d42edc2d6aa835eae20ed67f84675"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8fab56a82b18f54c1cabb9a29100e7e89f626a1a46849c95de8f6094e0c4c8b4"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/ralph-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ralph --version")

    system bin/"ralph", "init", "--backend", "claude"
    assert_path_exists testpath/"ralph.yml"
  end
end
