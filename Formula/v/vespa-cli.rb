class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://mirror.ghproxy.com/https://github.com/vespa-engine/vespa/archive/refs/tags/v8.355.18.tar.gz"
  sha256 "50e1b7be7c8fde0ac7a1a49bb379598e492d729b7a6564f7162a6b368cd53919"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/\D*?(\d+(?:\.\d+)+)(?:-\d+)?/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "637e8966a32d3473d9da7a42e8c5a1982d6cb14d61e790574a5c5423d8cb2a9a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "47705f5a19dc58f052528815791f345e7c28bcb130ea2d47e3f69cf6aed4e63d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1e7eca34a0a3514135e32f8cb338e6c06ca881d447b7de5012a13d6f256475e7"
    sha256 cellar: :any_skip_relocation, sonoma:         "5503c64d2bc41a4d2261a4d1249cd11508fa1a5bc319eb33cd4e518b34d57102"
    sha256 cellar: :any_skip_relocation, ventura:        "8d2aa809e60c44fe0bc845538a48ee4064606dd1c1530a2d30979a4ef015ae54"
    sha256 cellar: :any_skip_relocation, monterey:       "a6f9b22c327bfea79526561d3192353f175d7374b391192c56b40798e6f28bbf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7d34189aaf709b24c5dd109555ae81d218c8a3de4d1bd1a9854b01fc559d0f6c"
  end

  depends_on "go" => :build

  def install
    cd "client/go" do
      with_env(VERSION: version.to_s, PREFIX: prefix.to_s) do
        system "make", "install", "manpages"
      end
      generate_completions_from_executable(bin/"vespa", "completion")
    end
  end

  test do
    ENV["VESPA_CLI_HOME"] = testpath
    assert_match "Vespa CLI version #{version}", shell_output("#{bin}/vespa version")
    doc_id = "id:mynamespace:music::a-head-full-of-dreams"
    output = shell_output("#{bin}/vespa document get #{doc_id} 2>&1", 1)
    assert_match "Error: deployment not converged", output
    system "#{bin}/vespa", "config", "set", "target", "cloud"
    assert_match "target = cloud", shell_output("#{bin}/vespa config get target")
  end
end
