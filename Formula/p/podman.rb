class Podman < Formula
  desc "Tool for managing OCI containers and pods"
  homepage "https://podman.io/"
  url "https://github.com/containers/podman.git",
      tag:      "v5.1.1",
      revision: "bda6eb03dcbcf12a5b7ae004c1240e38dd056d24"
  license all_of: ["Apache-2.0", "GPL-3.0-or-later"]
  head "https://github.com/containers/podman.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c60760645cffd8ea604f5e476467580af5cdb4b201f1e0b45f34187a5348f9b2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4f8232393f049730f19c9f0dc5a69e129a1c5c6381ac606bc94687a99c0eb33c"
    sha256 cellar: :any_skip_relocation, sonoma:        "e5437c2ce96d2e36849ddeb399da3ad0a2929a8ffcb8205049b523e27fd7cb9e"
    sha256 cellar: :any_skip_relocation, ventura:       "4ac1fcecbced15059968d258d115c6e1988841c1c310d5d206de85bcd855e50b"
    sha256                               x86_64_linux:  "a6b749743bcf6285f5c39c70b02cda498f34fee8e02609b0b1a2dfbaf9519989"
  end

  depends_on "go" => :build
  depends_on "go-md2man" => :build
  depends_on macos: :ventura # see discussions in https://github.com/containers/podman/issues/22121
  uses_from_macos "python" => :build

  on_macos do
    depends_on "make" => :build
  end

  on_linux do
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "pkg-config" => :build
    depends_on "protobuf" => :build
    depends_on "rust" => :build
    depends_on "conmon"
    depends_on "crun"
    depends_on "fuse-overlayfs"
    depends_on "gpgme"
    depends_on "libseccomp"
    depends_on "slirp4netns"
    depends_on "systemd"
  end

  resource "gvproxy" do
    on_macos do
      url "https://mirror.ghproxy.com/https://github.com/containers/gvisor-tap-vsock/archive/refs/tags/v0.7.3.tar.gz"
      sha256 "851ed29b92e15094d8eba91492b6d7bab74aff4538dae0c973eb7d8ff48afd8a"
    end
  end

  resource "vfkit" do
    on_macos do
      url "https://mirror.ghproxy.com/https://github.com/crc-org/vfkit/archive/refs/tags/v0.5.1.tar.gz"
      sha256 "0825d5efabc5ec8817d2ed89f18717b2b4fa5be804b0f2ccc891b4a23b64d771"
    end
  end

  resource "catatonit" do
    on_linux do
      url "https://mirror.ghproxy.com/https://github.com/openSUSE/catatonit/archive/refs/tags/v0.2.0.tar.gz"
      sha256 "d0cf1feffdc89c9fb52af20fc10127887a408bbd99e0424558d182b310a3dc92"
    end
  end

  resource "netavark" do
    on_linux do
      url "https://mirror.ghproxy.com/https://github.com/containers/netavark/archive/refs/tags/v1.11.0.tar.gz"
      sha256 "5b96e5a00a41a550d716f1e5c180df6e0ee5b0ce20961827ef17aff3d6a92f9c"
    end
  end

  resource "aardvark-dns" do
    on_linux do
      url "https://mirror.ghproxy.com/https://github.com/containers/aardvark-dns/archive/refs/tags/v1.11.0.tar.gz"
      sha256 "3e95b363f89a945ee6e63f51051f9eb982bdc469bf8e727b5d7adca676789750"
    end
  end

  def install
    if OS.mac?
      ENV["CGO_ENABLED"] = "1"

      system "gmake", "podman-remote"
      bin.install "bin/darwin/podman" => "podman-remote"
      bin.install_symlink bin/"podman-remote" => "podman"

      system "gmake", "podman-mac-helper"
      bin.install "bin/darwin/podman-mac-helper" => "podman-mac-helper"

      resource("gvproxy").stage do
        system "gmake", "gvproxy"
        (libexec/"podman").install "bin/gvproxy"
      end

      resource("vfkit").stage do
        ENV["CGO_ENABLED"] = "1"
        ENV["CGO_CFLAGS"] = "-mmacosx-version-min=11.0"
        ENV["GOOS"]="darwin"
        arch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s
        system "gmake", "out/vfkit-#{arch}"
        (libexec/"podman").install "out/vfkit-#{arch}" => "vfkit"
      end

      system "gmake", "podman-remote-darwin-docs"
      man1.install Dir["docs/build/remote/darwin/*.1"]

      bash_completion.install "completions/bash/podman"
      zsh_completion.install "completions/zsh/_podman"
      fish_completion.install "completions/fish/podman.fish"
    else
      paths = Dir["**/*.go"].select do |file|
        (buildpath/file).read.lines.grep(%r{/etc/containers/}).any?
      end
      inreplace paths, "/etc/containers/", etc/"containers/"

      ENV.O0
      ENV["PREFIX"] = prefix
      ENV["HELPER_BINARIES_DIR"] = opt_libexec/"podman"

      system "make"
      system "make", "install", "install.completions"

      (prefix/"etc/containers/policy.json").write <<~EOS
        {"default":[{"type":"insecureAcceptAnything"}]}
      EOS

      (prefix/"etc/containers/storage.conf").write <<~EOS
        [storage]
        driver="overlay"
      EOS

      (prefix/"etc/containers/registries.conf").write <<~EOS
        unqualified-search-registries=["docker.io"]
      EOS

      resource("catatonit").stage do
        system "./autogen.sh"
        system "./configure"
        system "make"
        mv "catatonit", libexec/"podman/"
      end

      resource("netavark").stage do
        system "make"
        mv "bin/netavark", libexec/"podman/"
      end

      resource("aardvark-dns").stage do
        system "make"
        mv "bin/aardvark-dns", libexec/"podman/"
      end
    end
  end

  def caveats
    on_linux do
      <<~EOS
        You need "newuidmap" and "newgidmap" binaries installed system-wide
        for rootless containers to work properly.
      EOS
    end
    on_macos do
      <<-EOS
        In order to run containers locally, podman depends on a Linux kernel.
        One can be started manually using `podman machine` from this package.
        To start a podman VM automatically at login, also install the cask
        "podman-desktop".
      EOS
    end
  end

  service do
    run linux: [opt_bin/"podman", "system", "service", "--time=0"]
    environment_variables PATH: std_service_path_env
    working_dir HOMEBREW_PREFIX
  end

  test do
    assert_match "podman-remote version #{version}", shell_output("#{bin}/podman-remote -v")
    out = shell_output("#{bin}/podman-remote info 2>&1", 125)
    assert_match "Cannot connect to Podman", out

    if OS.mac?
      # This test will fail if VM images are not built yet. Re-run after VM images are built if this is the case
      # See https://github.com/Homebrew/homebrew-core/pull/166471
      out = shell_output("#{bin}/podman-remote machine init homebrew-testvm")
      assert_match "Machine init complete", out
      system bin/"podman-remote", "machine", "rm", "-f", "homebrew-testvm"
    else
      assert_equal %W[
        #{bin}/podman
        #{bin}/podman-remote
        #{bin}/podmansh
      ].sort, Dir[bin/"*"]
      assert_equal %W[
        #{libexec}/podman/catatonit
        #{libexec}/podman/netavark
        #{libexec}/podman/aardvark-dns
        #{libexec}/podman/quadlet
        #{libexec}/podman/rootlessport
      ].sort, Dir[libexec/"podman/*"]
      out = shell_output("file #{libexec}/podman/catatonit")
      assert_match "statically linked", out
    end
  end
end
