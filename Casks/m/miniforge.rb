cask "miniforge" do
  arch arm: "arm64", intel: "x86_64"

  version "24.11.0-0"
  sha256 arm:   "3c7c115de0ed6103b7d2e5c1fe969c2c9fd3aec4a454c1d5aa9b5721414413e0",
         intel: "1f0527ec14784de0766d8405a674868e51afb869ea16c915fb2672256209ecfd"

  url "https://mirror.ghproxy.com/https://github.com/conda-forge/miniforge/releases/download/#{version}/Miniforge3-#{version}-MacOSX-#{arch}.sh"
  name "miniforge"
  desc "Minimal installer for conda specific to conda-forge"
  homepage "https://github.com/conda-forge/miniforge"

  livecheck do
    url :homepage
    regex(/v?(\d+(?:[.-]\d+)+)/i)
    strategy :github_latest
  end

  auto_updates true
  conflicts_with cask: [
    "mambaforge",
    "miniconda",
  ]
  container type: :naked

  installer script: {
    executable: "Miniforge3-#{version}-MacOSX-#{arch}.sh",
    args:       ["-b", "-p", "#{caskroom_path}/base"],
  }
  binary "#{caskroom_path}/base/condabin/conda"
  binary "#{caskroom_path}/base/condabin/mamba"

  uninstall delete: "#{caskroom_path}/base"

  zap trash: [
    "~/.conda",
    "~/.condarc",
  ]

  caveats <<~EOS
    Please run the following to setup your shell:
      conda init "$(basename "${SHELL}")"
  EOS
end
