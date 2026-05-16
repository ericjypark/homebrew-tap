cask "codexisland" do
  version "0.1.7"
  sha256 "66d896848da57d5b40e518a1c39b67d38c31267d33a3f149b4f8d94c5b016969"

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
