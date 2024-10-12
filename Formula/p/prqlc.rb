class Prqlc < Formula
  desc "Simple, powerful, pipelined SQL replacement"
  homepage "https://prql-lang.org"
  url "https://mirror.ghproxy.com/https://github.com/PRQL/prql/archive/refs/tags/0.13.1.tar.gz"
  sha256 "250821f11eca13ccce13c26d968643fbd64183c3f03591bd677e82a365c63e9b"
  license "Apache-2.0"
  head "https://github.com/prql/prql.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b4edf658d2288a22db947c75ad3a46154f8d3d117bf1ef7b4d29c53b8772e4ec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e6e649157c8e8bc60ab08b7b883ab8dc0a93d8928c3e2e46c3367b149897a96d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "095031b37f95204a0ecec0f1b698351b33481c3126aea06f64e40a797e829475"
    sha256 cellar: :any_skip_relocation, sonoma:        "895d6aa482aad3def2fb9aa635e2d545f4b145db1a76826b6345377e641139f4"
    sha256 cellar: :any_skip_relocation, ventura:       "c14255d1d25475700fc6b064444ea80d677b1d81b9d30344bc7c21bee8516f83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "474e748dae2a6e3687d529b5e17b2681567480a282744bed76855e13c8c50f6e"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "prqlc", *std_cargo_args(path: "prqlc/prqlc")
  end

  test do
    stdin = "from employees | filter has_dog | select salary"
    stdout = pipe_output("#{bin}/prqlc compile", stdin)
    assert_match "SELECT", stdout
  end
end
