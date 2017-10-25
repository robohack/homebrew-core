require "language/haskell"

class Agda < Formula
  include Language::Haskell::Cabal

  desc "Dependently typed functional programming language"
  homepage "http://wiki.portal.chalmers.se/agda/"

  stable do
    url "https://hackage.haskell.org/package/Agda-2.5.3/Agda-2.5.3.tar.gz"
    sha256 "aa14d4a3582013100f71e64d71c5deff6caa2a286083e20fc16f6dbb0fdf0065"

    resource "stdlib" do
      url "https://github.com/agda/agda-stdlib.git",
          :revision => "477ba28360133b1f5c45ce1b4e6b4efd467af331"
    end
  end

  bottle do
    sha256 "697f3c5e925a2fb98b950190aeddd0f97f15a52b635e9e0a77b759f18f104f5f" => :high_sierra
    sha256 "99239ce3f316a102d4c23dde9e3f0247b51476b1e279b99f24642b7e895e9243" => :sierra
    sha256 "30287f76d07507a248a0cb8aa4de98d5a157a615e2225b3c8a6955dcf0168e48" => :el_capitan
    sha256 "0998529cdce68693765050339cc8e724ed7eecc47f515b84c92f37f334d5dfed" => :yosemite
  end

  head do
    url "https://github.com/agda/agda.git"

    resource "stdlib" do
      url "https://github.com/agda/agda-stdlib.git"
    end
  end

  deprecated_option "without-malonzo" => "without-ghc"

  option "without-stdlib", "Don't install the Agda standard library"
  option "without-ghc", "Disable the GHC backend"

  depends_on "ghc" => :recommended
  if build.with? "ghc"
    depends_on "cabal-install"
  else
    depends_on "ghc" => :build
    depends_on "cabal-install" => :build
  end

  depends_on :emacs => ["23.4", :recommended]

  def install
    # install Agda core
    install_cabal_package :using => ["alex", "happy", "cpphs"]

    if build.with? "stdlib"
      resource("stdlib").stage lib/"agda"

      # generate the standard library's bytecode
      cd lib/"agda" do
        cabal_sandbox :home => buildpath, :keep_lib => true do
          cabal_install "--only-dependencies"
          cabal_install
          system "GenerateEverything"
        end
      end

      # generate the standard library's documentation and vim highlighting files
      cd lib/"agda" do
        system bin/"agda", "-i", ".", "-i", "src", "--html", "--vim", "README.agda"
      end
    end

    # compile the included Emacs mode
    if build.with? "emacs"
      system bin/"agda-mode", "compile"
      elisp.install_symlink Dir["#{share}/*/Agda-#{version}/emacs-mode/*"]
    end
  end

  def caveats
    s = ""

    if build.with? "stdlib"
      s += <<~EOS
        To use the Agda standard library by default:
          mkdir -p ~/.agda
          echo #{HOMEBREW_PREFIX}/lib/agda/standard-library.agda-lib >>~/.agda/libraries
          echo standard-library >>~/.agda/defaults
      EOS
    end

    s
  end

  test do
    simpletest = testpath/"SimpleTest.agda"
    simpletest.write <<~EOS
      module SimpleTest where

      data ℕ : Set where
        zero : ℕ
        suc  : ℕ → ℕ

      infixl 6 _+_
      _+_ : ℕ → ℕ → ℕ
      zero  + n = n
      suc m + n = suc (m + n)

      infix 4 _≡_
      data _≡_ {A : Set} (x : A) : A → Set where
        refl : x ≡ x

      cong : ∀ {A B : Set} (f : A → B) {x y} → x ≡ y → f x ≡ f y
      cong f refl = refl

      +-assoc : ∀ m n o → (m + n) + o ≡ m + (n + o)
      +-assoc zero    _ _ = refl
      +-assoc (suc m) n o = cong suc (+-assoc m n o)
    EOS

    stdlibtest = testpath/"StdlibTest.agda"
    stdlibtest.write <<~EOS
      module StdlibTest where

      open import Data.Nat
      open import Relation.Binary.PropositionalEquality

      +-assoc : ∀ m n o → (m + n) + o ≡ m + (n + o)
      +-assoc zero    _ _ = refl
      +-assoc (suc m) n o = cong suc (+-assoc m n o)
    EOS

    iotest = testpath/"IOTest.agda"
    iotest.write <<~EOS
      module IOTest where

      open import Agda.Builtin.IO
      open import Agda.Builtin.Unit

      postulate
        return : ∀ {A : Set} → A → IO A

      {-# COMPILED return (\\_ -> return) #-}

      main : _
      main = return tt
    EOS

    stdlibiotest = testpath/"StdlibIOTest.agda"
    stdlibiotest.write <<~EOS
      module StdlibIOTest where

      open import IO

      main : _
      main = run (putStr "Hello, world!")
    EOS

    # typecheck a simple module
    system bin/"agda", simpletest

    # typecheck a module that uses the standard library
    if build.with? "stdlib"
      system bin/"agda", "-i", lib/"agda"/"src", stdlibtest
    end

    # compile a simple module using the JS backend
    system bin/"agda", "--js", simpletest

    # test the GHC backend
    if build.with? "ghc"
      cabal_sandbox do
        cabal_install "text", "ieee754"
        dbpath = Dir["#{testpath}/.cabal-sandbox/*-packages.conf.d"].first
        dbopt = "--ghc-flag=-package-db=#{dbpath}"

        # compile and run a simple program
        system bin/"agda", "-c", dbopt, iotest
        assert_equal "", shell_output(testpath/"IOTest")

        # compile and run a program that uses the standard library
        if build.with? "stdlib"
          system bin/"agda", "-c", "-i", lib/"agda"/"src", dbopt, stdlibiotest
          assert_equal "Hello, world!", shell_output(testpath/"StdlibIOTest")
        end
      end
    end
  end
end
