cask "kekaexternalhelper" do
  version "1.2.0,1.4.4"
  sha256 "6857bb22694b6f6c01a13c40953b0a04b1704acf90da414a7476be63961d9827"

  url "https://mirror.ghproxy.com/https://github.com/aonez/Keka/releases/download/v#{version.csv.second}/KekaExternalHelper-v#{version.csv.first}.zip"
  name "Keka External Helper"
  name "KekaDefaultApp"
  desc "Helper application for the Keka file archiver"
  homepage "https://github.com/aonez/Keka/wiki/Default-application"

  # We can identify the version from the `location` header of the first
  # response from https://d.keka.io/helper/ but we need to be able to either not
  # follow redirections (i.e., omit `--location` from curl args) or iterate
  # through the headers for all responses (not the hash of merged headers,
  # where only the last `location` header is available).
  livecheck do
    skip "Cannot identify version without access to all headers"
  end

  app "KekaExternalHelper.app"

  zap trash: [
    "~/Library/Containers/com.aone.keka",
    "~/Library/Saved Application State/com.aone.KekaExternalHelper.savedState",
  ]
end
