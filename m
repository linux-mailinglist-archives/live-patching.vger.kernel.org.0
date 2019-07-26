Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5058C75CBA
	for <lists+live-patching@lfdr.de>; Fri, 26 Jul 2019 04:08:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726193AbfGZCH6 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 25 Jul 2019 22:07:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53084 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725838AbfGZCH6 (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 25 Jul 2019 22:07:58 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id F2552308424C;
        Fri, 26 Jul 2019 02:07:56 +0000 (UTC)
Received: from redhat.com (ovpn-120-92.rdu2.redhat.com [10.10.120.92])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1E37A36FB;
        Fri, 26 Jul 2019 02:07:54 +0000 (UTC)
Date:   Thu, 25 Jul 2019 22:07:52 -0400
From:   Joe Lawrence <joe.lawrence@redhat.com>
To:     Masami Hiramatsu <mhiramat@kernel.org>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Naveen N . Rao" <naveen.n.rao@linux.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH] kprobes: Allow kprobes coexist with livepatch
Message-ID: <20190726020752.GA6388@redhat.com>
References: <156403587671.30117.5233558741694155985.stgit@devnote2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156403587671.30117.5233558741694155985.stgit@devnote2>
User-Agent: Mutt/1.12.0 (2019-05-25)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.40]); Fri, 26 Jul 2019 02:07:57 +0000 (UTC)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu, Jul 25, 2019 at 03:24:37PM +0900, Masami Hiramatsu wrote:
> Allow kprobes which do not modify regs->ip, coexist with livepatch
> by dropping FTRACE_OPS_FL_IPMODIFY from ftrace_ops.
> 
> User who wants to modify regs->ip (e.g. function fault injection)
> must set a dummy post_handler to its kprobes when registering.
> However, if such regs->ip modifying kprobes is set on a function,
> that function can not be livepatched.
> 
> Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
> ---
>  kernel/kprobes.c |   56 +++++++++++++++++++++++++++++++++++++++---------------
>  1 file changed, 40 insertions(+), 16 deletions(-)
> 
> diff --git a/kernel/kprobes.c b/kernel/kprobes.c
> index 9873fc627d61..29065380dad0 100644
> --- a/kernel/kprobes.c
> +++ b/kernel/kprobes.c
> @@ -961,9 +961,16 @@ static struct kprobe *alloc_aggr_kprobe(struct kprobe *p)
>  
>  #ifdef CONFIG_KPROBES_ON_FTRACE
>  static struct ftrace_ops kprobe_ftrace_ops __read_mostly = {
> +	.func = kprobe_ftrace_handler,
> +	.flags = FTRACE_OPS_FL_SAVE_REGS,
> +};
> +
> +static struct ftrace_ops kprobe_ipmodify_ops __read_mostly = {
>  	.func = kprobe_ftrace_handler,
>  	.flags = FTRACE_OPS_FL_SAVE_REGS | FTRACE_OPS_FL_IPMODIFY,
>  };
> +
> +static int kprobe_ipmodify_enabled;
>  static int kprobe_ftrace_enabled;
>  
>  /* Must ensure p->addr is really on ftrace */
> @@ -976,58 +983,75 @@ static int prepare_kprobe(struct kprobe *p)
>  }
>  
>  /* Caller must lock kprobe_mutex */
> -static int arm_kprobe_ftrace(struct kprobe *p)
> +static int __arm_kprobe_ftrace(struct kprobe *p, struct ftrace_ops *ops,
> +			       int *cnt)
>  {
>  	int ret = 0;
>  
> -	ret = ftrace_set_filter_ip(&kprobe_ftrace_ops,
> -				   (unsigned long)p->addr, 0, 0);
> +	ret = ftrace_set_filter_ip(ops, (unsigned long)p->addr, 0, 0);
>  	if (ret) {
>  		pr_debug("Failed to arm kprobe-ftrace at %pS (%d)\n",
>  			 p->addr, ret);
>  		return ret;
>  	}
>  
> -	if (kprobe_ftrace_enabled == 0) {
> -		ret = register_ftrace_function(&kprobe_ftrace_ops);
> +	if (*cnt == 0) {
> +		ret = register_ftrace_function(ops);
>  		if (ret) {
>  			pr_debug("Failed to init kprobe-ftrace (%d)\n", ret);
>  			goto err_ftrace;
>  		}
>  	}
>  
> -	kprobe_ftrace_enabled++;
> +	(*cnt)++;
>  	return ret;
>  
>  err_ftrace:
>  	/*
> -	 * Note: Since kprobe_ftrace_ops has IPMODIFY set, and ftrace requires a
> -	 * non-empty filter_hash for IPMODIFY ops, we're safe from an accidental
> -	 * empty filter_hash which would undesirably trace all functions.
> +	 * At this point, sinec ops is not registered, we should be sefe from
> +	 * registering empty filter.
>  	 */
> -	ftrace_set_filter_ip(&kprobe_ftrace_ops, (unsigned long)p->addr, 1, 0);
> +	ftrace_set_filter_ip(ops, (unsigned long)p->addr, 1, 0);
>  	return ret;
>  }
>  
> +static int arm_kprobe_ftrace(struct kprobe *p)
> +{
> +	bool ipmodify = (p->post_handler != NULL);
> +
> +	return __arm_kprobe_ftrace(p,
> +		ipmodify ? &kprobe_ipmodify_ops : &kprobe_ftrace_ops,
> +		ipmodify ? &kprobe_ipmodify_enabled : &kprobe_ftrace_enabled);
> +}
> +
>  /* Caller must lock kprobe_mutex */
> -static int disarm_kprobe_ftrace(struct kprobe *p)
> +static int __disarm_kprobe_ftrace(struct kprobe *p, struct ftrace_ops *ops,
> +				  int *cnt)
>  {
>  	int ret = 0;
>  
> -	if (kprobe_ftrace_enabled == 1) {
> -		ret = unregister_ftrace_function(&kprobe_ftrace_ops);
> +	if (*cnt == 1) {
> +		ret = unregister_ftrace_function(ops);
>  		if (WARN(ret < 0, "Failed to unregister kprobe-ftrace (%d)\n", ret))
>  			return ret;
>  	}
>  
> -	kprobe_ftrace_enabled--;
> +	(*cnt)--;
>  
> -	ret = ftrace_set_filter_ip(&kprobe_ftrace_ops,
> -			   (unsigned long)p->addr, 1, 0);
> +	ret = ftrace_set_filter_ip(ops, (unsigned long)p->addr, 1, 0);
>  	WARN_ONCE(ret < 0, "Failed to disarm kprobe-ftrace at %pS (%d)\n",
>  		  p->addr, ret);
>  	return ret;
>  }
> +
> +static int disarm_kprobe_ftrace(struct kprobe *p)
> +{
> +	bool ipmodify = (p->post_handler != NULL);
> +
> +	return __disarm_kprobe_ftrace(p,
> +		ipmodify ? &kprobe_ipmodify_ops : &kprobe_ftrace_ops,
> +		ipmodify ? &kprobe_ipmodify_enabled : &kprobe_ftrace_enabled);
> +}
>  #else	/* !CONFIG_KPROBES_ON_FTRACE */
>  #define prepare_kprobe(p)	arch_prepare_kprobe(p)
>  #define arm_kprobe_ftrace(p)	(-ENODEV)
> 

Thanks for the quick patch, Masami!

I gave it a spin and here are my new testing results:


perf probe, then livepatch
--------------------------

% perf probe --add cmdline_proc_show
Added new event:
  probe:cmdline_proc_show (on cmdline_proc_show)

You can now use it in all perf tools, such as:

        perf record -e probe:cmdline_proc_show -aR sleep 1

% perf record -e probe:cmdline_proc_show -aR sleep 30 &
[1] 980

% insmod samples/livepatch/livepatch-sample.ko

% cat /proc/cmdline 
this has been live patched

% fg
perf record -e probe:cmdline_proc_show -aR sleep 30
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.177 MB perf.data (2 samples) ]

% perf script
          insmod   983 [000]   157.126556: probe:cmdline_proc_show: (ffffffff9bf74890)
             cat   985 [000]   162.304028: probe:cmdline_proc_show: (ffffffff9bf74890)


livepatch, then perf probe
--------------------------

% insmod samples/livepatch/livepatch-sample.ko

% cat /proc/cmdline 
this has been live patched

% perf record -e probe:cmdline_proc_show -aR sleep 30
event syntax error: 'probe:cmdline_proc_show'
                     \___ unknown tracepoint

Error:  File /sys/kernel/debug/tracing/events/probe/cmdline_proc_show not found.
Hint:   Perhaps this kernel misses some CONFIG_ setting to enable this feature?.

Run 'perf list' for a list of valid events

 Usage: perf record [<options>] [<command>]
    or: perf record [<options>] -- <command> [<options>]

    -e, --event <event>   event selector. use 'perf list' to list available events


These results reflect my underestanding of FTRACE_OPS_FL_IPMODIFY in
light of your changes, so feel free to add my:

Acked-by: Joe Lawrence <joe.lawrence@redhat.com>

-- Joe
