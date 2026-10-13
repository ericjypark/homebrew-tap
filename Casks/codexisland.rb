cask "codexisland" do
  version "0.4.1"
  sha256 "396a71cb73357d904df10c6371d38195cf9707568941d1238db8fcf61b641b7f"

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
