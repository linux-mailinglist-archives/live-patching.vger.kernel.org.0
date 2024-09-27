Return-Path: <live-patching+bounces-691-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F38E98868D
	for <lists+live-patching@lfdr.de>; Fri, 27 Sep 2024 15:49:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D7D13283B60
	for <lists+live-patching@lfdr.de>; Fri, 27 Sep 2024 13:49:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A82AA1BF304;
	Fri, 27 Sep 2024 13:49:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="QPW6UcnR";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="Jb/bVpoj";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="i9gEgaiU";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="2z/ySeSA"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8E1D188CD5;
	Fri, 27 Sep 2024 13:49:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727444957; cv=none; b=qNb67WJn/1/GDN+2ovTFb7NInBcphdVZ7j95B1VRVMYebknuUA0b7xPcuTXyjqUE1eKNcNuAGvFEwGu+1EWz9QUL5RCKi7r/q+V/aCCp6zYLhzIRcpvkf3FkQcqcLvvfoeKGJ98mL7g8QNzq50DW7uXOKZuhb/wHNM5tDXLjD10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727444957; c=relaxed/simple;
	bh=565eMKEFQ2w1Ixr1Ki08+Z7oqizSERHzrgoDnIkLvpc=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=CoYe629lJJooK0Q+DSQe1L+TZJlqL1s4rPTEm7oFyzwfqXF3AEG8Mn2CQboK+d1nxMINqK0Vq+VSbESnFNUIikg1eJI8MBCcKnaCHmaVGkyBXcIx95vOZQmfGnwnPsRs0+LmiyqRJTYYFaupJNoCJIupucIjOrBYC8qf4CvF4zE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=QPW6UcnR; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=Jb/bVpoj; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=i9gEgaiU; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=2z/ySeSA; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from pobox.suse.cz (unknown [10.100.2.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id E202B219E2;
	Fri, 27 Sep 2024 13:49:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1727444953; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=J3PuSLNsQCdFCEmoxeZZHsqsDvTjIVFZiYMAkNDG6Fw=;
	b=QPW6UcnRtfJQi9gzgMlRYdH3ccjxDPZd42n3ukwyG7H1pwn9HgB13+ctSGf0dmwAAQgzVB
	1Rugv3vxL4DjV7T/tk7Yt0ynB0nSSAZIoCMAyDgBx5cZ75GQ65AsRjal0l827HwhQQrkKU
	66ejyL0nS0dbd5iOaY2lgzDMLolltqM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1727444953;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=J3PuSLNsQCdFCEmoxeZZHsqsDvTjIVFZiYMAkNDG6Fw=;
	b=Jb/bVpojphQiOI38vK57jO6p6AwjAO+bHmu/G4HT5HZ7ZWr3m8yJs/GZt06j4z1ntLv2UB
	a7Rfj+E98OWjg0Aw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1727444952; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=J3PuSLNsQCdFCEmoxeZZHsqsDvTjIVFZiYMAkNDG6Fw=;
	b=i9gEgaiUr9hlh8FdviXfUqgPGYPuj+GM7jNBZOOd1azqqKnc/GgDz3AfJaPcD4LoKzczro
	otep8EES6GnFkJcq9PFFUJYDj1atfxAvJiy6NC+AuWsG+ihz5d53VoaBEsZNkES5bHcCmc
	7pU+P/8xwyfWoUU8jSkw/nth+dfJH8g=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1727444952;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=J3PuSLNsQCdFCEmoxeZZHsqsDvTjIVFZiYMAkNDG6Fw=;
	b=2z/ySeSAiTMiQAEOlLUXC4GcRQ3Ny1vqdwMVYSwXgOMSgC6vhDQbYkKO3S5ma5zDDxg0D8
	sqS9pKFrdukQ6+BA==
Date: Fri, 27 Sep 2024 15:49:12 +0200 (CEST)
From: Miroslav Benes <mbenes@suse.cz>
To: Wardenjohn <zhangwarden@gmail.com>
cc: jpoimboe@kernel.org, jikos@kernel.org, pmladek@suse.com, 
    joe.lawrence@redhat.com, live-patching@vger.kernel.org, 
    linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Documentation: Add description to stack_order
 interface
In-Reply-To: <20240925064047.95503-3-zhangwarden@gmail.com>
Message-ID: <alpine.LSU.2.21.2409271546190.15317@pobox.suse.cz>
References: <20240925064047.95503-1-zhangwarden@gmail.com> <20240925064047.95503-3-zhangwarden@gmail.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Level: 
X-Spamd-Result: default: False [-4.29 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-0.999];
	NEURAL_HAM_SHORT(-0.19)[-0.966];
	MIME_GOOD(-0.10)[text/plain];
	RCPT_COUNT_SEVEN(0.00)[7];
	ARC_NA(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	RCVD_COUNT_ZERO(0.00)[0];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_EQ_ENVFROM(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_SOME(0.00)[]
X-Spam-Score: -4.29
X-Spam-Flag: NO

On Wed, 25 Sep 2024, Wardenjohn wrote:

> Update description of klp_patch stack_order sysfs interface to
> livepatch ABI documentation.
> 
> Signed-off-by: Wardenjohn <zhangwarden@gmail.com>
> 
> diff --git a/Documentation/ABI/testing/sysfs-kernel-livepatch b/Documentation/ABI/testing/sysfs-kernel-livepatch
> index a5df9b4910dc..9cad725a69c7 100644
> --- a/Documentation/ABI/testing/sysfs-kernel-livepatch
> +++ b/Documentation/ABI/testing/sysfs-kernel-livepatch
> @@ -47,6 +47,14 @@ Description:
>  		disabled when the feature is used. See
>  		Documentation/livepatch/livepatch.rst for more information.
>  
> +What:           /sys/kernel/livepatch/<patch>/stack_order
> +Date:           Sep 2024
> +KernelVersion:  6.12.0
> +Contact:        live-patching@vger.kernel.org
> +Description:
> +		This attribute record the stack order of this livepatch module
> +		applied to the running system.

"The attribute holds the stack order of a live patch module applied to the 
running system." ?

Please also squash the patch into the previous one. It belongs there.

Thank you,
Miroslav

