class Backupninja < Formula
  desc "Backup automation tool"
  homepage "https://labs.riseup.net/code/projects/backupninja"
  url "https://labs.riseup.net/code/attachments/download/275/backupninja-1.0.1.tar.gz"
  sha256 "10fa5dbcd569a082b8164cd30276dd04a238c7190d836bcba006ea3d1235e525"

  bottle do
    cellar :any_skip_relocation
    sha256 "0a4a20cb6085bcd8e341b480286f6a0f1d13200741d1e60a4c15ff8d2463d75f" => :high_sierra
    sha256 "844d6f69b560ddc0cbe0292e962c4b9613640d6730704ec8c8144261e0ce15e4" => :sierra
    sha256 "4e0b131e37240d5959ad09bbb105661ba9f8fffa1f058ffe46f2fe9729095a4e" => :el_capitan
    sha256 "e8ff74c3251e60e04a719be0b5e64a0ef8a6688d58dc4fb902baacf9cdcc4bf9" => :yosemite
    sha256 "88435f7cc59965f314fa3124ac759e2fb986736ffd066dfe83546ec81b367336" => :mavericks
  end

  depends_on "dialog"
  depends_on "gawk"

  skip_clean "etc/backup.d"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end
end
