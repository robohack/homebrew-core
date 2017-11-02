require "language/node"

class Svgo < Formula
  desc "Nodejs-based tool for optimizing SVG vector graphics files"
  homepage "https://github.com/svg/svgo"
  url "https://github.com/svg/svgo/archive/v1.0.1.tar.gz"
  sha256 "1333b86493b4115692dc7013fa094ece9fb56be5001717c638b5a2547bff8959"

  bottle do
    cellar :any_skip_relocation
    sha256 "9e91bb6f03f8911d0f2993df01f05bb95d2a3f9ef2d05033cb8700c050da853e" => :high_sierra
    sha256 "3a6ed7e647e164bf54be07b8ec30826fb4cad3893f98526113704974cc3065a6" => :sierra
    sha256 "cab94f5d68e5b7077d416faf40a1cfb331bf9e2fea214ba6332b962b38534f17" => :el_capitan
    sha256 "507ad3f9c0d5ab79d5a1adb11161d2e7f5aa05f2c9a170bab72720ef8bf94759" => :yosemite
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    cp test_fixtures("test.svg"), testpath
    system bin/"svgo", "test.svg", "-o", "test.min.svg"
    assert_match /^<svg /, (testpath/"test.min.svg").read
  end
end
