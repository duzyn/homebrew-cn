class SbomTool < Formula
  desc "Scalable and enterprise ready tool to create SBOMs for any variety of artifacts"
  homepage "https://github.com/microsoft/sbom-tool"
  url "https://ghproxy.com/https://github.com/microsoft/sbom-tool/archive/refs/tags/v1.3.3.tar.gz"
  sha256 "629925dc56fa02661e378a38bb55981c652eff4acf01747f27210ec073b2b200"
  license "MIT"
  head "https://github.com/microsoft/sbom-tool.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, ventura:      "d061f9ec47134282f9814d65391108a6f4fe3379a6bcf8286ec73f62c3cf36e5"
    sha256 cellar: :any_skip_relocation, monterey:     "d061f9ec47134282f9814d65391108a6f4fe3379a6bcf8286ec73f62c3cf36e5"
    sha256 cellar: :any_skip_relocation, big_sur:      "d061f9ec47134282f9814d65391108a6f4fe3379a6bcf8286ec73f62c3cf36e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "9a9cdb6cf5adb55a097a1a68e3c1b513ff7e6e937680dc76b0c60dcf4521cb43"
  end

  depends_on "dotnet" => :build
  # currently does not support arm build
  # upstream issue, https://github.com/microsoft/sbom-tool/issues/223
  depends_on arch: :x86_64

  uses_from_macos "icu4c" => :test
  uses_from_macos "zlib"

  def install
    bin.mkdir

    ENV["DOTNET_CLI_TELEMETRY_OPTOUT"] = "true"

    # the architecture is hardcoded to x64 for macOS due to to an issue with
    # the inclusion of dynamic libraries for the self-contained executable, for
    # details see: https://github.com/microsoft/sbom-tool/issues/223#issuecomment-1644578606
    os = OS.mac? ? "osx" : OS.kernel_name.downcase
    arch = if OS.mac? || Hardware::CPU.intel?
      "x64"
    else
      Hardware::CPU.arch.to_s
    end

    args = %W[
      --configuration Release
      --output #{buildpath}
      --runtime #{os}-#{arch}
      --self-contained=true
      -p:OFFICIAL_BUILD=true
      -p:MinVerVersionOverride=#{version}
      -p:PublishSingleFile=true
      -p:IncludeNativeLibrariesForSelfExtract=true
      -p:IncludeAllContentForSelfExtract=true
      -p:DebugType=None
      -p:DebugSymbols=false
    ]

    system "dotnet", "publish", "src/Microsoft.Sbom.Tool/Microsoft.Sbom.Tool.csproj", *args
    bin.install "Microsoft.Sbom.Tool" => "sbom-tool"
  end

  test do
    args = %W[
      -b #{testpath}
      -bc #{testpath}
      -pn TestProject
      -pv 1.2.3
      -ps Homebrew
      -nsb http://formulae.brew.sh
    ]

    system bin/"sbom-tool", "generate", *args

    json = JSON.parse((testpath/"_manifest/spdx_2.2/manifest.spdx.json").read)
    assert_equal json["name"], "TestProject 1.2.3"
  end
end
