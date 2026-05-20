class Bo4eCli < Formula
  desc "CLI for developers. It contains many useful features when working on using BO4E in your own projects."
  homepage "https://github.com/bo4e/BO4E-CLI"
  version "1.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/bo4e/BO4E-CLI/releases/download/v1.1.1/bo4e-cli-aarch64-apple-darwin.tar.xz"
      sha256 "b4f8363705a21a5bb66ac5b8802f6a559a91671a9ab37f276174b72c72fb0b9b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bo4e/BO4E-CLI/releases/download/v1.1.1/bo4e-cli-x86_64-apple-darwin.tar.xz"
      sha256 "493cf867c3ef8ddf4c5c95946e848f06fa19c17dd03ee6687b6e87731ba0fbc2"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/bo4e/BO4E-CLI/releases/download/v1.1.1/bo4e-cli-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "d25da19d89a88c403292dd1b8a7c6d956c3de243416fe64fbbf16fb9532e4ac0"
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":     {},
    "x86_64-apple-darwin":      {},
    "x86_64-pc-windows-gnu":    {},
    "x86_64-unknown-linux-gnu": {},
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
    bin.install "bo4e" if OS.mac? && Hardware::CPU.arm?
    bin.install "bo4e" if OS.mac? && Hardware::CPU.intel?
    bin.install "bo4e" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
