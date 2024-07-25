Return-Path: <live-patching+bounces-407-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D157193C117
	for <lists+live-patching@lfdr.de>; Thu, 25 Jul 2024 13:48:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7547B2810AD
	for <lists+live-patching@lfdr.de>; Thu, 25 Jul 2024 11:48:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37EB716F82E;
	Thu, 25 Jul 2024 11:48:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="yYqWx616";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="xZ80trt9";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="yYqWx616";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="xZ80trt9"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54A663C3C;
	Thu, 25 Jul 2024 11:48:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721908090; cv=none; b=N5IwMT9R0dWg8kPtSADoO52Vvf1U5IBHAtGnJ+ZEwsG3IXLHYncr+/9BVd+TCfF6jE+vp47QqHXGZbK/agTBr2DCfO8OqLMaYd7wz/pYy8rDCxS6MS9sZQqLlK5Kz+bbFJ+L5i1WUZjJBuhLxMpwQaXhUhB+c2esKzHGeXCOH60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721908090; c=relaxed/simple;
	bh=nyIjY4X5z1L2cUdrekGLwLmsrH3VfuGKT0bCdAEQ6WQ=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=i/PXuglF+IBMN/oCz8eTFSSGK+FU6T79pYkS6H+nUJ8OHbjC3ADa4lhPJXHZGCbN4zFQpvxx31zBGTnb7cQLVLu6sNWaxBBuhCrcYXI/ZFLL9bvncY4OzkAAmDv9zz1y7KdNbFO5lXi5n7cwBoDuxDzem7ccSHwF1WbDVpEzuxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=yYqWx616; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=xZ80trt9; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=yYqWx616; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=xZ80trt9; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from pobox.suse.cz (unknown [10.100.2.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 8830921A6B;
	Thu, 25 Jul 2024 11:48:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1721908086; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vuuMe5Zm1tzm/2ZG+q3EQEgd0rTxyVL637vBA1fA7D4=;
	b=yYqWx616q57VwLmC3BpsOs32nVnR4ARypukfSQRVjrwSGCyClXNijtMvToyVCqeLS3HvnI
	o+f2vVuDjV++tnWqmYlt2U5+u21hTfzMAP2+Dc6++gG0YPo/vtNJxZe1cZyELP/YhCgX1x
	gpzW3dPH7X/xYVREj/8e3QYgoYML4lk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1721908086;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vuuMe5Zm1tzm/2ZG+q3EQEgd0rTxyVL637vBA1fA7D4=;
	b=xZ80trt9DAwb/07DmUZFcqYsPHvCyTtPntbo33WaHz6cTmRTNOFuLZm/Gle5Kl1iBTMCE/
	pHDXM2TyBYCEVXAg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1721908086; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vuuMe5Zm1tzm/2ZG+q3EQEgd0rTxyVL637vBA1fA7D4=;
	b=yYqWx616q57VwLmC3BpsOs32nVnR4ARypukfSQRVjrwSGCyClXNijtMvToyVCqeLS3HvnI
	o+f2vVuDjV++tnWqmYlt2U5+u21hTfzMAP2+Dc6++gG0YPo/vtNJxZe1cZyELP/YhCgX1x
	gpzW3dPH7X/xYVREj/8e3QYgoYML4lk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1721908086;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vuuMe5Zm1tzm/2ZG+q3EQEgd0rTxyVL637vBA1fA7D4=;
	b=xZ80trt9DAwb/07DmUZFcqYsPHvCyTtPntbo33WaHz6cTmRTNOFuLZm/Gle5Kl1iBTMCE/
	pHDXM2TyBYCEVXAg==
Date: Thu, 25 Jul 2024 13:48:06 +0200 (CEST)
From: Miroslav Benes <mbenes@suse.cz>
To: Petr Mladek <pmladek@suse.com>
cc: Josh Poimboeuf <jpoimboe@kernel.org>, 
    Joe Lawrence <joe.lawrence@redhat.com>, Nicolai Stange <nstange@suse.de>, 
    live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [POC 3/7] livepatch: Use per-state callbacks in state API
 tests
In-Reply-To: <20231110170428.6664-4-pmladek@suse.com>
Message-ID: <alpine.LSU.2.21.2407251343160.21729@pobox.suse.cz>
References: <20231110170428.6664-1-pmladek@suse.com> <20231110170428.6664-4-pmladek@suse.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Level: 
X-Spamd-Result: default: False [-4.10 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_COUNT_ZERO(0.00)[0];
	TO_DN_SOME(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email]
X-Spam-Flag: NO
X-Spam-Score: -4.10

Hi,

On Fri, 10 Nov 2023, Petr Mladek wrote:

> Recent changes in the livepatch core have allowed to connect states,
> shadow variables, and callbacks. Use these new features in
> the state tests.
> 
> Use the shadow variable API to store the original loglevel. It is
> better suited for this purpose than directly accessing the .data
> pointer in state klp_state.
> 
> Another big advantage is that the shadow variable is preserved
> when the current patch is replaced by a new version. As a result,
> there is not need to copy the pointer.
> 
> Finally, the lifetime of the shadow variable is connected with
> the lifetime of the state. It is freed automatically when
> it is not longer supported.
> 
> This results into the following changes in the code:
> 
>   + Rename CONSOLE_LOGLEVEL_STATE -> CONSOLE_LOGLEVEL_FIX_ID
>     because it will be used also the for shadow variable
> 
>   + Remove the extra code for module coming and going states
>     because the new callback are per-state.
> 
>   + Remove callbacks needed to transfer the pointer between
>     states.
> 
>   + Keep the versioning of the state to prevent downgrade.
>     The problem is artificial because no callbacks are
>     needed to transfer or free the shadow variable anymore.
> 
> Signed-off-by: Petr Mladek <pmladek@suse.com>

it is much cleaner now.

[...]

>  static int allocate_loglevel_state(void)
>  {
> -	struct klp_state *loglevel_state;
> +	int *shadow_console_loglevel;
>  
> -	loglevel_state = klp_get_state(&patch, CONSOLE_LOGLEVEL_STATE);
> -	if (!loglevel_state)
> -		return -EINVAL;
> +	/* Make sure that the shadow variable does not exist yet. */
> +	shadow_console_loglevel =
> +		klp_shadow_alloc(&console_loglevel, CONSOLE_LOGLEVEL_FIX_ID,
> +				 sizeof(*shadow_console_loglevel), GFP_KERNEL,
> +				 NULL, NULL);
>  
> -	loglevel_state->data = kzalloc(sizeof(console_loglevel), GFP_KERNEL);
> -	if (!loglevel_state->data)
> +	if (!shadow_console_loglevel) {
> +		pr_err("%s: failed to allocated shadow variable for storing original loglevel\n",
> +		       __func__);
>  		return -ENOMEM;
> +	}
>  
>  	pr_info("%s: allocating space to store console_loglevel\n",
>  		__func__);
> +
>  	return 0;
>  }

Would it make sense to set is_shadow to 1 here? I mean you would pass 
klp_state down to allocate_loglevel_state() from setup callback and set 
its is_shadow member here. Because then...
  
>  static void free_loglevel_state(void)
>  {
> -	struct klp_state *loglevel_state;
> +	int *shadow_console_loglevel;
>  
> -	loglevel_state = klp_get_state(&patch, CONSOLE_LOGLEVEL_STATE);
> -	if (!loglevel_state)
> +	shadow_console_loglevel =
> +		(int *)klp_shadow_get(&console_loglevel, CONSOLE_LOGLEVEL_FIX_ID);
> +	if (!shadow_console_loglevel)
>  		return;
>  
>  	pr_info("%s: freeing space for the stored console_loglevel\n",
>  		__func__);
> -	kfree(loglevel_state->data);
> +	klp_shadow_free(&console_loglevel, CONSOLE_LOGLEVEL_FIX_ID, NULL);
>  }

would not be needed. And release callback neither.

Or am I wrong?

We can even have both ways implemented to demonstrate different 
approaches...

Miroslav

