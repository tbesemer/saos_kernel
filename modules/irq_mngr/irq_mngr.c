
#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/kthread.h>
#include <linux/kernel.h>
#include <linux/kthread.h>
#include <linux/types.h>
#include <linux/errno.h>
#include <linux/miscdevice.h>
#include <linux/ioport.h>
#include <linux/fcntl.h>
#include <linux/init.h>
#include <linux/proc_fs.h>
#include <linux/seq_file.h>
#include <linux/spinlock.h>
#include <linux/io.h>
#include <linux/uaccess.h>
#include <linux/mutex.h>
#include <linux/clk.h>
#include <linux/delay.h>
#include <linux/wait.h>
#include <linux/semaphore.h>

#include <sound/core.h>
#include <sound/pcm.h>
#include <sound/pcm_params.h>
#include <sound/initval.h>
#include <sound/soc.h>

static irqreturn_t irq_mngr_handle_tenk(int irq, void *p)
{

    return( IRQ_HANDLED );
}

static ssize_t irq_mngr_read(struct file *file, char __user *buf,
						size_t count, loff_t *ppos)
{
unsigned int minor;

    minor = iminor( file_inode(file) );

    return 0;

}

static ssize_t irq_mngr_write(struct file *file, const char __user *buf,
						size_t count, loff_t *ppos)
{
unsigned int minor;

    minor = iminor( file_inode(file) );

    return 0;
}


static long irq_mngr_ioctl(struct file *file, unsigned int cmd,
			unsigned long arg)
{
unsigned int minor;


    minor = iminor( file_inode(file) );

    switch (cmd) {
	default:
	   return( -EINVAL );
    }

    return( 0 );
}

static int irq_mngr_open(struct inode *inode, struct file *file)
{

	return 0;
}

static int irq_mngr_release(struct inode *inode, struct file *file)
{

	return 0;
}


int irqMngrCnt = 0;

static int irq_mngr_proc_show(struct seq_file *m, void *v)
{
	seq_printf( m, "irq_mngr_proc_show(): Called, irqMngrCnt = %d\n", irqMngrCnt++ );
	return( 0 );
}

static int irq_mngr_proc_open(struct inode *inode, struct  file *file)
{
    return( single_open(file, irq_mngr_proc_show, NULL) );
}

static const struct file_operations irq_mngr_proc_fops = {
	.owner = THIS_MODULE,
	.open = irq_mngr_proc_open,
	.read = seq_read,
	.llseek = seq_lseek,
	.release = single_release,
};

static int irq_mngr_proc_init(void)
{
    proc_create("irq_mngr", 0, NULL, &irq_mngr_proc_fops);
    return 0;
}

static void irq_mngr_proc_exit(void)
{
	remove_proc_entry("irq_mngr", NULL);
}



static const struct file_operations irq_mngr_fops = {
	.owner		= THIS_MODULE,
	.read		= irq_mngr_read,
	.write		= irq_mngr_write,
	.unlocked_ioctl	= irq_mngr_ioctl,
	.open		= irq_mngr_open,
	.release	= irq_mngr_release,
};


static int __init irq_mngr_init(void)
{
	int ret;

	ret = register_chrdev( 40, "irq_mngr", &irq_mngr_fops );
	if( ret < 0 ) {
	    printk( "irq_mngr_init(): registr_chrdev() failed\n" );
	    return( 0 );
	}
	
    	irq_mngr_proc_init();

	printk( "irq_mngr_init(): Registered, need to buy bullets\n" );

	return 0;
}

static void __exit irq_mngr_cleanup_module(void)
{
 
    irq_mngr_proc_exit();
    unregister_chrdev( 40, "irq_mngr" );
    printk( "irq_mngr_cleanup_module(): Unregistered\n" );

}

module_init(irq_mngr_init);
module_exit(irq_mngr_cleanup_module);

MODULE_LICENSE("GPL");
MODULE_ALIAS_MISCDEV(0);

