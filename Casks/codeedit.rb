cask "codeedit" do
  version "0.0.3-alpha.36,5650b45"
  sha256 "5faeabb324bcf3fc822244e8f309098ede05b8f38c27f6de8dc10da11c43a6c1"

  url "https://ghproxy.com/https://github.com/CodeEditApp/CodeEdit/releases/download/#{version.csv.first}/CodeEdit-#{version.csv.second}.dmg",
      verified: "github.com/CodeEditApp/CodeEdit/"
  name "CodeEdit"
  desc "Code editor"
  homepage "https://www.codeedit.app/"

  livecheck do
    url "https://github.com/CodeEditApp/CodeEdit/releases/latest"
    regex(%r{href=.*?/download/\D*?([^/]+?)/CodeEdit[._-]([a-f0-9]+)\.dmg}i)
    strategy :header_match do |headers, regex|
      next if headers["location"].blank?

      # Identify the latest tag from the response's `location` header
      latest_tag = File.basename(headers["location"])
      next if latest_tag.blank?

      # Fetch the assets list HTML for the latest tag and match within it
      assets_page = Homebrew::Livecheck::Strategy.page_content(
        @url.sub(%r{/releases/?.+}, "/releases/expanded_assets/#{latest_tag}"),
      )
      assets_page[:content]&.scan(regex)&.map { |match| "#{match[0]},#{match[1]}" }
    end
  end

  depends_on macos: ">= :ventura"

  app "CodeEdit.app"

  zap trash: [
    "~/Library/Application Scripts/*.CodeEdit.OpenWithCodeEdit",
    "~/Library/Application Support/CodeEdit",
    "~/Library/Application Support/com.apple.sharedfilelist/com.apple.LSSharedFileList.ApplicationRecentDocuments/*.codeedit.sfl2",
    "~/Library/Caches/*.CodeEdit",
    "~/Library/Containers/*.CodeEdit.OpenWithCodeEdit",
    "~/Library/HTTPStorages/*.CodeEdit",
    "~/Library/Preferences/*.CodeEdit.plist",
    "~/Library/Saved Application State/*.CodeEdit.savedState",
  ]
end
