class Bo4eCli < Formula
  desc "CLI for developers. It contains many useful features when working on using BO4E in your own projects."
  homepage "https://github.com/bo4e/BO4E-CLI"
  version "1.4.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/bo4e/BO4E-CLI/releases/download/v1.4.0/bo4e-cli-aarch64-apple-darwin.tar.xz"
      sha256 "e9ed8b6acb528d87da159745786ff28adb62f0f65f21a417950f9314a64412fb"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bo4e/BO4E-CLI/releases/download/v1.4.0/bo4e-cli-x86_64-apple-darwin.tar.xz"
      sha256 "fc657ae9f545d093f7ed62af3625ce1a8929b01b814f60367b22d136df01caa6"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/bo4e/BO4E-CLI/releases/download/v1.4.0/bo4e-cli-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "7253386ed6cced4b1b988171396ee4999e22bf6722ce6e727638fb48a57cc865"
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "bo4e"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "bo4e"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "bo4e"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
