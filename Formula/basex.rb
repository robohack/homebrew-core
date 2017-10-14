class Basex < Formula
  desc "Light-weight XML database and XPath/XQuery processor"
  homepage "http://basex.org"
  url "http://files.basex.org/releases/8.6.6/BaseX866.zip"
  version "8.6.6"
  sha256 "a41a6cc365741b8ee796ad22ce4acbe9f319059c5bca08fd094a351db9369acf"

  devel do
    url "http://files.basex.org/releases/latest/BaseX867-20170824.195627.zip"
    sha256 "290dd9d0917318e4971b5d412986b7272b042bc7ab4cc249964baaabf788cb65"
    version "8.6.7-rc20170824.195627"
  end

  bottle :unneeded

  depends_on :java => "1.7+"

  def install
    rm Dir["bin/*.bat"]
    rm_rf "repo"
    rm_rf "data"
    rm_rf "etc"
    prefix.install_metafiles
    libexec.install Dir["*"]
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_equal "1\n2\n3\n4\n5\n6\n7\n8\n9\n10", shell_output("#{bin}/basex '1 to 10'")
  end
end
