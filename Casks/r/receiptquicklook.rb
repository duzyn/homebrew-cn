cask "receiptquicklook" do
  version "1.4"
  sha256 "709fb09f38f57f8cb1e02f2a0390046bcceaa832d014bf5ca8c60e80da60165c"

  url "https://mirror.ghproxy.com/https://github.com/letiemble/ReceiptQuickLook/releases/download/#{version}/ReceiptQuickLook.qlgenerator.zip"
  name "ReceiptQuickLook"
  desc "Quick Look plugin to visualise App Store cryptographic receipts"
  homepage "https://github.com/letiemble/ReceiptQuickLook"

  no_autobump! because: :requires_manual_review

  qlplugin "ReceiptQuickLook.qlgenerator"

  # No zap stanza required
end
