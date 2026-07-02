class Bo4eCli < Formula
  desc "CLI for developers. It contains many useful features when working on using BO4E in your own projects."
  homepage "https://github.com/bo4e/BO4E-CLI"
  version "1.2.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/bo4e/BO4E-CLI/releases/download/v1.2.4/bo4e-cli-aarch64-apple-darwin.tar.xz"
      sha256 "ab34cb3ba4ff53c95769086f2b3e455a9f1b6234a624e18e851a003a26d8f942"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bo4e/BO4E-CLI/releases/download/v1.2.4/bo4e-cli-x86_64-apple-darwin.tar.xz"
      sha256 "07bab44f9e8d2605967d2b2cf540e121d1fe463b7b47fd57b36ba5b54885c95e"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/bo4e/BO4E-CLI/releases/download/v1.2.4/bo4e-cli-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "ab712e2d7b91767e4415e72aae68c9c5646f93d4f39d0e028fa4c48737d10461"
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
