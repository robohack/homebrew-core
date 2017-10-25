class Payara < Formula
  desc "Java EE application server forked from GlassFish"
  homepage "https://www.payara.fish"
  url "https://search.maven.org/remotecontent?filepath=fish/payara/distributions/payara/4.1.2.173/payara-4.1.2.173.zip"
  sha256 "944fae8fa38e83cf291e6176152827113a4733174096c49a2cf3d218ba1ad7f2"

  bottle :unneeded

  depends_on :java => "1.7+"

  conflicts_with "glassfish", :because => "both install the same scripts"

  def install
    # Remove Windows scripts
    rm_f Dir["**/*.{bat,exe}"]

    inreplace "bin/asadmin", /AS_INSTALL=.*/,
                             "AS_INSTALL=#{libexec}/glassfish"

    libexec.install Dir["*"]
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  def caveats; <<~EOS
    You may want to add the following to your .bash_profile:
      export GLASSFISH_HOME=#{opt_libexec}/glassfish
      export PATH=${PATH}:${GLASSFISH_HOME}/bin
  EOS
  end

  plist_options :manual => "asadmin start-domain --verbose domain1"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>KeepAlive</key>
      <dict>
        <key>Crashed</key>
        <true/>
        <key>SuccessfulExit</key>
        <false/>
      </dict>
      <key>WorkingDirectory</key>
      <string>#{opt_libexec}/glassfish</string>
      <key>EnvironmentVariables</key>
      <dict>
        <key>GLASSFISH_HOME</key>
        <string>#{opt_libexec}/glassfish</string>
      </dict>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_libexec}/glassfish/bin/asadmin</string>
        <string>start-domain</string>
        <string>--verbose</string>
        <string>domain1</string>
      </array>
    </dict>
    </plist>
  EOS
  end

  test do
    ENV["GLASSFISH_HOME"] = opt_libexec/"glassfish"
    output = shell_output("#{bin}/asadmin list-domains")
    assert_match /^domain1 not running$/, output
    assert_match /^payaradomain not running$/, output
    assert_match /^Command list-domains executed successfully\.$/, output
  end
end
