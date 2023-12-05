class SshVault < Formula
  desc "Encrypt/decrypt using SSH keys"
  homepage "https://ssh-vault.com/"
  url "https://mirror.ghproxy.com/https://github.com/ssh-vault/ssh-vault/archive/refs/tags/1.0.8.tar.gz"
  sha256 "1f9435fcb086b596ce17bc6db07fc7e616d9a4a4063562bdce95c6fd2d1cecd3"
  license "BSD-3-Clause"
  head "https://github.com/ssh-vault/ssh-vault.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "68601d7005a78b808b1950281612935c0fb89fb8bc230c9e57ad0e4286f5c2c3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ac14574ed486612f0801db517d764e7d4c7fc2b49612d7095c8edcdbf415d979"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "26318ea93f6d3ad1d781fc6af119737dfa332910924343253ec87d1c98d6d067"
    sha256 cellar: :any_skip_relocation, sonoma:         "ad75da060d9e54bb61ca7a2f358d9b8b2e05f1c648849023b5f62a3c38214848"
    sha256 cellar: :any_skip_relocation, ventura:        "5a22ec2da2ade28b1838dbd9171c7d3dd4f9cc1bf83eb3c73e4a037c75067051"
    sha256 cellar: :any_skip_relocation, monterey:       "8330456fcd9ecee340f80e205ad8e5059670426beccae74c03614fb9c4ec6e91"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6c2e7d218288069ef604c8ec7d0272ed0dd8ff8a80d71f284424eaf51c55a015"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
  end

  def check_binary_linkage(binary, library)
    binary.dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == File.realpath(library)
    end
  end

  test do
    test_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINixf2m2nj8TDeazbWuemUY8ZHNg7znA7hVPN8TJLr2W"
    (testpath/"public_key").write test_key
    cmd = "#{bin}/ssh-vault f -k  #{testpath}/public_key"
    assert_match "SHA256:hgIL5fEHz5zuOWY1CDlUuotdaUl4MvYG7vAgE4q4TzM", shell_output(cmd)

    if OS.linux?
      [
        Formula["openssl@3"].opt_lib/shared_library("libssl"),
        Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
      ].each do |library|
        assert check_binary_linkage(bin/"ssh-vault", library),
              "No linkage with #{library.basename}! Cargo is likely using a vendored version."
      end
    end
  end
end
