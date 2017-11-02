class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://github.com/fonttools/fonttools/releases/download/3.18.0/fonttools-3.18.0.zip"
  sha256 "f1a61cb4219d4acd145a12f19a01245367172dfa4d7da0e2f1f582b29d0b4fd7"
  head "https://github.com/fonttools/fonttools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6025bded6f3bd133f66d480ee5eeb961a1003aa0379874c4e9983b4f2bc2cf90" => :high_sierra
    sha256 "9030f459f209a7325dacf5781216f5cc23ba7acec321a1f77930361b9516518a" => :sierra
    sha256 "deef7642bb58d31a84c61e49800954e14efd02757d2a93ad32d0209129015162" => :el_capitan
  end

  option "with-pygtk", "Build with pygtk support for pyftinspect"

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "pygtk" => :optional

  def install
    virtualenv_install_with_resources
  end

  test do
    cp "/Library/Fonts/Arial.ttf", testpath
    system bin/"ttx", "Arial.ttf"
  end
end
