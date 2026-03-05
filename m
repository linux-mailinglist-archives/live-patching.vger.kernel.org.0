Return-Path: <live-patching+bounces-2126-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iNzIItuiqWl5BQEAu9opvQ
	(envelope-from <live-patching+bounces-2126-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 05 Mar 2026 16:35:55 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 951192149FE
	for <lists+live-patching@lfdr.de>; Thu, 05 Mar 2026 16:35:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 26E2330668DA
	for <lists+live-patching@lfdr.de>; Thu,  5 Mar 2026 15:20:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3E4C37BE99;
	Thu,  5 Mar 2026 15:20:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="g+5v0h1T"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 611823BE154
	for <live-patching@vger.kernel.org>; Thu,  5 Mar 2026 15:20:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772724056; cv=none; b=GPXT8gpMnlxNgcmAuJiQN+A+BN/mevCZMHGSxEYyNv7Nce8Q8x/3/525TunC8FRnuVjElX1w2lkfuyTb8UJ9AbZEIAhsEHGXtckJp74ViwN5kjyR+WxiX6TiVYiVe+f75lWupen9RJwMklb1aEyQIJDR3eh9aF5aDCXXmcI5pWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772724056; c=relaxed/simple;
	bh=vgF/42HSRGCHCud38H76BcD3xd1xoVfPLioOUYjzl2k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F/vZRhfNw+nZ22XlEHHaNIFmuJ+ABbHZkQvqZNHI/6O8mCv0Aeu0v2NH1Mbsk8ufxTdnWKapDnfS2i2UmJZY66RWqxWJkPjIo/kYInQTFYmFG2h4UjdP/SNyqcy6+VUmffuc8Gzgosea+POu3B13qEyaUg6MayMv7sNPdLO9rLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=g+5v0h1T; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-483a233819aso80572285e9.3
        for <live-patching@vger.kernel.org>; Thu, 05 Mar 2026 07:20:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1772724054; x=1773328854; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=G2XinCcOcOVs3jXZ/3RhlXte/lcWkGjrlAL+WQQoS9g=;
        b=g+5v0h1T4GTDxw3UMQZwikXtLt6fBf3UU/TaYDMrgV1io6+5BYvNHexoJaOrWtt7sD
         PCCu8wlcTY4R0LIOAphGC1F7zHflhsTeo/NQhtIZ7miGKy7U3NyiWWnn4FQdHvlFoobh
         XZuQ8u2k0ndJ4V3ZVs1LriWAonhue2Kd3/XlV73r7DZnVo2HInto1U7jVqgVuHyOg/9t
         RRYBXXoYF6M/8An47aNkkkjK8ndx66+KmFYiyL4xz+4bksH0hAA5UyR1AcsGvy7hsVY+
         Mo3YjzSDbwhQZr3x1ELGSunrRBl3PPN5PPBBcIfhJOsAcq5hxLqyZ5TAKYTbFjA82ZA3
         d87w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772724054; x=1773328854;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=G2XinCcOcOVs3jXZ/3RhlXte/lcWkGjrlAL+WQQoS9g=;
        b=W6iZ69LDtOuip+WbcJhucVXFJ+FYxuAyQ+EeZ/uPmMx0lMLDnDNhiKqOHhtH1ZC5cS
         H4RcGeOf36hx45RWJYZ0/A2IXGlgI7jjMaqdRk/HjQYeTB142Li/yACTDc8ePhowvQil
         vOwacMw9UiBwH18HTcIgsuvGbLlkW2bp9+asIQNSy0Q5i1iAnXGTXFAETFV8cieTpHaC
         iGv5VZRUW0w/sqKtNFOyDnVmJYLuqqWigJlGCdxUjaEDPbnOqp0DqDMVcFRyvOWKKYmO
         zkQghQPyaXOwgXKCV3g+5BYOwSELH3m+i53Td99FmqsOwxeeKAPWBC8BsmbaonMcL/dg
         K/JA==
X-Forwarded-Encrypted: i=1; AJvYcCVNyf5PvoCQ1vfGB6v+PoVWSC7jDsNyW8CH9RJXmqnfMaad7sDrCXb9DhxQZ1KkhmichHbxqpEPZOa4hiBq@vger.kernel.org
X-Gm-Message-State: AOJu0YwH+5sIXSAMmPzj1Zlr9Ev1onnqEgDsImA/GgrggPENf09AMmfa
	OdXyyoNWrQgOwLUz5w5P7gK8eAgyLEs9GiOL1DzFGw0m4yiV/L+WUoUsnAZUPpmVxls=
X-Gm-Gg: ATEYQzwBhYkM1HmesWrUavbydeKoOexs5kJYPm1ZJtKCF2JTt1yi16dDJDQUc/aDoh4
	QnVj6e0AttBc53UmCeSqoXkboBt3LhXu+bk3y38HAZrK2CTf1WcRdbKT/6e71Ebu++oOr8gYQgF
	T7Suci5LDqMJt5OYDcYnNAjjv+iI5bm4K5woeTiaXAE2/g6TFPcqP2maHZYPtp3Q5Gm2/yPwToR
	MLzURBNYeLxcsU6RGjK7pgmrqV4s1AaqNq2fEezmduOpo6JQbHtHV1kxajXdN+6TJA7szjK7Mnf
	bNJeB43yhY/61W3VAptl/L6AfwH3pBuqv7CLd9VmOhIhufaZ64Nf0+XLGi7NqH1wDg7XYwyeTVU
	JYS7/aADIC15uez0DTgzyamzgS9qbNJW7DVuh2cdZzOzVkcvDI1qjaqEZ0W6k2lhuwlk2cNPhGY
	fWzoUWriSt/PM7YDhsLuQ4sV2gKA==
X-Received: by 2002:a05:600c:1986:b0:477:af8d:203a with SMTP id 5b1f17b1804b1-48519897aa6mr101526865e9.27.1772724053477;
        Thu, 05 Mar 2026 07:20:53 -0800 (PST)
Received: from pathway.suse.cz ([176.114.240.130])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-439ac9f3e5bsm41237947f8f.37.2026.03.05.07.20.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Mar 2026 07:20:53 -0800 (PST)
Date: Thu, 5 Mar 2026 16:20:51 +0100
From: Petr Mladek <pmladek@suse.com>
To: Joe Lawrence <joe.lawrence@redhat.com>
Cc: Miroslav Benes <mbenes@suse.cz>, Song Liu <song@kernel.org>,
	live-patching@vger.kernel.org, jpoimboe@kernel.org,
	jikos@kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v3 8/8] livepatch: Add tests for klp-build toolchain
Message-ID: <aamfUxhAM_EZ0MtR@pathway.suse.cz>
References: <20260226005436.379303-1-song@kernel.org>
 <20260226005436.379303-9-song@kernel.org>
 <alpine.LSU.2.21.2602271052240.374@pobox.suse.cz>
 <CAPhsuW69EZTcMGyXSKv2fEjh7mhtYaSxriZrSgX0nTPCEYKS7A@mail.gmail.com>
 <alpine.LSU.2.21.2603020930540.21479@pobox.suse.cz>
 <aaiI7zv2JVgXZkPm@redhat.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aaiI7zv2JVgXZkPm@redhat.com>
X-Rspamd-Queue-Id: 951192149FE
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[suse.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[suse.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[suse.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2126-lists,live-patching=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[pmladek@suse.com,live-patching@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[live-patching];
	RCPT_COUNT_SEVEN(0.00)[7];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo,functions.sh:url,suse.com:dkim]
X-Rspamd-Action: no action

On Wed 2026-03-04 14:33:03, Joe Lawrence wrote:
> On Mon, Mar 02, 2026 at 09:38:17AM +0100, Miroslav Benes wrote:
> > Him
> > 
> > > > We store test modules in tools/testing/selftests/livepatch/test_modules/
> > > > now. Could you move klp_test_module.c there, please? You might also reuse
> > > > existing ones for the purpose perhaps.
> > > 
> > > IIUC, tools/testing/selftests/livepatch/test_modules/ is more like an out
> > > of tree module. In the case of testing klp-build, we prefer to have it to
> > > work the same as in-tree modules. This is important because klp-build
> > > is a toolchain, and any changes of in-tree Makefiles may cause issues
> > > with klp-build. Current version can catch these issues easily. If we build
> > > the test module as an OOT module, we may miss some of these issues.
> > > In the longer term, we should consider adding klp-build support to build
> > > livepatch for OOT modules. But for now, good test coverage for in-tree
> > > modules are more important.
> > 
> > Ok. I thought it would not matter but it is a fair point.
> > 
> > > > What about vmlinux? I understand that it provides a lot more flexibility
> > > > to have separate functions for testing but would it be somehow sufficient
> > > > to use the existing (real) kernel functions? Like cmdline_proc_show() and
> > > > such which we use everywhere else? Or would it be to limited? I am fine if
> > > > you find it necessary in the end. I just think that reusing as much as
> > > > possible is generally a good approach.
> > > 
> > > I think using existing functions would be too limited, and Joe seems to
> > > agree with this based on his experience. To be able to test corner cases
> > > of the compiler/linker, such as LTO, we need special code patterns.
> > > OTOH, if we want to use an existing kernel function for testing, it needs
> > > to be relatively stable, i.e., not being changed very often. It is not always
> > > easy to find some known to be stable code that follows specific patterns.
> > > If we add dedicated code as test targets, things will be much easier
> > > down the road.
> > 
> > Fair enough.
> > 
> Do the helpers in functions.sh for safely loading and unloading
> livepatches (that wait for the transition, etc.) aid here?
> 
> > > > And a little bit of bikeshedding at the end. I think it would be more
> > > > descriptive if the new config options and tests (test modules) have
> > > > klp-build somewhere in the name to keep it clear. What do you think?
> > > 
> > > Technically, we can also use these tests to test other toolchains, for
> > > example, kpatch-build. I don't know ksplice or kGraft enough to tell
> > > whether they can benefit from these tests or not. OTOH, I am OK
> > > changing the name/description of these config options.
> > 
> > I would prefer it, thank you. Unless someone else objects of course.
> > 
> 
> To continue the bike shedding, in my branch, I had dumped this all under
> a new tools/testing/klp-build subdirectory as my focus was to put
> klp-build through the paces.  It does load the generated livepatches in
> the runtime testing, but as only as a sanity check.  With that, it
> didn't touch CONFIG or intermix testing with the livepatch/ set.

The question is what you expect from the klp-build testing.

My understanding is that the current test primary checks whether:

  + klp-build machinery is able to put together a working livepatch
  + "objtool klp diff" is able to find and match the right symbols

I assume this because the README contains a very simple steps:

    <paste>
    3. Verify the correctness with:

      modprobe klp_test_module
      kpatch load livepatch-patch.ko
      grep -q unpatched /sys/kernel/klp_test/*/* && echo FAIL || echo PASS
    </paste>

A separate directory would be perfectly fine in this case.

We could keep the existing selftests/livepatch as is for
testing the kernel/livepatch features, e.g. transition,
shadow variables, callbacks, cooperation with ftrace/kprobe.

An integration with the existing selftests/livepatch would be
better if you wanted to do more complicated tests. You
might want to reuse the existing framework for checking
the dmesg output.

Honestly, I guess that we would want to integrate both tests
sooner or later anyway. You might want to test how klp-build
handles the extra features, e.g. shadow variables, ...

But the integration might be non-trivial.

> If we do end up supplementing the livepatch/ with klp-build tests, then
> I agree that naming them (either filename prefix or subdirectory) would
> be nice.
> 
> But first, is it goal for klp-build to be the build tool (rather than
> simple module kbuild) for the livepatching .ko selftests?

Best Regards,
Petr

PS: Sigh, I hope that I'll find time to send v2 of the patchset reworking
    the callbacks, shadow variables, and states. It modifies/reworks
    the existing selftests modules a lot, see v1 at
    https://lore.kernel.org/all/20250115082431.5550-1-pmladek@suse.com/

