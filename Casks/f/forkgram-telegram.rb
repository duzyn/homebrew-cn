cask "forkgram-telegram" do
  arch arm: "arm64", intel: "x86"

  version "5.6.2"
  sha256 arm:   "65c0f70c8923c7e7395e58b947dddd846a3680dc4e9655e2208a2d5b3b39da58",
         intel: "f7c31e52a6944600b4932add6bb979277f3404a41e276395c3b860088d5ddfef"

  url "https://mirror.ghproxy.com/https://github.com/Forkgram/tdesktop/releases/download/v#{version}/Forkgram.macOS.no.auto-update_#{arch}.zip"
  name "Forkgram"
  desc "Fork of Telegram Desktop"
  homepage "https://github.com/Forkgram/"

  # Not every GitHub release provides a file for macOS, so we check multiple
  # recent releases instead of only the "latest" release.
  livecheck do
    url :url
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_releases do |json, regex|
      file_regex = /^Forkgram[._-]macOS[._-].*?#{arch}\.zip$/i

      json.map do |release|
        next if release["draft"] || release["prerelease"]
        next unless release["assets"]&.any? { |asset| asset["name"]&.match?(file_regex) }

        match = release["tag_name"].match(regex)
        next if match.blank?

        match[1]
      end
    end
  end

  # Renamed to avoid conflict with telegram
  app "Telegram.app", target: "Forkgram.app"

  zap trash: "~/Library/Application Support/Forkgram Desktop"
end
