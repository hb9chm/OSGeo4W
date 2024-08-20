export P=sqlite3
export V=3.46.1
export B=next
export MAINTAINER=JuergenFischer
export BUILDDEPENDS=none
export PACKAGES="sqlite3 sqlite3-devel"

IFS=. read major minor patch < <(echo $V)

export BASE=$(printf "sqlite-amalgamation-%d%02d%02d00" $major $minor $patch)
export URL=https://sqlite.org/$(date +%Y)/$BASE.zip

source ../../../scripts/build-helpers

startlog

[ -f $BASE.zip ] || wget $URL
if ! [ -d ../$BASE ]; then
	cd ..
	unzip osgeo4w/$BASE.zip
	cd osgeo4w
fi

R=$OSGEO4W_REP/x86_64/release/$P
mkdir -p $R/$P-devel

vsenv

cat <<EOF >$R/setup.hint
sdesc: "The SQLite3 library for accessing SQLite3 database files (Runtime)."
ldesc: "The SQLite3 library for accessing SQLite3 database files (Runtime)."
category: Libs
requires: msvcrt2019
maintainer: $MAINTAINER
EOF

cat <<EOF >$R/$P-devel/setup.hint
sdesc: "The SQLite3 library for accessing SQLite3 database files (Development)."
ldesc: "The SQLite3 library for accessing SQLite3 database files (Development)."
category: Libs
requires: $P
external-source: $P
maintainer: $MAINTAINER
EOF

cat <<EOF | tee $R/$P-devel/$P-devel-$V-$B.txt >$R/$P-$V-$B.txt
SQLite Copyright

All of the code and documentation in SQLite has been dedicated to the public
domain by the authors. All code authors, and representatives of the companies
they work for, have signed affidavits dedicating their contributions to the
public domain and originals of those signed affidavits are stored in a firesafe
at the main offices of Hwaci. Anyone is free to copy, modify, publish, use,
compile, sell, or distribute the original SQLite code, either in source code
form or as a compiled binary, for any purpose, commercial or non-commercial,
and by any means.

The previous paragraph applies to the deliverable code and documentation in
SQLite - those parts of the SQLite library that you actually bundle and ship
with a larger application. Some scripts used as part of the build process (for
example the "configure" scripts generated by autoconf) might fall under other
open-source licenses. Nothing from these build scripts ever reaches the final
deliverable SQLite library, however, and so the licenses associated with those
scripts should not be a factor in assessing your rights to copy and use the
SQLite library.

All of the deliverable code in SQLite has been written from scratch. No code
has been taken from other projects or from the open internet. Every line of
code can be traced back to its original author, and all of those authors have
public domain dedications on file. So the SQLite code base is clean and is
uncontaminated with licensed code from other projects.
EOF


mkdir -p build-$V
cd build-$V

nmake /f ..\\makefile.vc INSTDIR=../install SRC=../../$BASE clean all install

cd ..

tar -C install -cjf $R/$P-$V-$B.tar.bz2 bin

tar -C install -cjf $R/$P-devel/$P-devel-$V-$B.tar.bz2 include lib

tar -C .. -cjf $R/$P-$V-$B-src.tar.bz2 osgeo4w/package.sh osgeo4w/makefile.vc osgeo4w/nmake.opt osgeo4w/always.h

endlog
