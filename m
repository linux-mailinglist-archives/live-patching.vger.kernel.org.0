Return-Path: <live-patching+bounces-607-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A323896D5FA
	for <lists+live-patching@lfdr.de>; Thu,  5 Sep 2024 12:27:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EEBDBB20CA3
	for <lists+live-patching@lfdr.de>; Thu,  5 Sep 2024 10:27:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B21A1990AB;
	Thu,  5 Sep 2024 10:23:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="m4hP2WlI";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="bK/sEj/w";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="K6aq3VdE";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="w+EM1ZsU"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E47E1991BE;
	Thu,  5 Sep 2024 10:23:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725531805; cv=none; b=Dt5pNwHoirJ9KdDleOwAxObE1dhNK7NOD/c1X01z4lHwnSSSEqlzXKCvs96Sm9SMNqU78VYfLCaQ5xtTpaGVoGR6GE3dY0vbikyjIruTa72fYIqt0Hj1JH5iW40N6QQys+QmVoAKECA7mjco9xmRoVB4FhbJQCmuJw3uSYW5pQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725531805; c=relaxed/simple;
	bh=1E22vSNqrNc8/21c47YgPahUEqQ/r/u7QQBOfp5x/m4=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=fFH/gmZd2rKDexu2AIos+aabYOfxHHrZu61j703RtnWH2AR1i28UfU0mG+AyE2TOvstZaIEQ4m2hBxhe6yawaDfMIVftIJlDEmdIbIJGlZlgA7PXGxDQQPPIqdVmc9Top3TI0zqlIEC044VRD5hmPWv+VNmLTnx1LYiHO+MLTV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=m4hP2WlI; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=bK/sEj/w; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=K6aq3VdE; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=w+EM1ZsU; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from pobox.suse.cz (unknown [10.100.2.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 427E6218E0;
	Thu,  5 Sep 2024 10:23:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1725531801; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cO3anjt8qx3VXZUVT2JbdFfigm6dHAujV55BPIWxpSo=;
	b=m4hP2WlIyGk3AlJSucf2qS8VG3QilxE6tKegI8g3BGcRjKC5z7O2GZK7qbYQk70Cu2naN9
	WOoDRBaK2Cyb8k4Yvzba3sfq38jSRzwcrVjlf76aHembQ/uErm0VBsObH58wyDmoVBiXzo
	wbLXtuZxneh+myP/hJQvvaQgRj5ztWU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1725531801;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cO3anjt8qx3VXZUVT2JbdFfigm6dHAujV55BPIWxpSo=;
	b=bK/sEj/wId3ol/+zOHTABaCgeu9fjRRzjF9wzNB4SiESCSthl99qQXyQqQaCuJlG/a0hui
	4StGaMVZs0YE2HCQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1725531800; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cO3anjt8qx3VXZUVT2JbdFfigm6dHAujV55BPIWxpSo=;
	b=K6aq3VdEs+QJnCm5Hyk6W8c/k2lJgITLoquVmOha/wVkYrIjN0Sv8GDaBbRpJZEu/KQk9h
	ZOCpc/r2Htznf6myTLLaDP1hjm4xKi+VNw8ZM4/FeUw3vWnvxjgAsv0XP9kw0uqwKMC7jy
	DYH9qOD9qwA4R4zI6MuP4j0ZEcqmJvU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1725531800;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cO3anjt8qx3VXZUVT2JbdFfigm6dHAujV55BPIWxpSo=;
	b=w+EM1ZsUUxu58Z59Vrom1bguzaxd1r5v/7+FDsbiGkApMWuTsRb7vAD1VFak0PA0oCOC9j
	DQ5gy8h0DCbZHlCg==
Date: Thu, 5 Sep 2024 12:23:20 +0200 (CEST)
From: Miroslav Benes <mbenes@suse.cz>
To: Wardenjohn <zhangwarden@gmail.com>
cc: jpoimboe@kernel.org, jikos@kernel.org, pmladek@suse.com, 
    joe.lawrence@redhat.com, live-patching@vger.kernel.org, 
    linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 2/2] livepatch: Add using attribute to klp_func for
 using function show
In-Reply-To: <20240828022350.71456-3-zhangwarden@gmail.com>
Message-ID: <alpine.LSU.2.21.2409051215140.8559@pobox.suse.cz>
References: <20240828022350.71456-1-zhangwarden@gmail.com> <20240828022350.71456-3-zhangwarden@gmail.com>
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
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-0.999];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCVD_COUNT_ZERO(0.00)[0];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[pobox.suse.cz:mid,pobox.suse.cz:helo]
X-Spam-Flag: NO
X-Spam-Level: 

Hi,

On Wed, 28 Aug 2024, Wardenjohn wrote:

> One system may contains more than one livepatch module. We can see
> which patch is enabled. If some patches applied to one system
> modifing the same function, livepatch will use the function enabled
> on top of the function stack. However, we can not excatly know
> which function of which patch is now enabling.
> 
> This patch introduce one sysfs attribute of "using" to klp_func.
> For example, if there are serval patches  make changes to function
> "meminfo_proc_show", the attribute "enabled" of all the patch is 1.
> With this attribute, we can easily know the version enabling belongs
> to which patch.
> 
> The "using" is set as three state. 0 is disabled, it means that this
> version of function is not used. 1 is running, it means that this
> version of function is now running. -1 is unknown, it means that
> this version of function is under transition, some task is still
> chaning their running version of this function.
> 
> cat /sys/kernel/livepatch/<patch1>/<object1>/<function1,sympos>/using -> 0
> means that the function1 of patch1 is disabled.
> 
> cat /sys/kernel/livepatch/<patchN>/<object1>/<function1,sympos>/using -> 1
> means that the function1 of patchN is enabled.
> 
> cat /sys/kernel/livepatch/<patchN>/<object1>/<function1,sympos>/using -> -1
> means that the function1 of patchN is under transition and unknown.
> 
> Signed-off-by: Wardenjohn <zhangwarden@gmail.com>

I am not a fan. Josh wrote most of my objections already so I will not 
repeat them. I understand that the attribute might be useful but the 
amount of code it adds to sensitive functions like 
klp_complete_transition() is no fun.

Would it be possible to just use klp_transition_patch and implement the 
logic just in using_show()? I have not thought through it completely but 
klp_transition_patch is also an indicator that there is a transition going 
on. It is set to NULL only after all func->transition are false. So if you 
check that, you can assign -1 in using_show() immediately and then just 
look at the top of func_stack.

If possible (and there are corner cases everywhere. Just take a look at 
barriers in all those functions.) and the resulting code is much simpler, 
we might take it. But otherwise this should really be solved in userspace 
using some live patch management tool as Josh said. I mean generally 
because you have much more serious problems without it.

Regards,
Miroslav

