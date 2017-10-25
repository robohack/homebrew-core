require "language/node"

class Jhipster < Formula
  desc "Generate, develop and deploy Spring Boot + Angular applications"
  homepage "https://jhipster.github.io/"
  url "https://registry.npmjs.org/generator-jhipster/-/generator-jhipster-4.10.1.tgz"
  sha256 "52f0f6d9644f009c00844c1a498f84bb8154aeaf90a2be7558cb6b9e3f843d8a"

  bottle do
    cellar :any_skip_relocation
    sha256 "8fea8c186c824b7c9d93c1020e474d3d3881997543b564bde9ee8cf2df754dbb" => :high_sierra
    sha256 "d863094dbe302c4ed341f225bda22dbbb1518ecce8f890389fd42a7b8288d7ae" => :sierra
    sha256 "9744c8273ef52babed03ba1b66a5e06152375a2c3e535f7bcf6648085719732c" => :el_capitan
  end

  depends_on "node"
  depends_on "yarn"
  depends_on :java => "1.8+"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "execution is complete", shell_output("#{bin}/jhipster info")
  end
end
