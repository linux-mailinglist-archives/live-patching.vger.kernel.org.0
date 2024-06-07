Return-Path: <live-patching+bounces-337-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D11690044F
	for <lists+live-patching@lfdr.de>; Fri,  7 Jun 2024 15:06:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D1F791F25152
	for <lists+live-patching@lfdr.de>; Fri,  7 Jun 2024 13:06:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C66B919309F;
	Fri,  7 Jun 2024 13:06:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="xER5avAJ";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="HBijFktW";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="w/e9BQ4k";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="OE0/Qpts"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F13D118732D;
	Fri,  7 Jun 2024 13:06:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717765580; cv=none; b=oEZcN4x7DZCf0WyxhBkKpPs4mW3RfWQ727jrLKXCZSEASDPwjg3ukKaLUnTlxgWpLJNYUNHBDgsnpKYax87tqZWtucZib3/305aZm/9/5PJcd/opsniNh/EcDZSUU11Qdptl3aH5YvbZOp3yTun+37PKXELRBROxMHdiTUFwak4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717765580; c=relaxed/simple;
	bh=cGw8o0ZX7zNrCp7rsfJ9EqnSgp44wvmUedwXlgBIv0U=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=h8+qT2pdXOwqhqFES6HtnSDU6ILFO9LpHSQb1wB+mWDBm16lr3Z6hGD9mowcupxn/Mlrz+rMq6QXYnM/W9fTV/cRARNPUi5tqYhgAIhFXpTCNcktODzPqPLifms/bjTZoygSb4GwtDxOLZ6jAKuZAhCGuDtpBk/QCGADUcwSlpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=xER5avAJ; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=HBijFktW; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=w/e9BQ4k; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=OE0/Qpts; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from pobox.suse.cz (unknown [10.100.2.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id E127721B5B;
	Fri,  7 Jun 2024 13:06:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1717765577; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lPvY+Tt9r94bsTZ7TYjRmH35+64xaq9cOEI4varcaL8=;
	b=xER5avAJkjwHieLCG1k4kqtkALwdf/PnaNTBIC5vetJ23ZHnZjZ0ZSzvQ6DefyxuXs0KEF
	nLUO/yN//vYvI45QH0FGCusd4oe3GZRl4bRfpkMqLtgmQO7XAROm8dRfPtvx+NH8YFnhM+
	8+vm0EACJJ3BJ8JrMM/W5ag6Ob9Gy4w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1717765577;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lPvY+Tt9r94bsTZ7TYjRmH35+64xaq9cOEI4varcaL8=;
	b=HBijFktW6el1fbLXoFJ4efVIuu3vJBqLERt9R4nO+tM5l9S2V5xjIowSQ1a/iTQ3ZkcXrm
	iRZCMBhLnFsWHZAg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1717765575; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lPvY+Tt9r94bsTZ7TYjRmH35+64xaq9cOEI4varcaL8=;
	b=w/e9BQ4kW8/0I3TZA24NggFjII/Xj0w9b5I5qL648PSyBKa/y2NJH42vOjxrfyBm2SdD/s
	OQiut7e/NoT4gLwTES3fHHJhLorA2EJdNpe/k5ceW5yv7uu/gt/d0qUuh0FKPMmpU26QcF
	3cZo7slS0zdWoXRUvWYosNv+nNbHSOQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1717765575;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lPvY+Tt9r94bsTZ7TYjRmH35+64xaq9cOEI4varcaL8=;
	b=OE0/QptssFazcchENtgBLSG/OoD/Nt+kGsSHj2Is7fNUL0STDDbPBtsMV4dKv4k70v+s73
	wimdnby7NbtC0IDA==
Date: Fri, 7 Jun 2024 15:06:14 +0200 (CEST)
From: Miroslav Benes <mbenes@suse.cz>
To: Song Liu <song@kernel.org>
cc: live-patching@vger.kernel.org, linux-kernel@vger.kernel.org, 
    jpoimboe@kernel.org, jikos@kernel.org, pmladek@suse.com, 
    joe.lawrence@redhat.com, nathan@kernel.org, morbo@google.com, 
    justinstitt@google.com, mcgrof@kernel.org, thunder.leizhen@huawei.com, 
    kees@kernel.org, kernel-team@meta.com
Subject: Re: [PATCH] kallsyms, livepatch: Fix livepatch with
 CONFIG_LTO_CLANG
In-Reply-To: <20240605032120.3179157-1-song@kernel.org>
Message-ID: <alpine.LSU.2.21.2406071458531.29080@pobox.suse.cz>
References: <20240605032120.3179157-1-song@kernel.org>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Flag: NO
X-Spam-Score: -4.18
X-Spam-Level: 
X-Spamd-Result: default: False [-4.18 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	NEURAL_HAM_SHORT(-0.08)[-0.404];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[14];
	RCVD_COUNT_ZERO(0.00)[0];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_SOME(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	DBL_BLOCKED_OPENRESOLVER(0.00)[pobox.suse.cz:helo]

Hi,

On Tue, 4 Jun 2024, Song Liu wrote:

> With CONFIG_LTO_CLANG, the compiler may postfix symbols with .llvm.<hash>
> to avoid symbol duplication. scripts/kallsyms.c sorted the symbols
> without these postfixes. The default symbol lookup also removes these
> postfixes before comparing symbols.
> 
> On the other hand, livepatch need to look up symbols with the full names.
> However, calling kallsyms_on_each_match_symbol with full name (with the
> postfix) cannot find the symbol(s). As a result, we cannot livepatch
> kernel functions with .llvm.<hash> postfix or kernel functions that use
> relocation information to symbols with .llvm.<hash> postfixes.
> 
> Fix this by calling kallsyms_on_each_match_symbol without the postfix;
> and then match the full name (with postfix) in klp_match_callback.
> 
> Signed-off-by: Song Liu <song@kernel.org>
> ---
>  include/linux/kallsyms.h | 13 +++++++++++++
>  kernel/kallsyms.c        | 21 ++++++++++++++++-----
>  kernel/livepatch/core.c  | 32 +++++++++++++++++++++++++++++++-
>  3 files changed, 60 insertions(+), 6 deletions(-)

I do not like much that something which seems to be kallsyms-internal is 
leaked out. You need to export cleanup_symbol_name() and there is now a 
lot of code outside. I would feel much more comfortable if it is all 
hidden from kallsyms users and kept there. Would it be possible?

Moreover, isn't there a similar problem for ftrace, kprobes, ebpf,...?

Thank you,
Miroslav

