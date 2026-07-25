class Browserctl < Formula
  desc "Manage default browser on macOS 13 or later"
  homepage "https://github.com/peter-bread/browserctl"
  url "https://github.com/peter-bread/browserctl/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "d347d8be511e7ed4a944de26287b6755a652e05f6c2114de3576172fc8d9d32c"
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
