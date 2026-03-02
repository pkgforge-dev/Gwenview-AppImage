#!/bin/sh

set -eu

ARCH=$(uname -m)
VERSION=$(pacman -Q gwenview | awk '{print $2; exit}') # example command to get version of application here
export ARCH VERSION
export OUTPATH=./dist
export ADD_HOOKS="self-updater.bg.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export ICON=/usr/share/icons/hicolor/128x128/apps/gwenview.png
export DESKTOP=/usr/share/applications/org.kde.gwenview.desktop
export ANYLINUX_LIB=1

# Deploy dependencies
quick-sharun \
	/usr/bin/gwenview* \
	/usr/lib/kf6/kioworker \
	/usr/lib/qt6/plugins/kf6/parts/gvpart.so \
	/usr/lib/qt6/plugins/kf6/kfileitemaction/slideshowfileitemaction.so

# it tries to dlopen pipewire and vulkan, causing a crash in alpine linux...
echo 'ANYLINUX_DO_NOT_LOAD_LIBS=libvulkan*:libpipewire*:${ANYLINUX_DO_NOT_LOAD_LIBS}' >> ./AppDir/.env

# Turn AppDir into AppImage
quick-sharun --make-appimage

# Test the app for 12 seconds, if the test fails due to the app
# having issues running in the CI use --simple-test instead
quick-sharun --test ./dist/*.AppImage
