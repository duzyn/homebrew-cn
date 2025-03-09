cask "kitty" do
  version "0.40.0"
  sha256 "65d2f2002d5c1304a28d30458dab81569fda3ecb6d85d36f55e3164b313bcf7c"

  url "https://mirror.ghproxy.com/https://github.com/kovidgoyal/kitty/releases/download/v#{version}/kitty-#{version}.dmg"
  name "kitty"
  desc "GPU-based terminal emulator"
  homepage "https://github.com/kovidgoyal/kitty"

  conflicts_with cask: "kitty@nightly"
  depends_on macos: ">= :big_sur"

  app "kitty.app"
  # shim script (https://github.com/Homebrew/homebrew-cask/issues/18809)
  kitty_shimscript = "#{staged_path}/kitty.wrapper.sh"
  binary kitty_shimscript, target: "kitty"
  # shim script (https://github.com/Homebrew/homebrew-cask/issues/18809)
  kitten_shimscript = "#{staged_path}/kitten.wrapper.sh"
  binary kitten_shimscript, target: "kitten"

  preflight do
    File.write kitty_shimscript, <<~EOS
      #!/bin/sh
      exec '#{appdir}/kitty.app/Contents/MacOS/kitty' "$@"
    EOS
    File.write kitten_shimscript, <<~EOS
      #!/bin/sh
      exec '#{appdir}/kitty.app/Contents/MacOS/kitten' "$@"
    EOS
  end

  zap trash: [
    "~/.config/kitty",
    "~/Library/Caches/kitty",
    "~/Library/Preferences/kitty",
    "~/Library/Preferences/net.kovidgoyal.kitty.plist",
    "~/Library/Saved Application State/net.kovidgoyal.kitty.savedState",
  ]
end
