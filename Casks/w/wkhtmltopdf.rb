cask "wkhtmltopdf" do
  version "0.12.6-2"
  sha256 "81a66b77b508fede8dbcaa67127203748376568b3673a17f6611b6d51e9894f8"

  url "https://mirror.ghproxy.com/https://github.com/wkhtmltopdf/packaging/releases/download/#{version}/wkhtmltox-#{version}.macos-cocoa.pkg",
      verified: "github.com/wkhtmltopdf/packaging/"
  name "wkhtmltopdf"
  desc "HTML to PDF renderer"
  homepage "https://wkhtmltopdf.org/"

  no_autobump! because: :requires_manual_review

  disable! date: "2024-12-16", because: :discontinued

  pkg "wkhtmltox-#{version}.macos-cocoa.pkg"

  uninstall script:  {
              executable: "/usr/local/bin/uninstall-wkhtmltox",
              sudo:       true,
            },
            pkgutil: "org.wkhtmltopdf.wkhtmltox",
            delete:  [
              "/usr/local/bin/wkhtmltoimage",
              "/usr/local/bin/wkhtmltopdf",
              "/usr/local/include/wkhtmltox",
              "/usr/local/lib/libwkhtmltox.#{version.major_minor}.dylib",
              "/usr/local/lib/libwkhtmltox.#{version.major}.dylib",
              "/usr/local/lib/libwkhtmltox.#{version.sub(/-.*$/, "")}.dylib",
              "/usr/local/lib/libwkhtmltox.dylib",
            ]

  # No zap stanza required

  caveats do
    files_in_usr_local
  end
end
