Return-Path: <live-patching+bounces-375-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BF80191BE6F
	for <lists+live-patching@lfdr.de>; Fri, 28 Jun 2024 14:24:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4715A284581
	for <lists+live-patching@lfdr.de>; Fri, 28 Jun 2024 12:24:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A266156885;
	Fri, 28 Jun 2024 12:24:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="D9thjItH";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="L+f3H4is";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="kAe6vkW5";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="U4ON3LjP"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 744901E898;
	Fri, 28 Jun 2024 12:23:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719577440; cv=none; b=SYcAcfsYzLbkJd3rjOpNqToip0sCzYXf3Sopn9voFeefSVJgrW943pB/IPB7eYafnjM+JYBYTj3dGqGYdwaQjpvg9YpIfxixq38l0Og4QwR9rDef5k215PNidggu9guT7yICfIlJV0vC2FgGvnmAzhGEt9S90XKyXgDEF09S6Ec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719577440; c=relaxed/simple;
	bh=4YDHKZi8aLhgvz4O249udEW1Pdt31jb38URmtBj4/hU=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=Q53uBssp96xCXqnULh7VjEZJH4VRp5PoWfBxSpfC32CqX00H1NObGm6rVrPBe5tZlvZ3nfowHO04YHaRH4ZBZssGAgo87fb87WT2fvB1wHB94yxaMP4tk5g4M935lV5WYPUFd3McAcCpNs2kw+CiD/nUe2jrB74buR4H+H5JVQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=D9thjItH; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=L+f3H4is; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=kAe6vkW5; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=U4ON3LjP; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from pobox.suse.cz (unknown [10.100.2.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 480AF21B62;
	Fri, 28 Jun 2024 12:23:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1719577430; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rOJAHhP09iSkMHBXfW1Ap1pPYlwd3RjPz7/D0Av41b0=;
	b=D9thjItHOc26RIGU6t609H+UZwIYjgYEPaIHo+JJcfVod3RVmfbVVRVXJ60zxzX8j5TQwo
	Z2AG3z2/PxynwseqrhQ2GCdZwi8iFak5lIpnKWXQgeMz8Ok1EiRDo2KsGeHGhnw+myNuWb
	sTA1WvZLgiIr1bJIyL2DeNMjGwUrU1U=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1719577430;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rOJAHhP09iSkMHBXfW1Ap1pPYlwd3RjPz7/D0Av41b0=;
	b=L+f3H4isfRncloyOciABmCpnz4ibN6YyrwoBMyeXdkhObWfJBADiSMAMO+EGrYVbS8K2Ev
	cES1NSpkQeFgmaBQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1719577429; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rOJAHhP09iSkMHBXfW1Ap1pPYlwd3RjPz7/D0Av41b0=;
	b=kAe6vkW57UeQyQxWbdkBKvnDyILBTnJwjIZHlerYnDaJw6KZnEV6dLRZeo3VMbMKzJ3LZB
	ftGVvQnimC2IAqUZAx2YQVTOZTps7eCttNpu8pwd6pYcpaeAFPkvNWDI/C6sxPhm0BWMG7
	dL6ugQwSOSHkrTB5oOtO6X3SCAqOJvg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1719577429;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rOJAHhP09iSkMHBXfW1Ap1pPYlwd3RjPz7/D0Av41b0=;
	b=U4ON3LjP9BbJTHwuyHhLxnvO+zZh7ngMkheye0nZu6GP6oS2rgy2vo7o+yjtheB9E026a3
	GuGycC9VCdQm28Bw==
Date: Fri, 28 Jun 2024 14:23:49 +0200 (CEST)
From: Miroslav Benes <mbenes@suse.cz>
To: Song Liu <song@kernel.org>
cc: live-patching@vger.kernel.org, linux-kernel@vger.kernel.org, 
    jpoimboe@kernel.org, jikos@kernel.org, pmladek@suse.com, 
    joe.lawrence@redhat.com, nathan@kernel.org, morbo@google.com, 
    justinstitt@google.com, mcgrof@kernel.org, thunder.leizhen@huawei.com, 
    kees@kernel.org, kernel-team@meta.com
Subject: Re: [PATCH] kallsyms, livepatch: Fix livepatch with
 CONFIG_LTO_CLANG
In-Reply-To: <CAPhsuW5th55V3PfskJvpG=4bwacKP8c8DpVYUyVUzt70KC7=gw@mail.gmail.com>
Message-ID: <alpine.LSU.2.21.2406281420590.15826@pobox.suse.cz>
References: <20240605032120.3179157-1-song@kernel.org> <alpine.LSU.2.21.2406071458531.29080@pobox.suse.cz> <CAPhsuW5th55V3PfskJvpG=4bwacKP8c8DpVYUyVUzt70KC7=gw@mail.gmail.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="1678380546-210972171-1719577429=:15826"
X-Spam-Score: -3.30
X-Spam-Level: 
X-Spam-Flag: NO
X-Spamd-Result: default: False [-3.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	CTYPE_MIXED_BOGUS(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[multipart/mixed,text/plain];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[14];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+,1:+];
	ARC_NA(0.00)[];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_ZERO(0.00)[0];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	DBL_BLOCKED_OPENRESOLVER(0.00)[pobox.suse.cz:helo,suse.cz:email]

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--1678380546-210972171-1719577429=:15826
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Fri, 7 Jun 2024, Song Liu wrote:

> Hi Miroslav,
> 
> Thanks for reviewing the patch!
> 
> On Fri, Jun 7, 2024 at 6:06 AM Miroslav Benes <mbenes@suse.cz> wrote:
> >
> > Hi,
> >
> > On Tue, 4 Jun 2024, Song Liu wrote:
> >
> > > With CONFIG_LTO_CLANG, the compiler may postfix symbols with .llvm.<hash>
> > > to avoid symbol duplication. scripts/kallsyms.c sorted the symbols
> > > without these postfixes. The default symbol lookup also removes these
> > > postfixes before comparing symbols.
> > >
> > > On the other hand, livepatch need to look up symbols with the full names.
> > > However, calling kallsyms_on_each_match_symbol with full name (with the
> > > postfix) cannot find the symbol(s). As a result, we cannot livepatch
> > > kernel functions with .llvm.<hash> postfix or kernel functions that use
> > > relocation information to symbols with .llvm.<hash> postfixes.
> > >
> > > Fix this by calling kallsyms_on_each_match_symbol without the postfix;
> > > and then match the full name (with postfix) in klp_match_callback.
> > >
> > > Signed-off-by: Song Liu <song@kernel.org>
> > > ---
> > >  include/linux/kallsyms.h | 13 +++++++++++++
> > >  kernel/kallsyms.c        | 21 ++++++++++++++++-----
> > >  kernel/livepatch/core.c  | 32 +++++++++++++++++++++++++++++++-
> > >  3 files changed, 60 insertions(+), 6 deletions(-)
> >
> > I do not like much that something which seems to be kallsyms-internal is
> > leaked out. You need to export cleanup_symbol_name() and there is now a
> > lot of code outside. I would feel much more comfortable if it is all
> > hidden from kallsyms users and kept there. Would it be possible?
> 
> I think it is possible. Currently, kallsyms_on_each_match_symbol matches
> symbols without the postfix. We can add a variation or a parameter, so
> that it matches the full name with post fix.

I think it might be better.

Luis, what is your take on this?
 
> > Moreover, isn't there a similar problem for ftrace, kprobes, ebpf,...?
> 
> Yes, there is a similar problem with tracing use cases. But the requirements
> are not the same:
> 
> For livepatch, we have to point to the exact symbol we want to patch or
> relocation to. We have sympos API defined to differentiate different symbols
> with the same name.

Yes. In fact, sympos may be used to solve even this problem. The user 
would disregard .llvm.<hash> suffix and they are suddenly in the same 
situation which sympos aims to solve. I will not argue with you if say it 
is cumbersome.

> For tracing, some discrepancy is acceptable. AFAICT, there isn't an API
> similar to sympos yet. Also, we can play some tricks with tracing. For
> example, we can use "uniq symbol + offset" to point a kprobe to one of
> the duplicated symbols.

If I am not mistaken, there was a patch set to address this. Luis might 
remember more.

Regards,
Miroslav
--1678380546-210972171-1719577429=:15826--

