################################################################################
#
# retis
#
################################################################################

#RETIS_VERSION = 1.4.0
#RETIS_SITE = $(call github,retis-org,retis,v$(RETIS_VERSION))
RETIS_SITE = ../retis
RETIS_SITE_METHOD = local
RETIS_LICENSE = GPLv2
RETIS_LICENSE_FILES = LICENSE

RETIS_DEPENDENCIES = \
	host-clang \
	host-jq	\
	host-llvm \
	host-rustc \
	elfutils \
	libpcap \
	python3 \
	zlib

define RETIS_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(PKG_CARGO_ENV) \
		PYO3_CROSS_LIB_DIR="$(STAGING_DIR)/usr/lib/python$(PYTHON3_VERSION_MAJOR)" \
		$(MAKE) release -C $(@D)
endef

define RETIS_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/target/$(RUSTC_TARGET_NAME)/release/retis \
		$(TARGET_DIR)/usr/bin/retis
	mkdir -p $(TARGET_DIR)/etc/retis/profiles/
	$(INSTALL) -D -m 0644 $(@D)/retis/profiles/* \
		$(TARGET_DIR)/etc/retis/profiles/
endef

$(eval $(generic-package))
