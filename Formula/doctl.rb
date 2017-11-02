class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://github.com/digitalocean/doctl"
  url "https://github.com/digitalocean/doctl/archive/v1.7.1.tar.gz"
  sha256 "6c47b5ce9c4739499732be96b914cecbad9135088504351601b75a9608d19d64"
  head "https://github.com/digitalocean/doctl.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "175bf088544b6a01663f661b9563e2ecf3a2b8469d9ae45cb0e885478fb36a8c" => :high_sierra
    sha256 "91142c1734b590aea0d24f0716f8c126471698825f671f01ddaca0d86389db21" => :sierra
    sha256 "932da2905bd465a88208e35b02af1aa70503a2b676cca4c1e5be24bf6d36eaa6" => :el_capitan
    sha256 "e18e04be0fe3df236eaf4b35873ce544be6752948cb348c88b72e753d6fca22c" => :yosemite
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    mkdir_p buildpath/"src/github.com/digitalocean/"
    ln_sf buildpath, buildpath/"src/github.com/digitalocean/doctl"

    doctl_version = version.to_s.split(/\./)
    base_flag = "-X github.com/digitalocean/doctl"
    ldflags = %W[
      #{base_flag}.Major=#{doctl_version[0]}
      #{base_flag}.Minor=#{doctl_version[1]}
      #{base_flag}.Patch=#{doctl_version[2]}
      #{base_flag}.Label=release
    ].join(" ")
    system "go", "build", "-ldflags", ldflags, "github.com/digitalocean/doctl/cmd/doctl"
    bin.install "doctl"

    (bash_completion/"doctl").write `#{bin}/doctl completion bash`
    (zsh_completion/"doctl").write `#{bin}/doctl completion zsh`
  end

  test do
    assert_match "doctl version #{version}-release", shell_output("#{bin}/doctl version")
  end
end
