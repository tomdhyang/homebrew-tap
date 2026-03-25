class Deepwrite < Formula
  desc "A terminal Markdown writing tool with Focus Mode"
  homepage "https://github.com/tomdhyang/deepwrite-tui"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/tomdhyang/deepwrite-tui/releases/download/v0.2.0/deepwrite-aarch64-apple-darwin.tar.xz"
      sha256 "81ff4bdaf4246da300f1ce20bd41d07ad451c8dcb6606118174f5a069b873075"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tomdhyang/deepwrite-tui/releases/download/v0.2.0/deepwrite-x86_64-apple-darwin.tar.xz"
      sha256 "26f35d4804c9e4044e13718ac50de1ffcda08579b28089cdcc348d494a4c7bc2"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/tomdhyang/deepwrite-tui/releases/download/v0.2.0/deepwrite-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "47d90d85f37d66ea6f2b74f022de3afa4ef85b85bca201146fd9bb1604ce6f14"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tomdhyang/deepwrite-tui/releases/download/v0.2.0/deepwrite-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "b974776b0f8158b4fd3601599710e94553ff29901449943ac59112ad9df7563c"
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
