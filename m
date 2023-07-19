Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD2F5759A20
	for <lists+live-patching@lfdr.de>; Wed, 19 Jul 2023 17:47:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231864AbjGSPrm (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 19 Jul 2023 11:47:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231696AbjGSPrl (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 19 Jul 2023 11:47:41 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB4B01B9
        for <live-patching@vger.kernel.org>; Wed, 19 Jul 2023 08:47:39 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 5738421BFF;
        Wed, 19 Jul 2023 15:47:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1689781658; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6hote0tCM3b928Stqa6vkJdgCZA0THIFFyoL6GFtx0s=;
        b=okcNIO/DpXcihXH+ltovT9WnMieI7BuKZoPyogR5derDll4aoOgKiXSOyrlUXgRiBqABMg
        OEKZkMxtg/IahPkxJT3bdtROMdGtQqu3lwtpV8sGEoMWBZcTZXc1H6mtAbFpM7rwdY355j
        Q7PYZiXghZPu9JiqnE5SXEZORegrvqw=
Received: from suse.cz (unknown [10.100.208.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id D3B1D2C142;
        Wed, 19 Jul 2023 15:47:37 +0000 (UTC)
Date:   Wed, 19 Jul 2023 17:47:37 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     Stefano Stabellini <sstabellini@kernel.org>
Cc:     boris.ostrovsky@oracle.com, jgross@suse.com,
        xen-devel@lists.xenproject.org, Luca Miccio <lucmiccio@gmail.com>,
        Stefano Stabellini <stefano.stabellini@xilinx.com>,
        live-patching@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH LINUX v5 2/2] xen: add support for initializing xenstore
 later as HVM domain
Message-ID: <ZLgFmS4TQwGWA7o0@alley>
References: <alpine.DEB.2.22.394.2205131417320.3842@ubuntu-linux-20-04-desktop>
 <20220513211938.719341-2-sstabellini@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220513211938.719341-2-sstabellini@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri 2022-05-13 14:19:38, Stefano Stabellini wrote:
> From: Luca Miccio <lucmiccio@gmail.com>
> 
> When running as dom0less guest (HVM domain on ARM) the xenstore event
> channel is available at domain creation but the shared xenstore
> interface page only becomes available later on.
> 
> In that case, wait for a notification on the xenstore event channel,
> then complete the xenstore initialization later, when the shared page
> is actually available.
> 
> The xenstore page has few extra field. Add them to the shared struct.
> One of the field is "connection", when the connection is ready, it is
> zero. If the connection is not-zero, wait for a notification.

I see the following warning from free_irq() in 6.5-rc2 when running
livepatching selftests. It does not happen after reverting this patch.

[  352.168453] livepatch: signaling remaining tasks
[  352.173228] ------------[ cut here ]------------
[  352.175563] Trying to free already-free IRQ 0
[  352.177355] WARNING: CPU: 1 PID: 88 at kernel/irq/manage.c:1893 free_irq+0xbf/0x350
[  352.179942] Modules linked in: test_klp_livepatch(EK)
[  352.181621] CPU: 1 PID: 88 Comm: xenbus_probe Kdump: loaded Tainted: G            E K    6.5.0-rc2-default+ #535
[  352.184754] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.15.0-0-g2dd4b9b-rebuilt.opensuse.org 04/01/2014
[  352.188214] RIP: 0010:free_irq+0xbf/0x350
[  352.192211] Code: 7a 08 75 0e e9 36 02 00 00 4c 3b 7b 08 74 5a 48 89 da 48 8b 5a 18 48 85 db 75 ee 44 89 f6 48 c7 c7 58 b0 8b 86 e8 21 0a f5 ff <0f> 0b 48 8b 34 24 4c 89 ef e8 53 bb e3 00 
48 8b 45 40 48 8b 40 78
[  352.200079] RSP: 0018:ffffaf0440b4be80 EFLAGS: 00010086
[  352.201465] RAX: 0000000000000000 RBX: ffff99f105116c80 RCX: 0000000000000003
[  352.203324] RDX: 0000000080000003 RSI: ffffffff8691d4bc RDI: 00000000ffffffff
[  352.204989] RBP: ffff99f100052000 R08: 0000000000000000 R09: c0000000ffff7fff
[  352.206253] R10: ffffaf0440b4bd18 R11: ffffaf0440b4bd10 R12: ffff99f1000521e8
[  352.207451] R13: ffff99f1000520a8 R14: 0000000000000000 R15: ffffffff86f42360
[  352.208787] FS:  0000000000000000(0000) GS:ffff99f15a400000(0000) knlGS:0000000000000000
[  352.210061] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  352.210815] CR2: 00007f8415d56000 CR3: 0000000105e36003 CR4: 0000000000370ee0
[  352.211867] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  352.212912] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[  352.213951] Call Trace:
[  352.214390]  <TASK>
[  352.214717]  ? __warn+0x81/0x170
[  352.215436]  ? free_irq+0xbf/0x350
[  352.215906]  ? report_bug+0x10b/0x200
[  352.216408]  ? prb_read_valid+0x17/0x20
[  352.216926]  ? handle_bug+0x44/0x80
[  352.217409]  ? exc_invalid_op+0x13/0x60
[  352.217932]  ? asm_exc_invalid_op+0x16/0x20
[  352.218497]  ? free_irq+0xbf/0x350
[  352.218979]  ? __pfx_xenbus_probe_thread+0x10/0x10
[  352.219600]  xenbus_probe+0x7a/0x80
[  352.221030]  xenbus_probe_thread+0x76/0xc0
[  352.221416]  ? __pfx_autoremove_wake_function+0x10/0x10
[  352.221882]  kthread+0xfd/0x130
[  352.222191]  ? __pfx_kthread+0x10/0x10
[  352.222544]  ret_from_fork+0x2d/0x50
[  352.222893]  ? __pfx_kthread+0x10/0x10
[  352.223260]  ret_from_fork_asm+0x1b/0x30
[  352.223629] RIP: 0000:0x0
[  352.223931] Code: Unable to access opcode bytes at 0xffffffffffffffd6.
[  352.224488] RSP: 0000:0000000000000000 EFLAGS: 00000000 ORIG_RAX: 0000000000000000
[  352.225044] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
[  352.225571] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
[  352.226106] RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
[  352.226632] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
[  352.227171] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  352.227710]  </TASK>
[  352.227917] irq event stamp: 22
[  352.228209] hardirqs last  enabled at (21): [<ffffffff854240be>] ___slab_alloc+0x68e/0xc80
[  352.228914] hardirqs last disabled at (22): [<ffffffff85fe98fd>] _raw_spin_lock_irqsave+0x8d/0x90
[  352.229546] softirqs last  enabled at (0): [<ffffffff850fc0ee>] copy_process+0xaae/0x1fd0
[  352.230079] softirqs last disabled at (0): [<0000000000000000>] 0x0
[  352.230503] ---[ end trace 0000000000000000 ]---

, where the message "livepatch: signaling remaining tasks" means that
it might send fake signals to non-kthread tasks.

The aim is to force userspace tasks to enter and leave kernel space
so that they might start using the new patched code. It is done
this way:

/*
 * Sends a fake signal to all non-kthread tasks with TIF_PATCH_PENDING set.
 * Kthreads with TIF_PATCH_PENDING set are woken up.
 */
static void klp_send_signals(void)
{
[...]

			/*
			 * Send fake signal to all non-kthread tasks which are
			 * still not migrated.
			 */
			set_notify_signal(task);
[...]

The warning is most likely printed in this condition:

const void *free_irq(unsigned int irq, void *dev_id)
{
	struct irq_desc *desc = irq_to_desc(irq);
	struct irqaction *action;
	const char *devname;

	if (!desc || WARN_ON(irq_settings_is_per_cpu_devid(desc)))
		return NULL;


See below.

> --- a/drivers/xen/xenbus/xenbus_probe.c
> +++ b/drivers/xen/xenbus/xenbus_probe.c
> @@ -750,6 +751,20 @@ static void xenbus_probe(void)
>  {
>  	xenstored_ready = 1;
>  
> +	if (!xen_store_interface) {
> +		xen_store_interface = xen_remap(xen_store_gfn << XEN_PAGE_SHIFT,
> +						XEN_PAGE_SIZE);
> +		/*
> +		 * Now it is safe to free the IRQ used for xenstore late
> +		 * initialization. No need to unbind: it is about to be
> +		 * bound again from xb_init_comms. Note that calling
> +		 * unbind_from_irqhandler now would result in xen_evtchn_close()
> +		 * being called and the event channel not being enabled again
> +		 * afterwards, resulting in missed event notifications.
> +		 */
> +		free_irq(xs_init_irq, &xb_waitq);

Is it possbile that this free_irq(), the fake signal, and the warning
are somehow related, please?

> +	}
> +
>  	/*
>  	 * In the HVM case, xenbus_init() deferred its call to
>  	 * xs_init() in case callbacks were not operational yet.

Best Regards,
Petr
