class Gamon3 < Formula
  desc "Automatically switch GitHub CLI account on `cd`"
  homepage "https://github.com/peter-bread/gamon3"
  url "https://github.com/peter-bread/gamon3/archive/refs/tags/v2.0.3.tar.gz"
  sha256 "b414609f40859aa1c5b6cbe14ace84c784c713b88d5d23da404e5dac00363509"
  license "MIT"
  head "https://github.com/peter-bread/gamon3.git", branch: "main"

  bottle do
    root_url "https://github.com/peter-bread/homebrew-tap/releases/download/gamon3-2.0.0"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "e201a1f361753a2c7df0ae52fb01ba89c4d1711ed46a403707087e99ef725e5c"
  end

  depends_on "go" => :build
  depends_on "gh"

  def install
    gamon3_version = if build.stable?
      version.to_s
    else
      Utils.safe_popen_read("git", "describe", "--tags", "--dirty").chomp
    end

    ldflags = %W[
      -s -w
      -X main.version=#{gamon3_version}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "-o", "bin/gamon3"
    bin.install "bin/gamon3"

    generate_completions_from_executable(bin/"gamon3", "completion")
  end

  test do
    assert_match "gamon3 version #{version}", shell_output("#{bin}/gamon3 --version")
  end
end
