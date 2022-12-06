class Acpica < Formula
  desc "OS-independent implementation of the ACPI specification"
  homepage "https://www.acpica.org/"
  url "https://acpica.org/sites/acpica/files/acpica-unix-20221020.tar_0.gz"
  # Work around invalid tarball extension (.tar_0.gz). Remove when fixed.
  version "20221020"
  sha256 "33a2e394aca0ca57d4018afe3da340dfad5eb45b1b9300e81dd595fda07cf1c5"
  license any_of: ["Intel-ACPI", "GPL-2.0-only", "BSD-3-Clause"]
  head "https://github.com/acpica/acpica.git", branch: "master"

  livecheck do
    url "https://acpica.org/downloads"
    regex(/href=.*?acpica-unix[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d8c97744dcd6f6b1be41c6b13a07b02c373f83bf1aa7d8852d96a2935a5c5330"
    sha256 cellar: :any_skip_relocation, ventura:       "36c5768c90757e49b87d58cb6068d1745a557c0741fc27c32df08fdd0254a949"
    sha256 cellar: :any_skip_relocation, monterey:      "0ada9f5afbb835d2ab0cf55ba23e07c286373ec6ed1b6fb46859cf510cfff49a"
    sha256 cellar: :any_skip_relocation, big_sur:       "27433e94ad72edf41984cfe6a665afa21f6f5ce997c3fdedf33c68eb864d785e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "87a339b361429ed66f9316dda49339bf70848c94d6038b22daf6585ee0123e10"
  end

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "m4" => :build

  def install
    # Work around invalid tarball extension (.tar_0.gz). Remove when fixed.
    system "tar", "--strip-components=1", "-xf", "acpica-unix-#{version}.tar_0"
    ENV.deparallelize
    system "make", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/acpihelp", "-u"
  end
end
