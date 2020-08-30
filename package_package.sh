#!env bash
#
# package_package.sh - Package this package for distribution

PKG=FasterDatevec
FILES="Mcode LICENSE Makefile README.md VERSION"

read -d $'\x04' VERSION < VERSION

echo Packaging $PKG version $VERSION

mkdir -p dist
archivename="${PKG}-${VERSION}"
tarball="${archivename}.tgz"
rm -rf dist/${archivename}
rm -f dist/${tarball}
mkdir -p dist/$archivename
cp -pR $FILES dist/$archivename
tarbase="${archivename}.tgz"
(
  cd dist
  tar czf $archivename.tgz $archivename
)

echo "$PKG" version $VERSION packaged at dist/$archivename.tgz
