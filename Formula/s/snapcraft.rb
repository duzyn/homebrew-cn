class Snapcraft < Formula
  include Language::Python::Virtualenv

  desc "Package any app for every Linux desktop, server, cloud or device"
  homepage "https://snapcraft.io/"
  url "https://mirror.ghproxy.com/https://github.com/canonical/snapcraft/archive/refs/tags/8.4.1.tar.gz"
  sha256 "0028e288e23dea32fed9146994e40fe6d89c284e20364e7273761bb310954d9d"
  license "GPL-3.0-only"
  head "https://github.com/canonical/snapcraft.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e50303c3d89b0ac774b322885d5fe8ed7c70a244c7967c24112d8e4739e1ca04"
    sha256 cellar: :any,                 arm64_sonoma:  "72459d630233c54f5e7a30758eca0e22cf17ee611072b0084958cd1df7ab1186"
    sha256 cellar: :any,                 arm64_ventura: "94d86ed8f426064ea8baeeb664a182fb5b25dee51dcae6a0266a82d1780da9df"
    sha256 cellar: :any,                 sonoma:        "b766db1a50093b9a22e780653a721398cffb84265bdbce29de5b11834eba8598"
    sha256 cellar: :any,                 ventura:       "b77f827af76fe37dbcd78ec9ee674325f88e218667435366167261698186815e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b67925be7621f9b8c0556ace6a1ce7a4f72df2235208ae9374b8af5c6251985"
  end

  depends_on "rust" => :build # for pydantic_core
  depends_on "libgit2@1.7"
  depends_on "libsodium"
  depends_on "libyaml"
  depends_on "lxc"
  depends_on "python@3.12"
  depends_on "snap"
  depends_on "xdelta"

  uses_from_macos "libffi"
  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  on_linux do
    depends_on "intltool" => :build # for python-distutils-extra
    depends_on "apt"
    depends_on "cryptography"

    # Extra non-PyPI Python resources
    # https://github.com/snapcore/snapcraft/blob/91a18b3128de4971edfc090a8683a64ff1679f2e/setup.py#L154-L158

    resource "python-distutils-extra" do
      url "https://deb.debian.org/debian/pool/main/p/python-distutils-extra/python-distutils-extra_3.0.tar.xz"
      sha256 "e5b9aa81a48a4dfdd817310b4f8c932a7bd9b86081a331d956581eac884e0499"
    end

    resource "python-apt" do
      url "https://ftp.debian.org/debian/pool/main/p/python-apt/python-apt_2.9.0.tar.xz"
      sha256 "5b7bf0b19a798a5ee0b8d027e162282db41b957f6586ffc8b90df827b650feb2"
    end

    # Extra PyPI Python resources for Linux

    resource "chardet" do
      url "https://files.pythonhosted.org/packages/f3/0d/f7b6ab21ec75897ed80c17d79b15951a719226b9fababf1e40ea74d69079/chardet-5.2.0.tar.gz"
      sha256 "1b3b6ff479a8c414bc3fa2c0852995695c4a026dcd6d0633b2dd092ca39c1cf7"
    end

    resource "jeepney" do
      url "https://files.pythonhosted.org/packages/d6/f4/154cf374c2daf2020e05c3c6a03c91348d59b23c5366e968feb198306fdf/jeepney-0.8.0.tar.gz"
      sha256 "5efe48d255973902f6badc3ce55e2aa6c5c3b3bc642059ef3a91247bcfcc5806"
    end

    resource "pylxd" do
      url "https://files.pythonhosted.org/packages/5d/94/c43092aa17917f6844f07fedff07969a1b4e060beb70aab69617126ca20c/pylxd-2.3.4.tar.gz"
      sha256 "01036405d9a60fc4248542fa1ba4c9d88432694711179035f2cc076e41b66b4e"
    end

    resource "python-debian" do
      url "https://files.pythonhosted.org/packages/ce/8d/2ebc549adf1f623d4044b108b30ff5cdac5756b0384cd9dddac63fe53eae/python-debian-0.1.49.tar.gz"
      sha256 "8cf677a30dbcb4be7a99536c17e11308a827a4d22028dc59a67f6c6dd3f0f58c"
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

  resource "annotated-types" do
    url "https://files.pythonhosted.org/packages/ee/67/531ea369ba64dcff5ec9c3402f9f51bf748cec26dde048a2f973a4eea7f5/annotated_types-0.7.0.tar.gz"
    sha256 "aff07c09a53a08bc8cfccb9c85b05f1aa9a2a6f23728d790723543408344ce89"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/fc/0f/aafca9af9315aee06a89ffde799a10a582fe8de76c563ee80bbcdc08b3fb/attrs-24.2.0.tar.gz"
    sha256 "5cfb1b9148b5b086569baec03f20d7b6bf3bcacc9a42bebf87ffaaca362f6346"
  end

  resource "boolean-py" do
    url "https://files.pythonhosted.org/packages/a2/d9/b6e56a303d221fc0bdff2c775e4eef7fedd58194aa5a96fa89fb71634cc9/boolean.py-4.0.tar.gz"
    sha256 "17b9a181630e43dde1851d42bef546d616d5d9b4480357514597e78b203d06e4"
  end

  resource "catkin-pkg" do
    url "https://files.pythonhosted.org/packages/2e/a2/88f8ba42a0119833887b8afe159f6e3ae96e2700720baf461eeabcc6acd8/catkin_pkg-1.0.0.tar.gz"
    sha256 "476e9f52917282f464739241b4bcaf5ebbfba9a7a68d9af8f875225feac0e1b5"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/b0/ee/9b19140fe824b367c04c5e1b369942dd754c4c5462d5674002f75c4dedc1/certifi-2024.8.30.tar.gz"
    sha256 "bec941d2aa8195e248a60b31ff9f0558284cf01a52591ceda73ea9afffd69fd9"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/fc/97/c783634659c2920c3fc70419e3af40972dbaf758daa229a7d6ea6135c90d/cffi-1.17.1.tar.gz"
    sha256 "1c39c6016c32bc48dd54561950ebd6836e1670f2ae46128f67cf49e789c52824"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "craft-application" do
    url "https://files.pythonhosted.org/packages/9d/6e/5536b647acc283695b99e96947c711f998267d3f662a27fbef98825ccc04/craft_application-4.2.4.tar.gz"
    sha256 "9c8526b5920bd6d675e83aa1dc3c0ab2a037f24c3535d6f0f11fe58ff83a2671"
  end

  resource "craft-archives" do
    url "https://files.pythonhosted.org/packages/7f/5a/c3bccaae5c5d2946a06ef299bf5d8e09a43309cc9f80ccfb7de489bdb2d7/craft_archives-2.0.00.tar.gz"
    sha256 "f0f69d4ee67dbeae3213036879510c5767205a67f0df33af8bc4b3dabc4e6e09"
  end

  resource "craft-cli" do
    url "https://files.pythonhosted.org/packages/2f/30/4d658c9f1f336c05711ffef29d29eab06865320c5a4b17e90b6c52329bd8/craft_cli-2.7.0.tar.gz"
    sha256 "2b1f93b420c2af39d48040e7d86234f4943744de1ca198c0e247edf169fc0b6a"
  end

  resource "craft-grammar" do
    url "https://files.pythonhosted.org/packages/02/d6/073514a6dd3f79fd82f73b0532df0f5dfc39c5ba548795a8c1406851e914/craft_grammar-2.0.1.tar.gz"
    sha256 "fd6d90b49f3dc1705d9a745192d61192f2eeb42ecb316d7a2b921083d7601c5a"
  end

  resource "craft-parts" do
    url "https://files.pythonhosted.org/packages/99/b4/17baee71831469c10aa77e816977fbd0e8a5d479e4db5ba6ae744af503f5/craft_parts-2.1.1.tar.gz"
    sha256 "241fd9eb8b1bb064589c8e1a910c70f8280fb6661595dcc431b8295b49d844c1"
  end

  resource "craft-platforms" do
    url "https://files.pythonhosted.org/packages/b3/a1/01dcf9fd2ff6caed32c733cad55bf5f69026561dcd8d292cfbdbee50517c/craft_platforms-0.3.0.tar.gz"
    sha256 "3c37a5dd27f5ac8c2852062e5212e7289948497cb60a7220157af3b3304dc790"
  end

  resource "craft-providers" do
    url "https://files.pythonhosted.org/packages/fc/4f/8f95d56c92c3f5c141d92d4a649724cf58ef7251008f52a72170951b6de7/craft_providers-2.0.1.tar.gz"
    sha256 "caeb36cf84c5d721800cf296e3c4bc1f419c1417f6ee1efe8fa4c076c8439f5a"
  end

  resource "craft-store" do
    url "https://files.pythonhosted.org/packages/16/8d/64c6210c14f339184daa270fc5d5dc4650e4b6d069a5e131fb767179f90b/craft_store-3.0.1.tar.gz"
    sha256 "621e5748c10a48b2592719bea28302719da42a86264d2e45dc07b55e4634f769"
  end

  resource "distro" do
    url "https://files.pythonhosted.org/packages/fc/f8/98eea607f65de6527f8a2e8885fc8015d3e6f5775df186e443e0964a11c3/distro-1.9.0.tar.gz"
    sha256 "2fa77c6fd8940f116ee1d6b94a2f90b13b5ea8d019b98bc8bafdcabcdd9bdbed"
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
    url "https://files.pythonhosted.org/packages/3d/ad/2371116b22d616c194aa25ec410c9c6c37f23599dcd590502b74db197584/httplib2-0.22.0.tar.gz"
    sha256 "d7a10bc5ef5ab08322488bde8c726eeee5c8618723fdb399597ec58f3d82df81"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "jaraco-classes" do
    url "https://files.pythonhosted.org/packages/06/c0/ed4a27bc5571b99e3cff68f8a9fa5b56ff7df1c2251cc715a652ddd26402/jaraco.classes-3.4.0.tar.gz"
    sha256 "47a024b51d0239c0dd8c8540c6c7f484be3b8fcf0b2d85c13825780d3b3f3acd"
  end

  resource "jaraco-context" do
    url "https://files.pythonhosted.org/packages/df/ad/f3777b81bf0b6e7bc7514a1656d3e637b2e8e15fab2ce3235730b3e7a4e6/jaraco_context-6.0.1.tar.gz"
    sha256 "9bae4ea555cf0b14938dc0aee7c9f32ed303aa20a3b73e7dc80111628792d1b3"
  end

  resource "jaraco-functools" do
    url "https://files.pythonhosted.org/packages/03/b1/6ca3c2052e584e9908a2c146f00378939b3c51b839304ab8ef4de067f042/jaraco_functools-4.0.2.tar.gz"
    sha256 "3460c74cd0d32bf82b9576bbb3527c4364d5b27a21f5158a62aed6c4b42e23f5"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/58/0d/c816f5ea5adaf1293a1d81d32e4cdfdaf8496973aa5049786d7fdb14e7e7/jsonschema-2.5.1.tar.gz"
    sha256 "36673ac378feed3daa5956276a829699056523d7961027911f064b52255ead41"
  end

  resource "keyring" do
    url "https://files.pythonhosted.org/packages/a5/1c/2bdbcfd5d59dc6274ffb175bc29aa07ecbfab196830e0cfbde7bd861a2ea/keyring-25.4.1.tar.gz"
    sha256 "b07ebc55f3e8ed86ac81dd31ef14e81ace9dd9c3d4b5d77a6e9a2016d0d71a1b"
  end

  resource "launchpadlib" do
    url "https://files.pythonhosted.org/packages/80/28/d1801b89af8f39e6b933840f0a2ab600fd502b67d04376d956297c36d7ef/launchpadlib-2.0.0.tar.gz"
    sha256 "5d4a9095e91773a7565d4c159594ae30eca792fd5f9b89ded459d711484a96cb"
  end

  resource "lazr-restfulclient" do
    url "https://files.pythonhosted.org/packages/ea/a3/45d80620a048c6f5d1acecbc244f00e65989914bca370a9179e3612aeec8/lazr.restfulclient-0.14.6.tar.gz"
    sha256 "43f12a1d3948463b1462038c47b429dcb5e42e0ba7f2e16511b02ba5d2adffdb"
  end

  resource "lazr-uri" do
    url "https://files.pythonhosted.org/packages/a6/db/310eaccd3639f5a8a6011c3133bb1cac7fd80bb46f8a50406df2966302e4/lazr.uri-1.0.6.tar.gz"
    sha256 "5026853fcbf6f91d5a6b11ea7860a641fe27b36d4172c731f4aa16b900cf8464"
  end

  resource "license-expression" do
    url "https://files.pythonhosted.org/packages/57/8b/dbe230196eee2de208ba87dcfae69c46db9d7ed70e2f30f143bf994ee075/license_expression-30.3.1.tar.gz"
    sha256 "60d5bec1f3364c256a92b9a08583d7ea933c7aa272c8d36d04144a89a3858c01"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/e7/6b/20c3a4b24751377aaa6307eb230b66701024012c29dd374999cc92983269/lxml-5.3.0.tar.gz"
    sha256 "4e109ca30d1edec1ac60cdbe341905dc3b8f55b16855e03a54aaf59e51ec8c6f"
  end

  resource "macaroonbakery" do
    url "https://files.pythonhosted.org/packages/4b/ae/59f5ab870640bd43673b708e5f24aed592dc2673cc72caa49b0053b4af37/macaroonbakery-1.3.4.tar.gz"
    sha256 "41ca993a23e4f8ef2fe7723b5cd4a30c759735f1d5021e990770c8a0e0f33970"
  end

  resource "more-itertools" do
    url "https://files.pythonhosted.org/packages/51/78/65922308c4248e0eb08ebcbe67c95d48615cc6f27854b6f2e57143e9178f/more-itertools-10.5.0.tar.gz"
    sha256 "5482bfef7849c25dc3c6dd53a6173ae4795da2a41a80faea6700d9f5846c5da6"
  end

  resource "mypy-extensions" do
    url "https://files.pythonhosted.org/packages/98/a4/1ab47638b92648243faf97a5aeb6ea83059cc3624972ab6b8d2316078d3f/mypy_extensions-1.0.0.tar.gz"
    sha256 "75dbf8955dc00442a438fc4d0666508a9a97b6bd41aa2f0ffe9d2f2725af0782"
  end

  resource "oauthlib" do
    url "https://files.pythonhosted.org/packages/6d/fa/fbf4001037904031639e6bfbfc02badfc7e12f137a8afa254df6c4c8a670/oauthlib-3.2.2.tar.gz"
    sha256 "9859c40929662bec5d64f34d01c99e093149682a3f38915dc0655d5a633dd918"
  end

  resource "overrides" do
    url "https://files.pythonhosted.org/packages/36/86/b585f53236dec60aba864e050778b25045f857e17f6e5ea0ae95fe80edd2/overrides-7.7.0.tar.gz"
    sha256 "55158fa3d93b98cc75299b1e67078ad9003ca27945c76162c1c0766d6f91820a"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/51/65/50db4dda066951078f0a96cf12f4b9ada6e4b811516bf0262c0f4f7064d4/packaging-24.1.tar.gz"
    sha256 "026ed72c8ed3fcce5bf8950572258698927fd1dbda10a5e981cdf0ac37f4f002"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/13/fc/128cc9cb8f03208bdbf93d3aa862e16d376844a14f9a0ce5cf4507372de4/platformdirs-4.3.6.tar.gz"
    sha256 "357fb2acbc885b0419afd3ce3ed34564c13c9b95c89360cd9563f73aa5e2b907"
  end

  resource "progressbar" do
    url "https://files.pythonhosted.org/packages/a3/a6/b8e451f6cff1c99b4747a2f7235aa904d2d49e8e1464e0b798272aa84358/progressbar-2.5.tar.gz"
    sha256 "5d81cb529da2e223b53962afd6c8ca0f05c6670e40309a7219eacc36af9b6c63"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/b1/a4/4579a61de526e19005ceeb93e478b61d77aa38c8a85ad958ff16a9906549/protobuf-5.28.2.tar.gz"
    sha256 "59379674ff119717404f7454647913787034f03fe7049cbef1d74a97bb4593f0"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/18/c7/8c6872f7372eb6a6b2e4708b88419fb46b857f7a2e1892966b851cc79fc9/psutil-6.0.0.tar.gz"
    sha256 "8faae4f310b6d969fa26ca0545338b21f73c6b15db7c4a8d934a5482faa818f2"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/1d/b2/31537cf4b1ca988837256c910a668b553fceb8f069bedc4b1c826024b52c/pycparser-2.22.tar.gz"
    sha256 "491c8be9c040f5390f5bf44a5b07752bd07f56edf992381b05c701439eec10f6"
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/a9/b7/d9e3f12af310e1120c21603644a1cd86f59060e040ec5c3a80b8f05fae30/pydantic-2.9.2.tar.gz"
    sha256 "d155cef71265d1e9807ed1c32b4c8deec042a44a50a4188b25ac67ecd81a9c0f"
  end

  resource "pydantic-core" do
    url "https://files.pythonhosted.org/packages/e2/aa/6b6a9b9f8537b872f552ddd46dd3da230367754b6f707b8e1e963f515ea3/pydantic_core-2.23.4.tar.gz"
    sha256 "2584f7cf844ac4d970fba483a717dbe10c1c1c96a969bf65d61ffe94df1b2863"
  end

  resource "pyelftools" do
    url "https://files.pythonhosted.org/packages/88/56/0f2d69ed9a0060da009f672ddec8a71c041d098a66f6b1d80264bf6bbdc0/pyelftools-0.31.tar.gz"
    sha256 "c774416b10310156879443b81187d182d8d9ee499660380e645918b50bc88f99"
  end

  resource "pygit2" do
    url "https://files.pythonhosted.org/packages/09/50/f0795db653ceda94f4388d2b40598c188aa4990715909fabcf16b381b843/pygit2-1.13.3.tar.gz"
    sha256 "0257c626011e4afb99bdb20875443f706f84201d4c92637f02215b98eac13ded"
  end

  resource "pymacaroons" do
    url "https://files.pythonhosted.org/packages/37/b4/52ff00b59e91c4817ca60210c33caf11e85a7f68f7b361748ca2eb50923e/pymacaroons-0.13.0.tar.gz"
    sha256 "1e6bba42a5f66c245adf38a5a4006a99dcc06a0703786ea636098667d42903b8"
  end

  resource "pynacl" do
    url "https://files.pythonhosted.org/packages/a7/22/27582568be639dfe22ddb3902225f91f2f17ceff88ce80e4db396c8986da/PyNaCl-1.5.0.tar.gz"
    sha256 "8ac7448f09ab85811607bdd21ec2464495ac8b7c66d146bf545b0f08fb9220ba"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/83/08/13f3bce01b2061f2bbd582c9df82723de943784cf719a35ac886c652043a/pyparsing-3.1.4.tar.gz"
    sha256 "f86ec8d1a83f11977c9a6ea7598e8c27fc5cddfa5b07ea2241edbbde1d7bc032"
  end

  resource "pyrfc3339" do
    url "https://files.pythonhosted.org/packages/00/52/75ea0ae249ba885c9429e421b4f94bc154df68484847f1ac164287d978d7/pyRFC3339-1.1.tar.gz"
    sha256 "81b8cbe1519cdb79bed04910dd6fa4e181faf8c88dff1e1b987b5f7ab23a5b1a"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/3a/31/3c70bf7603cc2dca0f19bdc53b4537a797747a58875b552c8c413d963a3f/pytz-2024.2.tar.gz"
    sha256 "2aa355083c50a0f93fa581709deac0c9ad65cca8a9e9beac660adcbd493c798a"
  end

  resource "pyxdg" do
    url "https://files.pythonhosted.org/packages/b0/25/7998cd2dec731acbd438fbf91bc619603fc5188de0a9a17699a781840452/pyxdg-0.28.tar.gz"
    sha256 "3267bb3074e934df202af2ee0868575484108581e6f3cb006af1da35395e88b4"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "raven" do
    url "https://files.pythonhosted.org/packages/79/57/b74a86d74f96b224a477316d418389af9738ba7a63c829477e7a86dd6f47/raven-6.10.0.tar.gz"
    sha256 "3fa6de6efa2493a7c827472e984ce9b020797d0da16f1db67197bcc23c8fae54"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "requests-toolbelt" do
    url "https://files.pythonhosted.org/packages/f3/61/d7545dafb7ac2230c70d38d31cbfe4cc64f7144dc41f6e4e4b78ecd9f5bb/requests-toolbelt-1.0.0.tar.gz"
    sha256 "7681a0a3d047012b5bdc0ee37d7f8f07ebe76ab08caeccfc3921ce23c88d5bc6"
  end

  resource "requests-unixsocket" do
    url "https://files.pythonhosted.org/packages/c3/ea/0fb87f844d8a35ff0dcc8b941e1a9ffc9eb46588ac9e4267b9d9804354eb/requests-unixsocket-0.3.0.tar.gz"
    sha256 "28304283ea9357d45fff58ad5b11e47708cfbf5806817aa59b2a363228ee971e"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/27/b8/f21073fde99492b33ca357876430822e4800cdf522011f18041351dfa74b/setuptools-75.1.0.tar.gz"
    sha256 "d59a21b17a275fb872a9c3dae73963160ae079f1049ed956880cd7c09b120538"
  end

  resource "simplejson" do
    url "https://files.pythonhosted.org/packages/3d/29/085111f19717f865eceaf0d4397bf3e76b08d60428b076b64e2a1903706d/simplejson-3.19.3.tar.gz"
    sha256 "8e086896c36210ab6050f2f9f095a5f1e03c83fa0e7f296d6cba425411364680"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "snap-helpers" do
    url "https://files.pythonhosted.org/packages/50/2a/221ab0a9c0200065bdd8a5d2b131997e3e19ce81832fdf8138a7f5247216/snap-helpers-0.4.2.tar.gz"
    sha256 "ef3b8621e331bb71afe27e54ef742a7dd2edd9e8026afac285beb42109c8b9a9"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/ec/fe/802052aecb21e3797b8f7902564ab6ea0d60ff8ca23952079064155d1ae1/tabulate-0.9.0.tar.gz"
    sha256 "0095b12bf5966de529c0feb1fa08671671b3368eec77d7ef7ab114be2c068b3c"
  end

  resource "tinydb" do
    url "https://files.pythonhosted.org/packages/30/0b/9e75a8d3333a6a3d9b36de04bf87a37a8d7f100035ea23c9c37bf0a112ab/tinydb-4.8.0.tar.gz"
    sha256 "6dd686a9c5a75dfa9280088fd79a419aefe19cd7f4bd85eba203540ef856d564"
  end

  resource "toml" do
    url "https://files.pythonhosted.org/packages/be/ba/1f744cdc819428fc6b5084ec34d9b30660f6f9daaf70eead706e3203ec3c/toml-0.10.2.tar.gz"
    sha256 "b3bda1d108d5dd99f4a20d24d9c348e91c4db7ab1b749200bded2f839ccbe68f"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/df/db/f35a00659bc03fec321ba8bce9420de607a1d37f8342eee1863174c69557/typing_extensions-4.12.2.tar.gz"
    sha256 "1a7ead55c7e559dd4dee8856e3a88b41225abfe1ce8df57b7c13915fe121ffb8"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e4/e8/6ff5e6bc22095cfc59b6ea711b687e2b7ed4bdb373f7eeec370a97d7392f/urllib3-1.26.20.tar.gz"
    sha256 "40c2dc0c681e47eb8f90e7e27bf6ff7df2e677421fd46756da1161c39ca70d32"
  end

  resource "validators" do
    url "https://files.pythonhosted.org/packages/64/07/91582d69320f6f6daaf2d8072608a4ad8884683d4840e7e4f3a9dbdcc639/validators-0.34.0.tar.gz"
    sha256 "647fe407b45af9a74d245b943b18e6a816acf4926974278f6dd617778e1e781f"
  end

  resource "wadllib" do
    url "https://files.pythonhosted.org/packages/35/07/040cc4cc736cdf25873848bd4c717cc25e257196a7c11f42b3a09617a961/wadllib-1.3.6.tar.gz"
    sha256 "acd9ad6a2c1007d34ca208e1da6341bbca1804c0e6850f954db04bdd7666c5fc"
  end

  def install
    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    ENV["SNAP_VERSION"] = version.to_s
    virtualenv_install_with_resources
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    assert_match version.to_s, shell_output("#{bin}/snapcraft --version")

    assert_match "Package, distribute, and update snaps", shell_output("#{bin}/snapcraft --help 2>&1")

    system bin/"snapcraft", "init"
    assert_predicate testpath/"snap/snapcraft.yaml", :exist?
  end
end
