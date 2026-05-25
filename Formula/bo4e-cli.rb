class Bo4eCli < Formula
  desc "CLI for developers. It contains many useful features when working on using BO4E in your own projects."
  homepage "https://github.com/bo4e/BO4E-CLI"
  version "1.2.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/bo4e/BO4E-CLI/releases/download/v1.2.1/bo4e-cli-aarch64-apple-darwin.tar.xz"
      sha256 "67f5df2b296f333add73c0afe31e5d354e3bf68bb553cf586e01018a518ff129"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bo4e/BO4E-CLI/releases/download/v1.2.1/bo4e-cli-x86_64-apple-darwin.tar.xz"
      sha256 "190503017a09f4d34168bd914c23f91e8b417a5deeef6c804fcd9aafb6b556d3"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/bo4e/BO4E-CLI/releases/download/v1.2.1/bo4e-cli-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "74078d50e57ce91bedf82368d69e21045800093d3c7928c8cad0afd12643a64a"
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
