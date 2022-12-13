class Buf < Formula
  desc "New way of working with Protocol Buffers"
  homepage "https://github.com/bufbuild/buf"
  url "https://github.com/bufbuild/buf/archive/refs/tags/v1.10.0.tar.gz"
  sha256 "0fb3f1796164f86912e83c2e16c5a5f13d92589969661b1dc6cd6ee7f3670b1d"
  license "Apache-2.0"
  head "https://github.com/bufbuild/buf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "310be695fa41a1ad649a34d1ba402cbce4a9d2fbb7d913cf65551543e2d7b81e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bf8bab964707233c4aebfd0bfcd145493d4a2eb56d9c82e5f090f1657e782216"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fcf6d75534eb032cda8ff1aa4b5018a90878da5e061bf80502b9ef0530251d22"
    sha256 cellar: :any_skip_relocation, ventura:        "ff2dc26c9c5ecb6d2436f5e9c3bf1f47f4959ab84847b7113fd1a8b34f5d2f71"
    sha256 cellar: :any_skip_relocation, monterey:       "d0d5f8d27acef1322715ffd32dfd5d8bda7e531c08d4c9b92da8b981d418945a"
    sha256 cellar: :any_skip_relocation, big_sur:        "b1dde6c3881493bd8b66ac3d8a09b69ace1ea91e6325a9e8f93e2f3ecbf7e982"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "88cd3665f7c65ac87adb341597f3a78b80eba7bacc5578e7981f1a7bd1abfee0"
  end

  depends_on "go" => :build

  def install
    %w[buf protoc-gen-buf-breaking protoc-gen-buf-lint].each do |name|
      system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/name), "./cmd/#{name}"
    end

    generate_completions_from_executable(bin/"buf", "completion")
    man1.mkpath
    system bin/"buf", "manpages", man1
  end

  test do
    (testpath/"invalidFileName.proto").write <<~EOS
      syntax = "proto3";
      package examplepb;
    EOS

    (testpath/"buf.yaml").write <<~EOS
      version: v1
      name: buf.build/bufbuild/buf
      lint:
        use:
          - DEFAULT
          - UNARY_RPC
      breaking:
        use:
          - FILE
        ignore_unstable_packages: true
    EOS

    expected = <<~EOS
      invalidFileName.proto:1:1:Filename "invalidFileName.proto" should be \
      lower_snake_case.proto, such as "invalid_file_name.proto".
      invalidFileName.proto:2:1:Files with package "examplepb" must be within \
      a directory "examplepb" relative to root but were in directory ".".
      invalidFileName.proto:2:1:Package name "examplepb" should be suffixed \
      with a correctly formed version, such as "examplepb.v1".
    EOS
    assert_equal expected, shell_output("#{bin}/buf lint invalidFileName.proto 2>&1", 100)

    assert_match version.to_s, shell_output("#{bin}/buf --version")
  end
end
