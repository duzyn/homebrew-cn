cask "font-ibm-plex-sans-kr" do
  version "1.0.0"
  sha256 "b977effaabce2328f888db8590f0989c162cb9a9aad9d70949f3910552e6652b"

  url "https://github.com/IBM/plex/releases/download/%40ibm%2Fplex-sans-kr%40#{version}/ibm-plex-sans-kr.zip"
  name "IBM Plex Sans KR"
  homepage "https://github.com/IBM/plex"

  livecheck do
    url :url
    regex(%r{^@ibm/plex-sans-kr@?(\d+(?:\.\d+)+)$}i)
  end

  font "ibm-plex-sans-kr/fonts/complete/otf/IBMPlexSansKR-Bold.otf"
  font "ibm-plex-sans-kr/fonts/complete/otf/IBMPlexSansKR-ExtraLight.otf"
  font "ibm-plex-sans-kr/fonts/complete/otf/IBMPlexSansKR-Light.otf"
  font "ibm-plex-sans-kr/fonts/complete/otf/IBMPlexSansKR-Medium.otf"
  font "ibm-plex-sans-kr/fonts/complete/otf/IBMPlexSansKR-Regular.otf"
  font "ibm-plex-sans-kr/fonts/complete/otf/IBMPlexSansKR-SemiBold.otf"
  font "ibm-plex-sans-kr/fonts/complete/otf/IBMPlexSansKR-Text.otf"
  font "ibm-plex-sans-kr/fonts/complete/otf/IBMPlexSansKR-Thin.otf"

  # No zap stanza required
end
