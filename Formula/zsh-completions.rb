class ZshCompletions < Formula
  desc "Additional completion definitions for zsh"
  homepage "https://github.com/zsh-users/zsh-completions"
  url "https://github.com/zsh-users/zsh-completions/archive/0.26.0.tar.gz"
  sha256 "783768c8308cc0ff37bce346c66386308550ede05121e352b1a284ff6bf88540"

  head "https://github.com/zsh-users/zsh-completions.git"

  bottle :unneeded

  def install
    pkgshare.install Dir["src/_*"]
  end

  def caveats
    <<-EOS.undent
    To activate these completions, add the following to your .zshrc:

      fpath=(#{HOMEBREW_PREFIX}/share/zsh-completions $fpath)

    You may also need to force rebuild `zcompdump`:

      rm -f ~/.zcompdump; compinit

    Additionally, if you receive "zsh compinit: insecure directories" warnings when attempting
    to load these completions, you may need to run this:

      chmod go-w '#{HOMEBREW_PREFIX}/share'
    EOS
  end

  test do
    (testpath/"test.zsh").write <<-EOS.undent
      fpath=(#{pkgshare} $fpath)
      autoload _ack
      which _ack
    EOS
    assert_match /^_ack/, shell_output("/bin/zsh test.zsh")
  end
end
