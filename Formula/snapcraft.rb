class Snapcraft < Formula
  include Language::Python::Virtualenv

  desc "Package any app for every Linux desktop, server, cloud or device"
  homepage "https://snapcraft.io/"
  url "https://github.com/snapcore/snapcraft.git",
      tag:      "7.2.10",
      revision: "b7ee0805eac483f7b40b7a5f93e0c0f84d914dae"
  license "GPL-3.0-only"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e430b4fdff534d31f08491b4d74b94782499dfb49770c42c7b6e81280bff03de"
    sha256 cellar: :any,                 arm64_monterey: "763bac2a1ca9aeafd52fd0fca12a5ca6b7c9fb2e9688932f26a76de9a36bc4cd"
    sha256 cellar: :any,                 arm64_big_sur:  "4a02c9b2e1f93c612e61586f5c7b2efb301ecd9a8bf3c9b12a729ac93387ab8d"
    sha256 cellar: :any,                 ventura:        "0c33af48bb66820d31cf31cf1ef3a26d761f6011df57365e7e205725f417eecc"
    sha256 cellar: :any,                 monterey:       "2070072f81630b270f8fa5bb37b4920db1aabf661848eb7c99153ad7cf31ed4b"
    sha256 cellar: :any,                 big_sur:        "23c7550698943b18d2c421e77421d8c178fbeb295446c0c8db0a1dd0033c0fa3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3112b4ff548dd38a2743be3c75b202a91616fbc238640c5cc75e5294441e500e"
  end

  depends_on "rust" => :build # for cryptography
  depends_on "libsodium"
  depends_on "lxc"
  depends_on "python-tabulate"
  depends_on "python-typing-extensions"
  depends_on "python@3.11"
  depends_on "pyyaml"
  depends_on "six"
  depends_on "snap"
  depends_on "xdelta"

  uses_from_macos "libxml2" # for lxml
  uses_from_macos "libxslt" # for lxml

  on_linux do
    depends_on "intltool" => :build # for python-distutils-extra
    depends_on "apt"

    # Extra non-PyPI Python resources

    resource "python-distutils-extra" do
      url "https://deb.debian.org/debian/pool/main/p/python-distutils-extra/python-distutils-extra_2.45.tar.xz"
      sha256 "9db7e00e609a762ac5541532816aa028475cb715a8be8ee8d615a5ab63dd7344"
    end

    resource "python-apt" do
      url "https://ftp.debian.org/debian/pool/main/p/python-apt/python-apt_2.2.1.tar.xz"
      sha256 "b9336cc92dc0a3bcc7be05b40f6752d10220cc968b19061f6c7fc12bf22a97f2"
    end

    # Extra PyPI Python resources for Linux

    resource "chardet" do
      url "https://files.pythonhosted.org/packages/31/a2/12c090713b3d0e141f367236d3a8bdc3e5fca0d83ff3647af4892c16c205/chardet-5.0.0.tar.gz"
      sha256 "0368df2bfd78b5fc20572bb4e9bb7fb53e2c094f60ae9993339e8671d0afb8aa"
    end

    resource "jeepney" do
      url "https://files.pythonhosted.org/packages/d6/f4/154cf374c2daf2020e05c3c6a03c91348d59b23c5366e968feb198306fdf/jeepney-0.8.0.tar.gz"
      sha256 "5efe48d255973902f6badc3ce55e2aa6c5c3b3bc642059ef3a91247bcfcc5806"
    end

    resource "pylxd" do
      url "https://files.pythonhosted.org/packages/26/13/cd06edfccf667c348022b72c5177f127129a51de64d115b766decd2890e2/pylxd-2.3.1.tar.gz"
      sha256 "556a2127d51dd8d1559989cb8257183910d397156f5ebe59fe4f6289ea014154"
    end

    resource "python-debian" do
      url "https://files.pythonhosted.org/packages/bf/30/7ea365c55d68d61045ecf614239ef6c221d895f2c1b7c36741f5f5c5e77a/python-debian-0.1.47.tar.gz"
      sha256 "51e202823777a3d716a843b8a540fba2ba0bed9f507a87c0c0f9eefcdec3342c"
    end

    resource "secretstorage" do
      url "https://files.pythonhosted.org/packages/53/a4/f48c9d79cb507ed1373477dbceaba7401fd8a23af63b837fa61f1dcd3691/SecretStorage-3.3.3.tar.gz"
      sha256 "2403533ef369eca6d2ba81718576c5e0f564d5cca1b58f73a8b23e7d4eeebd77"
    end

    resource "ws4py" do
      url "https://files.pythonhosted.org/packages/53/20/4019a739b2eefe9282d3822ef6a225250af964b117356971bd55e274193c/ws4py-0.5.1.tar.gz"
      sha256 "29d073d7f2e006373e6a848b1d00951a1107eb81f3742952be905429dc5a5483"
    end
  end

  fails_with gcc: "5" # due to apt on Linux

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/1a/cb/c4ffeb41e7137b23755a45e1bfec9cbb76ecf51874c6f1d113984ecaa32c/attrs-22.1.0.tar.gz"
    sha256 "29adc2665447e5191d0e7c568fde78b21f9672d344281d0c6e1ab085429b22b6"
  end

  resource "catkin-pkg" do
    url "https://files.pythonhosted.org/packages/b0/c3/c2f0de6be573b2209e229f7c65e54123f1a49a24e2d25698e5de05148a17/catkin_pkg-0.5.2.tar.gz"
    sha256 "5d643eeafbce4890fcceaf9db197eadf2ca5a187d25593f65b6e5c57935f5da2"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/cb/a4/7de7cd59e429bd0ee6521ba58a75adaec136d32f91a761b28a11d8088d44/certifi-2022.9.24.tar.gz"
    sha256 "0d9c601124e5a6ba9712dbc60d9c53c21e34f5f641fe83002317394311bdce14"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/2b/a8/050ab4f0c3d4c1b8aaa805f70e26e84d0e27004907c5b8ecc1d31815f92a/cffi-1.15.1.tar.gz"
    sha256 "d400bfb9a37b1351253cb402671cea7e89bdecc294e8016a707f6d1d8ac934f9"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/a1/34/44964211e5410b051e4b8d2869c470ae8a68ae274953b1c7de6d98bbcf94/charset-normalizer-2.1.1.tar.gz"
    sha256 "5a3d016c7c547f69d6f81fb0db9449ce888b418b5b9952cc5e6e66843e9dd845"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/59/87/84326af34517fca8c58418d148f2403df25303e02736832403587318e9e8/click-8.1.3.tar.gz"
    sha256 "7682dc8afb30297001674575ea00d1814d808d6a36af415a82bd481d37ba7b8e"
  end

  resource "craft-cli" do
    url "https://files.pythonhosted.org/packages/27/79/084746d656a483b8a58aca7e9d8db536208018ce0860d04c8a53f5b2c969/craft-cli-1.2.0.tar.gz"
    sha256 "fb71127ccbc9da0a37e4d08824d44a14079935d94a8382dd158a0250ec125795"
  end

  resource "craft-grammar" do
    url "https://files.pythonhosted.org/packages/96/d5/5fa68f1d0ce92c16e20c6b306370b2963cd74ba809441fb75951fe45e4a6/craft-grammar-1.1.1.tar.gz"
    sha256 "43af311206b5fcf9f6459250b7f498b3ad597ce222feed67b320317daa03639d"
  end

  resource "craft-parts" do
    url "https://files.pythonhosted.org/packages/29/c0/aedce7ebd8d0ae9ee89f7269ec702d2dd5504e91e282989cd352ecc63c18/craft-parts-1.17.1.tar.gz"
    sha256 "084f123955c37dd8995e4ad85f62003b2cb9590549de42d7ab2c1febb1985fb8"
  end

  resource "craft-providers" do
    url "https://files.pythonhosted.org/packages/19/33/f756a14055aa51270ba306a405091d5f2de6dc340e45ce1eadef1e2f9ea8/craft-providers-1.6.1.tar.gz"
    sha256 "ecf7c768e0c9809998f25c0222df0deb372e5ad72cf08877b140f4ba478c960c"
  end

  resource "craft-store" do
    url "https://files.pythonhosted.org/packages/10/d8/4355935257b72a9d8fc3251649c7f1e3fbc383bd7f7fb85f91f0622ab2a3/craft-store-2.3.0.tar.gz"
    sha256 "9e17620c7d543662fd4a4fa31cb1f1bb88040652198ae35f7099b13f7663dbbb"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/ea/d8/2afd2890fe451a3c109d2bdb6bc4ded55ec43059e524344d5e0004e36412/cryptography-3.4.tar.gz"
    sha256 "9f7aa11ea95723359f914be3217d8b378bc3897f65a1ec1ab4e0118c336f51fc"
  end

  resource "Deprecated" do
    url "https://files.pythonhosted.org/packages/c8/d1/e412abc2a358a6b9334250629565fe12697ca1cdee4826239eddf944ddd0/Deprecated-1.2.13.tar.gz"
    sha256 "43ac5335da90c31c24ba028af536a91d41d53f9e6901ddb021bcc572ce44e38d"
  end

  resource "distro" do
    url "https://files.pythonhosted.org/packages/4b/89/eaa3a3587ebf8bed93e45aa79be8c2af77d50790d15b53f6dfc85b57f398/distro-1.8.0.tar.gz"
    sha256 "02e111d1dc6a50abb8eed6bf31c3e48ed8b0830d1ea2a1b78c61765c2513fdd8"
  end

  resource "docutils" do
    url "https://files.pythonhosted.org/packages/6b/5c/330ea8d383eb2ce973df34d1239b3b21e91cd8c865d21ff82902d952f91f/docutils-0.19.tar.gz"
    sha256 "33995a6753c30b7f577febfc2c50411fec6aac7f7ffeb7c4cfe5991072dcf9e6"
  end

  resource "gnupg" do
    url "https://files.pythonhosted.org/packages/96/6c/21f99b450d2f0821ff35343b9a7843b71e98de35192454606435c72991a8/gnupg-2.3.1.tar.gz"
    sha256 "8db5a05c369dbc231dab4c98515ce828f2dffdc14f1534441a6c59b71c6d2031"
  end

  resource "httplib2" do
    url "https://files.pythonhosted.org/packages/9c/65/57ad964eb8d45cc3d1316ce5ada2632f74e35863a0e57a52398416a182a1/httplib2-0.20.4.tar.gz"
    sha256 "58a98e45b4b1a48273073f905d2961666ecf0fbac4250ea5b47aef259eb5c585"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "jaraco.classes" do
    url "https://files.pythonhosted.org/packages/bf/02/a956c9bfd2dfe60b30c065ed8e28df7fcf72b292b861dca97e951c145ef6/jaraco.classes-3.2.3.tar.gz"
    sha256 "89559fa5c1d3c34eff6f631ad80bb21f378dbcbb35dd161fd2c6b93f5be2f98a"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/58/0d/c816f5ea5adaf1293a1d81d32e4cdfdaf8496973aa5049786d7fdb14e7e7/jsonschema-2.5.1.tar.gz"
    sha256 "36673ac378feed3daa5956276a829699056523d7961027911f064b52255ead41"
  end

  resource "keyring" do
    url "https://files.pythonhosted.org/packages/2a/ef/28d3d5428108111dae4304a2ebec80d113aea9e78c939e25255425d486ff/keyring-23.9.3.tar.gz"
    sha256 "69b01dd83c42f590250fe7a1f503fc229b14de83857314b1933a3ddbf595c4a5"
  end

  resource "launchpadlib" do
    url "https://files.pythonhosted.org/packages/c6/ab/d660df8b1678aed8e1fe6469f4aa771dccb124fb2891f38746615c93b35b/launchpadlib-1.10.16.tar.gz"
    sha256 "0df4b13936f988afd0ee485f40fa6922eab783b48c38ca0108cb73c8788fca80"
  end

  resource "lazr.restfulclient" do
    url "https://files.pythonhosted.org/packages/c9/3b/610cd97c0db307bdf04812261ede0c5fefb7dd67470346f89e99083625d5/lazr.restfulclient-0.14.4.tar.gz"
    sha256 "bf0fd6b2749b3a2d02711f854c9d23704756f7afed21fb5d5b9809d72aa6d087"
  end

  resource "lazr.uri" do
    url "https://files.pythonhosted.org/packages/a6/db/310eaccd3639f5a8a6011c3133bb1cac7fd80bb46f8a50406df2966302e4/lazr.uri-1.0.6.tar.gz"
    sha256 "5026853fcbf6f91d5a6b11ea7860a641fe27b36d4172c731f4aa16b900cf8464"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/70/bb/7a2c7b4f8f434aa1ee801704bf08f1e53d7b5feba3d5313ab17003477808/lxml-4.9.1.tar.gz"
    sha256 "fe749b052bb7233fe5d072fcb549221a8cb1a16725c47c37e42b0b9cb3ff2c3f"
  end

  resource "macaroonbakery" do
    url "https://files.pythonhosted.org/packages/52/40/2a8bb2f507ce1a6c5b896c1b98044d74d34b07a6dd771526b4fe84e3181f/macaroonbakery-1.3.1.tar.gz"
    sha256 "23f38415341a1d04a155b4dac6730d3ad5f39b86ce07b1bb134bdda52b48b053"
  end

  resource "more-itertools" do
    url "https://files.pythonhosted.org/packages/c7/0c/fad24ca2c9283abc45a32b3bfc2a247376795683449f595ff1280c171396/more-itertools-8.14.0.tar.gz"
    sha256 "c09443cd3d5438b8dafccd867a6bc1cb0894389e90cb53d227456b0b0bccb750"
  end

  resource "mypy-extensions" do
    url "https://files.pythonhosted.org/packages/63/60/0582ce2eaced55f65a4406fc97beba256de4b7a95a0034c6576458c6519f/mypy_extensions-0.4.3.tar.gz"
    sha256 "2d82818f5bb3e369420cb3c4060a7970edba416647068eb4c5343488a6c604a8"
  end

  resource "oauthlib" do
    url "https://files.pythonhosted.org/packages/fe/58/30a4d3302f9bbd602c43385e7270fc3a9e8a665d07aafd6a4d4baa844739/oauthlib-3.2.1.tar.gz"
    sha256 "1565237372795bf6ee3e5aba5e2a85bd5a65d0e2aa5c628b9a97b7d7a0da3721"
  end

  resource "overrides" do
    url "https://files.pythonhosted.org/packages/67/9b/58655bed3190319830d9ae5fb859c51a14ed35d4ea79d78bf036b5b768d7/overrides-7.0.0.tar.gz"
    sha256 "49754f440f29de43975e27838942331adcc7521e6f552fdbb434dd5b4f895b3d"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/df/9e/d1a7217f69310c1db8fdf8ab396229f55a699ce34a203691794c5d1cad0c/packaging-21.3.tar.gz"
    sha256 "dd47c42927d89ab911e606518907cc2d3a1f38bbd026385970643f9c5b8ecfeb"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/ff/7b/3613df51e6afbf2306fc2465671c03390229b55e3ef3ab9dd3f846a53be6/platformdirs-2.5.2.tar.gz"
    sha256 "58c8abb07dcb441e6ee4b11d8df0ac856038f944ab98b7be6b27b2a3c7feef19"
  end

  resource "progressbar" do
    url "https://files.pythonhosted.org/packages/a3/a6/b8e451f6cff1c99b4747a2f7235aa904d2d49e8e1464e0b798272aa84358/progressbar-2.5.tar.gz"
    sha256 "5d81cb529da2e223b53962afd6c8ca0f05c6670e40309a7219eacc36af9b6c63"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/55/5b/e3d951e34f8356e5feecacd12a8e3b258a1da6d9a03ad1770f28925f29bc/protobuf-3.20.3.tar.gz"
    sha256 "2e3427429c9cffebf259491be0af70189607f365c2f41c7c3764af6f337105f2"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/8f/57/828ac1f70badc691a716e77bfae258ef5db76bb7830109bf4bcf882de020/psutil-5.9.2.tar.gz"
    sha256 "feb861a10b6c3bb00701063b37e4afc754f8217f0f09c42280586bd6ac712b5c"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/5e/0b/95d387f5f4433cb0f53ff7ad859bd2c6051051cebbb564f139a999ab46de/pycparser-2.21.tar.gz"
    sha256 "e644fdec12f7872f86c58ff790da456218b10f863970249516d60a5eaca77206"
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/60/a3/23a8a9378ff06853bda6527a39fe317b088d760adf41cf70fc0f6110e485/pydantic-1.9.0.tar.gz"
    sha256 "742645059757a56ecd886faf4ed2441b9c0cd406079c2b4bee51bcc3fbcd510a"
  end

  resource "pydantic-yaml" do
    url "https://files.pythonhosted.org/packages/d9/61/1be9472b8e85d32924a0e9a784341a2b5e5ed9437b5150eabb26b6976fbb/pydantic_yaml-0.8.1.tar.gz"
    sha256 "73905a4e678266dabe41793ddd169ea9450f9181358322e00802fa4ee81ff816"
  end

  resource "pyelftools" do
    url "https://files.pythonhosted.org/packages/0e/35/e76da824595452a5ad07f289ea1737ca0971fc6cc7b6ee9464279be06b5e/pyelftools-0.29.tar.gz"
    sha256 "ec761596aafa16e282a31de188737e5485552469ac63b60cfcccf22263fd24ff"
  end

  resource "pymacaroons" do
    url "https://files.pythonhosted.org/packages/37/b4/52ff00b59e91c4817ca60210c33caf11e85a7f68f7b361748ca2eb50923e/pymacaroons-0.13.0.tar.gz"
    sha256 "1e6bba42a5f66c245adf38a5a4006a99dcc06a0703786ea636098667d42903b8"
  end

  resource "PyNaCl" do
    url "https://files.pythonhosted.org/packages/a7/22/27582568be639dfe22ddb3902225f91f2f17ceff88ce80e4db396c8986da/PyNaCl-1.5.0.tar.gz"
    sha256 "8ac7448f09ab85811607bdd21ec2464495ac8b7c66d146bf545b0f08fb9220ba"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/71/22/207523d16464c40a0310d2d4d8926daffa00ac1f5b1576170a32db749636/pyparsing-3.0.9.tar.gz"
    sha256 "2b020ecf7d21b687f219b71ecad3631f644a47f01403fa1d1036b0c6416d70fb"
  end

  resource "pyRFC3339" do
    url "https://files.pythonhosted.org/packages/00/52/75ea0ae249ba885c9429e421b4f94bc154df68484847f1ac164287d978d7/pyRFC3339-1.1.tar.gz"
    sha256 "81b8cbe1519cdb79bed04910dd6fa4e181faf8c88dff1e1b987b5f7ab23a5b1a"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/31/da/2d48d3499b59c7f3c5d5e1c79fcee5537c320c8ab7b7a0cd2db578bc34b3/pytz-2022.4.tar.gz"
    sha256 "48ce799d83b6f8aab2020e369b627446696619e79645419610b9facd909b3174"
  end

  resource "pyxdg" do
    url "https://files.pythonhosted.org/packages/b0/25/7998cd2dec731acbd438fbf91bc619603fc5188de0a9a17699a781840452/pyxdg-0.28.tar.gz"
    sha256 "3267bb3074e934df202af2ee0868575484108581e6f3cb006af1da35395e88b4"
  end

  resource "raven" do
    url "https://files.pythonhosted.org/packages/79/57/b74a86d74f96b224a477316d418389af9738ba7a63c829477e7a86dd6f47/raven-6.10.0.tar.gz"
    sha256 "3fa6de6efa2493a7c827472e984ce9b020797d0da16f1db67197bcc23c8fae54"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/a5/61/a867851fd5ab77277495a8709ddda0861b28163c4613b011bc00228cc724/requests-2.28.1.tar.gz"
    sha256 "7c5599b102feddaa661c826c56ab4fee28bfd17f5abca1ebbe3e7f19d7c97983"
  end

  resource "requests-toolbelt" do
    url "https://files.pythonhosted.org/packages/57/d6/20857446a2b81136dd02eed6d198343ce7a045ce8c06d4cb73fd2fee9001/requests-toolbelt-0.10.0.tar.gz"
    sha256 "f695d6207931200b46c8ef6addbc8a921fb5d77cc4cd209c2e7d39293fcd2b30"
  end

  resource "requests-unixsocket" do
    url "https://files.pythonhosted.org/packages/c3/ea/0fb87f844d8a35ff0dcc8b941e1a9ffc9eb46588ac9e4267b9d9804354eb/requests-unixsocket-0.3.0.tar.gz"
    sha256 "28304283ea9357d45fff58ad5b11e47708cfbf5806817aa59b2a363228ee971e"
  end

  resource "semantic-version" do
    url "https://files.pythonhosted.org/packages/7d/31/f2289ce78b9b473d582568c234e104d2a342fd658cc288a7553d83bb8595/semantic_version-2.10.0.tar.gz"
    sha256 "bdabb6d336998cbb378d4b9db3a4b56a1e3235701dc05ea2690d9a997ed5041c"
  end

  resource "semver" do
    url "https://files.pythonhosted.org/packages/31/a9/b61190916030ee9af83de342e101f192bbb436c59be20a4cb0cdb7256ece/semver-2.13.0.tar.gz"
    sha256 "fa0fe2722ee1c3f57eac478820c3a5ae2f624af8264cbdf9000c980ff7f75e3f"
  end

  resource "setuptools-rust" do
    url "https://files.pythonhosted.org/packages/dc/20/0b16eb0dd28c3ec6fccef77230b11e4b9ec94aa7ade1c99b1ab66d237fbe/setuptools-rust-1.5.1.tar.gz"
    sha256 "0e05e456645d59429cb1021370aede73c0760e9360bbfdaaefb5bced530eb9d7"
  end

  resource "simplejson" do
    url "https://files.pythonhosted.org/packages/7a/47/c7cc3d4ed15f09917838a2fb4e1759eafb6d2f37ebf7043af984d8b36cf7/simplejson-3.17.6.tar.gz"
    sha256 "cf98038d2abf63a1ada5730e91e84c642ba6c225b0198c3684151b1f80c5f8a6"
  end

  resource "snap-helpers" do
    url "https://files.pythonhosted.org/packages/54/a4/7f11eb8d96826cfe17c4c68b907f8005d97ad1ef23dea67aa3d39287f6d7/snap-helpers-0.2.0.tar.gz"
    sha256 "e72c810af32a0126bfcb7d5c39dda5ca2037889ca2fe2ee5aa543a25b9ca670b"
  end

  resource "tinydb" do
    url "https://files.pythonhosted.org/packages/77/b3/2ab727ab4062800731c2e4d773358c6c25f8d630affa3e3ccdb21dc40d68/tinydb-4.7.0.tar.gz"
    sha256 "357eb7383dee6915f17b00596ec6dd2a890f3117bf52be28a4c516aeee581100"
  end

  resource "toml" do
    url "https://files.pythonhosted.org/packages/be/ba/1f744cdc819428fc6b5084ec34d9b30660f6f9daaf70eead706e3203ec3c/toml-0.10.2.tar.gz"
    sha256 "b3bda1d108d5dd99f4a20d24d9c348e91c4db7ab1b749200bded2f839ccbe68f"
  end

  resource "types-Deprecated" do
    url "https://files.pythonhosted.org/packages/45/2f/c0e57815699277d3ecb3cc974c4ffee0afc37a593437328766a42a525dd2/types-Deprecated-1.2.9.tar.gz"
    sha256 "e04ce58929509865359e91dcc38720123262b4cd68fa2a8a90312d50390bb6fa"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/b2/56/d87d6d3c4121c0bcec116919350ca05dc3afd2eeb7dc88d07e8083f8ea94/urllib3-1.26.12.tar.gz"
    sha256 "3fa96cf423e6987997fc326ae8df396db2a8b7c667747d47ddd8ecba91f4a74e"
  end

  resource "wadllib" do
    url "https://files.pythonhosted.org/packages/35/07/040cc4cc736cdf25873848bd4c717cc25e257196a7c11f42b3a09617a961/wadllib-1.3.6.tar.gz"
    sha256 "acd9ad6a2c1007d34ca208e1da6341bbca1804c0e6850f954db04bdd7666c5fc"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/11/eb/e06e77394d6cf09977d92bff310cb0392930c08a338f99af6066a5a98f92/wrapt-1.14.1.tar.gz"
    sha256 "380a85cf89e0e69b7cfbe2ea9f765f004ff419f34194018a6827ac0e3edfed4d"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    require "open3"

    ENV["LC_ALL"] = "en_US.UTF-8"
    assert_match version.to_s, shell_output("#{bin}/snapcraft --version")

    # `--help` goes to stderr, not stdout, so we can't use `shell_output`
    ohai "#{bin}/snapcraft --help"
    Open3.popen3("#{bin}/snapcraft --help") do |_stdin, _stdout, stderr, _wait_thr|
      assert_match "Package, distribute, and update snaps for Linux and IoT", stderr.read
    end

    system bin/"snapcraft", "init"
    assert_predicate testpath/"snap/snapcraft.yaml", :exist?
  end
end
