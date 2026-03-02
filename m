Return-Path: <live-patching+bounces-2098-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KDtzAYJMpWmt8AUAu9opvQ
	(envelope-from <live-patching+bounces-2098-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Mon, 02 Mar 2026 09:38:26 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A04761D4B86
	for <lists+live-patching@lfdr.de>; Mon, 02 Mar 2026 09:38:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 8E65B300E297
	for <lists+live-patching@lfdr.de>; Mon,  2 Mar 2026 08:38:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B65C83321A1;
	Mon,  2 Mar 2026 08:38:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="1OnkcKsf";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="4H5+m6tm";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="1OnkcKsf";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="4H5+m6tm"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27693387593
	for <live-patching@vger.kernel.org>; Mon,  2 Mar 2026 08:38:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772440701; cv=none; b=idmIva5FoNL4gmv3AZa/P4/0TCm3j/7avhxrs6gHT0UZyLPnEZhZgMFon9zm8l3gEFp+n6NeW3Sk6NSG8r6UpHQBJmq9DtSU6aVK/4woefstexdLbCNEQ6VPd7dXq10y4N/TG83aHq3WHiWIA1h9mp0iBElx7sKL7a1FTZP49JE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772440701; c=relaxed/simple;
	bh=43wUCAYmSzJZaubjcKZhtZTaUR9PNEShC+kEqh2Hq04=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=Cd6nI2Ag6MhsQUxO1yyvngi7fKQOCvqwQ8PtEbmNY5IrRJq58kGXcWsh6EMkE5uSz4teOxxjcypceCH+jTue34fjSqQ0mwQLzMU7td3iJhdb3Z+5xvnNmOrN7mOsRV4dVBkoa3yezaNh04YLF9pFsPFPpC+n3HDuG6PU0oF8H10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=1OnkcKsf; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=4H5+m6tm; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=1OnkcKsf; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=4H5+m6tm; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from pobox.suse.cz (unknown [10.128.32.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 623BC3FAF7;
	Mon,  2 Mar 2026 08:38:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772440697; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2QDyqvlyynKMv9qdbzx9H0V7wWTN9/oUFlEiWkHJoJQ=;
	b=1OnkcKsfMzNq0vko0dc5IN6BoGPXANWhkS4XT0kz6JhIuBVAmJ5/4YzL7BJZsjfRQaFUu+
	higBT/niLuIiyou5SIwXtAxeMr+bHWpoiEyxylx7lKmfxDvb4mxwstIbstEiEUwjVVV0hT
	RetgO6iFiki+QvFqsR3LmJ7f98LKt3Q=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772440697;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2QDyqvlyynKMv9qdbzx9H0V7wWTN9/oUFlEiWkHJoJQ=;
	b=4H5+m6tmGay8uWAXYNsbuZQ8JUtWidKYhBcZMNtL5V3lG1QQs14hNdUqzQM81zFSKoIGwP
	8+kPIr0kT2tDxUCQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772440697; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2QDyqvlyynKMv9qdbzx9H0V7wWTN9/oUFlEiWkHJoJQ=;
	b=1OnkcKsfMzNq0vko0dc5IN6BoGPXANWhkS4XT0kz6JhIuBVAmJ5/4YzL7BJZsjfRQaFUu+
	higBT/niLuIiyou5SIwXtAxeMr+bHWpoiEyxylx7lKmfxDvb4mxwstIbstEiEUwjVVV0hT
	RetgO6iFiki+QvFqsR3LmJ7f98LKt3Q=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772440697;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2QDyqvlyynKMv9qdbzx9H0V7wWTN9/oUFlEiWkHJoJQ=;
	b=4H5+m6tmGay8uWAXYNsbuZQ8JUtWidKYhBcZMNtL5V3lG1QQs14hNdUqzQM81zFSKoIGwP
	8+kPIr0kT2tDxUCQ==
Date: Mon, 2 Mar 2026 09:38:17 +0100 (CET)
From: Miroslav Benes <mbenes@suse.cz>
To: Song Liu <song@kernel.org>
cc: live-patching@vger.kernel.org, jpoimboe@kernel.org, jikos@kernel.org, 
    pmladek@suse.com, joe.lawrence@redhat.com, kernel-team@meta.com
Subject: Re: [PATCH v3 8/8] livepatch: Add tests for klp-build toolchain
In-Reply-To: <CAPhsuW69EZTcMGyXSKv2fEjh7mhtYaSxriZrSgX0nTPCEYKS7A@mail.gmail.com>
Message-ID: <alpine.LSU.2.21.2603020930540.21479@pobox.suse.cz>
References: <20260226005436.379303-1-song@kernel.org> <20260226005436.379303-9-song@kernel.org> <alpine.LSU.2.21.2602271052240.374@pobox.suse.cz> <CAPhsuW69EZTcMGyXSKv2fEjh7mhtYaSxriZrSgX0nTPCEYKS7A@mail.gmail.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Flag: NO
X-Spam-Score: -4.30
X-Spam-Level: 
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-2098-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[suse.cz];
	DKIM_TRACE(0.00)[suse.cz:+];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[mbenes@suse.cz,live-patching@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	NEURAL_HAM(-0.00)[-0.999];
	RCPT_COUNT_SEVEN(0.00)[7];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,suse.cz:dkim,pobox.suse.cz:mid]
X-Rspamd-Queue-Id: A04761D4B86
X-Rspamd-Action: no action

Him

> > We store test modules in tools/testing/selftests/livepatch/test_modules/
> > now. Could you move klp_test_module.c there, please? You might also reuse
> > existing ones for the purpose perhaps.
> 
> IIUC, tools/testing/selftests/livepatch/test_modules/ is more like an out
> of tree module. In the case of testing klp-build, we prefer to have it to
> work the same as in-tree modules. This is important because klp-build
> is a toolchain, and any changes of in-tree Makefiles may cause issues
> with klp-build. Current version can catch these issues easily. If we build
> the test module as an OOT module, we may miss some of these issues.
> In the longer term, we should consider adding klp-build support to build
> livepatch for OOT modules. But for now, good test coverage for in-tree
> modules are more important.

Ok. I thought it would not matter but it is a fair point.

> > What about vmlinux? I understand that it provides a lot more flexibility
> > to have separate functions for testing but would it be somehow sufficient
> > to use the existing (real) kernel functions? Like cmdline_proc_show() and
> > such which we use everywhere else? Or would it be to limited? I am fine if
> > you find it necessary in the end. I just think that reusing as much as
> > possible is generally a good approach.
> 
> I think using existing functions would be too limited, and Joe seems to
> agree with this based on his experience. To be able to test corner cases
> of the compiler/linker, such as LTO, we need special code patterns.
> OTOH, if we want to use an existing kernel function for testing, it needs
> to be relatively stable, i.e., not being changed very often. It is not always
> easy to find some known to be stable code that follows specific patterns.
> If we add dedicated code as test targets, things will be much easier
> down the road.

Fair enough.

> > And a little bit of bikeshedding at the end. I think it would be more
> > descriptive if the new config options and tests (test modules) have
> > klp-build somewhere in the name to keep it clear. What do you think?
> 
> Technically, we can also use these tests to test other toolchains, for
> example, kpatch-build. I don't know ksplice or kGraft enough to tell
> whether they can benefit from these tests or not. OTOH, I am OK
> changing the name/description of these config options.

I would prefer it, thank you. Unless someone else objects of course.

Regards,
Miroslav

