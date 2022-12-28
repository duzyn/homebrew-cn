class Inform6 < Formula
  desc "Design system for interactive fiction"
  homepage "https://inform-fiction.org/inform6.html"
  url "https://ifarchive.org/if-archive/infocom/compilers/inform6/source/inform-6.41-r2.tar.gz"
  version "6.41-r2"
  sha256 "a6043b2df82173474635dcbcccfe510cdb2e1ef24be8abb9a8b0e46cd8a5f6e0"
  license "Artistic-2.0"
  head "https://gitlab.com/DavidGriffith/inform6unix.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "27c5ab4616b8e363a4ac5f23697da66cb3524538e1ab87344a4adf3714ac20ca"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1b23f0804583534b513318f2815e0d75f0824ca203bc2572537afae617c75c19"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8e51f92d6c9268284a1288c6ab956bb64fb75e2f450ef4600963a73fee5af0f2"
    sha256 cellar: :any_skip_relocation, ventura:        "10e317ad4c970a853dd723e6386a7fb30e33f131f3c3f8c101b154921787ca47"
    sha256 cellar: :any_skip_relocation, monterey:       "e5777d8aa13b0d11aeee545fa8c333ed02e3b1e4095e93c5224849126211e240"
    sha256 cellar: :any_skip_relocation, big_sur:        "eaa7b6772af8973a21ccf5d956847930b74fd009ee71e3fa4feead7d69d51321"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5b442fafb251231f8aa097e81b9dd0146b41b139cda5242ceb2b11a538be1952"
  end

  resource "homebrew-test_resource" do
    url "https://inform-fiction.org/examples/Adventureland/Adventureland.inf"
    sha256 "3961388ff00b5dfd1ccc1bb0d2a5c01a44af99bdcf763868979fa43ba3393ae7"
  end

  # patch Makefile to make it portable
  # upstream PR ref, https://gitlab.com/DavidGriffith/inform6unix/-/merge_requests/24
  patch do
    url "https://gitlab.com/DavidGriffith/inform6unix/-/commit/ba179ca1.diff"
    sha256 "05b6027009d4f936c503ef25397c3f106d16c7dad3585e926f277dbbda54e893"
  end

  def install
    # Parallel install fails because of: https://gitlab.com/DavidGriffith/inform6unix/-/issues/26
    ENV.deparallelize
    system "make", "PREFIX=#{prefix}", "MAN_PREFIX=#{man}", "MANDIR=#{man1}", "install"
  end

  test do
    resource("homebrew-test_resource").stage do
      system "#{bin}/inform", "Adventureland.inf"
      assert_predicate Pathname.pwd/"Adventureland.z5", :exist?
    end
  end
end
