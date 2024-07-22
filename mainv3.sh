#! /bin/bash

export DEBIAN_FRONTEND="noninteractive"
export DEB_BUILD_MAINT_OPTIONS="optimize=+lto -march=x86-64-v3 -O3 -flto -fuse-linker-plugin -falign-functions=32"
export DEB_CFLAGS_MAINT_APPEND="-march=x86-64-v3 -O3 -flto -fuse-linker-plugin -falign-functions=32"
export DEB_CPPFLAGS_MAINT_APPEND="-march=x86-64-v3 -O3 -flto -fuse-linker-plugin -falign-functions=32"
export DEB_CXXFLAGS_MAINT_APPEND="-march=x86-64-v3 -O3 -flto -fuse-linker-plugin -falign-functions=32"
export DEB_LDFLAGS_MAINT_APPEND="-march=x86-64-v3 -O3 -flto -fuse-linker-plugin -falign-functions=32"
export DEB_BUILD_OPTIONS="nocheck notest terse"
export DPKG_GENSYMBOLS_CHECK_LEVEL=0

# Clone Upstream
git clone https://github.com/Exiv2/exiv2 -b v0.28.3
cp -rvf ./debian ./exiv2/
cd ./exiv2/

# Get build deps
apt-get build-dep ./ -y

# Build package
for i in ../patches/* ; do echo "Applying Patch: $i" && patch -Np1 -i $i || bash -c "echo "Applying Patch $i Failed!" && exit 2"; done
#LOGNAME=root dh_make --createorig -y -l -p exiv2_0.28.3 || echo "dh-make didn't go clean"
LOGNAME=root dh_make --createorig -y -l -p exiv2_0.28.3+dfsg-2 || echo "dh-make didn't go clean"
dpkg-buildpackage --no-sign

# Move the debs to output
cd ../
mkdir -p ./output
mv ./*.deb ./output/
