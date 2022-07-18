Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7709957832A
	for <lists+live-patching@lfdr.de>; Mon, 18 Jul 2022 15:07:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235275AbiGRNHU (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 18 Jul 2022 09:07:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234739AbiGRNHT (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 18 Jul 2022 09:07:19 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E7B6BD9;
        Mon, 18 Jul 2022 06:07:18 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 3DD3E33C3C;
        Mon, 18 Jul 2022 13:07:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1658149637; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=H5Wq7UiyiOTRMUDpc6xc7IitAP2lzVm2pLNGp2lGASQ=;
        b=XtJe6a8nF7pqBa8nRk/UCO84w5sS9fRUTRjOvlycoFn3dsOc0mRZLm8PtJoI7KPHXV4OYW
        mqLLSB7DQg0vcVUn+lBUl5h19Uhz7Atgivc1U2HOM8CxHuJjX9ttutIwrwnyayDSkkAcdQ
        LJFNpWbBrtpRpYRzvwjFhdnyp05AA60=
Received: from suse.cz (unknown [10.100.201.202])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 06BF92C141;
        Mon, 18 Jul 2022 13:07:17 +0000 (UTC)
Date:   Mon, 18 Jul 2022 15:07:16 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     Song Liu <song@kernel.org>
Cc:     bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        live-patching@vger.kernel.org, daniel@iogearbox.net,
        kernel-team@fb.com, jolsa@kernel.org, rostedt@goodmis.org
Subject: Re: [PATCH v3 bpf-next 4/4] bpf: support bpf_trampoline on functions
 with IPMODIFY (e.g. livepatch)
Message-ID: <YtVbBFYbJGiRAv99@alley>
References: <20220718001405.2236811-1-song@kernel.org>
 <20220718001405.2236811-5-song@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220718001405.2236811-5-song@kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Sun 2022-07-17 17:14:05, Song Liu wrote:
> When tracing a function with IPMODIFY ftrace_ops (livepatch), the bpf
> trampoline must follow the instruction pointer saved on stack. This needs
> extra handling for bpf trampolines with BPF_TRAMP_F_CALL_ORIG flag.
> 
> Implement bpf_tramp_ftrace_ops_func and use it for the ftrace_ops used
> by BPF trampoline. This enables tracing functions with livepatch.
> 
> This also requires moving bpf trampoline to *_ftrace_direct_mult APIs.
> 
> --- a/kernel/bpf/trampoline.c
> +++ b/kernel/bpf/trampoline.c
> @@ -13,6 +13,7 @@
>  #include <linux/static_call.h>
>  #include <linux/bpf_verifier.h>
>  #include <linux/bpf_lsm.h>
> +#include <linux/delay.h>
>  
>  /* dummy _ops. The verifier will operate on target program's ops. */
>  const struct bpf_verifier_ops bpf_extension_verifier_ops = {
> @@ -29,6 +30,81 @@ static struct hlist_head trampoline_table[TRAMPOLINE_TABLE_SIZE];
>  /* serializes access to trampoline_table */
>  static DEFINE_MUTEX(trampoline_mutex);
>  
> +#ifdef CONFIG_DYNAMIC_FTRACE_WITH_DIRECT_CALLS
> +static int bpf_trampoline_update(struct bpf_trampoline *tr, bool lock_direct_mutex);
> +
> +static int bpf_tramp_ftrace_ops_func(struct ftrace_ops *ops, enum ftrace_ops_cmd cmd)
> +{
> +	struct bpf_trampoline *tr = ops->private;
> +	int ret = 0;
> +
> +	if (cmd == FTRACE_OPS_CMD_ENABLE_SHARE_IPMODIFY_SELF) {
> +		/* This is called inside register_ftrace_direct_multi(), so
> +		 * tr->mutex is already locked.
> +		 */
> +		WARN_ON_ONCE(!mutex_is_locked(&tr->mutex));

Again, better is:

		lockdep_assert_held_once(&tr->mutex);

> +
> +		/* Instead of updating the trampoline here, we propagate
> +		 * -EAGAIN to register_ftrace_direct_multi(). Then we can
> +		 * retry register_ftrace_direct_multi() after updating the
> +		 * trampoline.
> +		 */
> +		if ((tr->flags & BPF_TRAMP_F_CALL_ORIG) &&
> +		    !(tr->flags & BPF_TRAMP_F_ORIG_STACK)) {
> +			if (WARN_ON_ONCE(tr->flags & BPF_TRAMP_F_SHARE_IPMODIFY))
> +				return -EBUSY;
> +
> +			tr->flags |= BPF_TRAMP_F_SHARE_IPMODIFY;
> +			return -EAGAIN;
> +		}
> +
> +		return 0;
> +	}
> +
> +	/* The normal locking order is
> +	 *    tr->mutex => direct_mutex (ftrace.c) => ftrace_lock (ftrace.c)
> +	 *
> +	 * The following two commands are called from
> +	 *
> +	 *   prepare_direct_functions_for_ipmodify
> +	 *   cleanup_direct_functions_after_ipmodify
> +	 *
> +	 * In both cases, direct_mutex is already locked. Use
> +	 * mutex_trylock(&tr->mutex) to avoid deadlock in race condition
> +	 * (something else is making changes to this same trampoline).
> +	 */
> +	if (!mutex_trylock(&tr->mutex)) {
> +		/* sleep 1 ms to make sure whatever holding tr->mutex makes
> +		 * some progress.
> +		 */
> +		msleep(1);
> +		return -EAGAIN;
> +	}

Huh, this looks horrible. And I do not get it. The above block prints
a warning when the mutex is not taken. Why it is already taken
when cmd == FTRACE_OPS_CMD_ENABLE_SHARE_IPMODIFY_SELF
and why it has to be explicitly taken otherwise?

Would it be possible to call prepare_direct_functions_for_ipmodify(),
cleanup_direct_functions_after_ipmodify() with rt->mutex already taken
so that the ordering is correct even in this case.

That said, this is the first version when I am in Cc. I am not sure
if it has already been discussed.


> +	switch (cmd) {
> +	case FTRACE_OPS_CMD_ENABLE_SHARE_IPMODIFY_PEER:
> +		tr->flags |= BPF_TRAMP_F_SHARE_IPMODIFY;
> +
> +		if ((tr->flags & BPF_TRAMP_F_CALL_ORIG) &&
> +		    !(tr->flags & BPF_TRAMP_F_ORIG_STACK))
> +			ret = bpf_trampoline_update(tr, false /* lock_direct_mutex */);
> +		break;
> +	case FTRACE_OPS_CMD_DISABLE_SHARE_IPMODIFY_PEER:
> +		tr->flags &= ~BPF_TRAMP_F_SHARE_IPMODIFY;
> +
> +		if (tr->flags & BPF_TRAMP_F_ORIG_STACK)
> +			ret = bpf_trampoline_update(tr, false /* lock_direct_mutex */);
> +		break;
> +	default:
> +		ret = -EINVAL;
> +		break;
> +	};
> +
> +	mutex_unlock(&tr->mutex);
> +	return ret;
> +}
> +#endif
> +
>  bool bpf_prog_has_trampoline(const struct bpf_prog *prog)
>  {
>  	enum bpf_attach_type eatype = prog->expected_attach_type;

Note that I did not do proper review. I not much familiar with the
ftrace code. I just wanted to check how much this patchset affects
livepatching and noticed the commented things.

Best Regards,
Petr
