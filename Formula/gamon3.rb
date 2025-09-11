class Gamon3 < Formula
  desc "Automatically switch GitHub CLI account on `cd`"
  homepage "https://github.com/peter-bread/gamon3"
  url "https://github.com/peter-bread/gamon3/archive/refs/tags/v1.0.7.tar.gz"
  sha256 "7bfaa4099adae82158a889650b7f9657f3ce9bf873dc0d99d5c4149012ac9d68"
  license "MIT"
  head "https://github.com/peter-bread/gamon3.git", branch: "main"

  bottle do
    root_url "https://github.com/peter-bread/homebrew-tap/releases/download/gamon3-1.0.7"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "aaae8a4720611909343e322354e0f1be2472d61fc3ef0c57ea46691425dbdec6"
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
