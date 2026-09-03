#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm \
	breeze        \
	gwenview      \
	kvantum       \
	lxqt-qtplugin \
	oxygen        \
	qt6ct         \
	qt6-imageformats

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano ffmpeg-nano kiconthemes-mini

# remove qt6webengine, otherwise it gets deployed due to it having a qml plugin
pacman -Rdd --noconfirm qt6-webengine

# If the application needs to be manually built that has to be done down here

# if you also have to make nightly releases check for DEVEL_RELEASE = 1
#
# if [ "${DEVEL_RELEASE-}" = 1 ]; then
# 	nightly build steps
# else
# 	regular build steps
# fi
