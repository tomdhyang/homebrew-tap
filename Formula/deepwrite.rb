class Deepwrite < Formula
  desc "A terminal Markdown writing tool with Focus Mode"
  homepage "https://github.com/tomdhyang/deepwrite-tui"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/tomdhyang/deepwrite-tui/releases/download/v0.1.0/deepwrite-aarch64-apple-darwin.tar.xz"
      sha256 "4379c3f075d98648afc4e8d5f8174a6684228313790abe0796d39837203e872d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tomdhyang/deepwrite-tui/releases/download/v0.1.0/deepwrite-x86_64-apple-darwin.tar.xz"
      sha256 "3cd04d7668b7d1747c33998de33577db52142e1a5a57399df263ead720d2e3a0"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/tomdhyang/deepwrite-tui/releases/download/v0.1.0/deepwrite-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "7caf0768c6873c2f404e146232dc172a620fe05298e4bdff278d8e1dba83fdae"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tomdhyang/deepwrite-tui/releases/download/v0.1.0/deepwrite-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "8110e0986e7fec84b98081b6710871c971ddb7ac2bb38a220d2e21deec5c5474"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "deepwrite" if OS.mac? && Hardware::CPU.arm?
    bin.install "deepwrite" if OS.mac? && Hardware::CPU.intel?
    bin.install "deepwrite" if OS.linux? && Hardware::CPU.arm?
    bin.install "deepwrite" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
