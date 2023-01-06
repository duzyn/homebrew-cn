class Pluto < Formula
  desc "CLI tool to help discover deprecated apiVersions in Kubernetes"
  homepage "https://fairwinds.com"
  url "https://github.com/FairwindsOps/pluto/archive/v5.12.0.tar.gz"
  sha256 "18261d01d073110b30bd0a5699d9fbdbf618f330fc3ea57ef16fdf6eb6f0a34e"
  license "Apache-2.0"
  head "https://github.com/FairwindsOps/pluto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c345797209de8a911adde494b1406ee97395dee578727d7fd58cc042e525649f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7ad29027e657ea864117a656ab06671aa9df955895bd9076ba45159351f4a08e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0c19058d853421feb439af3edf4dc7e36e85ebaaa6124a3a9117572f5ca6cffa"
    sha256 cellar: :any_skip_relocation, ventura:        "f8af284e1980a03d293fdffc99c4654da6bc39ccb34820ea7d2889d906e51460"
    sha256 cellar: :any_skip_relocation, monterey:       "8bf59877e03b3e31c8ed636817c83d6d945a7f1519fc890bff1c210e9a952b0b"
    sha256 cellar: :any_skip_relocation, big_sur:        "29160dbf3eadcca42c10a8ebc666d8c843281cae22b2a4d060afe5efd789c068"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "35213e526e735da4ebc554e4515ea453e92b92025fee15c7151468ac5c2eba35"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags: ldflags), "cmd/pluto/main.go"
    generate_completions_from_executable(bin/"pluto", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pluto version")
    assert_match "Deployment", shell_output("#{bin}/pluto list-versions")

    (testpath/"deployment.yaml").write <<~EOS
      apiVersion: extensions/v1beta1
      kind: Deployment
      metadata:
        name: homebrew-test
      spec: {}
    EOS
    assert_match "homebrew-test", shell_output("#{bin}/pluto detect deployment.yaml")
  end
end
