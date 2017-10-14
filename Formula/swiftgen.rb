class Swiftgen < Formula
  desc "Swift code generator for assets, storyboards, Localizable.strings, …"
  homepage "https://github.com/SwiftGen/SwiftGen"
  url "https://github.com/SwiftGen/SwiftGen.git",
      :tag => "5.1.2",
      :revision => "a55d6d382c47e0feac50f25d93e260e2b8d6cb37"
  head "https://github.com/SwiftGen/SwiftGen.git"

  bottle do
    cellar :any
    sha256 "d8acad4fd19b2e9e34e3e87fa9238c50535e299160da4e48d05a0342bffddf2e" => :high_sierra
    sha256 "2607116727b5f63799627de2613fc51967c0fe6b767a00edd4278739059e2b17" => :sierra
  end

  depends_on :xcode => ["8.3", :build]

  def install
    # Disable swiftlint Build Phase to avoid build errors if versions mismatch
    ENV["NO_CODE_LINT"]="1"

    # Install bundler, then use it to `rake cli:install` SwiftGen
    ENV["GEM_HOME"] = buildpath/"gem_home"
    system "gem", "install", "bundler"
    ENV.prepend_path "PATH", buildpath/"gem_home/bin"
    system "bundle", "install"
    system "bundle", "exec", "rake", "cli:install[#{bin},#{lib},#{pkgshare}/templates]"

    fixtures = {
      "Resources/Fixtures/XCAssets/Images.xcassets" => "Images.xcassets",
      "Resources/Fixtures/XCAssets/Colors.xcassets" => "Colors.xcassets",
      "Resources/Fixtures/Colors/colors.xml" => "colors.xml",
      "Resources/Fixtures/Strings/Localizable.strings" => "Localizable.strings",
      "Resources/Fixtures/Storyboards-iOS" => "Storyboards-iOS",
      "Resources/Fixtures/Fonts" => "Fonts",
      "Resources/Tests/Expected/XCAssets/swift3-context-all.swift" => "xcassets.swift",
      "Resources/Tests/Expected/Colors/swift3-context-defaults.swift" => "colors.swift",
      "Resources/Tests/Expected/Strings/structured-swift3-context-localizable.swift" => "strings.swift",
      "Resources/Tests/Expected/Storyboards-iOS/swift3-context-all.swift" => "storyboards.swift",
      "Resources/Tests/Expected/Fonts/swift3-context-defaults.swift" => "fonts.swift",
    }
    (pkgshare/"fixtures").install fixtures
  end

  test do
    system bin/"swiftgen", "--version"

    fixtures = pkgshare/"fixtures"

    output = shell_output("#{bin}/swiftgen xcassets --templatePath #{pkgshare/"templates/xcassets/swift3.stencil"} #{fixtures}/Images.xcassets #{fixtures}/Colors.xcassets").strip
    assert_equal output, (fixtures/"xcassets.swift").read.strip, "swiftgen xcassets failed"

    output = shell_output("#{bin}/swiftgen colors --templatePath #{pkgshare/"templates/colors/swift3.stencil"} #{fixtures}/colors.xml").strip
    assert_equal output, (fixtures/"colors.swift").read.strip, "swiftgen colors failed"

    output = shell_output("#{bin}/swiftgen strings --templatePath #{pkgshare/"templates/strings/structured-swift3.stencil"} #{fixtures}/Localizable.strings").strip
    assert_equal output, (fixtures/"strings.swift").read.strip, "swiftgen strings failed"

    output = shell_output("#{bin}/swiftgen storyboards --templatePath #{pkgshare/"templates/storyboards/swift3.stencil"} #{fixtures}/Storyboards-iOS").strip
    assert_equal output, (fixtures/"storyboards.swift").read.strip, "swiftgen storyboards failed"

    output = shell_output("#{bin}/swiftgen fonts --templatePath #{pkgshare/"templates/fonts/swift3.stencil"} #{fixtures}/Fonts").strip
    assert_equal output, (fixtures/"fonts.swift").read.strip, "swiftgen fonts failed"
  end
end
