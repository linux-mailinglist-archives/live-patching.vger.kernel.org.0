Return-Path: <live-patching+bounces-335-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D01529003B0
	for <lists+live-patching@lfdr.de>; Fri,  7 Jun 2024 14:33:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D998D1C20809
	for <lists+live-patching@lfdr.de>; Fri,  7 Jun 2024 12:33:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D433186E46;
	Fri,  7 Jun 2024 12:33:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="OCogoCNV";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="kP2eepKG";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="OCogoCNV";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="kP2eepKG"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E5621847
	for <live-patching@vger.kernel.org>; Fri,  7 Jun 2024 12:33:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717763634; cv=none; b=sT7iYs5vvrhP2IZ8DmITzhqRl6OrQPA6pUXscJD+dyDEKRussw7hm+CROJwFn7mW08XrZNcxrrefVBLPjwBpG520al8mRCKJtjOj3VkJ/Ie2f8/X5Z0j3IibZeRhfwqiNqOdHH1wTdRtwVIAD/ZVkTzWShGWLC5psNQfb7jW+4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717763634; c=relaxed/simple;
	bh=L/5nrZAVsQ0lzXS1Md1zh+C/70cSnYUsn3ErSBoM2gs=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=Ekm+mSYI79FDRPS6PGGKlKow8fZAKrm9vjgOjYSNv/wWhw5bxd2siysYRM89aQUIIY10UCS82Afn4bUIXSoI0INBVDSaao5YkZZWH57i2U4DlPu1Onyg8whcbF7frMSBNWBuJjDTcAC0iTLuyxECmjsI4lLz3nPFDjY1NZs26FU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=OCogoCNV; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=kP2eepKG; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=OCogoCNV; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=kP2eepKG; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from pobox.suse.cz (unknown [10.100.2.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 83F4F21B58;
	Fri,  7 Jun 2024 12:33:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1717763630; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VMqn2ibXwFCeNB01bpZ3RUGDhFO7I4suaxNl3r1rUhw=;
	b=OCogoCNV7Q0Pm7GB8MtcdWKvB7B7KU6Lp+6hBv48X+wvdDdwArGLMKmiFdVX8UyobNHWGI
	G77+sdWC3/jqbfuD8JlD3MFhiItR/sN6Og5Vna7EVLIMSMlHvMS9rvWoU8rW8qzz1s0whu
	oCpErqX/lwMGqLMUHHyupu/PiQ8pCDY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1717763630;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VMqn2ibXwFCeNB01bpZ3RUGDhFO7I4suaxNl3r1rUhw=;
	b=kP2eepKGsJ3YXfRuVkYo2/jYI2c34gJlB1xf2DFp+suXHwao8HryissnbuwydXIC1CSADS
	3SktWLxofkm+e1Cw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1717763630; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VMqn2ibXwFCeNB01bpZ3RUGDhFO7I4suaxNl3r1rUhw=;
	b=OCogoCNV7Q0Pm7GB8MtcdWKvB7B7KU6Lp+6hBv48X+wvdDdwArGLMKmiFdVX8UyobNHWGI
	G77+sdWC3/jqbfuD8JlD3MFhiItR/sN6Og5Vna7EVLIMSMlHvMS9rvWoU8rW8qzz1s0whu
	oCpErqX/lwMGqLMUHHyupu/PiQ8pCDY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1717763630;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VMqn2ibXwFCeNB01bpZ3RUGDhFO7I4suaxNl3r1rUhw=;
	b=kP2eepKGsJ3YXfRuVkYo2/jYI2c34gJlB1xf2DFp+suXHwao8HryissnbuwydXIC1CSADS
	3SktWLxofkm+e1Cw==
Date: Fri, 7 Jun 2024 14:33:49 +0200 (CEST)
From: Miroslav Benes <mbenes@suse.cz>
To: Yafang Shao <laoar.shao@gmail.com>
cc: jpoimboe@kernel.org, jikos@kernel.org, pmladek@suse.com, 
    joe.lawrence@redhat.com, live-patching@vger.kernel.org
Subject: Re: [PATCH] livepatch: Add a new sysfs interface replace
In-Reply-To: <20240607070157.33828-1-laoar.shao@gmail.com>
Message-ID: <alpine.LSU.2.21.2406071425530.29080@pobox.suse.cz>
References: <20240607070157.33828-1-laoar.shao@gmail.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Flag: NO
X-Spam-Score: -2.79
X-Spam-Level: 
X-Spamd-Result: default: False [-2.79 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.19)[-0.940];
	MIME_GOOD(-0.10)[text/plain];
	FREEMAIL_TO(0.00)[gmail.com];
	RCVD_COUNT_ZERO(0.00)[0];
	MIME_TRACE(0.00)[0:+];
	TAGGED_RCPT(0.00)[];
	ARC_NA(0.00)[];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6]

Hi,

I think the subject should be something like

"livepatch: Add "replace" sysfs attribute"

or use a different way to stress "replace" is the name.

On Fri, 7 Jun 2024, Yafang Shao wrote:

> When building a livepatch, a user can set it to be either an atomic-replace
> livepatch or a non-atomic-replace livepatch.

I am not a native speaker but I would drop '-' everywhere in this context.

> However, it is not easy to
> identify whether a livepatch is atomic-replace or not until it actually
> replaces some old livepatches.

Ok.

> This can lead to mistakes in a mixed
> atomic-replace and non-atomic-replace environment, especially when
> transitioning all livepatches from non-atomic-replace to atomic-replace in
> a large fleet of servers.

Out of curiosity, could you describe your setup in more detail here? It is 
interesting to mix different type of livepatches so I would like to learn 
more.

> To address this issue, a new sysfs interface called 'replace' is introduced
> in this patch. The result after this change is as follows:
> 
>   $ cat /sys/kernel/livepatch/livepatch-non_replace/replace
>   0
> 
>   $ cat /sys/kernel/livepatch/livepatch-replace/replace
>   1
> 
> Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> ---
>  Documentation/ABI/testing/sysfs-kernel-livepatch |  8 ++++++++
>  kernel/livepatch/core.c                          | 12 ++++++++++++
>  2 files changed, 20 insertions(+)
> 
> diff --git a/Documentation/ABI/testing/sysfs-kernel-livepatch b/Documentation/ABI/testing/sysfs-kernel-livepatch
> index a5df9b4910dc..3735d868013d 100644
> --- a/Documentation/ABI/testing/sysfs-kernel-livepatch
> +++ b/Documentation/ABI/testing/sysfs-kernel-livepatch
> @@ -47,6 +47,14 @@ Description:
>  		disabled when the feature is used. See
>  		Documentation/livepatch/livepatch.rst for more information.
>  
> +What:		/sys/kernel/livepatch/<patch>/replace
> +Date:		Jun 2024
> +KernelVersion:	6.11.0
> +Contact:	live-patching@vger.kernel.org
> +Description:
> +		An attribute which indicates whether the patch supports
> +		atomic-replace.
> +
>  What:		/sys/kernel/livepatch/<patch>/<object>
>  Date:		Nov 2014
>  KernelVersion:	3.19.0
> diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
> index 52426665eecc..0e9832f146f1 100644
> --- a/kernel/livepatch/core.c
> +++ b/kernel/livepatch/core.c
> @@ -346,6 +346,7 @@ int klp_apply_section_relocs(struct module *pmod, Elf_Shdr *sechdrs,
>   * /sys/kernel/livepatch/<patch>/enabled
>   * /sys/kernel/livepatch/<patch>/transition
>   * /sys/kernel/livepatch/<patch>/force
> + * /sys/kernel/livepatch/<patch>/replace
>   * /sys/kernel/livepatch/<patch>/<object>
>   * /sys/kernel/livepatch/<patch>/<object>/patched
>   * /sys/kernel/livepatch/<patch>/<object>/<function,sympos>
> @@ -443,13 +444,24 @@ static ssize_t force_store(struct kobject *kobj, struct kobj_attribute *attr,
>  	return count;
>  }
>  
> +static ssize_t replace_show(struct kobject *kobj,
> +			    struct kobj_attribute *attr, char *buf)
> +{
> +	struct klp_patch *patch;
> +
> +	patch = container_of(kobj, struct klp_patch, kobj);
> +	return snprintf(buf, PAGE_SIZE-1, "%d\n", patch->replace);

It might be better to use sysfs_emit() here. See patched_show() in the 
same file. There are still snprintf() occurrences and it might be a 
separate cleanup patch if you are interested.

Regards,
Miroslav

