class Browserctl < Formula
  desc "Manage default browser on macOS 13 or later"
  homepage "https://github.com/peter-bread/browserctl"
  url "https://github.com/peter-bread/browserctl/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "b94aaa820675d3fb3bec1f557d65fcf6164d5084cf38078d044dbb1f12406994"
  license "MIT"

  depends_on :macos

  on_macos do
    depends_on macos: :ventura
  end

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release"
    bin.install "./.build/release/browserctl"

    system "swift", "package", "--disable-sandbox", "plugin", "generate-manual"
    man.mkpath
    man1.install "./.build/plugins/GenerateManual/outputs/browserctl/browserctl.1"

    generate_completions_from_executable(bin/"browserctl", "--generate-completion-script")
  end

  test do
    assert_equal "OVERVIEW: A utility to manage default browser on macOS",
                  shell_output("#{bin}/browserctl --help").lines.first.chomp
  end
end
