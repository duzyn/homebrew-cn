class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https://github.com/crate-ci/typos"
  url "https://github.com/crate-ci/typos/archive/refs/tags/v1.13.6.tar.gz"
  sha256 "94e3ef34a9f6c2d102958c6ad934fe98ffc45a1ec51be75e0b639059014474cf"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "29528cdd525e9817c972ec5c051d5ed28bea15148b4f5209d4c215515c256927"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ad0d5640978e7c2cabdc1f1a0372957f6921ce95520a381c05b61e8dbfa81007"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1f06efde94908ca884d836d324b3d542ca5218517336181c384497aada4de05e"
    sha256 cellar: :any_skip_relocation, ventura:        "943c2560dc556fdaff40af3243a4364a4a62dd47b9baedac499d3d6541d7f99d"
    sha256 cellar: :any_skip_relocation, monterey:       "f5cc55f0736442ae992c7e73405e771991fb37bb841b2e3c0bc5c6be095c4426"
    sha256 cellar: :any_skip_relocation, big_sur:        "652db32392ba694271639ecda83358440b744e0834eaa46da51c0b340bc0bc99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "073135815723a219803bc0ebda823233238f691cef82581eb33f5252c7fbe89c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "error: `teh` should be `the`", pipe_output("#{bin}/typos -", "teh", 2)
    assert_empty pipe_output("#{bin}/typos -", "the")
  end
end
