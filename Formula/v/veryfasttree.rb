class Veryfasttree < Formula
  desc "Efficient phylogenetic tree inference for massive taxonomic datasets"
  homepage "https://github.com/citiususc/veryfasttree"
  url "https://mirror.ghproxy.com/https://github.com/citiususc/veryfasttree/archive/refs/tags/v4.0.4.tar.gz"
  sha256 "27c779164f4fa0c75897a6e95b35f820a2a10e7c244b8923c575e0ea46f15f6b"
  license all_of: [
    "GPL-3.0-only",
    "BSD-3-Clause", # libs/cli11
    "MPL-2.0", # libs/bxzstr
  ]
  head "https://github.com/citiususc/veryfasttree.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "3b4f10da88fbaf21f6082772ddc623d10f9cff34d3be95ac45924baf5c17769b"
    sha256 cellar: :any,                 arm64_sonoma:  "ff5e59bfbcad12d6870b9409386bb11501d3713444863286c576abc8ebfac815"
    sha256 cellar: :any,                 arm64_ventura: "3a1062d7ed565cb1429d559ed74b54473320305f26268bd76d2733121f2ff77d"
    sha256 cellar: :any,                 sonoma:        "8d2e08a346280fa22e36641d702d1fc7feb5a95cd37d94b6e213171379c9a63e"
    sha256 cellar: :any,                 ventura:       "f5c4898142258d22a2f9eb459596656de0a4f446a9c6fa68926b2d56b4b6cef5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "17517e0f776012479018748edccccc2042d9bc72b6e03943eac593a0e80720fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9055dc85be8ca2fc65b2f47f13c8bd6d38427f6ee8f92f1128e502cb538dc341"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "robin-map" => :build
  depends_on "xxhash" => :build

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  on_macos do
    depends_on "libomp"
  end

  def install
    # remove libraries that can be unbundled
    rm_r(Dir["libs/*"] - ["libs/CLI11", "libs/bxzstr"])

    args = ["-DUSE_SHARED=ON"]
    args << "-DUSE_NATIVE=OFF" if ENV.effective_arch != :native
    args << "-DUSE_SEE4=ON" if Hardware::CPU.intel? && OS.mac? && MacOS.version.requires_sse41?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    man1.install "man/VeryFastTree.1"
  end

  test do
    (testpath/"test.fasta").write <<~FASTA
      >N3289
      --RNRSCRRDNTNGQDLQAALAIFAAKVYVGVALQSVQVAAGIGKHPVYKHIPSKKYTGL
      IIQELYLERLMAELADGLADAAPDVLLDIRGLMLALDAPAREKPIIL-LHLAASAGDALR
      DKGQALRRELLPRLSGLGYAGLASGALTGDNATLMSARLIGLLVSATLLAL---------
      -----------------
      >N1763
      ------ISKDTTEERFLEVDKLTFAPKSYAGTLQTKILSAVSVPAGTLYKDFPTTELALL
      VTLEVYQATDTSGAQDGLAANARDILHVLVELFLALAGFAAQDPLHLLLPMAAALTSSLR
      GRLRELRRELLAKGAAKVYTGLGAADATGDGVQLGAASLAMQLLGALLPCLRLDALLGSL
      ASGLPEEKLASLAIFL-
      >N2100
      --RGRARPKQTTAESNLDATMGKFASQEYDGTMHRELGAASGVSLGTLYPDYPTWEMLIL
      VTLESYLEPVVSALYAGLATDAPDILQR-LQLFLALLGFAMNHPGALLKSLAATLESELC
      GKLKALTREVLEKLGASVFEGLPEPTLTGDEATPMSAALLMPLVQALLLCLLLQPLLAKH
      SDDLPQIILAIYGIF--
      >N774
      --RGRRRTKTIVSEKDLSATMGRFAEQPYDGSLERNAATAASAPLNTMYGEFPTQDMFLL
      MCLESYLIPTVLEADAE-ATEARDVLRRRLQLFLALLGFALNHPTQLLKMLATTLHKALR
      GKIKDLQREVFARLTASAPAGLAAQFLTGDNATLMEAVLLMPFLAALLSCLILEPLDRKF
      ADDFPAVILAIYAIF--
      >N211
      --KARGRTTIETGEKVLTGEMDRFAELQYDGSLQRDDTTGAAPPLGTLYGKLPTQDMFLL
      FALESYLDPGTPELGQGLATKAPDGLRKRLHLFLGLLSFSLDHPVHLLKSLATT-HKAVR
      GKVKDLQRDRFARLNASAPSGIAHPALTGDMATLMEAGLLMPLLAALLPILILAPLDKKY
      AHDNHNDILAIYAIFLT
      >N747
      MGKARGITTAYAYSQVLIGRLGAHAALPYNGSLERKDVAALDAPTNKLYGQFPDGDSWLL
      GALEAYIHTCPPELPQSLATQAPETIFTRLQPYLGLADFGLAHPGQLLKIEATKLQRAVR
      GKFKELQKDAPAQLTANGITVVGQPNLTGDLGTLSEAVVLLQLVPSLLAAIIFKPIDKKY
      GESAPVGILLPFSVW--
      >N952
      MGRGRARTTVEAGEKVLLGTMIRFAELPHDGSLQRNDSTALAAPLNTLYAKFPTQDMFLL
      FALESYLHPSSPELGMGLATPAPDILRKRLALFLGLLSFSLEHPIQLLKSLATT-HKAVR
      GPFKDLQKDVPAHLTATAPSGIAHPALTGDMATLMEAVLLMPLLAALLPVLVLKPLDKKF
      ADDSPGDILAVYAIF--
      >N3964
      ------RTTVEDNDKVLNATMDRFADLPYDGSLQRDDTTAQTAPLGTLYGKFPTADMFLL
      NALESYLDPKRPELGQGLATKAPDALRKKLQLFLGLLAFALSHPNRLLKSLATT-HKLVR
      GKLKDQEREIFARLTASAPPAIAHPALTGDMATLMEAVLLMPLLAALLTVLPLEPLDKAY
      EDDSPGDILAVYAVF--
      >N3613
      LGRGMARTTVEDLETVLNATMDRFAQLPYDGSLQRDDTTAASAPLGTLYGKSPTADMFLQ
      FALESYLDPKRPELGQGLATKAPDALRKRLQLYLGLLSFALEHPTPLLQSLATTLHK-VR
      GKLKNLQREVFARLTASAASGIAHPALTGDMATLMDAVLLMPLLAKLLTIIILEPLDKKY
      SDNSPDDILAAYAAFLS
      >N1689
      MKLGRYRTVQTANEKYLETTAGRYADQNYAGTAQRGVQKANSVPLGTLYPDLPTRDMLLL
      VSLESYLESITAGL-AGLATKAVTLFKVVLVLFLSVTGFALSHPGELFLSMAAVLQTEIR
      GKLKNLTRELLQKLSASLTAGLAVPELTGDEASLGAGKILVPLLAALLVALLLSPLLGGF
      SDDLPNMVLAIYAVTL-
      >N3700
      MKMGRPRTKQSTSQRYLDTAGARYDDQAYAGTLQRGLGNAKGVPLGTLYLDFPIRDMLLL
      VTLESYLESIVAGLYA-GATKAPNLLQAVLILFLNVVGFALLHPGALLLTMAAVLHNELI
      GKLKEFSRELLERLAASVITGLAVPELTGDEGTLAAGVILMALLAALLLYLLLDPLLSGF
      SGDLPDSGLAVHA----
    FASTA
    system bin/"VeryFastTree", "test.fasta"
  end
end
