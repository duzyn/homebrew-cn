cask "mactex" do
  version "2025.0308"
  sha256 "be084f849e545d9e9511b791da07ca4f9f33d85d42bb69dade636e345421ab7c"

  url "https://mirrors.aliyun.com/CTAN/systems/mac/mactex/mactex-#{version.no_dots}.pkg",
      verified: "mirrors.aliyun.com/CTAN/systems/mac/mactex/"
  name "MacTeX"
  desc "Full TeX Live distribution with GUI applications"
  homepage "https://www.tug.org/mactex/"

  livecheck do
    url "https://ctan.org/texarchive/systems/mac/mactex/"
    regex(/href=.*?mactex[._-](\d{4})(\d{2})(\d{2})\.pkg/i)
    strategy :page_match do |page, regex|
      match = page.match(regex)
      next if match.blank?

      "#{match[1]}.#{match[2]}#{match[3]}"
    end
  end

  no_autobump! because: :requires_manual_review

  conflicts_with cask: [
    "basictex",
    "mactex-no-gui",
  ]
  depends_on formula: "ghostscript"
  depends_on macos: ">= :mojave"

  pkg "mactex-#{version.no_dots}.pkg",
      choices: [
        {
          # Ghostscript
          "choiceIdentifier" => "org.tug.mactex.ghostscript10.04.0",
          "choiceAttribute"  => "selected",
          "attributeSetting" => 0,
        },
        {
          # Ghostscript Dynamic Library
          "choiceIdentifier" => "org.tug.mactex.ghostscript10.04.0-libgs",
          "choiceAttribute"  => "selected",
          "attributeSetting" => 0,
        },
        {
          # Ghostscript Mutool
          "choiceIdentifier" => "org.tug.mactex.ghostscript10.04.0-mutool",
          "choiceAttribute"  => "selected",
          "attributeSetting" => 0,
        },
        {
          # GUI Applications
          "choiceIdentifier" => "org.tug.mactex.gui#{version.major}",
          "choiceAttribute"  => "selected",
          "attributeSetting" => 1,
        },
        {
          # TeX Live
          "choiceIdentifier" => "org.tug.mactex.texlive#{version.major}",
          "choiceAttribute"  => "selected",
          "attributeSetting" => 1,
        },
      ]

  uninstall pkgutil: [
              "org.tug.mactex.gui#{version.major}",
              "org.tug.mactex.texlive#{version.major}",
            ],
            delete:  [
              "/Applications/TeX",
              "/etc/manpaths.d/TeX",
              "/etc/paths.d/TeX",
              "/Library/TeX",
              "/usr/local/texlive/#{version.major}",
            ]

  zap trash: [
        "/usr/local/texlive/texmf-local",
        "~/Library/Application Scripts/*.fr.chachatelier.pierre.LaTeXiT",
        "~/Library/Application Scripts/fr.chachatelier.pierre.LaTeXiT.appex",
        "~/Library/Application Support/BibDesk",
        "~/Library/Application Support/com.apple.sharedfilelist/*/fr.chachatelier.pierre.latexit.sfl*",
        "~/Library/Application Support/com.apple.sharedfilelist/com.apple.LSSharedFileList.ApplicationRecentDocuments/texshop.sfl*",
        "~/Library/Application Support/LaTeXiT",
        "~/Library/Application Support/TeX Live Utility",
        "~/Library/Application Support/TeXShop",
        "~/Library/Caches/com.apple.helpd/Generated/edu.ucsd.cs.mmccrack.bibdesk.help*",
        "~/Library/Caches/com.apple.helpd/Generated/TeX Live Utility Help*",
        "~/Library/Caches/com.apple.helpd/Generated/TeXShop Help*",
        "~/Library/Caches/edu.ucsd.cs.mmccrack.bibdesk",
        "~/Library/Caches/fr.chachatelier.pierre.LaTeXiT",
        "~/Library/Caches/TeXShop",
        "~/Library/Containers/fr.chachatelier.pierre.LaTeXiT.appex",
        "~/Library/Cookies/edu.ucsd.cs.mmccrack.bibdesk.binarycookies",
        "~/Library/Cookies/fr.chachatelier.pierre.LaTeXiT.binarycookies",
        "~/Library/Group Containers/*.fr.chachatelier.pierre.LaTeXiT",
        "~/Library/HTTPStorages/fr.chachatelier.pierre.LaTeXiT",
        "~/Library/HTTPStorages/TeXShop",
        "~/Library/Preferences/edu.ucsd.cs.mmccrack.bibdesk.plist",
        "~/Library/Preferences/fr.chachatelier.pierre.LaTeXiT.plist",
        "~/Library/Preferences/TeXShop.plist",
        "~/Library/texlive",
        "~/Library/TeXShop",
        "~/Library/WebKit/fr.chachatelier.pierre.LaTeXiT",
        "~/Library/WebKit/TeXShop",
      ],
      rmdir: "/usr/local/texlive"

  caveats <<~EOS
    You must restart your terminal window for the installation of MacTeX CLI
    tools to take effect.

    Alternatively, Bash and Zsh users can run the command:

      eval "$(/usr/libexec/path_helper)"
  EOS
end
