class Deepwrite < Formula
  desc "A terminal Markdown writing tool with Focus Mode"
  homepage "https://github.com/tomdhyang/deepwrite-tui"
  version "0.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/tomdhyang/deepwrite-tui/releases/download/v0.3.0/deepwrite-aarch64-apple-darwin.tar.xz"
      sha256 "a5b021a2c9e45586df1086c43a2cc4ad6ddb881ef7b58649c8c705bee53c93fa"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tomdhyang/deepwrite-tui/releases/download/v0.3.0/deepwrite-x86_64-apple-darwin.tar.xz"
      sha256 "99a55a73ef509231e71fcb42f80bdb5acb505b60140db423ee02865d75110717"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/tomdhyang/deepwrite-tui/releases/download/v0.3.0/deepwrite-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "b9a9734742d80e3d9631a242b3ff6759f04f19d19e2948718c54e0e0355795e7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tomdhyang/deepwrite-tui/releases/download/v0.3.0/deepwrite-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "a83716a075b0d56d04d9e62f19340746c2be5908f9a3178fbcaa44d5ef94748e"
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
