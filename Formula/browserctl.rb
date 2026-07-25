class Browserctl < Formula
  desc "Manage default browser on macOS 13 or later"
  homepage "https://github.com/peter-bread/browserctl"
  url "https://github.com/peter-bread/browserctl/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "b94aaa820675d3fb3bec1f557d65fcf6164d5084cf38078d044dbb1f12406994"
  license "MIT"

  bottle do
    root_url "https://github.com/peter-bread/homebrew-tap/releases/download/browserctl-0.1.1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3d3302f7fa05fd925a459eb1e9655fe34fa1a325b5d6d90474b5ad905c619946"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "96db1f4c2a3b80e8e27c31397a15dcae1b70b3ff048eff3985f313bbec8f1562"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6ad06bd1d756de0f1f2a7cd0de43c48886c55ab0b1020220d3ed1c355b49ec6c"
  end

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
