class Browserctl < Formula
  desc "Manage default browser on macOS 13 or later"
  homepage "https://github.com/peter-bread/browserctl"
  url "https://github.com/peter-bread/browserctl/archive/refs/tags/v0.2.2.tar.gz"
  sha256 "bd2a652f8e23ebdd8dea052787abdb58f04e80009644477468860aaa4b6242fb"
  license "MIT"

  bottle do
    root_url "https://github.com/peter-bread/homebrew-tap/releases/download/browserctl-0.2.1"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d85c5891f7a346488815c0862810eb2d55ef4cf31e5e9db954211acc0fbf321a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e87fa4f9935cbf7dfdf90c0123ee166f994126ac9f31524df1975dbf60ea6ba3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b969fca5e6acd5bf3e9a1a89a26bc870e275dccac2956f33e0807e67ffcfe6e4"
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

    # assert_match "browserctl #{version}", shell_output("#{bin}/browserctl --version")
  end
end
