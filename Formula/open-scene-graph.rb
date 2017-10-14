class OpenSceneGraph < Formula
  desc "3D graphics toolkit"
  homepage "https://github.com/openscenegraph/OpenSceneGraph"
  url "https://github.com/openscenegraph/OpenSceneGraph/archive/OpenSceneGraph-3.5.6.tar.gz"
  sha256 "58e9436b811d0344723116cb1ada6ef305bdb6d97f42f04a700a29eda17f54b2"
  revision 1
  head "https://github.com/openscenegraph/OpenSceneGraph.git"

  bottle do
    rebuild 1
    sha256 "04246e8fb2af25014e6620645fd3fd600b8ff97d872d8d50fea0719ae19c7c4c" => :high_sierra
    sha256 "9a5b050af3debc7b0860349a095c02b8935bf3ef494036e22da61a97ca85d01c" => :sierra
    sha256 "14b40a23917655700302c751e8a6d785a94c94d5311e82efa1ff403a6a5dbf56" => :el_capitan
    sha256 "b2f7c7f7f5d36a0a966d03de9b44146a0c5e7313acaac93a5d41c2250ee4a952" => :yosemite
  end

  option :cxx11
  option "with-docs", "Build the documentation with Doxygen and Graphviz"

  deprecated_option "docs" => "with-docs"
  deprecated_option "with-qt5" => "with-qt"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "jpeg"
  depends_on "gtkglext"
  depends_on "freetype"
  depends_on "gdal" => :optional
  depends_on "jasper" => :optional
  depends_on "openexr" => :optional
  depends_on "dcmtk" => :optional
  depends_on "librsvg" => :optional
  depends_on "collada-dom" => :optional
  depends_on "gnuplot" => :optional
  depends_on "ffmpeg" => :optional
  depends_on "qt" => :optional

  # patch necessary to ensure support for gtkglext-quartz
  # filed as an issue to the developers https://github.com/openscenegraph/osg/issues/34
  patch :DATA

  if build.with? "docs"
    depends_on "doxygen" => :build
    depends_on "graphviz" => :build
  end

  # jpeg 9 compatibility
  # Upstream issue from 18 Feb 2016 "fails to build without -fpermissive"
  # See https://github.com/openscenegraph/OpenSceneGraph/issues/58
  patch :p0 do
    url "https://raw.githubusercontent.com/macports/macports-ports/a54de1ab602/graphics/OpenSceneGraph/files/patch-src_osgPlugins_jpeg_ReaderWriterJPEG.cpp.diff"
    sha256 "c62a284d1df478a73082bb0c8eae504ffcc8a9e7b00ee541cc00543d6b163c94"
  end

  def install
    ENV.cxx11 if build.cxx11?

    # Turning off FFMPEG takes this change or a dozen "-DFFMPEG_" variables
    if build.without? "ffmpeg"
      inreplace "CMakeLists.txt", "FIND_PACKAGE(FFmpeg)", "#FIND_PACKAGE(FFmpeg)"
    end

    args = std_cmake_args
    args << "-DBUILD_DOCUMENTATION=" + (build.with?("docs") ? "ON" : "OFF")
    args << "-DCMAKE_CXX_FLAGS=-Wno-error=narrowing" # or: -Wno-c++11-narrowing

    if MacOS.prefer_64_bit?
      args << "-DCMAKE_OSX_ARCHITECTURES=#{Hardware::CPU.arch_64_bit}"
      args << "-DOSG_DEFAULT_IMAGE_PLUGIN_FOR_OSX=imageio"
      args << "-DOSG_WINDOWING_SYSTEM=Cocoa"
    else
      args << "-DCMAKE_OSX_ARCHITECTURES=#{Hardware::CPU.arch_32_bit}"
    end

    if build.with? "collada-dom"
      args << "-DCOLLADA_INCLUDE_DIR=#{Formula["collada-dom"].opt_include}/collada-dom"
    end

    if build.with? "qt"
      args << "-DCMAKE_PREFIX_PATH=#{Formula["qt"].opt_prefix}"
    end

    mkdir "build" do
      system "cmake", "..", *args
      system "make"
      system "make", "doc_openscenegraph" if build.with? "docs"
      system "make", "install"
      doc.install Dir["#{prefix}/doc/OpenSceneGraphReferenceDocs/*"] if build.with? "docs"
    end
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <iostream>
      #include <osg/Version>
      using namespace std;
      int main()
        {
          cout << osgGetVersion() << endl;
          return 0;
        }
    EOS
    system ENV.cxx, "test.cpp", "-I#{include}", "-L#{lib}", "-losg", "-o", "test"
    assert_equal `./test`.chomp, version.to_s
  end
end
__END__
diff --git a/CMakeModules/FindGtkGl.cmake b/CMakeModules/FindGtkGl.cmake
index 321cede..6497589 100644
--- a/CMakeModules/FindGtkGl.cmake
+++ b/CMakeModules/FindGtkGl.cmake
@@ -10,7 +10,7 @@ IF(PKG_CONFIG_FOUND)
     IF(WIN32)
         PKG_CHECK_MODULES(GTKGL gtkglext-win32-1.0)
     ELSE()
-        PKG_CHECK_MODULES(GTKGL gtkglext-x11-1.0)
+        PKG_CHECK_MODULES(GTKGL gtkglext-quartz-1.0)
     ENDIF()

 ENDIF()
