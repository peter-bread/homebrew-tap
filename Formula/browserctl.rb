class Browserctl < Formula
  desc "Manage default browser on macOS 13 or later"
  homepage "https://github.com/peter-bread/browserctl"
  url "https://github.com/peter-bread/browserctl/archive/refs/tags/v0.2.4.tar.gz"
  sha256 "1c70be6241bddb550e1982c220f516643acd24f5fcb10ce6c2de4a81b943bf04"
  license "MIT"

  bottle do
    root_url "https://github.com/peter-bread/homebrew-tap/releases/download/browserctl-0.2.4"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1491ed12715afdf0d38154218c405ab8b62172c531909c3eaf357e9c90025412"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2be8888f7cb1350f25f7ee9c55c674d40911643c8e8770e250a56ca0e6b1f9d0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "506c68148e4901f00e11fdc4ba5c8559ac3b6bae9713847d0d6c1ffadbb3b397"
  end

  depends_on :macos

  on_macos do
    depends_on macos: :ventura
  end

  def install
    browserctl_version = version.to_s
    build = Pathname(".build")

    with_env("BROWSERCTL_VERSION" => browserctl_version) do
      system "make", "release"
    end
    bin.install build/"release/browserctl"

    system "make", "man"
    man.mkpath
    man1.install build/"plugins/GenerateManual/outputs/browserctl/browserctl.1"

    generate_completions_from_executable(bin/"browserctl", "--generate-completion-script")
  end

  test do
    assert_equal "OVERVIEW: A utility to manage default browser on macOS",
                  shell_output("#{bin}/browserctl --help").lines.first.chomp

    assert_match "browserctl #{version}", shell_output("#{bin}/browserctl --version")
  end
end
