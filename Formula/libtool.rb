# Xcode 4.3 provides the Apple libtool.
# This is not the same so as a result we must install this as glibtool.

class Libtool < Formula
  desc "Generic library support script"
  homepage "https://www.gnu.org/software/libtool/"
  url "https://ftpmirror.gnu.org/libtool/libtool-2.4.6.tar.xz"
  mirror "https://ftp.gnu.org/gnu/libtool/libtool-2.4.6.tar.xz"
  sha256 "7c87a8c2c8c0fc9cd5019e402bed4292462d00a718a7cd5f11218153bf28b26f"

  revision 1

  bottle do
    cellar :any
    sha256 "b7651d0a082e2f103f03ca3a5ed831e2ff5655ccc1044ac0452e4d1825475a35" => :el_capitan
    sha256 "0eb206c0f51e8ce2e3e9340b5ce3c8ecef961ae6696f676073327a7ac04e5c0b" => :yosemite
    sha256 "2e51ef82ef2bd1ad9d921a9016b9e5d7fa82d131849e2c32a3c90daa119e2eda" => :mavericks
    sha256 "bc7b0f657919331906a9828904d3822ce9c9cf80f226a84a5154294b4475bac1" => :x86_64_linux
  end

  keg_only :provided_until_xcode43

  option :universal
  option "with-default-names", "Do not prepend 'g' to the binary"

  def install
    ENV.universal_binary if build.universal?
    ENV["SED"] = "sed" # prevent libtool from hardcoding sed path from superenv
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          ("--program-prefix=g" if build.without? "default-names"),
                          "--enable-ltdl-install"
    system "make", "install"

    if build.with? "default-names"
      bin.install_symlink "libtool" => "glibtool"
      bin.install_symlink "libtoolize" => "glibtoolize"
    end
  end

  def caveats; <<-EOS.undent
    In order to prevent conflicts with Apple's own libtool we have prepended a "g"
    so, you have instead: glibtool and glibtoolize.
    EOS
  end

  test do
    system "#{bin}/glibtool", "execute", "true"
  end
end
