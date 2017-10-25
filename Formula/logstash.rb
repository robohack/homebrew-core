class Logstash < Formula
  desc "Tool for managing events and logs"
  homepage "https://www.elastic.co/products/logstash"
  url "https://artifacts.elastic.co/downloads/logstash/logstash-5.6.2.tar.gz"
  sha256 "7d302fe858fe5a4ff6e122f1dec7381aba0f1085da7ee05718eeeaa4a10eb8ad"
  head "https://github.com/elastic/logstash.git"

  bottle :unneeded

  depends_on :java => "1.8+"

  def install
    if build.head?
      # Build the package from source
      system "rake", "artifact:tar"
      # Extract the package to the current directory
      mkdir "tar"
      system "tar", "--strip-components=1", "-xf", Dir["build/logstash-*.tar.gz"].first, "-C", "tar"
      cd "tar"
    end

    inreplace %w[bin/logstash], %r{^\. "\$\(cd `dirname \$SOURCEPATH`\/\.\.; pwd\)\/bin\/logstash\.lib\.sh\"}, ". #{libexec}/bin/logstash.lib.sh"
    inreplace %w[bin/logstash-plugin], %r{^\. "\$\(cd `dirname \$0`\/\.\.; pwd\)\/bin\/logstash\.lib\.sh\"}, ". #{libexec}/bin/logstash.lib.sh"
    inreplace %w[bin/logstash.lib.sh], /^LOGSTASH_HOME=.*$/, "LOGSTASH_HOME=#{libexec}"
    libexec.install Dir["*"]
    bin.install_symlink libexec/"bin/logstash"
    bin.install_symlink libexec/"bin/logstash-plugin"
  end

  def caveats; <<~EOS
    Please read the getting started guide located at:
      https://www.elastic.co/guide/en/logstash/current/getting-started-with-logstash.html
    EOS
  end

  plist_options :manual => "logstash"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
        <dict>
          <key>KeepAlive</key>
          <false/>
          <key>Label</key>
          <string>#{plist_name}</string>
          <key>ProgramArguments</key>
          <array>
            <string>#{opt_bin}/logstash</string>
          </array>
          <key>EnvironmentVariables</key>
          <dict>
          </dict>
          <key>RunAtLoad</key>
          <true/>
          <key>WorkingDirectory</key>
          <string>#{var}</string>
          <key>StandardErrorPath</key>
          <string>#{var}/log/logstash.log</string>
          <key>StandardOutPath</key>
          <string>#{var}/log/logstash.log</string>
        </dict>
      </plist>
    EOS
  end

  test do
    # workaround https://github.com/elastic/logstash/issues/6378
    mkdir testpath/"config"
    ["jvm.options", "log4j2.properties", "startup.options"].each { |f| cp prefix/"libexec/config/#{f}", testpath/"config" }
    (testpath/"config/logstash.yml").write <<~EOS
      path.queue: #{testpath}/queue
    EOS
    mkdir testpath/"data"
    mkdir testpath/"logs"
    mkdir testpath/"queue"

    output = pipe_output("#{bin}/logstash -e '' --path.data=#{testpath}/data --path.logs=#{testpath}/logs --path.settings=#{testpath}/config --log.level=fatal", "hello world\n")
    assert_match /hello world/, output
  end
end
