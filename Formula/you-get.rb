class YouGet < Formula
  include Language::Python::Virtualenv

  desc "Dumb downloader that scrapes the web"
  homepage "https://you-get.org/"
  url "https://github.com/soimort/you-get/releases/download/v0.4.915/you-get-0.4.915.tar.gz"
  sha256 "e0167a626f90b9b6f1a3934391e73f27adb908d3be95a053ba779924a7ef5b68"
  head "https://github.com/soimort/you-get.git", :branch => "develop"

  bottle do
    cellar :any_skip_relocation
    sha256 "0e9335e1dbc8b7bbde6673c89e345c91058362328bbde9c1fffabba76fe419e7" => :high_sierra
    sha256 "26dd1b29a187d2eee2fbd59739f5713bcaf4394d331f5ff517b8a329097c611a" => :sierra
    sha256 "39063e39c9369f584384d6aee608caa4316fb1538f631ea26cd783c4288ff7e0" => :el_capitan
  end

  depends_on :python3

  depends_on "rtmpdump" => :optional

  def install
    virtualenv_install_with_resources
  end

  def caveats
    "To use post-processing options, `brew install ffmpeg` or `brew install libav`."
  end

  test do
    system bin/"you-get", "--info", "https://youtu.be/he2a4xK8ctk"
  end
end
