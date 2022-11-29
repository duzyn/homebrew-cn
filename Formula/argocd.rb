class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.github.io/cd"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v2.5.3",
      revision: "0c7de210ae66bf631cc4f27ee1b5cdc0d04c1c96"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cb51a387c4b50ad89ce2f60a13b436582d31d4bdb0f09a83bc36f086341523da"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d672b4a49303184614757fc9045d86a33524c24a81fddceef09d439128c42c2c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "22733b36caba288bb95c8171930dd55af9368bc03dc78dec1e10be12f0e35f62"
    sha256 cellar: :any_skip_relocation, ventura:        "ac36b5728249c860e567c2dded479bef3c54a19731fd42de4df399c98ae4091c"
    sha256 cellar: :any_skip_relocation, monterey:       "55365964748866bb98e4c3882b8b5e6ef3880dbd976c80fc8e4eb36e05faf5ae"
    sha256 cellar: :any_skip_relocation, big_sur:        "0bfb22fc8a35bc7a507c4ddfb6098a24c8e5e1b87095a4ee0787808016c8e15b"
    sha256 cellar: :any_skip_relocation, catalina:       "808427f3133c0dd979bfecc38ecb931f0411078cfb71e279553e7c1ec5f99d88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "09465b0eeaa1895291325350ebeeaad478b194383526dc5fccd81c323cd5f645"
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
