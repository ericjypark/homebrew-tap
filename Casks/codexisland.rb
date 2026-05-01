cask "codexisland" do
  version "0.0.10"
  sha256 "d1995c222ca801820a095173b1047d1b4a4451f83dc83c582fdb436d52567451"

  url "https://github.com/ericjypark/codex-island/releases/download/v#{version}/CodexIsland-#{version}.dmg"
  name "CodexIsland"
  desc "Notch-based live activity for Claude Code and Codex API rate limits"
  homepage "https://github.com/ericjypark/codex-island"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "CodexIsland.app"

  # Homebrew removed --no-quarantine in late 2025. CodexIsland is unsigned by
  # Apple (Sparkle handles update verification independently), so without this
  # the first launch hits a "damaged or unidentified developer" Gatekeeper
  # block.
  #
  # MUST be -dr (recursive). Sparkle.framework ships nested helpers
  # (Updater.app + Installer.xpc + Downloader.xpc); macOS refuses to spawn
  # quarantined helpers from a non-quarantined parent, which surfaces as
  # "The updater failed to start" inside the app.
  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-dr", "com.apple.quarantine", "#{appdir}/CodexIsland.app"],
                   sudo: false
  end

  zap trash: [
    "~/Library/Preferences/dev.codexisland.CodexIsland.plist",
    "~/Library/Application Support/CodexIsland",
  ]
end
