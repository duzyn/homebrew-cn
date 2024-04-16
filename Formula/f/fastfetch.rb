class Fastfetch < Formula
  desc "Like neofetch, but much faster because written mostly in C"
  homepage "https://github.com/fastfetch-cli/fastfetch"
  url "https://mirror.ghproxy.com/https://github.com/fastfetch-cli/fastfetch/archive/refs/tags/2.9.2.tar.gz"
  sha256 "3ca9e48ed30c49fc50d5f64a2ce327a9f00ce4497feac01865c50086cc43e5ce"
  license "MIT"
  head "https://github.com/fastfetch-cli/fastfetch.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sonoma:   "7d4da5b81c9fef1737f3fd6bab960626f9ed241b014a14a6cb785bf5dfcb8660"
    sha256 arm64_ventura:  "bed3da79559f7aa9f1d0bd0d0c9c7147553932a3199f6499851fd2a365624feb"
    sha256 arm64_monterey: "dac19dcf723ec8e707bf669f67d661bb44d64f7beb8c450985325a4a39ba0093"
    sha256 sonoma:         "f44fef7f18177473ab159a8beffa4cb59b8109540419f454874a3915ba93b9b2"
    sha256 ventura:        "2a7a666a2b2a79c6bcca8bafa3a08fced8b95e7a5a394fa8fdfe24d09b06d70d"
    sha256 monterey:       "3894d90e4f25b90d81f9e5c57969b79dd4d1345320b780f1790cd628344fc49a"
    sha256 x86_64_linux:   "775f4dd673e23b85dc5d175e6a0ec35ca3006883df4db0d6102b2e501828eb5f"
  end

  depends_on "chafa" => :build
  depends_on "cmake" => :build
  depends_on "glib" => :build
  depends_on "imagemagick" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.12" => :build
  depends_on "vulkan-loader" => :build

  uses_from_macos "sqlite" => :build
  uses_from_macos "zlib" => :build

  on_linux do
    depends_on "dbus" => :build
    depends_on "ddcutil" => :build
    depends_on "libdrm" => :build
    depends_on "libx11" => :build
    depends_on "libxcb" => :build
    depends_on "libxrandr" => :build
    depends_on "mesa" => :build
    depends_on "opencl-icd-loader" => :build
    depends_on "pciutils" => :build
    depends_on "pulseaudio" => :build
    depends_on "rpm" => :build
    depends_on "wayland" => :build
  end

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_INSTALL_SYSCONFDIR=#{etc}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    bash_completion.install share/"bash-completion/completions/fastfetch"
  end

  test do
    assert_match "fastfetch", shell_output("#{bin}/fastfetch --version")
    assert_match "OS", shell_output("#{bin}/fastfetch --structure OS --pipe")
  end
end
