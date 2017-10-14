class Direnv < Formula
  desc "Load/unload environment variables based on $PWD"
  homepage "https://direnv.net/"
  url "https://github.com/direnv/direnv/archive/v2.13.1.tar.gz"
  sha256 "eea1d4eb4c95c1a6d41bb05a35ed0e106d497f10761e5d0e1c3b87d07c70c7b4"
  head "https://github.com/direnv/direnv.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "5c47aaf4555aace5386f6cfa4ee76105271d01c6e470f27887349f42f332f4c3" => :high_sierra
    sha256 "71876677847d22b01698c45fc1b12174ee1ef78c10e294ba5a72d6984157a931" => :sierra
    sha256 "46de205de4bcb4bd5b196ee4164e84dfca156adb811fe56bea117933260600b9" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/direnv/direnv").install buildpath.children
    cd "src/github.com/direnv/direnv" do
      system "make", "install", "DESTDIR=#{prefix}"
      prefix.install_metafiles
    end
  end

  test do
    system bin/"direnv", "status"
  end
end
