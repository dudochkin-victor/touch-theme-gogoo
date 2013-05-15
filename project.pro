VERSION = 0.1.6
TEMPLATE = subdirs

# Install rules

# MEEGO THEME
meego.files = ./meego
meego.path = /usr/share/themes
meego.CONFIG += no_check_exist
meego.commands += perl extract.pl meego/meegotouch/svg/ meego/meegotouch/ids.txt

meego_icon.files = ./meego/meegotouch/icons/icon-l-theme-meego.svg
meego_icon.path = /usr/share/themes/base/meegotouch/icons
meego_icon.CONFIG += no_check_exist

INSTALLS += meego \
            meego_icon \

QMAKE_CLEAN += build-stamp configure-stamp
QMAKE_DISTCLEAN += build-stamp configure-stamp
