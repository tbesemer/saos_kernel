# Root of the container, everything referenced from this.
#
export OS_KERNEL_CONTAINER_ROOT := $(shell pwd)
include ${OS_KERNEL_CONTAINER_ROOT}/config/machine.mk
export OS_KERNEL_ROOT := ${OS_KERNEL_CONTAINER_ROOT}/linux
export OS_KERNEL_MODULE_ROOT := ${OS_KERNEL_CONTAINER_ROOT}/deploy
export OS_KERNEL_DEPLOY_ROOT := ${OS_KERNEL_CONTAINER_ROOT}/deploy
export OS_KERNEL_CONFIG_ROOT := ${OS_KERNEL_CONTAINER_ROOT}/config
export OS_KERNEL_SCRIPTS_ROOT := ${OS_KERNEL_CONTAINER_ROOT}/bin

export LOADADDR=0x08008000

.PHONY: all
all: container_submodule_init kernel_standard_uimage kernel_standard_zimage kernel_standard_dtb kernel_standard_modules

.PHONY: kernel_standard_uimage
kernel_standard_uimage: check_env kernel_standard_defconfig
	make -j 4 -C ${OS_KERNEL_ROOT} uImage
	cp -p ${OS_KERNEL_ROOT}/arch/arm/boot/uImage ${OS_KERNEL_DEPLOY_ROOT}/${OS_MACHINE}-uImage

.PHONY: kernel_standard_zimage
kernel_standard_zimage: check_env kernel_standard_defconfig
	make -j 4 -C ${OS_KERNEL_ROOT} zImage
	cp -p ${OS_KERNEL_ROOT}/arch/arm/boot/zImage ${OS_KERNEL_DEPLOY_ROOT}/${OS_MACHINE}-zImage
	ln -fs ${OS_KERNEL_DEPLOY_ROOT}/${OS_MACHINE}-zImage ${OS_KERNEL_DEPLOY_ROOT}/zImage


.PHONY: kernel_standard_dtb
kernel_standard_dtb: check_env kernel_standard_defconfig
	make -j 4 -C ${OS_KERNEL_ROOT} ${OS_MACHINE}.dtb
	cp -p ${OS_KERNEL_ROOT}/arch/arm/boot/dts/${OS_MACHINE}.dtb ${OS_KERNEL_DEPLOY_ROOT}/${OS_MACHINE}.dtb
	ln -fs ${OS_KERNEL_DEPLOY_ROOT}/${OS_MACHINE}.dtb ${OS_KERNEL_DEPLOY_ROOT}/zImage.dtb

.PHONY: kernel_standard_modules
kernel_standard_modules: check_env kernel_standard_defconfig
	make -j 4 -C ${OS_KERNEL_ROOT} modules
	make -j 4 -C ${OS_KERNEL_ROOT} INSTALL_MOD_PATH=${OS_KERNEL_MODULE_ROOT} modules_install

.PHONY: kernel_standard_mrproper
kernel_standard_mrproper: check_env check_env
	make -C ${OS_KERNEL_ROOT} mrproper

.PHONY: kernel_xconfig
kernel_xconfig:
	@ make -C ${OS_KERNEL_ROOT} ARCH=arm xconfig

.PHONY: kernel_standard_defconfig
kernel_standard_defconfig: check_env
	@ if [ -f ${OS_KERNEL_ROOT}/.config ]; \
          then \
            echo "Kernel Contains <.config> file, not overwriting";\
          else\
            cp -p ${OS_KERNEL_CONFIG_ROOT}/kernel_standard_config ${OS_KERNEL_ROOT}/.config; \
            make -C ${OS_KERNEL_ROOT} oldconfig; \
          fi;

.PHONY: kernel_standard_save_defconfig
kernel_standard_save_defconfig: 
	cp -p ${OS_KERNEL_ROOT}/.config ${OS_KERNEL_CONFIG_ROOT}/kernel_standard_config

.PHONY: kernel_deploy_clean
kernel_deploy_clean:
	rm -rf ${OS_KERNEL_DEPLOY_ROOT}/*

.PHONY: container_submodule_init
container_submodule_init:
	@ git submodule update --init

.PHONY: print_machine
print_machine:
	@ echo ${OS_MACHINE}

.PHONY: check_env
check_env:
	@ ${OS_KERNEL_SCRIPTS_ROOT}/do_chk_env.sh set

