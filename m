Return-Path: <live-patching+bounces-219-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8AD02899C0D
	for <lists+live-patching@lfdr.de>; Fri,  5 Apr 2024 13:47:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3AB70283EAB
	for <lists+live-patching@lfdr.de>; Fri,  5 Apr 2024 11:47:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24C6116C692;
	Fri,  5 Apr 2024 11:47:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="BEnt1lON";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="95++aYZM";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="BEnt1lON";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="95++aYZM"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39CC86CDB7;
	Fri,  5 Apr 2024 11:46:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712317620; cv=none; b=pYweXljyMiInPNWT36u6v1KUPT9Kugxz2PihtjE3jgenLZToM9fmyMsBLb10pRxGK3e89GrtieLP2gPW2F0g9A3I3iSDAtcug1fZyu/RHqUzUjs8lG6JEu2OnvMNSOqJfG0+auD9cb6UvxIF9TShe1Yk1AEYGyEVZ55DBlhFenw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712317620; c=relaxed/simple;
	bh=NG9RHd5G37IHLkPn/9+Zom7FmhDI4PCfK8ILPMziYeE=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=Aos00HXClwqjqcmcKGKnj40W8Q86ipENt+9StSh0D86C1AViJQ+ZNqO8wiRsldUpF2mxqBDB2yO4+hvHjPqvo/gfbyrvpY7Sg62YCdvl+KPxwbHOFkUQbTWZr/JHaHFw3pMlO8xqVc4+t4NyVDfnQgKnCIgUcEzomMbV9hobEV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=BEnt1lON; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=95++aYZM; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=BEnt1lON; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=95++aYZM; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from pobox.suse.cz (unknown [10.100.2.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 3AD8C21A3A;
	Fri,  5 Apr 2024 11:46:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1712317616; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Tr9scxBbnuYQ9DFHbSA9arfYXV9urCKlpz4lwV32V+A=;
	b=BEnt1lONkiy/wX/WouOFfl603wUxXy6TMbJUuWtY4LL9WURct4yTB3EjIpVNU30GRkDRcJ
	uI8RwYDY3YiXOnWpexKeYQHPvK+LU5Zr1Y418kMrZGsJQlHoCty8Fi84FD5iJ3a5GqviIU
	iWhgZyIgWH/g7XQaiHqAHzJKBpJTAMU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1712317616;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Tr9scxBbnuYQ9DFHbSA9arfYXV9urCKlpz4lwV32V+A=;
	b=95++aYZMwRjvc2bCWdCPTXliFklDSqqBeUrKkoP0gHjhq/LCoV2EDoYEObLBGZtKFKix3H
	ZPxmeSPFxb7inRBw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1712317616; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Tr9scxBbnuYQ9DFHbSA9arfYXV9urCKlpz4lwV32V+A=;
	b=BEnt1lONkiy/wX/WouOFfl603wUxXy6TMbJUuWtY4LL9WURct4yTB3EjIpVNU30GRkDRcJ
	uI8RwYDY3YiXOnWpexKeYQHPvK+LU5Zr1Y418kMrZGsJQlHoCty8Fi84FD5iJ3a5GqviIU
	iWhgZyIgWH/g7XQaiHqAHzJKBpJTAMU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1712317616;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Tr9scxBbnuYQ9DFHbSA9arfYXV9urCKlpz4lwV32V+A=;
	b=95++aYZMwRjvc2bCWdCPTXliFklDSqqBeUrKkoP0gHjhq/LCoV2EDoYEObLBGZtKFKix3H
	ZPxmeSPFxb7inRBw==
Date: Fri, 5 Apr 2024 13:46:56 +0200 (CEST)
From: Miroslav Benes <mbenes@suse.cz>
To: Joe Lawrence <joe.lawrence@redhat.com>
cc: Yafang Shao <laoar.shao@gmail.com>, pmladek@suse.com, jpoimboe@kernel.org, 
    jikos@kernel.org, mcgrof@kernel.org, live-patching@vger.kernel.org, 
    linux-modules@vger.kernel.org
Subject: Re: [PATCH] livepatch: Delete the associated module when replacing
 an old livepatch
In-Reply-To: <f9780cb7-1071-7cb3-c18a-0681a741e0b4@redhat.com>
Message-ID: <alpine.LSU.2.21.2404051333010.8047@pobox.suse.cz>
References: <20240331133839.18316-1-laoar.shao@gmail.com> <ZgrMfYBo8TynjSKX@redhat.com> <CALOAHbDWiO+TbRnjxCN3j9YWD3Cz9NOg9g-xOhVqmaPmexqNoQ@mail.gmail.com> <f9780cb7-1071-7cb3-c18a-0681a741e0b4@redhat.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Level: 
X-Spamd-Result: default: False [0.20 / 50.00];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	BAYES_HAM(-0.00)[39.41%];
	RCPT_COUNT_SEVEN(0.00)[8];
	RCVD_COUNT_ZERO(0.00)[0];
	TAGGED_RCPT(0.00)[];
	ARC_NA(0.00)[];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,suse.com,kernel.org,vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	FROM_EQ_ENVFROM(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_SOME(0.00)[]
X-Spam-Score: 0.20
X-Spam-Flag: NO

> >>> --- a/kernel/livepatch/core.c
> >>> +++ b/kernel/livepatch/core.c
> >>> @@ -711,6 +711,8 @@ static void klp_free_patch_start(struct klp_patch *patch)
> >>>   */
> >>>  static void klp_free_patch_finish(struct klp_patch *patch)
> >>>  {
> >>> +     struct module *mod = patch->mod;
> >>> +
> >>>       /*
> >>>        * Avoid deadlock with enabled_store() sysfs callback by
> >>>        * calling this outside klp_mutex. It is safe because
> >>> @@ -721,8 +723,13 @@ static void klp_free_patch_finish(struct klp_patch *patch)
> >>>       wait_for_completion(&patch->finish);
> >>>
> >>>       /* Put the module after the last access to struct klp_patch. */
> >>> -     if (!patch->forced)
> >>> -             module_put(patch->mod);
> >>> +     if (!patch->forced)  {
> >>> +             module_put(mod);
> >>> +             if (module_refcount(mod))
> >>> +                     return;
> >>> +             mod->state = MODULE_STATE_GOING;
> >>> +             delete_module(mod);
> >>> +     }
> 
> I'm gonna have to read study code in kernel/module/ to be confident that
> this is completely safe.  What happens if this code races a concurrent
> `rmmod` from the user (perhaps that pesky kpatch utility)?  Can a stray
> module reference sneak between the code here.  Etc.  The existing
> delete_module syscall does some additional safety checks under the
> module_mutex, which may or may not make sense for this use case... Petr,
> Miroslav any thoughts?

Compared to the existing delete_module syscall we know at this point that 
the module was live and used which gives us a slight advantage (leaving 
the issue that this path is also used in klp_enable_patch() as Petr said 
aside). However as you and Petr pointed out already I do not think it is 
correct to do this here. Changing mod->state is possible without 
module_mutex but only in some cases. I need to refresh it.

Anyway, a separate patch with a preparation work might reveal some of 
these issues and would be easier to review hopefully.

Miroslav



