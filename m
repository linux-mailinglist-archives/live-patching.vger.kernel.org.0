Return-Path: <live-patching+bounces-692-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id CA3549886B4
	for <lists+live-patching@lfdr.de>; Fri, 27 Sep 2024 16:11:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 34F4FB20DF0
	for <lists+live-patching@lfdr.de>; Fri, 27 Sep 2024 14:11:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99E2F6F06B;
	Fri, 27 Sep 2024 14:11:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Rfg7sbDR";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="VyekaBgc";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="CSUbcNHC";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="AK3uZE1c"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32BC74D8DA;
	Fri, 27 Sep 2024 14:11:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727446267; cv=none; b=bcUOvnx5lvWoBaAElSS8ofbmgxxKiBJ72q+wxcgJzphR9wHraYFTDEXW9aiKLB0FK07h0/0WhGxOSv927wlLNUOx3VQ1FZVQGltEBPvIX9DimJWp4Q3PdNZ8D/Fxu2hYLMqn1WaQmwuap7QR/JIQO6gkP+do32y/YradWeSThhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727446267; c=relaxed/simple;
	bh=zJ//QJzR1JKvTzilY56ro+zbd5/0v7ezApwp6Lb9cXI=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=IgSJR8/hgbtD4fnZPvqmCLIX/UbKZH3fkn6hk/cyImVrqOe2NIteBu42FjzP8AbvPJImepnfVEJqLd7WfZADRyqyDaKVfF1cMQTPe67+MhgDauYoaXacKK2491GM9riz613sfA8IDsEbdMMiCGsqbSxpeheEet8En2DuuDOQCZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Rfg7sbDR; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=VyekaBgc; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=CSUbcNHC; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=AK3uZE1c; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from pobox.suse.cz (unknown [10.100.2.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 5525121B9A;
	Fri, 27 Sep 2024 14:11:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1727446263; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9fZLS8zDun9PxlD1zMjkYj0rYDVXyKtIfloVmCujHt8=;
	b=Rfg7sbDRYel5iSLIdVBu0KSzWrmKBTNcwDQfX6BDWPALnlShfj3qijio1ZIbDsUnkoq9f+
	uduWSlwTeG1FVIysu057qopHC3zrK3pfrTO2Qs0FTZmf26P/6AzkoC37XPpT2wssVOakgX
	eHpT3QRtasj8aaOQ2Alx5DqLJBIXQow=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1727446263;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9fZLS8zDun9PxlD1zMjkYj0rYDVXyKtIfloVmCujHt8=;
	b=VyekaBgc68yuGvocIcFpiCXmN+qnyP/HK+S5zWlH8Gbmfsy+YGmftezhtvsgY8tYqsRMYG
	Glq4rkKsR9c7CcDg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1727446262; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9fZLS8zDun9PxlD1zMjkYj0rYDVXyKtIfloVmCujHt8=;
	b=CSUbcNHC4vmD0BkZU8UW6j85DIKBrbsqFw0Zah0LlP3PKBGXd+EOe0Xt4sX14BtuDc0K1F
	Bx1zofxhZ9We3dZ0a3SDr466RltN/PHnndcMxhBgneBVcVV4KEtlQ+iNcajqNUfW5LJNWn
	jM1iRs2zdBT/ZzVnGn3K3Ea18l0shRY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1727446262;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9fZLS8zDun9PxlD1zMjkYj0rYDVXyKtIfloVmCujHt8=;
	b=AK3uZE1cEi9Ds683q7MbfNwyWAEqoBV7IOLGuYsp1PSU+6ceS6zn6scw6+RmHoue4p3uN0
	sOmapRJMXtmrdqDA==
Date: Fri, 27 Sep 2024 16:11:02 +0200 (CEST)
From: Miroslav Benes <mbenes@suse.cz>
To: Wardenjohn <zhangwarden@gmail.com>
cc: jpoimboe@kernel.org, jikos@kernel.org, pmladek@suse.com, 
    joe.lawrence@redhat.com, live-patching@vger.kernel.org, 
    linux-kernel@vger.kernel.org
Subject: Re: [PATCH] livepatch: introduce 'stack_order' sysfs interface to
 klp_patch
In-Reply-To: <20240925064047.95503-2-zhangwarden@gmail.com>
Message-ID: <alpine.LSU.2.21.2409271555430.15317@pobox.suse.cz>
References: <20240925064047.95503-1-zhangwarden@gmail.com> <20240925064047.95503-2-zhangwarden@gmail.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Level: 
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:email,suse.com:email]
X-Spam-Score: -4.30
X-Spam-Flag: NO

Hi,

I would change the subject to something like

"livepatch: Add "stack_order" sysfs attribute"

to keep it somehow consistent with what we have there so far.

On Wed, 25 Sep 2024, Wardenjohn wrote:

> This feature can provide livepatch patch order information.
> With the order of sysfs interface of one klp_patch, we can
> use patch order to find out which function of the patch is
> now activate.
> 
> After the discussion, we decided that patch-level sysfs
> interface is the only accaptable way to introduce this
> information.
> 
> This feature is like:
> cat /sys/kernel/livepatch/livepatch_1/stack_order -> 1
> means this livepatch_1 module is the 1st klp patch applied.
> 
> cat /sys/kernel/livepatch/livepatch_module/stack_order -> N
> means this lviepatch_module is the Nth klp patch applied
> to the system.

Perhaps something like

"
Add "stack_order" sysfs attribute which holds the order in which a live 
patch module was loaded into the system. A user can then determine an 
active live patched version of a function.

 cat /sys/kernel/livepatch/livepatch_1/stack_order -> 1

 means that livepatch_1 is the first live patch applied

 cat /sys/kernel/livepatch/livepatch_module/stack_order -> N

 means that livepatch_module is the Nth live patch applied
"
?

> Suggested-by: Petr Mladek <pmladek@suse.com>
> Suggested-by: Miroslav Benes <mbenes@suse.cz>
> Suggested-by: Josh Poimboeuf <jpoimboe@kernel.org>
> Signed-off-by: Wardenjohn <zhangwarden@gmail.com>
 
How do you prepare your patches?

"---" delimiter is missing here.

> diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
> index ecbc9b6aba3a..914b7cabf8fe 100644
> --- a/kernel/livepatch/core.c
> +++ b/kernel/livepatch/core.c
> @@ -346,6 +346,7 @@ int klp_apply_section_relocs(struct module *pmod, Elf_Shdr *sechdrs,
>   * /sys/kernel/livepatch/<patch>/enabled
>   * /sys/kernel/livepatch/<patch>/transition
>   * /sys/kernel/livepatch/<patch>/force
> + * /sys/kernel/livepatch/<patch>/stack_order
>   * /sys/kernel/livepatch/<patch>/<object>
>   * /sys/kernel/livepatch/<patch>/<object>/patched
>   * /sys/kernel/livepatch/<patch>/<object>/<function,sympos>
> @@ -443,13 +444,37 @@ static ssize_t force_store(struct kobject *kobj, struct kobj_attribute *attr,
>  	return count;
>  }
>  
> +static ssize_t stack_order_show(struct kobject *kobj,
> +				struct kobj_attribute *attr, char *buf)
> +{
> +	struct klp_patch *patch, *this_patch;
> +	int stack_order = 0;
> +
> +	this_patch = container_of(kobj, struct klp_patch, kobj);
> +
> +	/* make sure the calculate of patch order correct */

The comment is not necessary.

> +	mutex_lock(&klp_mutex);
> +
> +	klp_for_each_patch(patch) {
> +		stack_order++;
> +		if (patch == this_patch)
> +			break;
> +	}
> +
> +	mutex_unlock(&klp_mutex);

Please add an empty line before return here.

>+       return sysfs_emit(buf, "%d\n", stack_order);
>+}

Miroslav

