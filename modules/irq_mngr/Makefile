
export OS_KERNEL_CONTAINER_ROOT := $(shell cd ../../;pwd)
export CROSS_COMPILE=arm-poky-linux-gnueabi-
export ARCH=arm


CFILES := irq_mngr.c

KDIR=${OS_KERNEL_CONTAINER_ROOT}/linux

obj-m := irq_mngr.o

ssc-objs := $(CFILES:.c=.o)
all:
		make V=1 -C $(KDIR) M=$(PWD) modules

clean:
		make -C $(KDIR) M=$(PWD) clean
