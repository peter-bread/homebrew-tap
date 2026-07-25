class Browserctl < Formula
  desc "Manage default browser on macOS 13 or later"
  homepage "https://github.com/peter-bread/browserctl"
  url "https://github.com/peter-bread/browserctl/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "d347d8be511e7ed4a944de26287b6755a652e05f6c2114de3576172fc8d9d32c"
  license "MIT"

  bottle do
    root_url "https://github.com/peter-bread/homebrew-tap/releases/download/browserctl-0.2.1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "343d538dd1ad5195596487de346ce0f0fa1ff00212b96168c3feda933c62932f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "46b453dacd88f9e91b13b8f9a8bb2c1577e4a60de9ede44f711feaa291019a69"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e50127ab7c76f3755dc8a8c031a560fe2253ab40bec5989554154f717fc73d89"
  end

  depends_on :macos

  on_macos do
    depends_on macos: :ventura
  end

  def install
    browserctl_version = version.to_s

    with_env("BROWSERCTL_VERSION" => browserctl_version) do
      system "swift", "build", "--disable-sandbox", "-c", "release"
    end
    bin.install "./.build/release/browserctl"

    system "swift", "package", "--disable-sandbox", "plugin", "generate-manual"
    man.mkpath
    man1.install "./.build/plugins/GenerateManual/outputs/browserctl/browserctl.1"

    generate_completions_from_executable(bin/"browserctl", "--generate-completion-script")
  end

  test do
    assert_equal "OVERVIEW: A utility to manage default browser on macOS",
                  shell_output("#{bin}/browserctl --help").lines.first.chomp

    assert_match "browserctl #{version}", shell_output("#{bin}/browserctl --version")
  end
end
