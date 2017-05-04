FROM tim03/gcc
MAINTAINER Chen, Wenli <chenwenli@chenwenli.com>

ENV 	PRJROOT=/opt/cross/w64 \
	TARGET=x86_64-w64-mingw32 
ENV 	PREFIX=${PRJROOT}/tools \
	BUILD=${PRJROOT}/build-tools 
ENV 	TARGET_PREFIX=${PREFIX}/${TARGET}
ENV	MAKEOPTS="-j4 -s"
ENV 	PATH=${PATH}:${PREFIX}/bin

COPY createdir.sh .

RUN \
	/bin/bash createdir.sh && rm createdir.sh

ENV BUILD_TOOLS="lzip"

RUN apt-get -qq update && apt-get -qqy install --no-install-recommends \
	$BUILD_TOOLS \
 && apt-get -y autoremove \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* \
 && cd $BUILD \
 && curl -L http://ftp.gnu.org/gnu/binutils/binutils-2.28.tar.gz | tar zxf - \
 && cd build-binutils \
 && ../binutils-2.28/configure --disable-multilib --target=$TARGET --prefix=$PREFIX --with-sysroot=${PREFIX} \
 && make \
 && make install \ 
 && cd $BUILD \ 
 && rm -rf build-binutils binutils-2.28 \
# mingw headers
 && curl -L http://downloads.sourceforge.net/project/mingw-w64/mingw-w64/mingw-w64-release/mingw-w64-v5.0.2.tar.bz2 | tar jxf - \
 && mkdir -p $BUILD/build-mingw-w64-header/ \
 && cd $BUILD/build-mingw-w64-header/ \
 && ../mingw-w64-v5.0.2/configure --host=${TARGET} --prefix=${TARGET_PREFIX} --with-sysroot=${TARGET_PREFIX} --without-crt \
 && make \
 && make install \
 && cd $BUILD \
 && rm -rf build-mingw-w64-header \
# gcc phase 1
 && curl -L http://ftp.tsukuba.wide.ad.jp/software/gcc/releases/gcc-6.3.0/gcc-6.3.0.tar.bz2 | tar jxf - \
 && ln -s $TARGET_PREFIX $PREFIX/mingw \
 && mkdir -p $TARGET_PREFIX/lib \
 && ln -s $TARGET_PREFIX/lib $TARGET_PREFIX/lib64 \
# gmp
 && curl -L https://gmplib.org/download/gmp/gmp-6.1.2.tar.lz | tar --lzip -xf -  \
 && mv gmp-6.1.2 gcc-6.3.0/gmp \
# mpc
 && curl -L ftp://ftp.gnu.org/gnu/mpc/mpc-1.0.3.tar.gz | tar zxf - \
 && mv mpc-1.0.3 gcc-6.3.0/mpc \
# mpfr
 && curl -L http://www.mpfr.org/mpfr-current/mpfr-3.1.5.tar.bz2 | tar jxf - \
 && mv mpfr-3.1.5 gcc-6.3.0/mpfr \
 && cd $BUILD/build-gcc \
 && ../gcc-6.3.0/configure --disable-multilib --target=$TARGET --prefix=$PREFIX --with-sysroot=${PREFIX} --enable-languages=c,c++ \
 && make all-gcc \
 && make install-gcc \
# mingw CRT
 && mkdir -p $BUILD/build-mingw-w64-crt/ \
 && cd $BUILD/build-mingw-w64-crt/ \
 && ../mingw-w64-v5.0.2/configure --host=$TARGET --prefix=$TARGET_PREFIX --without-header --with-sysroot=${TARGET_PREFIX} \
 && make \
 && make install \
 && cd $BUILD \
 && rm -rf build-mingw-w64-crt mingw-w64-v5.0.2 \
# gcc phase 2
 && cd $BUILD/build-gcc \
 && make all \
 && make install \
 && cd $BUILD \
 && rm -rf build-gcc gcc-6.3.0 

ENV LOCALSOURCEDIR /tmp/src/
ENV LOCALDESTDIR /usr
ENV LOCALBUILDDIR /tmp/build/

WORKDIR /tmp
RUN mkdir /tmp/src/
RUN mkdir /tmp/build/

RUN cd ${LOCALSOURCEDIR} && \
	wget -c http://www.nasm.us/pub/nasm/releasebuilds/2.12.02/nasm-2.12.02.tar.gz && \
	cd ${LOCALBUILDDIR} && \
	tar xzf ${LOCALSOURCEDIR}/nasm-2.12.02.tar.gz && \
	cd nasm-2.12.02 && \
	./configure --prefix=${LOCALDESTDIR} && \
	make && \
	make install

RUN cd ${LOCALSOURCEDIR} && \
	wget -c --no-check-certificate http://pkgconfig.freedesktop.org/releases/pkg-config-0.29.1.tar.gz && \
	cd ${LOCALBUILDDIR} && \
	tar xzf ${LOCALSOURCEDIR}/pkg-config-0.29.1.tar.gz && \
	cd pkg-config-0.29.1 && \
	./configure --prefix=${LOCALDESTDIR} && \
	make && \
	make install

ENV includedir /usr/include/
ENV libdir /usr/lib/

RUN cd ${LOCALSOURCEDIR} && \
	wget -c ftp://sourceware.org/pub/libffi/libffi-3.2.1.tar.gz
RUN cd ${LOCALBUILDDIR} && \
	tar zxf ${LOCALSOURCEDIR}/libffi-3.2.1.tar.gz && \
	cd libffi-3.2.1 && \
	sed -e '/^includesdir/ s/$(libdir).*$/$(includedir)/' \
		-i include/Makefile.in && \
	sed -e '/^includedir/ s/=.*$/=@includedir@/' \
		-e 's/^Cflags: -I${includedir}/Cflags:/' \
		-i libffi.pc.in        && \
	./configure --build=x86_64-w64-mingw32 --prefix=${LOCALDESTDIR} && \
	CCAS=nasm make && \
	CCAS=nasm make install

RUN cd ${LOCALSOURCEDIR} && \
	wget -c http://ftp.gnu.org/pub/gnu/gettext/gettext-0.19.4.tar.gz && \
	cd ${LOCALBUILDDIR} && \
	tar xzf ${LOCALSOURCEDIR}/gettext-0.19.4.tar.gz && \
	mv gettext-0.19.4 gettext-0.19.4-runtime && \
	cd gettext-0.19.4-runtime && \
	cat gettext-tools/woe32dll/gettextlib-exports.c | grep -v rpl_opt > gettext-tools/woe32dll/gettextlib-exports.c.new && \
	mv gettext-tools/woe32dll/gettextlib-exports.c.new gettext-tools/woe32dll/gettextlib-exports.c && \
	CFLAGS="-mms-bitfields -mthreads -O2" ./configure --prefix=${LOCALDESTDIR} --enable-threads=win32 --enable-relocatable && \
	cd gettext-runtime && \
	make && \
	make install

RUN cd ${LOCALSOURCEDIR} && \
	wget -c ftp://xmlsoft.org/libxml2/libxml2-2.9.4.tar.gz && \
	cd ${LOCALBUILDDIR} && \
	tar xzf ${LOCALSOURCEDIR}/libxml2-2.9.4.tar.gz && \
	cd libxml2-2.9.4 && \
	./configure --prefix=${LOCALDESTDIR} --with-zlib=${LOCALDESTDIR} --without-python && \
	make && \
	make install 

RUN cd ${LOCALSOURCEDIR} && \
	wget -c http://ftp.gnome.org/pub/gnome/sources/glib/2.48/glib-2.48.1.tar.xz && \
	cd ${LOCALBUILDDIR} && \
	tar xJf ${LOCALSOURCEDIR}/glib-2.48.1.tar.xz && \
	cd glib-2.48.1 && \
	./configure --build=x86_64-w64-mingw32 --prefix=${LOCALDESTDIR} --with-pcre=internal --enable-debug=no --disable-gtk-doc && \
	make && \
	make install

RUN cd ${LOCALSOURCEDIR} && \
	wget -c http://ftp.gnome.org/pub/gnome/sources/gobject-introspection/1.48/gobject-introspection-1.48.0.tar.xz && \
	cd ${LOCALBUILDDIR} && \
	tar xJf ${LOCALSOURCEDIR}/gobject-introspection-1.48.0.tar.xz && \
	cd gobject-introspection-1.48.0 && \
	./configure --build=x86_64-w64-mingw32 --prefix=${LOCALDESTDIR} \
	make && \
	make install

