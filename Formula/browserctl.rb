class Browserctl < Formula
  desc "Manage default browser on macOS 13 or later"
  homepage "https://github.com/peter-bread/browserctl"
  url "https://github.com/peter-bread/browserctl/archive/refs/tags/v0.2.4.tar.gz"
  sha256 "1c70be6241bddb550e1982c220f516643acd24f5fcb10ce6c2de4a81b943bf04"
  license "MIT"

  bottle do
    root_url "https://github.com/peter-bread/homebrew-tap/releases/download/browserctl-0.2.4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4630ca34962e70a577e2476f885cbe6c148820137791972afdd9fa2ad57e7dc2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "66cdd2e9772c0bcfb7fd257205eaeb213023ca408de681c4f82cca08d0c44860"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3271ae65d5936bde477260ee4ad7bcafd51fa99e05ede97469603c7640e26e2e"
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
