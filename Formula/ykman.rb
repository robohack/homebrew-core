class Ykman < Formula
  include Language::Python::Virtualenv

  desc "Tool for managing your YubiKey configuration"
  homepage "https://developers.yubico.com/yubikey-manager/"
  url "https://developers.yubico.com/yubikey-manager/Releases/yubikey-manager-0.4.6.tar.gz"
  sha256 "6f9aae731e1c71ea65bea48911aa33a29b284afbabe9430f84e07a27cfcfcbeb"

  bottle do
    cellar :any
    sha256 "49bdc999cf7b014966613d10df701bf77117ea96d746cc94586f7fff2fc2c4d2" => :high_sierra
    sha256 "2ffce72e2292548bdaf9b3ff0d519da7f02ce0c75bb042997c7092b3668f7348" => :sierra
    sha256 "1c23b2f634d4580ed908d8f7b6b9edb895895e5aa11ce3bc8182fae5377968f5" => :el_capitan
  end

  head do
    url "https://github.com/Yubico/yubikey-manager.git"
  end

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "swig" => :build
  depends_on "ykpers"
  depends_on "libu2f-host"
  depends_on "libusb"
  depends_on "openssl"

  resource "asn1crypto" do
    url "https://files.pythonhosted.org/packages/31/53/8bca924b30cb79d6d70dbab6a99e8731d1e4dd3b090b7f3d8412a8d8ffbc/asn1crypto-0.23.0.tar.gz"
    sha256 "0874981329cfebb366d6584c3d16e913f2a0eb026c9463efcc4aaf42a9d94d70"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/c9/70/89b68b6600d479034276fed316e14b9107d50a62f5627da37fafe083fde3/cffi-1.11.2.tar.gz"
    sha256 "ab87dd91c0c4073758d07334c1e5f712ce8fe48f007b86f8238773963ee700a6"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/95/d9/c3336b6b5711c3ab9d1d3a80f1a3e2afeb9d8c02a7166462f6cc96570897/click-6.7.tar.gz"
    sha256 "f15516df478d5a56180fbf80e68f206010e6d160fc39fa508b65e035fd75130b"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/bf/da/6a9f49cc7a970380c8235b3adab0c08c7c3d4814876f7383b33e3882a577/cryptography-2.1.1.tar.gz"
    sha256 "2699ed21e1f73dd1bdb7b0b22a517295de07809d535b23e200dd22166037fe6f"
  end

  resource "enum34" do
    url "https://files.pythonhosted.org/packages/bf/3e/31d502c25302814a7c2f1d3959d2a3b3f78e509002ba91aea64993936876/enum34-1.1.6.tar.gz"
    sha256 "8ad8c4783bf61ded74527bffb48ed9b54166685e4230386a9ed9b1279e2df5b1"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f4/bd/0467d62790828c23c47fc1dfa1b1f052b24efdf5290f071c7a91d0d82fd3/idna-2.6.tar.gz"
    sha256 "2c6a5de3089009e3da7c5dde64a141dbc8551d5b7f6cf4ed7c2568d0cc520a8f"
  end

  resource "ipaddress" do
    url "https://files.pythonhosted.org/packages/4e/13/774faf38b445d0b3a844b65747175b2e0500164b7c28d78e34987a5bfe06/ipaddress-1.0.18.tar.gz"
    sha256 "5d8534c8e185f2d8a1fda1ef73f2c8f4b23264e8e30063feeb9511d492a413e1"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/8c/2d/aad7f16146f4197a11f8e91fb81df177adcc2073d36a17b1491fd09df6ed/pycparser-2.18.tar.gz"
    sha256 "99a8ca03e29851d96616ad0404b4aad7d9ee16f25c9f9708a11faf2810f7b226"
  end

  resource "pyOpenSSL" do
    url "https://files.pythonhosted.org/packages/ee/6a/cd78737dd990297205943cc4dcad3d3c502807fd2c5b18c5f33dc90ca214/pyOpenSSL-17.3.0.tar.gz"
    sha256 "29630b9064a82e04d8242ea01d7c93d70ec320f5e3ed48e95fcabc6b1d0f6c76"
  end

  resource "pyscard" do
    url "https://files.pythonhosted.org/packages/96/fa/b1dd66639f88ddc696523bbe7da64e2dd1b7033da935f6db9862e4d4bfa8/pyscard-1.9.6.tar.gz"
    sha256 "6e28143c623e2b34200d2fa9178dbc80a39b9c068b693b2e6527cdae784c6c12"
  end

  resource "pyusb" do
    url "https://files.pythonhosted.org/packages/5f/34/2095e821c01225377dda4ebdbd53d8316d6abb243c9bee43d3888fa91dd6/pyusb-1.0.2.tar.gz"
    sha256 "4e9b72cc4a4205ca64fbf1f3fff39a335512166c151ad103e55c8223ac147362"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/16/d8/bc6316cf98419719bd59c91742194c111b6f2e85abac88e496adefaf7afe/six-1.11.0.tar.gz"
    sha256 "70e8a77beed4562e7f14fe23a786b54f6296e34344c23bc42f07b15018ff98e9"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ykman --version")
  end
end
