#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm gwenview qt6ct

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano ffmpeg-mini

# remove qt6webengine, otherwise it gets deployed due to it having a qml plugin
pacman -Rdd --noconfirm qt6-webengine

# build kiconthemes without mandatory link to massive libKF6BreezeIcons.so library
PRE_BUILD_CMDS="
  sed -i -e 's|-DBUILD_TESTING=OFF|-DBUILD_TESTING=OFF -DUSE_BreezeIcons=OFF|g ./PKGBUILD
" make-aur-package --archlinux-pkg kiconthemes

# If the application needs to be manually built that has to be done down here

# if you also have to make nightly releases check for DEVEL_RELEASE = 1
#
# if [ "${DEVEL_RELEASE-}" = 1 ]; then
# 	nightly build steps
# else
# 	regular build steps
# fi
