Return-Path: <live-patching+bounces-1285-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D3E9A670F4
	for <lists+live-patching@lfdr.de>; Tue, 18 Mar 2025 11:16:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2273D19A2CE4
	for <lists+live-patching@lfdr.de>; Tue, 18 Mar 2025 10:15:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60CFA209677;
	Tue, 18 Mar 2025 10:15:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="xVlQase8";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="yrLkcJFM";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="xVlQase8";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="yrLkcJFM"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 103C0207A2C
	for <live-patching@vger.kernel.org>; Tue, 18 Mar 2025 10:14:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742292902; cv=none; b=gdZtJCg0UnBMti/z4ib2KKqw+U+6nAV0I41Yd1XpLVwYhRiCxPni4+rRXgUyohBEAF1F7otl8QylGK/0oLDevNLOUkkPI0g8Gn488g4LkTx+U44oL6v3fOKSfsu+KlGzlc6R2mmq8Ih7qirfuVpR6ix3kEE949U42qqydkbYUEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742292902; c=relaxed/simple;
	bh=EkZWksrY9KPpDnpA8kp3+LW+0ygY4EM28p8/IvR0aDM=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=W/fmnEILlSxvtIP7IwnEjTwjF0/TWGXWSgtxJ/9O5wo6935LhQ4exe3SeyikjLIWdCR9lOo5De78UJ7Egysealyvy0V8YGvKMKF1FhsJ4ySgMdOvuG14DoXtuunCglBFS+d+ZXPRRprE7pUd54j9EaralR4aPZ+sLKJM27rmX5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=xVlQase8; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=yrLkcJFM; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=xVlQase8; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=yrLkcJFM; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from pobox.suse.cz (unknown [10.100.2.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 3B8D621E02;
	Tue, 18 Mar 2025 10:14:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1742292895; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6m02JkiWFa4cjCKC/89QrMrZQCXp49lqgvPh3fZqayU=;
	b=xVlQase8kGYJ32AAQDxHP0yQEvYOFcyLzBjDA3BvR8ea5gMQ82XRECIQC2Vu+nH5rODMrD
	lPSm7Npvuv0qE1gJM7lfywmO3UPDxbqjfW+sUN2yPNQBYyK1ZpodB5xiXq8CVputMItN1T
	FwG/G5CmQyLu4RfLER6A4m6b23aeBsM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1742292895;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6m02JkiWFa4cjCKC/89QrMrZQCXp49lqgvPh3fZqayU=;
	b=yrLkcJFM9uTMGyVSuFCkbvFKYQqC0XO6m4lOWnLzr6bHmXrKdqlsu9+EptoSfShaAIxZmU
	rJZkg1PHAKWKV2Dg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1742292895; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6m02JkiWFa4cjCKC/89QrMrZQCXp49lqgvPh3fZqayU=;
	b=xVlQase8kGYJ32AAQDxHP0yQEvYOFcyLzBjDA3BvR8ea5gMQ82XRECIQC2Vu+nH5rODMrD
	lPSm7Npvuv0qE1gJM7lfywmO3UPDxbqjfW+sUN2yPNQBYyK1ZpodB5xiXq8CVputMItN1T
	FwG/G5CmQyLu4RfLER6A4m6b23aeBsM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1742292895;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6m02JkiWFa4cjCKC/89QrMrZQCXp49lqgvPh3fZqayU=;
	b=yrLkcJFM9uTMGyVSuFCkbvFKYQqC0XO6m4lOWnLzr6bHmXrKdqlsu9+EptoSfShaAIxZmU
	rJZkg1PHAKWKV2Dg==
Date: Tue, 18 Mar 2025 11:14:55 +0100 (CET)
From: Miroslav Benes <mbenes@suse.cz>
To: Song Liu <song@kernel.org>
cc: Joe Lawrence <joe.lawrence@redhat.com>, live-patching@vger.kernel.org, 
    jpoimboe@kernel.org, kernel-team@meta.com, jikos@kernel.org, 
    pmladek@suse.com
Subject: Re: [PATCH] selftest/livepatch: Only run test-kprobe with
 CONFIG_KPROBES_ON_FTRACE
In-Reply-To: <CAPhsuW6UdBHHZA+h=hCctkL05YU7xpQ3uZ3=36ub5vrFYRNd5A@mail.gmail.com>
Message-ID: <alpine.LSU.2.21.2503181112380.16243@pobox.suse.cz>
References: <20250317165128.2356385-1-song@kernel.org> <2862567f-e380-a580-c3be-08bd768384f9@redhat.com> <CAPhsuW6UdBHHZA+h=hCctkL05YU7xpQ3uZ3=36ub5vrFYRNd5A@mail.gmail.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="1678380546-723765612-1742292895=:16243"
X-Spam-Level: 
X-Spamd-Result: default: False [-3.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	CTYPE_MIXED_BOGUS(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[multipart/mixed,text/plain];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	MIME_TRACE(0.00)[0:+,1:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_ZERO(0.00)[0];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[]
X-Spam-Score: -3.30
X-Spam-Flag: NO

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--1678380546-723765612-1742292895=:16243
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT

Hi,

On Mon, 17 Mar 2025, Song Liu wrote:

> On Mon, Mar 17, 2025 at 11:59 AM Joe Lawrence <joe.lawrence@redhat.com> wrote:
> >
> > On 3/17/25 12:51, Song Liu wrote:
> > > CONFIG_KPROBES_ON_FTRACE is required for test-kprobe. Skip test-kprobe
> > > when CONFIG_KPROBES_ON_FTRACE is not set.
> > >
> > > Signed-off-by: Song Liu <song@kernel.org>
> > > ---
> > >  tools/testing/selftests/livepatch/test-kprobe.sh | 2 ++
> > >  1 file changed, 2 insertions(+)
> > >
> > > diff --git a/tools/testing/selftests/livepatch/test-kprobe.sh b/tools/testing/selftests/livepatch/test-kprobe.sh
> > > index 115065156016..fd823dd5dd7f 100755
> > > --- a/tools/testing/selftests/livepatch/test-kprobe.sh
> > > +++ b/tools/testing/selftests/livepatch/test-kprobe.sh
> > > @@ -5,6 +5,8 @@
> > >
> > >  . $(dirname $0)/functions.sh
> > >
> > > +zgrep KPROBES_ON_FTRACE /proc/config.gz || skip "test-kprobe requires CONFIG_KPROBES_ON_FTRACE"
> > > +
> >
> > Hi Song,
> >
> > This in turn depends on CONFIG_IKCONFIG_PROC for /proc/config.gz (not
> > set for RHEL distro kernels).
> 
> I was actually worrying about this when testing it.
> 
> > Is there a dynamic way to figure out CONFIG_KPROBES_ON_FTRACE support?
> 
> How about we grep kprobe_ftrace_ops from /proc/kallsyms?

which relies on having KALLSYMS_ALL enabled but since CONFIG_LIVEPATCH 
depends on it, we are good. So I would say yes, it is a better option. 
Please, add a comment around.

Thank you,
Miroslav
--1678380546-723765612-1742292895=:16243--

