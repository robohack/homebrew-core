class Nnn < Formula
  desc "Free, fast, friendly file browser"
  homepage "https://github.com/jarun/nnn"
  url "https://github.com/jarun/nnn/archive/v1.0.tar.gz"
  sha256 "032d8cdcaa237f4392cc0ab335b984f2107c458c7d1ffec35a4abfe3aa0e5486"

  bottle do
    cellar :any_skip_relocation
    sha256 "a932abf9441184e7d4df429cf6f4442fc8c7f485b5acceb62382fa7aaa00cc98" => :sierra
    sha256 "fbad09d8339f50138bc99f4e246856cf9b2ae29f084f66b3d46ac29a39efd36f" => :el_capitan
    sha256 "b3238d012532bb04c128ac012086cb8abf9a5266ceb458102efc0022093755b9" => :yosemite
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    touch "foobar"
    # Testing this curses app requires a pty
    require "pty"
    PTY.spawn(bin/"nnn") do |r, w, _pid|
      w.write "q"
      assert_match "foobar", r.read
    end
  end
end
