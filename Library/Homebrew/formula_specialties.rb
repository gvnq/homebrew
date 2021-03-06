# Base classes for specialized types of formulae.

# See chcase for an example
class ScriptFileFormula < Formula
  def install
    bin.install Dir['*']
  end
end

# See browser for an example
class GithubGistFormula < ScriptFileFormula
  def initialize name='__UNKNOWN__', path=nil
    url = self.class.stable.url
    self.class.stable.version(File.basename(File.dirname(url))[0,6])
    super
  end
end

# This formula serves as the base class for several very similar
# formulae for Amazon Web Services related tools.
class AmazonWebServicesFormula < Formula
  # Use this method to peform a standard install for Java-based tools,
  # keeping the .jars out of HOMEBREW_PREFIX/lib
  def standard_install
    rm Dir['bin/*.cmd'] # Remove Windows versions
    libexec.install Dir['*']
    bin.install_symlink Dir["#{libexec}/bin/*"] - ["#{libexec}/bin/service"]
  end

  # Use this method to generate standard caveats.
  def standard_instructions home_name
    <<-EOS.undent
      Before you can use these tools you must export some variables to your $SHELL
      and download your X.509 certificate and private key from Amazon Web Services.

      Your certificate and private key are available at:
      http://aws-portal.amazon.com/gp/aws/developer/account/index.html?action=access-key

      Download two ".pem" files, one starting with `pk-`, and one starting with `cert-`.
      You need to put both into a folder in your home directory, `~/.ec2`.

      To export the needed variables, add them to your dotfiles.
       * On Bash, add them to `~/.bash_profile`.
       * On Zsh, add them to `~/.zprofile` instead.

      export JAVA_HOME="$(/usr/libexec/java_home)"
      export EC2_PRIVATE_KEY="$(/bin/ls "$HOME"/.ec2/pk-*.pem | /usr/bin/head -1)"
      export EC2_CERT="$(/bin/ls "$HOME"/.ec2/cert-*.pem | /usr/bin/head -1)"
      export #{home_name}="#{libexec}"
    EOS
  end
end
