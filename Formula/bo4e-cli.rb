class Bo4eCli < Formula
  desc "CLI for developers. It contains many useful features when working on using BO4E in your own projects."
  homepage "https://github.com/bo4e/BO4E-CLI"
  version "1.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/bo4e/BO4E-CLI/releases/download/v1.3.0/bo4e-cli-aarch64-apple-darwin.tar.xz"
      sha256 "7c4a9d55a41cd119735da5a7f47236a503a36cd44cd586ef16d6cf3fcd6cc3a5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bo4e/BO4E-CLI/releases/download/v1.3.0/bo4e-cli-x86_64-apple-darwin.tar.xz"
      sha256 "bf2b94ef9777fd692d016631c8c83505540f0002ab3d09357445af23b2e13a86"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/bo4e/BO4E-CLI/releases/download/v1.3.0/bo4e-cli-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "1ca50296f0c40e0be8edf50b7a5d4dd3b684e6401c575829822c6cc1206b993b"
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
