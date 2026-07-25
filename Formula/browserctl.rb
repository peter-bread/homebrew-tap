class Browserctl < Formula
  desc "Manage default browser on macOS 13 or later"
  homepage "https://github.com/peter-bread/browserctl"
  url "https://github.com/peter-bread/browserctl/archive/refs/tags/v0.2.2.tar.gz"
  sha256 "bd2a652f8e23ebdd8dea052787abdb58f04e80009644477468860aaa4b6242fb"
  license "MIT"

  bottle do
    root_url "https://github.com/peter-bread/homebrew-tap/releases/download/browserctl-0.2.2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4ba275a9070fd9e12e26ceffdee5d4a6cd5a05c1a8834aa3f07f01595c52d8c3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dba4a1081d52106b31c54b792dd88d96c2bb57e2eaaf56c45bd8c9d7cf50733e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "71c5962f41c55feee3676b63eb84a6a3a46951fb6c33f1785ec8a32a0e821800"
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
