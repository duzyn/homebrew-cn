class DockerGen < Formula
  desc "Generate files from docker container metadata"
  homepage "https://github.com/nginx-proxy/docker-gen"
  url "https://github.com/nginx-proxy/docker-gen/archive/0.9.2.tar.gz"
  sha256 "420e9fc402ef80c45514489b514d58d294bbe0bcacbf58cf02cbf8935f1e5050"
  license "MIT"
  head "https://github.com/nginx-proxy/docker-gen.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "687480484586bcdeceaea831d3d9efad648097c406bdd1408decc1c210e17807"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8eec25a10572744f81313146ef41ca2f661ca4ec53bf000c6c05bc8a0f1fb33c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f08e4c6c463822a323d15d0a7f23c9ac3255029c878031f99f46c5bfe6cde63c"
    sha256 cellar: :any_skip_relocation, ventura:        "15e975a15693a4d0f350e07b1a91c374015e21b4dde4c2538673fe232915efdc"
    sha256 cellar: :any_skip_relocation, monterey:       "6d0637a4ec30d491266f9e2b4e256b5cbde3d85a0d316ddf7ee57d889531af9c"
    sha256 cellar: :any_skip_relocation, big_sur:        "7b931d540487ce49d48853cd37cc453a032dd6fa77e188d65c9578adec9b4ccf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e1507eea265e53ad4611b0ee1146a6d87ee14f9fc00ae60e1c4bbd098fedea56"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.buildVersion=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/docker-gen"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/docker-gen --version")
  end
end
