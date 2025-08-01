class Tkdiff < Formula
  desc "Graphical side by side diff utility"
  homepage "https://tkdiff.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/tkdiff/tkdiff/6.0/tkdiff-6-0.zip?use_mirror=jaist"
  version "6.0"
  sha256 "4fa27c87846c1d6635da5beaa90ce4561638ee25a9169e455175afcf5288e453"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(%r{url=.*?/tkdiff/v?(\d+(?:\.\d+)+)/[^"]+?\.zip}i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e36f04c9c518b1d76ff97fab80dc92c59d158f9f83bdf6a87c17a98bbb20bba5"
  end

  # upstream bug report about running with system tcl-tk, https://sourceforge.net/p/tkdiff/bugs/98/
  depends_on "tcl-tk@8"

  def install
    bin.install "tkdiff"
    bin.env_script_all_files libexec, PATH: "#{Formula["tcl-tk@8"].opt_bin}:${PATH}"
  end

  test do
    # Fails with: no display name and no $DISPLAY environment variable on GitHub Actions
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"].present?

    system bin/"tkdiff", "--help"
  end
end
