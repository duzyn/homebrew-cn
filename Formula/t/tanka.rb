class Tanka < Formula
  desc "Flexible, reusable and concise configuration for Kubernetes using Jsonnet"
  homepage "https://tanka.dev"
  url "https://github.com/grafana/tanka.git",
      tag:      "v0.30.2",
      revision: "7ced3f94234b5cbdb2edd879abb8bea72f74ae00"
  license "Apache-2.0"
  head "https://github.com/grafana/tanka.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "97438ec530dbd4eec0301e7ede24d3018449096e7c48c4e10fd6d0577f10e215"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "97438ec530dbd4eec0301e7ede24d3018449096e7c48c4e10fd6d0577f10e215"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "97438ec530dbd4eec0301e7ede24d3018449096e7c48c4e10fd6d0577f10e215"
    sha256 cellar: :any_skip_relocation, sonoma:        "ba40fffe9c3e5b3c81bab7baaa5efd5551168a2bdb73cbffa07634e82a477c97"
    sha256 cellar: :any_skip_relocation, ventura:       "ba40fffe9c3e5b3c81bab7baaa5efd5551168a2bdb73cbffa07634e82a477c97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b462dcea20844e54f1f5f8ed449d69ed03480836c5e876fdec8e2eecfb58bdc7"
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli"

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
      -X github.com/grafana/tanka/pkg/tanka.CurrentVersion=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"tk"), "./cmd/tk"
  end

  test do
    system "git", "clone", "https://github.com/sh0rez/grafana.libsonnet"
    system bin/"tk", "show", "--dangerous-allow-redirect", "grafana.libsonnet/environments/default"
  end
end
