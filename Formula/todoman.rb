class Todoman < Formula
  include Language::Python::Virtualenv

  desc "Simple CalDAV-based todo manager"
  homepage "https://todoman.readthedocs.io/"
  url "https://files.pythonhosted.org/packages/81/7e/30547f981ca6d5f9d8e51f4e27ab6dda9a81d4156c006deba9f7a332407c/todoman-3.1.0.tar.gz"
  sha256 "ad4ec5c63f8813acc6bf403cf9ceb99447b2661c0c27efaea745db2e870e0408"
  head "https://github.com/pimutils/todoman.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "adeb1303553c7e7219713b10fbaedf91c7c77112dc08863ae5ff049051d18820" => :sierra
    sha256 "80925ea0b29b4318c068174f63f099ac0706ca6a4cabbe70bc3258137befe290" => :el_capitan
    sha256 "aeb132bcf1a5eaa1ebb9332ba28a52452a47346dcb893838e469aab0bd3439a5" => :yosemite
  end

  depends_on :python3

  resource "atomicwrites" do
    url "https://files.pythonhosted.org/packages/a1/e1/2d9bc76838e6e6667fde5814aa25d7feb93d6fa471bf6816daac2596e8b2/atomicwrites-1.1.5.tar.gz"
    sha256 "240831ea22da9ab882b551b31d4225591e5e447a68c5e188db5b89ca1d487585"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/95/d9/c3336b6b5711c3ab9d1d3a80f1a3e2afeb9d8c02a7166462f6cc96570897/click-6.7.tar.gz"
    sha256 "f15516df478d5a56180fbf80e68f206010e6d160fc39fa508b65e035fd75130b"
  end

  resource "click-log" do
    url "https://files.pythonhosted.org/packages/b7/71/d029ea00ede6c1fd307c8d87cd7aac90c1a7ed8dec2ede5dc115e254fade/click-log-0.1.8.tar.gz"
    sha256 "57271008c12e2dc16d413373bedd7fd3ff17c57434e168650dc27dfb9c743392"
  end

  resource "configobj" do
    url "https://files.pythonhosted.org/packages/64/61/079eb60459c44929e684fa7d9e2fdca403f67d64dd9dbac27296be2e0fab/configobj-5.0.6.tar.gz"
    sha256 "a2f5650770e1c87fb335af19a9b7eb73fc05ccf22144eb68db7d00cd2bcb0902"
  end

  resource "future" do
    url "https://files.pythonhosted.org/packages/00/2b/8d082ddfed935f3608cc61140df6dcbf0edea1bc3ab52fb6c29ae3e81e85/future-0.16.0.tar.gz"
    sha256 "e39ced1ab767b5936646cedba8bcce582398233d6a627067d4c6a454c90cfedb"
  end

  resource "humanize" do
    url "https://files.pythonhosted.org/packages/8c/e0/e512e4ac6d091fc990bbe13f9e0378f34cf6eecd1c6c268c9e598dcf5bb9/humanize-0.5.1.tar.gz"
    sha256 "a43f57115831ac7c70de098e6ac46ac13be00d69abbf60bdcac251344785bb19"
  end

  resource "icalendar" do
    url "https://files.pythonhosted.org/packages/7f/0b/f13fa6ec05f44c13014ab7d7dd2ffae349c94d71151a311a8c5e7198b0a8/icalendar-3.11.3.tar.gz"
    sha256 "6317d716563c41ca44b4694458f0a94734e35bb8c708994eb4503c8638d5d220"
  end

  resource "parsedatetime" do
    url "https://files.pythonhosted.org/packages/32/a8/29473ee95f1ceb5c3428d35387200be404cf6dfc60c110e75d775e27979a/parsedatetime-2.3.tar.gz"
    sha256 "94ca3c9efcf2652a7a8ee6b11983e7344988a3c658fd617f8021689446ab79ee"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/51/fc/39a3fbde6864942e8bb24c93663734b74e281b984d1b8c4f95d64b0c21f6/python-dateutil-2.6.0.tar.gz"
    sha256 "62a2f8df3d66f878373fd0072eacf4ee52194ba302e00082828e0d263b0418d2"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/d0/e1/aca6ef73a7bd322a7fc73fd99631ee3454d4fc67dc2bee463e2adf6bb3d3/pytz-2016.10.tar.bz2"
    sha256 "7016b2c4fa075c564b81c37a252a5fccf60d8964aa31b7f5eae59aeb594ae02b"
  end

  resource "pyxdg" do
    url "https://files.pythonhosted.org/packages/26/28/ee953bd2c030ae5a9e9a0ff68e5912bd90ee50ae766871151cd2572ca570/pyxdg-0.25.tar.gz"
    sha256 "81e883e0b9517d624e8b0499eb267b82a815c0b7146d5269f364988ae031279d"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/b3/b2/238e2590826bfdd113244a40d9d3eb26918bd798fc187e2360a8367068db/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/1c/a1/3367581782ce79b727954f7aa5d29e6a439dc2490a9ac0e7ea0a7115435d/tabulate-0.7.7.tar.gz"
    sha256 "83a0b8e17c09f012090a50e1e97ae897300a72b35e0c86c0b53d3bd2ae86d8c6"
  end

  resource "urwid" do
    url "https://files.pythonhosted.org/packages/85/5d/9317d75b7488c335b86bd9559ca03a2a023ed3413d0e8bfe18bea76f24be/urwid-1.3.1.tar.gz"
    sha256 "cfcec03e36de25a1073e2e35c2c7b0cc6969b85745715c3a025a31d9786896a1"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    (testpath/".config/todoman/todoman.conf").write <<-EOS.undent
      [main]
      path = #{testpath}/.calendar/*
      date_format = %Y-%m-%d
      default_list = Personal
    EOS
    (testpath/".calendar/Personal").mkpath
    system "#{bin}/todo", "new", "newtodo"
    assert_match "newtodo", shell_output("#{bin}/todo list")
  end
end
