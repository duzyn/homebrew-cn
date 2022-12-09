class Ibazel < Formula
  desc "Tools for building Bazel targets when source files change"
  homepage "https://github.com/bazelbuild/bazel-watcher"
  url "https://github.com/bazelbuild/bazel-watcher/archive/refs/tags/v0.21.0.tar.gz"
  sha256 "c6413d3298c51d968bbbe8a01f481b83947e55eae6af78c0b8268a91e02d7989"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "589e6363b32a7b04d26c82ea20f0cf1c57bbbf8032a85184a51b10c099b73a8e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "96c2e05c6989413b925022963934672797bb1c2a6fd84c2094487b904d0178d0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c0ef0efb3f2ddd64c0ef4091de7fe73533e9426944b2966c3305dc961735542a"
    sha256 cellar: :any_skip_relocation, ventura:        "2eb34b4a29ec5bd9eea7dfec7edf6f6b2c93c23dc3fe4f83f67d57bbddfc1ddf"
    sha256 cellar: :any_skip_relocation, monterey:       "2eb34b4a29ec5bd9eea7dfec7edf6f6b2c93c23dc3fe4f83f67d57bbddfc1ddf"
    sha256 cellar: :any_skip_relocation, big_sur:        "baafd1ed952af966721f4982c9fc4cd746b1c3c7adfab0b0f49d94008570a1ca"
  end

  depends_on "bazel" => [:build, :test]
  depends_on "go" => [:build, :test]
  depends_on :macos

  def install
    system "bazel", "build", "--config=release", "--workspace_status_command", "echo STABLE_GIT_VERSION #{version}", "//cmd/ibazel:ibazel"
    bin.install "bazel-bin/cmd/ibazel/ibazel_/ibazel"
  end

  test do
    # Test building a sample Go program
    (testpath/"WORKSPACE").write <<~EOS
      load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

      http_archive(
        name = "io_bazel_rules_go",
        sha256 = "f2dcd210c7095febe54b804bb1cd3a58fe8435a909db2ec04e31542631cf715c",
        urls = [
            "https://mirror.bazel.build/ghproxy.com/github.com/bazelbuild/rules_go/releases/download/v0.31.0/rules_go-v0.31.0.zip",
            "https://ghproxy.com/github.com/bazelbuild/rules_go/releases/download/v0.31.0/rules_go-v0.31.0.zip",
        ],
      )

      load("@io_bazel_rules_go//go:deps.bzl", "go_host_sdk", "go_rules_dependencies")

      go_rules_dependencies()

      go_host_sdk(name = "go_sdk")
    EOS

    (testpath/"test.go").write <<~EOS
      package main
      import "fmt"
      func main() {
        fmt.Println("Hi!")
      }
    EOS

    (testpath/"BUILD").write <<~EOS
      load("@io_bazel_rules_go//go:def.bzl", "go_binary")

      go_binary(
        name = "bazel-test",
        srcs = glob(["*.go"])
      )
    EOS

    pid = fork { exec("ibazel", "build", "//:bazel-test") }
    out_file = "bazel-bin/bazel-test_/bazel-test"
    sleep 1 until File.exist?(out_file)
    assert_equal "Hi!\n", shell_output(out_file)
  ensure
    Process.kill("TERM", pid)
    sleep 1
    Process.kill("TERM", pid)
  end
end
