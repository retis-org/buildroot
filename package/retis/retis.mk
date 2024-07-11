################################################################################
#
# retis
#
################################################################################

RETIS_VERSION = 1.4.0
RETIS_SITE = $(call github,retis-org,retis,v$(RETIS_VERSION))
RETIS_LICENSE = GPLv2
RETIS_LICENSE_FILES = LICENSE

RETIS_DEPENDENCIES = \
	host-clang \
	host-elfutils \
	host-jq	\
	host-llvm \
	host-rustc \
	host-zlib \
	elfutils \
	libpcap \
	zlib

# Do not build Python support by default.
RETIS_CARGO_CMD_OPTS = --offline --locked --no-default-features

ifeq ($(BR2_PACKAGE_PYTHON3),y)
RETIS_DEPENDENCIES += python3
RETIS_CARGO_CMD_OPTS += -F python
endif

define RETIS_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) $(PKG_CARGO_ENV) \
		CLANG=$(HOST_DIR)/bin/clang \
		PYO3_CROSS_LIB_DIR="$(STAGING_DIR)/usr/lib/python$(PYTHON3_VERSION_MAJOR)" \
		$(MAKE) release -C $(@D) CARGO_CMD_OPTS="$(RETIS_CARGO_CMD_OPTS)"
endef

define RETIS_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/target/$(RUSTC_TARGET_NAME)/release/retis \
		$(TARGET_DIR)/usr/bin/retis
	mkdir -p $(TARGET_DIR)/etc/retis/profiles/
	$(INSTALL) -D -m 0644 $(@D)/retis/profiles/* \
		$(TARGET_DIR)/etc/retis/profiles/
endef

$(eval $(cargo-package))
