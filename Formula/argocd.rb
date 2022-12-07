class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.github.io/cd"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v2.5.4",
      revision: "86b2dde8e4bf1187acd2b4294e94451cd104dad8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "154c6ffd1bc90c39e296d013a8183306b0f07e54e731f354c946394cea62ede2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "55e6055c372338fddbe3b2d579462a5f66183092c4bffddca1ceab2794a725cb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "352d92a7ad47945466371d0435041ab9a64952fc4268798feac9122e336295c5"
    sha256 cellar: :any_skip_relocation, ventura:        "dc702e14f1298d2f485ea74830c8685cc3601146a10deb11fdd647a00c46a836"
    sha256 cellar: :any_skip_relocation, monterey:       "e93edb74809557b76e8b7d6e2dc97c66ddefe24e545001b4302de46ea02aede6"
    sha256 cellar: :any_skip_relocation, big_sur:        "509c8e1df85461c892631aade8b19618f33c874edfe016c18aecd48bc4a9e12c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a8384f987840c2762cc81dbdcf1e683b7716a8aa271d5c49764dcc2f858f9ea2"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "yarn" => :build

  def install
    system "make", "dep-ui-local"
    with_env(
      NODE_ENV:        "production",
      NODE_ONLINE_ENV: "online",
    ) do
      system "yarn", "--cwd", "ui", "build"
    end
    system "make", "cli-local"
    bin.install "dist/argocd"

    generate_completions_from_executable(bin/"argocd", "completion", shells: [:bash, :zsh])
  end

  test do
    assert_match "argocd controls a Argo CD server",
      shell_output("#{bin}/argocd --help")

    # Providing argocd with an empty config file returns the contexts table header
    touch testpath/"argocd-config"
    (testpath/"argocd-config").chmod 0600
    assert_match "CURRENT  NAME  SERVER\n",
      shell_output("#{bin}/argocd context --config ./argocd-config")
  end
end
