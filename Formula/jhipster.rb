require "language/node"

class Jhipster < Formula
  desc "Generate, develop and deploy Spring Boot + Angular applications"
  homepage "https://jhipster.github.io/"
  url "https://registry.npmjs.org/generator-jhipster/-/generator-jhipster-4.9.0.tgz"
  sha256 "abd73bc3aeab7a0e7963ef4b8a17e3c8143a96c2be7258ca1a4c9b87836c3c47"

  bottle do
    cellar :any_skip_relocation
    sha256 "9ad2dfb774eb699f5f926aeaec118d7285bf5044fac957b33e43f01406607fbf" => :high_sierra
    sha256 "c8129c702b2a77bcc839618d82f6102f569ec9f1746b6842d39118fbcd388fc0" => :sierra
    sha256 "685e9c9739d9e849720228555ea8aae8c80957b6ec98bb013bf251514e01cbdf" => :el_capitan
  end

  depends_on "node"
  depends_on "yarn"
  depends_on :java => "1.8+"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "Execution complete", shell_output("#{bin}/jhipster info")
  end
end
