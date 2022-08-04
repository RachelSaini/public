install_dir="/usr/local"
boost_version="1_76_0"
#
apk add autoconf automake build-base cmake curl git libtool linux-headers perl pkgconf python3 python3-dev re2c tar
#
apk add icu-dev libexecinfo-dev openssl-dev qt5-qtbase-dev qt5-qttools-dev qt5-qtsvg-dev zlib-dev
#
git clone --shallow-submodules --recurse-submodules https://github.com/ninja-build/ninja.git ~/ninja && cd ~/ninja
git checkout "$(git tag -l --sort=-v:refname "v*" | head -n 1)" # always checkout the latest release
cmake -Wno-dev -Wno-deprecated -B build \
	-D CMAKE_CXX_STANDARD="17" \
	-D CMAKE_CXX_FLAGS="-w" \
	-D CMAKE_INSTALL_PREFIX="${install_dir}"
cmake --build build
cmake --install build
#
curl -sNLk https://boostorg.jfrog.io/artifactory/main/release/${boost_version//_/.}/source/boost_${boost_version}.tar.gz -o "$HOME/boost_${boost_version}.tar.gz"
tar xf "$HOME/boost_${boost_version}.tar.gz" -C "$HOME"
#
git clone --shallow-submodules --recurse-submodules https://github.com/arvidn/libtorrent.git ~/libtorrent && cd ~/libtorrent
# git checkout $(git tag -l --sort=-v:refname "v2*" | head -n 1) # always checkout the latest release of libtorrent v2
git checkout "$(git tag -l --sort=-v:refname "v2*" | head -n 1)" # always checkout the latest release of libtorrent v1
cmake -Wno-dev -Wno-deprecated -G Ninja -B build \
	-D CMAKE_BUILD_TYPE="Release" \
	-D CMAKE_CXX_STANDARD="17" \
	-D CMAKE_CXX_FLAGS="-w" \
	-D BOOST_INCLUDEDIR="$HOME/boost_${boost_version}/" \
	-D CMAKE_INSTALL_LIBDIR="lib" \
	-D CMAKE_INSTALL_PREFIX="${install_dir}"
cmake --build build
cmake --install build
#
git clone --shallow-submodules --recurse-submodules https://github.com/qbittorrent/qBittorrent.git ~/qbittorrent && cd ~/qbittorrent
git checkout "$(git tag -l --sort=-v:refname | head -n 1)" # always checkout the latest release of qbittorrent
cmake -Wno-dev -Wno-deprecated -G Ninja -B build \
	-D CMAKE_BUILD_TYPE="release" \
	-D CMAKE_CXX_STANDARD="17" \
	-D CMAKE_CXX_FLAGS="-w" \
	-D GUI=OFF \
	-D BOOST_INCLUDEDIR="$HOME/boost_${boost_version}/" \
	-D CMAKE_CXX_STANDARD_LIBRARIES="/usr/lib/libexecinfo.so" \
	-D CMAKE_INSTALL_PREFIX="${install_dir}"
cmake --build build
cmake --install build
#
cd && rm -rf qbittorrent libtorrent ninja boost_${boost_version} boost_${boost_version}.tar.gz
