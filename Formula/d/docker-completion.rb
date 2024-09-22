class DockerCompletion < Formula
  desc "Bash, Zsh and Fish completion for Docker"
  homepage "https://www.docker.com/"
  url "https://mirror.ghproxy.com/https://github.com/docker/cli/archive/refs/tags/v27.3.0.tar.gz"
  sha256 "c2b42668f1877686e1139de9b0f694d53830bf3146f7897bc7134425a69945ba"
  license "Apache-2.0"
  head "https://github.com/docker/cli.git", branch: "master"

  livecheck do
    formula "docker"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "fe0ec67de9485fdefd78f368ec07b3a7253a5d0d85709acb8ab80faba5ae2cfd"
  end

  # These used to also be provided by the `docker` formula.
  link_overwrite "etc/bash_completion.d/docker"
  link_overwrite "share/fish/vendor_completions.d/docker.fish"
  link_overwrite "share/zsh/site-functions/_docker"

  def install
    bash_completion.install "contrib/completion/bash/docker"
    fish_completion.install "contrib/completion/fish/docker.fish"
    zsh_completion.install "contrib/completion/zsh/_docker"
  end

  test do
    assert_match "-F _docker",
      shell_output("bash -c 'source #{bash_completion}/docker && complete -p docker'")
  end
end
