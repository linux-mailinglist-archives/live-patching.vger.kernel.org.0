Return-Path: <live-patching+bounces-606-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 34DDE96D580
	for <lists+live-patching@lfdr.de>; Thu,  5 Sep 2024 12:11:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 59FE71C2533F
	for <lists+live-patching@lfdr.de>; Thu,  5 Sep 2024 10:11:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25ABE195F04;
	Thu,  5 Sep 2024 10:10:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="ZH+wBdk6";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="MmmFmWlt";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="ZH+wBdk6";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="MmmFmWlt"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB90A13AA2B;
	Thu,  5 Sep 2024 10:10:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725531019; cv=none; b=gchQ6OqNzbzKcN72HnCRhNukWETRRW64HfXFR/STjl3GJkT7MxXZYytI5MeVm6j60A4goa2HtRegkoiS+pKXMzGLcpJj49TTOFwcXY5g563xQas3uwI9T5KcVLTSkbO3qg+pNI1fHOAgXD5rTWa8D+CbFhwwQx8uI0pQrff939Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725531019; c=relaxed/simple;
	bh=4OvP9ljVjWEhn0hF3oHwV51qlhoZH2nXlCSTpCQvfP8=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=f4RIMhLWSUuffbKUYZXP1AJB0DuLKScWnaBCvBT8Aa9nVHOClUvZnkh6OLr5LGiHple29cwQvGOL7VcdCBx+bQ5oedgR+Wsz6+FpVBiDLOR2Y6wxlWK0ximbrXitIwT5XYcMTWVBkXwzQfZYNIpPcTZ4POiro7nzrjUp15ND7uc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=ZH+wBdk6; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=MmmFmWlt; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=ZH+wBdk6; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=MmmFmWlt; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from pobox.suse.cz (unknown [10.100.2.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id E01EC21961;
	Thu,  5 Sep 2024 10:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1725531014; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nJTfIzYXnlllHqZjh7Vi0R+mu/mG6WoXv37+SM86wZM=;
	b=ZH+wBdk6fOD09EtSIqtGNfl/gUpaiEaLp0JZFBiWGPtDE80wFwlo2UBMGRPd10OsqO/Qyx
	uGEi0AknGsHFxpPx1BTuoHQshUJY5vMoxGuCSisk16f2Sga43YIT32mluOhKAf1MW++s2T
	rfj4V04TNxQAfQKlrrDgn51Sg35RgTU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1725531014;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nJTfIzYXnlllHqZjh7Vi0R+mu/mG6WoXv37+SM86wZM=;
	b=MmmFmWltcKnPwephrKXGuNV32b9lB902gELSKrtpHQJmwmnoeGgio8l8i70t4ivw2pnbLf
	fDdvY2im7MLr6oDQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1725531014; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nJTfIzYXnlllHqZjh7Vi0R+mu/mG6WoXv37+SM86wZM=;
	b=ZH+wBdk6fOD09EtSIqtGNfl/gUpaiEaLp0JZFBiWGPtDE80wFwlo2UBMGRPd10OsqO/Qyx
	uGEi0AknGsHFxpPx1BTuoHQshUJY5vMoxGuCSisk16f2Sga43YIT32mluOhKAf1MW++s2T
	rfj4V04TNxQAfQKlrrDgn51Sg35RgTU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1725531014;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nJTfIzYXnlllHqZjh7Vi0R+mu/mG6WoXv37+SM86wZM=;
	b=MmmFmWltcKnPwephrKXGuNV32b9lB902gELSKrtpHQJmwmnoeGgio8l8i70t4ivw2pnbLf
	fDdvY2im7MLr6oDQ==
Date: Thu, 5 Sep 2024 12:10:14 +0200 (CEST)
From: Miroslav Benes <mbenes@suse.cz>
To: Wardenjohn <zhangwarden@gmail.com>
cc: jpoimboe@kernel.org, jikos@kernel.org, pmladek@suse.com, 
    joe.lawrence@redhat.com, live-patching@vger.kernel.org, 
    linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 1/2] Introduce klp_ops into klp_func structure
In-Reply-To: <20240828022350.71456-2-zhangwarden@gmail.com>
Message-ID: <alpine.LSU.2.21.2409051139540.8559@pobox.suse.cz>
References: <20240828022350.71456-1-zhangwarden@gmail.com> <20240828022350.71456-2-zhangwarden@gmail.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Score: -4.30
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-0.999];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	RCPT_COUNT_SEVEN(0.00)[7];
	FREEMAIL_TO(0.00)[gmail.com];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_ZERO(0.00)[0];
	ARC_NA(0.00)[];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email]
X-Spam-Flag: NO
X-Spam-Level: 

Hi,

the subject is missing "livepatch: " prefix and I would prefer something 
like

"livepatch: Move struct klp_ops to struct klp_func"

On Wed, 28 Aug 2024, Wardenjohn wrote:

> Before introduce feature "using". Klp transition will need an
> easier way to get klp_ops from klp_func.

I think that the patch might make sense on its own as a 
cleanup/optimization as Petr suggested. If fixed. See below. Then the 
changelog can be restructured and the above can be removed.

Btw if it comes to it, I would much rather have something like "active" 
instead of "using". 

> This patch make changes as follows:
> 1. Move klp_ops into klp_func structure.
> Rewrite the logic of klp_find_ops and
> other logic to get klp_ops of a function.
> 
> 2. Move definition of struct klp_ops into
> include/linux/livepatch.h
> 
> With this changes, we can get klp_ops of a klp_func easily. 
> klp_find_ops can also be simple and straightforward. And we 
> do not need to maintain one global list for now.
> 
> Signed-off-by: Wardenjohn <zhangwarden@gmail.com>

Missing "Suggested-by: Petr Mladek <pmladek@suse.com> perhaps?

>diff --git a/include/linux/livepatch.h b/include/linux/livepatch.h
>index 51a258c24ff5..d874aecc817b 100644
>--- a/include/linux/livepatch.h
>+++ b/include/linux/livepatch.h
>@@ -22,6 +22,25 @@
> #define KLP_TRANSITION_UNPATCHED        0
> #define KLP_TRANSITION_PATCHED          1
> 
>+/**
>+ * struct klp_ops - structure for tracking registered ftrace ops structs
>+ *
>+ * A single ftrace_ops is shared between all enabled replacement functions
>+ * (klp_func structs) which have the same old_func.  This allows the switch
>+ * between function versions to happen instantaneously by updating the klp_ops
>+ * struct's func_stack list.  The winner is the klp_func at the top of the
>+ * func_stack (front of the list).
>+ *
>+ * @node:      node for the global klp_ops list
>+ * @func_stack:        list head for the stack of klp_func's (active func is on top)
>+ * @fops:      registered ftrace ops struct
>+ */
>+struct klp_ops {
>+       struct list_head node;

Not needed anymore.

>+       struct list_head func_stack;
>+       struct ftrace_ops fops;
>+};
>+
>
> diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
> index 52426665eecc..e4572bf34316 100644
> --- a/kernel/livepatch/core.c
> +++ b/kernel/livepatch/core.c
> @@ -760,6 +760,8 @@ static int klp_init_func(struct klp_object *obj, struct klp_func *func)
>  	if (!func->old_name)
>  		return -EINVAL;
>  
> +	func->ops = NULL;
> +

Any reason why it is not added a couple of lines later alongside the rest 
of the initialization?

>  	/*
>  	 * NOPs get the address later. The patched module must be loaded,
>  	 * see klp_init_object_loaded().
> diff --git a/kernel/livepatch/patch.c b/kernel/livepatch/patch.c
> index 90408500e5a3..8ab9c35570f4 100644
> --- a/kernel/livepatch/patch.c
> +++ b/kernel/livepatch/patch.c
> @@ -20,18 +20,25 @@
>  #include "patch.h"
>  #include "transition.h"
>  
> -static LIST_HEAD(klp_ops);
>  
>  struct klp_ops *klp_find_ops(void *old_func)
>  {
> -	struct klp_ops *ops;
> +	struct klp_patch *patch;
> +	struct klp_object *obj;
>  	struct klp_func *func;
>  
> -	list_for_each_entry(ops, &klp_ops, node) {
> -		func = list_first_entry(&ops->func_stack, struct klp_func,
> -					stack_node);
> -		if (func->old_func == old_func)
> -			return ops;
> +	klp_for_each_patch(patch) {
> +		klp_for_each_object(patch, obj) {
> +			klp_for_each_func(obj, func) {
> +				/*
> +				 * Ignore entry where func->ops has not been
> +				 * assigned yet. It is most likely the one
> +				 * which is about to be created/added.
> +				 */
> +				if (func->old_func == old_func && func->ops)
> +					return func->ops;
> +			}
> +		}
>  	}

The function is not used anywhere after this patch.

Regards,
Miroslav

