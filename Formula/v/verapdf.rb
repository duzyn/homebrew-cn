class Verapdf < Formula
  desc "Open-source industry-supported PDF/A validation"
  homepage "https://verapdf.org/home/"
  url "https://mirror.ghproxy.com/https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.25.126.tar.gz"
  sha256 "f2145bcd9f7f34a3037ed5f49dff832d47a3c871569f32ce7972a1f268075b28"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]
  head "https://github.com/veraPDF/veraPDF-apps.git", branch: "integration"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7987e7dfa259490c733a1fd4b47a320d1db3d3eda3e7bc8e7316d63dfd86910e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1b50fd537824d3686c3ae457c8a662f7657674e450ae982c75b30ca89157aa97"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6074644404326b5e693f5096887a64310d3934281427f99e28c741346ccc7456"
    sha256 cellar: :any_skip_relocation, sonoma:         "a33025879cc571c4740cfd7b5ce8882573a291c7ae84b845b841e9b1ff49f77f"
    sha256 cellar: :any_skip_relocation, ventura:        "430b2f0e93f02bf0a48866e20db9f63d3b60b1a4890e594bfd6e9adfe6a2eb57"
    sha256 cellar: :any_skip_relocation, monterey:       "886f872a4cba2012f140547b0cdd98b1afa88da79302522f6cdfd3a1e701e773"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4b889832d4be37bbbaee021978fe0414a10b011e18f27e0c3c3db2f518f1eabc"
  end

  depends_on "maven" => :build
  depends_on "openjdk@17"

  def install
    ENV["JAVA_HOME"] = Language::Java.java_home("17")
    system "mvn", "clean", "install"

    installer_file = Pathname.glob("installer/target/verapdf-izpack-installer-*.jar").first
    system "java", "-DINSTALL_PATH=#{libexec}", "-jar", installer_file, "-options-system"

    bin.install libexec/"verapdf", libexec/"verapdf-gui"
    bin.env_script_all_files libexec, Language::Java.overridable_java_home_env("17")
    prefix.install "tests"
  end

  test do
    with_env(VERAPDF: "#{bin}/verapdf", NO_CD: "1") do
      system prefix/"tests/exit-status.sh"
    end
  end
end
