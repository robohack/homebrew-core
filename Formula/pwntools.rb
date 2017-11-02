class Pwntools < Formula
  include Language::Python::Virtualenv

  desc "CTF framework used by Gallopsled in every CTF"
  homepage "https://pwntools.com/"
  url "https://github.com/Gallopsled/pwntools/archive/3.10.0.tar.gz"
  sha256 "9544c4f987a123f25dd9c6e0ad2b3d8d4f4385da66d2cfc8052480c7c5d59a82"

  bottle do
    cellar :any
    sha256 "0ee315109b4115325aeb453c53cb95da4ad5b3df8311e9508c8469606e54ea2a" => :high_sierra
    sha256 "5a7c4530835b73b421c3c44094b392823c8b8c72c2bf4cdd695eb73b00a1c39a" => :sierra
    sha256 "3f5f650edf8b6339d770bdb277889ef3f17ef592e4386737abf76184bf149eff" => :el_capitan
  end

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "openssl@1.1"
  depends_on "binutils" => :recommended

  conflicts_with "moreutils", :because => "Both install `errno` binaries"

  def install
    venv = virtualenv_create(libexec)
    system libexec/"bin/pip", "install", "-v", "--no-binary", ":all:",
                              "--ignore-installed", buildpath
    system libexec/"bin/pip", "uninstall", "-y", name
    venv.pip_install_and_link buildpath
  end

  test do
    assert_equal "686f6d6562726577696e7374616c6c636f6d706c657465",
                 shell_output("#{bin}/hex homebrewinstallcomplete").strip
  end
end
