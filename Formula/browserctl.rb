class Browserctl < Formula
  desc "Manage default browser on macOS 13 or later"
  homepage "https://github.com/peter-bread/browserctl"
  url "https://github.com/peter-bread/browserctl/archive/refs/tags/v0.2.3.tar.gz"
  sha256 "e61566eceafccf73a22136e7a02a535c2f13eda06b4eda325b98d27b04a983af"
  license "MIT"

  bottle do
    root_url "https://github.com/peter-bread/homebrew-tap/releases/download/browserctl-0.2.3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d8add0794e13582953aeba252f94cace9c46ff3d5cd6ef62568925499ab765fd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7dbe730d7236057ad7b2dce75191c695a627cb0d362779ec4233fb361fcc8362"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b9884070dded7fdd654230f0166fc7788a002536f22ed51bdaf5bdce42b64a10"
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
