Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B06157DB44
	for <lists+live-patching@lfdr.de>; Fri, 22 Jul 2022 09:31:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233126AbiGVHbO (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 22 Jul 2022 03:31:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbiGVHbN (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 22 Jul 2022 03:31:13 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FD081409B;
        Fri, 22 Jul 2022 00:31:12 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id y4so4817294edc.4;
        Fri, 22 Jul 2022 00:31:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=cMGjEmksGbq9ZooTMM1T/lY+pXcCKXDwE4wNoSrZ2hg=;
        b=TH76iLy9dvr523IuccT1AOnxbJj7Vw/nTEElft6axnsDsxIsuiGK4+6sOYDo9BKjAA
         WTUrmOVDsR+jeydmqR8jse+I0zm445ccZzT6qPpImA7HnfClaVJbYmNQiRA0LhMm8tEj
         He8cjOcx+W9q+KWlf2G5BFTCFW0g5mwmb6Fg+oEYIRfPfiq6VxXTEVJKeS2cx+NtljZH
         IP4NkCHIAiATaBPEwr6ywlmZVbrdVmd2FqiETRr2Td/zComgi9n2ItFQIeAQnZ9ESkjf
         LKJ8abidkrNtELsV15R8nUreCgYxqLkLNQuFd4OvcK1/gyFLRnMgB+WQDQp+cB1m9NLf
         dX+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=cMGjEmksGbq9ZooTMM1T/lY+pXcCKXDwE4wNoSrZ2hg=;
        b=HD/0cDX+bKY4jccxRsef0BFwX8G967EU4ygExngMHsyZw7KMJ5qTo7SWGlKftbUEKJ
         bpZWlAm4JeKNVSYDTHnwcl+vsaTNXmrweMo2ByMH6IdqTtpCn8ldlXY5Vml5Nmzy8ghC
         1gHkirrHJ1KNaS9xQExOV53k0g6+u9476SPIHmRQgCLS6QVu8JGiCTgeZLErIRxrD36l
         OmdqfjHmo5Mr1JjwtIen5a6+90P4njDs43dCq+3V9IhxoYG4WJ/TPKx25/lxgZZ4huk8
         0hrPrCZG6RhieyirOlVTfZtE/AP8VtclWmdni8rlZSqej3+anfKZNH9QJ6rgIlxQJDF7
         Zy4w==
X-Gm-Message-State: AJIora+6WP+QtkuyQvJ2kNWTLmGJNkt2pDvjlumZ8apXUSmyz6PI+awB
        t/23eguqT9LS6tLaFHwWrTMcuc7QwGpqUA==
X-Google-Smtp-Source: AGRyM1v6WwER6wO/fnkL1PHTHIGpTaaecpjJsSwgHXEMUn5jy38kGSke8plJPNJtK4Gd53v1z4UzrQ==
X-Received: by 2002:a05:6402:240a:b0:437:d2b6:3dde with SMTP id t10-20020a056402240a00b00437d2b63ddemr2160536eda.62.1658475070614;
        Fri, 22 Jul 2022 00:31:10 -0700 (PDT)
Received: from krava ([193.85.244.190])
        by smtp.gmail.com with ESMTPSA id w7-20020aa7dcc7000000b0043a83f77b59sm2086796edu.48.2022.07.22.00.31.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Jul 2022 00:31:09 -0700 (PDT)
From:   Jiri Olsa <olsajiri@gmail.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
Date:   Fri, 22 Jul 2022 09:31:05 +0200
To:     Song Liu <song@kernel.org>
Cc:     bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        live-patching@vger.kernel.org, daniel@iogearbox.net,
        kernel-team@fb.com, rostedt@goodmis.org
Subject: Re: [PATCH v5 bpf-next 4/4] bpf: Support bpf_trampoline on functions
 with IPMODIFY (e.g. livepatch)
Message-ID: <YtpSOTlpHbKOKTDJ@krava>
References: <20220720002126.803253-1-song@kernel.org>
 <20220720002126.803253-5-song@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220720002126.803253-5-song@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, Jul 19, 2022 at 05:21:26PM -0700, Song Liu wrote:

SNIP

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
> @@ -89,6 +165,16 @@ static struct bpf_trampoline *bpf_trampoline_lookup(u64 key)
>  	tr = kzalloc(sizeof(*tr), GFP_KERNEL);
>  	if (!tr)
>  		goto out;
> +#ifdef CONFIG_DYNAMIC_FTRACE_WITH_DIRECT_CALLS
> +	tr->fops = kzalloc(sizeof(struct ftrace_ops), GFP_KERNEL);
> +	if (!tr->fops) {
> +		kfree(tr);
> +		tr = NULL;
> +		goto out;
> +	}

would it be easier to put ftrace_ops directly to bpf_trampoline,
not just pointer.. it's allocated and freed at the same point

I recall there were some include issues when I tried that long
time ago [1], but could make the change bit simpler

[1] https://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git/commit/?h=bpf/batch&id=52a1d4acdf55df41e99ca2cea51865e6821036ce

jirka

> +	tr->fops->private = tr;
> +	tr->fops->ops_func = bpf_tramp_ftrace_ops_func;
> +#endif
>  
>  	tr->key = key;
>  	INIT_HLIST_NODE(&tr->hlist);
> @@ -128,7 +214,7 @@ static int unregister_fentry(struct bpf_trampoline *tr, void *old_addr)
>  	int ret;
>  
>  	if (tr->func.ftrace_managed)
> -		ret = unregister_ftrace_direct((long)ip, (long)old_addr);
> +		ret = unregister_ftrace_direct_multi(tr->fops, (long)old_addr);
>  	else
>  		ret = bpf_arch_text_poke(ip, BPF_MOD_CALL, old_addr, NULL);
>  
> @@ -137,15 +223,20 @@ static int unregister_fentry(struct bpf_trampoline *tr, void *old_addr)
>  	return ret;
>  }
>  
> -static int modify_fentry(struct bpf_trampoline *tr, void *old_addr, void *new_addr)
> +static int modify_fentry(struct bpf_trampoline *tr, void *old_addr, void *new_addr,
> +			 bool lock_direct_mutex)
>  {
>  	void *ip = tr->func.addr;
>  	int ret;
>  
> -	if (tr->func.ftrace_managed)
> -		ret = modify_ftrace_direct((long)ip, (long)old_addr, (long)new_addr);
> -	else
> +	if (tr->func.ftrace_managed) {
> +		if (lock_direct_mutex)
> +			ret = modify_ftrace_direct_multi(tr->fops, (long)new_addr);
> +		else
> +			ret = modify_ftrace_direct_multi_nolock(tr->fops, (long)new_addr);
> +	} else {
>  		ret = bpf_arch_text_poke(ip, BPF_MOD_CALL, old_addr, new_addr);
> +	}
>  	return ret;
>  }
>  
> @@ -163,10 +254,12 @@ static int register_fentry(struct bpf_trampoline *tr, void *new_addr)
>  	if (bpf_trampoline_module_get(tr))
>  		return -ENOENT;
>  
> -	if (tr->func.ftrace_managed)
> -		ret = register_ftrace_direct((long)ip, (long)new_addr);
> -	else
> +	if (tr->func.ftrace_managed) {
> +		ftrace_set_filter_ip(tr->fops, (unsigned long)ip, 0, 0);
> +		ret = register_ftrace_direct_multi(tr->fops, (long)new_addr);
> +	} else {
>  		ret = bpf_arch_text_poke(ip, BPF_MOD_CALL, NULL, new_addr);
> +	}
>  
>  	if (ret)
>  		bpf_trampoline_module_put(tr);
> @@ -332,11 +425,11 @@ static struct bpf_tramp_image *bpf_tramp_image_alloc(u64 key, u32 idx)
>  	return ERR_PTR(err);
>  }
>  
> -static int bpf_trampoline_update(struct bpf_trampoline *tr)
> +static int bpf_trampoline_update(struct bpf_trampoline *tr, bool lock_direct_mutex)
>  {
>  	struct bpf_tramp_image *im;
>  	struct bpf_tramp_links *tlinks;
> -	u32 flags = BPF_TRAMP_F_RESTORE_REGS;
> +	u32 orig_flags = tr->flags;
>  	bool ip_arg = false;
>  	int err, total;
>  
> @@ -358,18 +451,31 @@ static int bpf_trampoline_update(struct bpf_trampoline *tr)
>  		goto out;
>  	}
>  
> +	/* clear all bits except SHARE_IPMODIFY */
> +	tr->flags &= BPF_TRAMP_F_SHARE_IPMODIFY;
> +
>  	if (tlinks[BPF_TRAMP_FEXIT].nr_links ||
> -	    tlinks[BPF_TRAMP_MODIFY_RETURN].nr_links)
> +	    tlinks[BPF_TRAMP_MODIFY_RETURN].nr_links) {
>  		/* NOTE: BPF_TRAMP_F_RESTORE_REGS and BPF_TRAMP_F_SKIP_FRAME
>  		 * should not be set together.
>  		 */
> -		flags = BPF_TRAMP_F_CALL_ORIG | BPF_TRAMP_F_SKIP_FRAME;
> +		tr->flags |= BPF_TRAMP_F_CALL_ORIG | BPF_TRAMP_F_SKIP_FRAME;
> +	} else {
> +		tr->flags |= BPF_TRAMP_F_RESTORE_REGS;
> +	}
>  
>  	if (ip_arg)
> -		flags |= BPF_TRAMP_F_IP_ARG;
> +		tr->flags |= BPF_TRAMP_F_IP_ARG;
> +
> +#ifdef CONFIG_DYNAMIC_FTRACE_WITH_DIRECT_CALLS
> +again:
> +	if ((tr->flags & BPF_TRAMP_F_SHARE_IPMODIFY) &&
> +	    (tr->flags & BPF_TRAMP_F_CALL_ORIG))
> +		tr->flags |= BPF_TRAMP_F_ORIG_STACK;
> +#endif
>  
>  	err = arch_prepare_bpf_trampoline(im, im->image, im->image + PAGE_SIZE,
> -					  &tr->func.model, flags, tlinks,
> +					  &tr->func.model, tr->flags, tlinks,
>  					  tr->func.addr);
>  	if (err < 0)
>  		goto out;
> @@ -378,17 +484,34 @@ static int bpf_trampoline_update(struct bpf_trampoline *tr)
>  	WARN_ON(!tr->cur_image && tr->selector);
>  	if (tr->cur_image)
>  		/* progs already running at this address */
> -		err = modify_fentry(tr, tr->cur_image->image, im->image);
> +		err = modify_fentry(tr, tr->cur_image->image, im->image, lock_direct_mutex);
>  	else
>  		/* first time registering */
>  		err = register_fentry(tr, im->image);
> +
> +#ifdef CONFIG_DYNAMIC_FTRACE_WITH_DIRECT_CALLS
> +	if (err == -EAGAIN) {
> +		/* -EAGAIN from bpf_tramp_ftrace_ops_func. Now
> +		 * BPF_TRAMP_F_SHARE_IPMODIFY is set, we can generate the
> +		 * trampoline again, and retry register.
> +		 */
> +		/* reset fops->func and fops->trampoline for re-register */
> +		tr->fops->func = NULL;
> +		tr->fops->trampoline = 0;
> +		goto again;
> +	}
> +#endif
>  	if (err)
>  		goto out;
> +
>  	if (tr->cur_image)
>  		bpf_tramp_image_put(tr->cur_image);
>  	tr->cur_image = im;
>  	tr->selector++;
>  out:
> +	/* If any error happens, restore previous flags */
> +	if (err)
> +		tr->flags = orig_flags;
>  	kfree(tlinks);
>  	return err;
>  }
> @@ -454,7 +577,7 @@ static int __bpf_trampoline_link_prog(struct bpf_tramp_link *link, struct bpf_tr
>  
>  	hlist_add_head(&link->tramp_hlist, &tr->progs_hlist[kind]);
>  	tr->progs_cnt[kind]++;
> -	err = bpf_trampoline_update(tr);
> +	err = bpf_trampoline_update(tr, true /* lock_direct_mutex */);
>  	if (err) {
>  		hlist_del_init(&link->tramp_hlist);
>  		tr->progs_cnt[kind]--;
> @@ -487,7 +610,7 @@ static int __bpf_trampoline_unlink_prog(struct bpf_tramp_link *link, struct bpf_
>  	}
>  	hlist_del_init(&link->tramp_hlist);
>  	tr->progs_cnt[kind]--;
> -	return bpf_trampoline_update(tr);
> +	return bpf_trampoline_update(tr, true /* lock_direct_mutex */);
>  }
>  
>  /* bpf_trampoline_unlink_prog() should never fail. */
> @@ -715,6 +838,7 @@ void bpf_trampoline_put(struct bpf_trampoline *tr)
>  	 * multiple rcu callbacks.
>  	 */
>  	hlist_del(&tr->hlist);
> +	kfree(tr->fops);
>  	kfree(tr);
>  out:
>  	mutex_unlock(&trampoline_mutex);
> -- 
> 2.30.2
> 
