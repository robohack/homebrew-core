require "language/node"

class Bit < Formula
  desc "Distributed Code Component Manager"
  homepage "https://www.bitsrc.io"
  url "https://registry.npmjs.org/bit-bin/-/bit-bin-0.10.9.tgz"
  sha256 "c153eee37e86eb4fe71df2da0f04bcd8c766e5229812340e8ceb870186470ec2"
  head "https://github.com/teambit/bit.git"

  bottle do
    sha256 "9f8c4c5a74cf4f16b2e3e7f94d7e1a5192113a3b1b849780a8e739dded55282f" => :high_sierra
    sha256 "d5a6606933925ede7b83be76d0567c010654e20d2a60ffc241ffc274ca35bd5a" => :sierra
    sha256 "cd883b34bedceb4866e1badaaa9dc5f6e5bdcdcb0071062525234b3bfdad8377" => :el_capitan
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_equal "successfully initialized an empty bit scope.\n",
                 shell_output("#{bin}/bit init --skip-update")
  end
end
