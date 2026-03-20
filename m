Return-Path: <live-patching+bounces-2243-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CFd5BG8xvWmI7QIAu9opvQ
	(envelope-from <live-patching+bounces-2243-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 20 Mar 2026 12:37:19 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 624EF2D9B1F
	for <lists+live-patching@lfdr.de>; Fri, 20 Mar 2026 12:37:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 262173026AAC
	for <lists+live-patching@lfdr.de>; Fri, 20 Mar 2026 11:33:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C294375AA2;
	Fri, 20 Mar 2026 11:33:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="byhVwfbH"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A719361DB9
	for <live-patching@vger.kernel.org>; Fri, 20 Mar 2026 11:33:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774006413; cv=none; b=oj/MYbgcjvCodcNoHrfs4p7ReO2EPPjwnnFtBRDAl10GzqEftgYJFLWltLJhgEbRdZqSCtU0Eu44+wazWmo6PMZD1zBmGVjjM7lf1iM2u+sfEGxj3FsB69aHC6qihu2NHFIUDaz0kr6QXDmVS6E1E0vFCbt89TwyYmERIL21s+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774006413; c=relaxed/simple;
	bh=ZlmFijkHDWcuZv/ee3JFBOPSYSxx5p0eNtkud6YlakI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hYHy7Our2LDdFjhA5qGNR78gjb9pwn3eB0VcC+XhVDYpW/cy9Y45QsiR2U6I5tcbOYzFeL4XVMpZJlRYj/RZypSuI/jA8PAMwpaap86SittO+1B/hEQ/OzdwFYgJy2aIpiXjbYvpLqPlLjpOfcpNPvJjmfDwgsQ+k4fWjXWzXUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=byhVwfbH; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-439d8df7620so1180594f8f.0
        for <live-patching@vger.kernel.org>; Fri, 20 Mar 2026 04:33:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1774006410; x=1774611210; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=3S86zsIMdrfTwxyiohbEf4eM7eTcf7P9TI7z+BHhdfE=;
        b=byhVwfbHXPf5P7OwGS+TG0esceb9hcFhU0D0mqG3czZLr4+tCAy/AXSLLuZWWiT4d7
         USqaFl36l0+IOCXbgCTXfWLK1VwKJupErFr3+H2pb2ESFAalSbtxISh8R2C51xUMFLZH
         7Ujtoka11JoBA1aEGpkYknYzLosAgctEkLwIkM3YK6evOSuecM84ZdaKSmmFkxHOa82v
         P0NWXhJtB6AMIfFQkL0cpC88dslaDb4Iha0rjJ8ujfxQWGKqpcfYMyubTuPbszAU5e2V
         ChT08bLtIpjcbQz45sV+JuA5v8qvA2cRe0Gwz5/bzxiZ1MuF38sXjTrpTd7E1DVxaH+A
         aX9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774006410; x=1774611210;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3S86zsIMdrfTwxyiohbEf4eM7eTcf7P9TI7z+BHhdfE=;
        b=Ca1q1Gh+Tzo3/RqwrMXKRiMLtK1P2r82KYimHW8oWt+GuHBiX0cAUAxPOWSevmEx/A
         mO1jWGyMZwgZ/hMSpOWMdXUqtUzJshWhYMa0c/UPrae3CjGJCyJnNFy9JYrUDJ/t3oMQ
         SWXjcqXj7PM0yhXMY6hXBYE71eeC4fKLgPu6LCC7dxeuvjplhm57mgnxPQ/mNXeq8SLv
         ppuby4SzOAchFFqAAO60Acs9Leda2ZJXoN5HHMFofNEsqO5n42trmE+XXx7TW/bmJE6F
         eHlBP0/lxSoJnpXh5Ei3OdtgXfgvK5H1leM/fk5NYIQyOl5xDAtbRQj+BHgF09rZjx3A
         mb0A==
X-Forwarded-Encrypted: i=1; AJvYcCWyas4Q0z793xNWg9Iba61QK6HIE/bQErgWH/Um7BLcew1GRVIm8jOst4B/rxezW4zHvTt9kGfMHDRc1ewg@vger.kernel.org
X-Gm-Message-State: AOJu0Yzq9jPgY+m3wPI/+XxzSLxQj2wkIj/2co8+yguNgpbSNWA+htRc
	Cb5m7v0lXPt+GSmRpT0XzFCEsZqGxNVwVS5D7HqMckifZvJji4zX2XbSryUlw8xVmw0=
X-Gm-Gg: ATEYQzwLNpYjMLYo9LtHL9mzNo0k4DtS8dDGHmRfkeNIwwyhmLvFEM059yxT6r9clx+
	I9zglbJaFl2FdIkDwleSEAm1qhWIXSEZlIJX3ScpYZpTP3KuE95PJQJCel+210MEfjS1hEJb4iI
	1xddnzYhizeS1Dr55ADycVxFUBbzUh6qKRwacFOwgdWFVpOtR1FI9nbJM4V4zedSoaFKdarYFx0
	zjDvnAvdLGb4q26AUwaqAVbBUZ58ps7qxR70Ks6xAyUt36ReD9euI9MQ/t4IH8qK1jeKSHTAdR4
	ouZi8YyHdBhNpT5zxSTrQwKSElz5ENdXdVet2f0/WJUKyEQ1DJ1nipHGvkr+8ZfO1OrqWbdJPQA
	LjmuLCK2fLmw94m0rX6GdsOQL0ouFLDD6WqfwACqTTfnzQ8BBy+HXgl31+SKh6ANuDCLMDaCWZV
	fOC/5iMCVcPZxfqiba8hyIci6OqQ==
X-Received: by 2002:a05:600c:8b61:b0:483:78c5:d743 with SMTP id 5b1f17b1804b1-486fee25f53mr38809955e9.28.1774006410163;
        Fri, 20 Mar 2026 04:33:30 -0700 (PDT)
Received: from pathway.suse.cz ([176.114.240.130])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-486fe7dc4a2sm61221255e9.5.2026.03.20.04.33.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Mar 2026 04:33:29 -0700 (PDT)
Date: Fri, 20 Mar 2026 12:33:28 +0100
From: Petr Mladek <pmladek@suse.com>
To: Marcos Paulo de Souza <mpdesouza@suse.com>
Cc: Joe Lawrence <joe.lawrence@redhat.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Jiri Kosina <jikos@kernel.org>, Miroslav Benes <mbenes@suse.cz>,
	Shuah Khan <shuah@kernel.org>, live-patching@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/8] selftests: livepatch: test-kprobe: Check if kprobes
 can work with livepatches
Message-ID: <ab0wiEuokqDwq5_v@pathway.suse.cz>
References: <20260313-lp-tests-old-fixes-v1-0-71ac6dfb3253@suse.com>
 <20260313-lp-tests-old-fixes-v1-3-71ac6dfb3253@suse.com>
 <abhqRTBtF1hLDmPq@redhat.com>
 <c4249fb8b36aba8649e4dcdac022f2d646413756.camel@suse.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c4249fb8b36aba8649e4dcdac022f2d646413756.camel@suse.com>
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[suse.com,quarantine];
	R_DKIM_ALLOW(-0.20)[suse.com:s=google];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[suse.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2243-lists,live-patching=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[pmladek@suse.com,live-patching@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	RCPT_COUNT_SEVEN(0.00)[9];
	NEURAL_HAM(-0.00)[-0.994];
	TAGGED_RCPT(0.00)[live-patching];
	TO_DN_SOME(0.00)[]
X-Rspamd-Queue-Id: 624EF2D9B1F
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Thu 2026-03-19 11:35:16, Marcos Paulo de Souza wrote:
> On Mon, 2026-03-16 at 16:38 -0400, Joe Lawrence wrote:
> > On Fri, Mar 13, 2026 at 05:58:34PM -0300, Marcos Paulo de Souza
> > wrote:
> > > Running the upstream selftests on older kernels can presente some
> > > issues
> > > regarding features being not present. One of such issues if the
> > > missing
> > > capability of having both kprobes and livepatches on the same
> > > function.
> > > 
> > 
> > nit picking, but slightly reworded for clarity and spelling:
> > 
> > Running upstream selftests on older kernels can be problematic when
> > features or fixes from newer versions are not present. For example,
> > older kernels may lack the capability to support kprobes and
> > livepatches
> > on the same function simultaneously.
> 
> Much better, I'll pick your description for v2.
> 
> > 
> > > The support was introduced in commit 0bc11ed5ab60c
> > > ("kprobes: Allow kprobes coexist with livepatch"), which means that
> > > older
> > > kernels may lack this change.
> > > 
> > > The lack of this feature can be checked when a kprobe without a
> > > post_handler is loaded and checking that the enabled_function's
> > > file
> > > shows the flag "I". A kernel with the proper support for kprobes
> > > and
> > > livepatches would presente the flag only when a post_handler is
> > 
> > nit: s/presente/present
> 
> > > --- a/tools/testing/selftests/livepatch/test-kprobe.sh
> > > +++ b/tools/testing/selftests/livepatch/test-kprobe.sh
> > > @@ -16,30 +16,19 @@ setup_config
> > >  # when it uses a post_handler since only one IPMODIFY maybe be
> > > registered
> > >  # to any given function at a time.
> > >  
> > > -start_test "livepatch interaction with kprobed function with
> > > post_handler"
> > > -
> > > -echo 1 > "$SYSFS_KPROBES_DIR/enabled"
> > > -
> > > -load_mod $MOD_KPROBE has_post_handler=1
> > > -load_failing_mod $MOD_LIVEPATCH
> > > -unload_mod $MOD_KPROBE
> > > -
> > > -check_result "% insmod test_modules/test_klp_kprobe.ko
> > > has_post_handler=1
> > > -% insmod test_modules/$MOD_LIVEPATCH.ko
> > > -livepatch: enabling patch '$MOD_LIVEPATCH'
> > > -livepatch: '$MOD_LIVEPATCH': initializing patching transition
> > > -livepatch: failed to register ftrace handler for function
> > > 'cmdline_proc_show' (-16)
> > > -livepatch: failed to patch object 'vmlinux'
> > > -livepatch: failed to enable patch '$MOD_LIVEPATCH'
> > > -livepatch: '$MOD_LIVEPATCH': canceling patching transition, going
> > > to unpatch
> > > -livepatch: '$MOD_LIVEPATCH': completing unpatching transition
> > > -livepatch: '$MOD_LIVEPATCH': unpatching complete
> > > -insmod: ERROR: could not insert module
> > > test_modules/$MOD_LIVEPATCH.ko: Device or resource busy
> > > -% rmmod test_klp_kprobe"
> > > -
> > >  start_test "livepatch interaction with kprobed function without
> > > post_handler"
> > >  
> > >  load_mod $MOD_KPROBE has_post_handler=0
> > > +
> > > +# Check if commit 0bc11ed5ab60c ("kprobes: Allow kprobes coexist
> > > with livepatch")
> > > +# is missing, meaning that livepatches and kprobes can't be used
> > > together.
> > > +# When the commit is missing, kprobes always set IPMODIFY (the I
> > > flag), even
> > > +# when the post handler is missing.
> > > +if grep --quiet ") R I"
> > > "$SYSFS_DEBUG_DIR/tracing/enabled_functions"; then
> > 
> > Will flags R I always be in this order?
> 
> 		seq_printf(m, " (%ld)%s%s%s%s%s",
> 			   ftrace_rec_count(rec),
> 			   rec->flags & FTRACE_FL_REGS ? " R" : "  ",
> 			   rec->flags & FTRACE_FL_IPMODIFY ? " I" : " 
> ",
> 
> So this is safe. I'll add a comment in the patch to explain why this is
> safe too. Thanks for the comment!

I would personally check also "cmdline_proc_show" to make sure that
the line is about this function. Something like:

     grep --quiet ") "cmdline_proc_show.*([0-9]\+) R"


But I am afraid that this approach is not good. It breaks the test.
It won't longer be able to catch regressions when the kprobe
sets "FTRACE_FL_IPMODIFY" by mistake again.

We could add a version check. But it would break users who backport
the fix into older kernels.

IMHO, the best solution would be to keep the test as is.
Whoever is running the test with older kernels should mark it
as "failure-expected". The test is pointing out an existing problem
in the old kernel. IMHO, it should not hide it.

Best Regards,
Petr

