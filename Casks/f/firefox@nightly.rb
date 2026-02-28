cask "firefox@nightly" do
  version "150.0a1,2026-02-27-09-06-53"

  language "ca" do
    sha256 "0e5df03f0529a43080b4c7037e1edab4a51718721f0826daf41b81c2ed0d5cca"
    "ca"
  end
  language "cs" do
    sha256 "d708d75ab8da53a44f11e3ffbab017b1fc89894e308fdeb5aa4b1f01db67c8ae"
    "cs"
  end
  language "de" do
    sha256 "1bccce5bb233386178d1d4a34dcc87f351bee89e0c7c9b7c1a3243d44a673c18"
    "de"
  end
  language "en-CA" do
    sha256 "44772374ffd8b5dd5c376055df58584709c009e438e97953724bb07e9ef97d20"
    "en-CA"
  end
  language "en-GB" do
    sha256 "360cdb09f264034217c07208a057c263eb74c7def8774364eec92c3a5092b376"
    "en-GB"
  end
  language "en", default: true do
    sha256 "3a3d4f2d78a96f5bcac2e182c66c54648c3347ab7d8b3e61f6555da26c5e62a7"
    "en-US"
  end
  language "es" do
    sha256 "2bf2f46a53473fc1a0356b55765cebd9526b7bb5f11417f05e90af3a59db24ef"
    "es-ES"
  end
  language "fr" do
    sha256 "488e6ca097f16c10c57da3e6d280f859452bcb73b8c6f9298e4dcab039fb47a7"
    "fr"
  end
  language "it" do
    sha256 "f1302b3f99a90be80228c24b258d4b4ff5842d1fdad2eb37d20a934f99f8a4e9"
    "it"
  end
  language "ja" do
    sha256 "67eef51defa46b6e11ece25f3faa75d6fee5a4bde5c6a46378ee5d7776c99352"
    "ja-JP-mac"
  end
  language "ko" do
    sha256 "a789f02257f97950703715dfcab064b06b533a80dd82ba37b66df6c09917a36e"
    "ko"
  end
  language "nl" do
    sha256 "d6e59b94ba10f27ea30e8b5bc89318c8489ecf9366c78b3966c1d15a71a394d4"
    "nl"
  end
  language "pt-BR" do
    sha256 "c65f56487beec491044a37efad092c1249b1beba32f8cfadce27cd9322e5de3b"
    "pt-BR"
  end
  language "ru" do
    sha256 "72e225d66df6071ae751e8ceae1554cad00dd9489c620ac0b62d71e32809ce02"
    "ru"
  end
  language "uk" do
    sha256 "b12240e23c5d31eade0ce516c207ddfbb5bed47436132919d5c060bcaa2be61a"
    "uk"
  end
  language "zh-TW" do
    sha256 "29641e5bc0d204a512f5ea7897a83fdc202cc9db84f54a72f53655cfa5ba10ab"
    "zh-TW"
  end
  language "zh" do
    sha256 "cd71ccab14ed98c6d93f270d958ec1a0d9d9af3f4612e3f3cf7d179c92cb1579"
    "zh-CN"
  end

  url "https://ftp.mozilla.org/pub/firefox/nightly/#{version.csv.second.split("-").first}/#{version.csv.second.split("-").second}/#{version.csv.second}-mozilla-central#{"-l10n" if language != "en-US"}/firefox-#{version.csv.first}.#{language}.mac.dmg"
  name "Mozilla Firefox Nightly"
  desc "Web browser"
  homepage "https://www.mozilla.org/firefox/channel/desktop/#nightly"

  livecheck do
    url "https://product-details.mozilla.org/1.0/firefox_versions.json"
    regex(%r{/(\d+(?:[._-]\d+)+)[^/]*/firefox}i)
    strategy :json do |json, regex|
      version = json["FIREFOX_NIGHTLY"]
      next if version.blank?

      content = Homebrew::Livecheck::Strategy.page_content("https://ftp.mozilla.org/pub/firefox/nightly/latest-mozilla-central/firefox-#{version}.en-US.mac.buildhub.json")
      next if content[:content].blank?

      build_json = Homebrew::Livecheck::Strategy::Json.parse_json(content[:content])
      build = build_json.dig("download", "url")&.[](regex, 1)
      next if build.blank?

      "#{version},#{build}"
    end
  end

  auto_updates true

  app "Firefox Nightly.app"

  zap trash: [
        "/Library/Logs/DiagnosticReports/firefox_*",
        "~/Library/Application Support/com.apple.sharedfilelist/com.apple.LSSharedFileList.ApplicationRecentDocuments/org.mozilla.firefox.sfl*",
        "~/Library/Application Support/CrashReporter/firefox_*",
        "~/Library/Application Support/Firefox",
        "~/Library/Caches/Firefox",
        "~/Library/Caches/Mozilla/updates/Applications/Firefox",
        "~/Library/Caches/org.mozilla.firefox",
        "~/Library/Preferences/org.mozilla.firefox.plist",
        "~/Library/Saved Application State/org.mozilla.firefox.savedState",
        "~/Library/WebKit/org.mozilla.firefox",
      ],
      rmdir: [
        "~/Library/Application Support/Mozilla", #  May also contain non-Firefox data
        "~/Library/Caches/Mozilla",
        "~/Library/Caches/Mozilla/updates",
        "~/Library/Caches/Mozilla/updates/Applications",
      ]
end
