Return-Path: <live-patching+bounces-2051-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qNMCO9J3l2nVywIAu9opvQ
	(envelope-from <live-patching+bounces-2051-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 19 Feb 2026 21:51:30 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 2ABD716276C
	for <lists+live-patching@lfdr.de>; Thu, 19 Feb 2026 21:51:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 64225300A4F5
	for <lists+live-patching@lfdr.de>; Thu, 19 Feb 2026 20:51:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43765318EC5;
	Thu, 19 Feb 2026 20:51:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qmNfAls5"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 204953164D4
	for <live-patching@vger.kernel.org>; Thu, 19 Feb 2026 20:51:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771534264; cv=none; b=lzK7o2aPOqwMsIGXpHP9bF7ASDV7bHjAtnDHacLZEXK+jVxNM0s1vUHTytYDuamCjoiNwo/P8H5cwNF9JrKEY8WssGLhzBPhn0cBb+Qv71JRCePdhzYOiGmuZeDmMt1nwfp7WrwfZ7fCdHm0RryYXseaJ6rT3o8/myLUFoJu1gM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771534264; c=relaxed/simple;
	bh=JaGB2L1/qnxoxKVwDvddVb5xT83vX7hNnPR3kVJrCsk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ihvPl7rtPNui+swnDaONmYWBeZ+9HTTHp7hA89r67lTlTADFJJJ53QI0Qg8Isa1VQA+02ZX9uwj199nAZZIyqw4z9RJMvUenBO2Dl7EOLnKCZkRWk3Nxk2CMknmLftJX4X2FWVF7Bqb8JcWyHbfrvEH5nj9igsdfvzH2X8T5Jk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qmNfAls5; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71DA3C4CEF7;
	Thu, 19 Feb 2026 20:51:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771534263;
	bh=JaGB2L1/qnxoxKVwDvddVb5xT83vX7hNnPR3kVJrCsk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qmNfAls5St/OcC77SIP6ORqJl0fmI3VjRS5GQYBCMGlCKVMdlxWYBLzluEcPB8c+y
	 SIQXq3gJlY2lPLC4+Mj4AiT1cmBO+dXvfI4oFydzfC/9h3Y4acTTyJkuXujMzatwFy
	 6sIfUk7Kj1CyEejEASrJjByqFJkE9hN1j9rVbCP3XKQXkMI7zc4Q3HhLtJJhmfwj5t
	 ns6hq9vTE0dKEoa1igRqvGmOoDsfnIY27rpjmHiUxScLFcR8JqpxpWR6RrgyOqb0GU
	 CID+p3Da/vvF5iRwUyfFmD6WobBkGRBFWC+2iFJlzdSQTa327H8IW9UA3A2owd1yhT
	 8mQYR1BaAVEVw==
Date: Thu, 19 Feb 2026 12:51:01 -0800
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Song Liu <song@kernel.org>
Cc: Joe Lawrence <joe.lawrence@redhat.com>, live-patching@vger.kernel.org, 
	jikos@kernel.org, mbenes@suse.cz, pmladek@suse.com, kernel-team@meta.com
Subject: Re: [PATCH 0/8] objtool/klp: klp-build LTO support and tests
Message-ID: <5l3i26zkg7eoprhuyl7pdujrn2a4vyule423xqovnoea53tu3j@j4pbbgdy232c>
References: <20260212192201.3593879-1-song@kernel.org>
 <aZZEjfxgLWTWODE7@redhat.com>
 <CAPhsuW7zHDxct5OByqDH+i3m5xbqBrrRtEJ4xV=AC6rgFgbq3g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPhsuW7zHDxct5OByqDH+i3m5xbqBrrRtEJ4xV=AC6rgFgbq3g@mail.gmail.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2051-lists,live-patching=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jpoimboe@kernel.org,live-patching@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 2ABD716276C
X-Rspamd-Action: no action

On Wed, Feb 18, 2026 at 07:08:55PM -0800, Song Liu wrote:
> On Wed, Feb 18, 2026 at 3:00 PM Joe Lawrence <joe.lawrence@redhat.com> wrote:
> >
> > On Thu, Feb 12, 2026 at 11:21:53AM -0800, Song Liu wrote:
> [...]
> > vmlinux.o: warning: objtool: correlate c_start.llvm.15251198824366928061 (origial) to c_start.llvm.14107081093236395767 (patched)
> > vmlinux.o: warning: objtool: correlate c_stop.llvm.15251198824366928061 (origial) to c_stop.llvm.14107081093236395767 (patched)
> > vmlinux.o: warning: objtool: correlate c_next.llvm.15251198824366928061 (origial) to c_next.llvm.14107081093236395767 (patched)
> > vmlinux.o: warning: objtool: correlate show_cpuinfo.llvm.15251198824366928061 (origial) to show_cpuinfo.llvm.10047843810948474008 (patched)
> > vmlinux.o: warning: objtool: correlate .str.llvm.1768504738091882651 (origial) to .str.llvm.7814622528726587167 (patched)
> > vmlinux.o: warning: objtool: correlate crypto_seq_ops.llvm.1768504738091882651 (origial) to crypto_seq_ops.llvm.14107081093236395767 (patched)
> > vmlinux.o: warning: objtool: correlate c_start.llvm.1768504738091882651 (origial) to c_start.llvm.14107081093236395767 (patched)
> > vmlinux.o: warning: objtool: correlate c_stop.llvm.1768504738091882651 (origial) to c_stop.llvm.14107081093236395767 (patched)
> > vmlinux.o: warning: objtool: correlate c_next.llvm.1768504738091882651 (origial) to c_next.llvm.14107081093236395767 (patched)
> > vmlinux.o: warning: objtool: correlate c_show.llvm.1768504738091882651 (origial) to c_show.llvm.14107081093236395767 (patched)
> > vmlinux.o: warning: objtool: correlate __pfx_c_start.llvm.15251198824366928061 (origial) to __pfx_c_start.llvm.14107081093236395767 (patched)
> > vmlinux.o: warning: objtool: correlate __pfx_c_stop.llvm.15251198824366928061 (origial) to __pfx_c_stop.llvm.14107081093236395767 (patched)
> > vmlinux.o: warning: objtool: correlate __pfx_c_next.llvm.15251198824366928061 (origial) to __pfx_c_next.llvm.14107081093236395767 (patched)
> > vmlinux.o: warning: objtool: correlate __pfx_show_cpuinfo.llvm.15251198824366928061 (origial) to __pfx_show_cpuinfo.llvm.10047843810948474008 (patched)
> > vmlinux.o: warning: objtool: correlate __pfx_c_start.llvm.1768504738091882651 (origial) to __pfx_c_start.llvm.14107081093236395767 (patched)
> > vmlinux.o: warning: objtool: correlate __pfx_c_stop.llvm.1768504738091882651 (origial) to __pfx_c_stop.llvm.14107081093236395767 (patched)
> > vmlinux.o: warning: objtool: correlate __pfx_c_next.llvm.1768504738091882651 (origial) to __pfx_c_next.llvm.14107081093236395767 (patched)
> > vmlinux.o: warning: objtool: correlate __pfx_c_show.llvm.1768504738091882651 (origial) to __pfx_c_show.llvm.14107081093236395767 (patched)
> > vmlinux.o: warning: objtool: no correlation: c_start.llvm.1768504738091882651
> > vmlinux.o: warning: objtool: no correlation: c_stop.llvm.1768504738091882651
> > vmlinux.o: warning: objtool: no correlation: c_next.llvm.1768504738091882651
> > vmlinux.o: new function: c_start.llvm.10047843810948474008
> > vmlinux.o: new function: c_stop.llvm.10047843810948474008
> > vmlinux.o: new function: c_next.llvm.10047843810948474008
> > vmlinux.o: changed function: c_start.llvm.14107081093236395767
> > vmlinux.o: changed function: c_stop.llvm.14107081093236395767
> > vmlinux.o: changed function: c_next.llvm.14107081093236395767
> > Building patch module: livepatch-min.ko
> > SUCCESS
> 
> Thanks for the test case. This one shows the worst case of the .llvm.
> suffix issue.
> 
> We have
>   c_start.llvm.15251198824366928061
>   c_start.llvm.1768504738091882651
> in the original kernel, and
>   c_start.llvm.14107081093236395767
>   c_start.llvm.10047843810948474008
> in the patched kernel.
> 
> All of them are GLOBAL HIDDEN functions, so I don't think we can
> reliably correlate them. Maybe we should fail the build in such cases.

I'm thinking the "correlate <orig> to <patched>" warnings would need to
be an error when there's ambiguity (i.e., two symbols with the same
".llvm.*" mangled name), as there's nothing preventing their symbols'
orders from getting swapped.

And note that changing a symbol from local to global (or vice versa) can
do exactly that, as globals always come at the end.

Also, this problem may be more widespread than the above, as there are a
lot of duplicately named functions in the kernel, with
CONFIG_DEBUG_SECTION_MISMATCH making the problem even worse in practice.

I think we may need to figure out a way to map sym.llvm.<hash> back to
its original FILE symbol so correlate_symbols() can reliably
disambiguate.

The hash seems to be file-specific.  I don't think there's a way for
objtool to reverse engineer that.

DWARF could be used to map the symbol to its original file name, but we
can't necessarily rely on CONFIG_DEBUG_INFO.

However, I did find that LLVM has a hidden option:

  -mllvm -use-source-filename-for-promoted-locals

which changes the hash to a file path:

  c_start.llvm.arch_x86_kernel_cpu_proc_c

That would be (almost) everything we'd need to match a symbol to its
FILE symbol.

The only remaining ambiguity is that FILE symbols only have the
basename, not the full path.  So a duplicate "basename+sym" would still
be ambiguous.  But that seems much less likely.

We could possibly enforce a new requirement that "basename+sym" be
unique treewide.  Then we could maybe even base sympos on that.  That
also might help fix some of the other unique symbol headaches I remember
some people having with tracing and possibly elsewhere.

-- 
Josh

