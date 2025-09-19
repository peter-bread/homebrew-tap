class Gamon3 < Formula
  desc "Automatically switch GitHub CLI account on `cd`"
  homepage "https://github.com/peter-bread/gamon3"
  url "https://github.com/peter-bread/gamon3/archive/refs/tags/v1.1.2.tar.gz"
  sha256 "d277027a0b321f03ef998672481de4524ec0ed4614d361495cff5f0a3553421f"
  license "MIT"
  head "https://github.com/peter-bread/gamon3.git", branch: "main"

  bottle do
    root_url "https://github.com/peter-bread/homebrew-tap/releases/download/gamon3-1.1.1"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "00ea5db878816a70ed9858db3e2926bf34139a5d7d7910f0ca46ee06ccee4d13"
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
