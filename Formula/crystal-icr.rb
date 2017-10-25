class CrystalIcr < Formula
  desc "Interactive console for Crystal programming language"
  homepage "https://github.com/crystal-community/icr"
  url "https://github.com/crystal-community/icr/archive/v0.3.0.tar.gz"
  sha256 "4e3695965c95d55d345baf8c7fc9a7eff0bf95da1b1c8141bdb63c2d5269a30e"

  bottle do
    sha256 "0cb94b0e22b8e279c5ef434813dc4994e0a8415fd56cb09dc5fb297bc33842e5" => :high_sierra
    sha256 "aaddd53dfbfd42acebefad53ae70f644d341851efab0f0198ee070f6ff1f6d09" => :sierra
    sha256 "b0b5a8d6e38caf8f797399c1f2dd66f4f65583652138c7731438ab5521a8aa14" => :el_capitan
  end

  depends_on "crystal-lang"
  depends_on "readline"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_match "icr version #{version}", shell_output("#{bin}/icr -v")
  end
end
