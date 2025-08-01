class Rolldice < Formula
  desc "Rolls an amount of virtual dice"
  homepage "https://github.com/sstrickl/rolldice"
  url "https://mirror.ghproxy.com/https://github.com/sstrickl/rolldice/archive/refs/tags/v1.16.tar.gz"
  sha256 "8bc82b26c418453ef0fe79b43a094641e7a76dae406032423a2f0fb270930775"
  license "GPL-2.0-only"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "f0b8ac560f934b0d4559fc18471a9fabba189ee9d41e050c03b88c6e56490054"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4d805d84d6f2e3083c040c4e3c650009d34516e949c351e1d85a5906faa2c017"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "adeb468985368ac97a5e5e16a8276ca39a7c87f9615dbab892298e74d3d0f018"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2fa79795244358b512e08fddb6cc86a27029ce8f14038130ab7fc33b84724f43"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1feb7522fecad653acb8a6d91152475486f1fa0f19107df1086c7674074a6870"
    sha256 cellar: :any_skip_relocation, sonoma:         "b241b74db5c976f271a7e32ce87054d1c74ac488e258bd0b152ccd173e544412"
    sha256 cellar: :any_skip_relocation, ventura:        "3f3fa0150cb26cb71c0df08c79226e1258e738eb6c3f965a491d3e649dbf2b4f"
    sha256 cellar: :any_skip_relocation, monterey:       "66ee3760def3920ddbeb564ed32f772fe12538c5db6124c7ebd56ef1a82eed97"
    sha256 cellar: :any_skip_relocation, big_sur:        "65289049d189acb12af84edb62fb1fb5b0e8faa55931176aa4430d4442e28cdb"
    sha256 cellar: :any_skip_relocation, catalina:       "a3fec25c1ccaf264a80a81f276aabf54cea670f3e88a48a40c7ffa9c7942bad4"
    sha256 cellar: :any_skip_relocation, mojave:         "eb32f285b1ba6a4ce42e22d4c636aac91f9f899e0a5e6355200f14d7f0ccc990"
    sha256 cellar: :any_skip_relocation, high_sierra:    "74364058c7f8859e71b5b43b80b40c01dd99ce6b80724ef4e97f9a9ea0587775"
    sha256 cellar: :any_skip_relocation, sierra:         "a7019dfc0a37c4cb814f8d116140b9fac999d6d97e6650e0806c02cb633087fb"
    sha256 cellar: :any_skip_relocation, el_capitan:     "3ee6afe89723d119075feffe735f4b4d4552d51bab5d79df6b8e100f90d21109"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "f9367e489792cd6941e69ab7633fc40c8b6c5c964dd02b0e6f90d592eef26656"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c528a9c75ae75ef5bf9c28db1b40cd8e30fee54029580bbd05c7b5cbc8449936"
  end

  on_linux do
    depends_on "readline"
  end

  # Submitted upstream at https://github.com/sstrickl/rolldice/pull/25
  # Remove if merged and included in a tagged release
  patch do
    url "https://github.com/sstrickl/rolldice/commit/5e53bade81d0fc972857889c1b690dcd830b439b.patch?full_index=1"
    sha256 "133214dcc8c8d8e4620205273c6c932cc0674e11717bf4b2fa432a205e825cc5"
  end

  def install
    system "make", "CC=#{ENV.cc}"
    bin.install "rolldice"
    man6.install Utils::Gzip.compress("rolldice.6")
  end

  test do
    assert_match "Roll #1", shell_output("#{bin}/rolldice -s 1x2d6")
  end
end
