class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.28.3.tar.gz"
  sha256 "606604e1751bbf010d53e8a1244145d2124b16653ee50621bae4293da92a30f7"

  head "https://github.com/nicklockwood/SwiftFormat.git", :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "54d1db530cea8f7dad6af5702d998d13a90b11fac1d94a3fe79eb0e521302e46" => :sierra
    sha256 "6eb88b1495664d4e904a2f4725540d8bbdaeea37663debdd1def5eda642f2b79" => :el_capitan
  end

  depends_on :xcode => ["8.0", :build]

  def install
    xcodebuild "-project",
        "SwiftFormat.xcodeproj",
        "-scheme", "SwiftFormat (Command Line Tool)",
        "CODE_SIGN_IDENTITY=",
        "SYMROOT=build", "OBJROOT=build"
    bin.install "build/Release/swiftformat"
  end

  test do
    (testpath/"potato.swift").write <<-EOS.undent
      struct Potato {
        let baked: Bool
      }
    EOS
    system "#{bin}/swiftformat", "#{testpath}/potato.swift"
  end
end
