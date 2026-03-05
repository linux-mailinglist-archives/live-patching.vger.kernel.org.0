Return-Path: <live-patching+bounces-2127-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2PeGCJfQqWmYFgEAu9opvQ
	(envelope-from <live-patching+bounces-2127-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 05 Mar 2026 19:51:03 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id A64A3217211
	for <lists+live-patching@lfdr.de>; Thu, 05 Mar 2026 19:51:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 213B03087D2B
	for <lists+live-patching@lfdr.de>; Thu,  5 Mar 2026 18:50:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8F322D9ECD;
	Thu,  5 Mar 2026 18:50:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YJKwmfEu"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 852872D0603
	for <live-patching@vger.kernel.org>; Thu,  5 Mar 2026 18:50:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772736656; cv=none; b=SDRH/MjFTkgl09XAa/Lc7AxmWAPdHn3jiAdFrvI7gkOq1/EfufO07PTV1j8PXYpARhhEpWNYtS5KxuNDMSfUemjAs/L4D4TVTPQEsqxwj9AJayuwheCj3kFcUr1mSZnSjbMOSpIqVzN79WD7utIgokbJI28FIWLRN7WDiqdrVLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772736656; c=relaxed/simple;
	bh=ZpJ3xSD7T1Kv84rXWd6Gw/ltqbl3d1h4ltapX+7b1a0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uCU/DX5RwOdA4Ir2/dSm/rD4b3ema0D3+cAD5OnFEKFTMRytJI2wZFYXq9h6eVmQgahWsfV0HRmds4F9trDJSbC92Q17kZg2s30uk3qalhFVS+0hNP/UZd7YYw80UbpnmbhaVN9DC8p/VMwPm3G8cwCb3MFZpamDkm9bmF8Y5ks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YJKwmfEu; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A3A9C116C6;
	Thu,  5 Mar 2026 18:50:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772736656;
	bh=ZpJ3xSD7T1Kv84rXWd6Gw/ltqbl3d1h4ltapX+7b1a0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YJKwmfEu+4LdotvFLlO0dZO035ymulrAD0MAy6l147my2kcASnfaofqcD07NzUlNP
	 R3VBLCCCPpGHb3nZpYHj/efweUop7eIFtmkJWGw+qFxvQQ9v/s56pVwGszU3kcgYwq
	 of/QVQb0x2r/Z8QwyqDvYE9MNILDwhA/KPiwuGDWXoIeDaoSt5HP0vDhtMTW3RLtb4
	 i+y9dNvaI25dcS14697dUBGUvn0tsPBvaU+C3TR7z8kOHpcB8DTWjx6eOfHzDhjdSa
	 wKBqHCdhBMoyY0Il6VDYjbELbo8TRONbCNvcR/NyCDzK6ruBzh40NQyLSd+DnMTp7a
	 03E5aR5We+FDA==
Date: Thu, 5 Mar 2026 10:50:53 -0800
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Joe Lawrence <joe.lawrence@redhat.com>
Cc: Miroslav Benes <mbenes@suse.cz>, Song Liu <song@kernel.org>, 
	live-patching@vger.kernel.org, jikos@kernel.org, pmladek@suse.com, kernel-team@meta.com
Subject: Re: [PATCH v3 8/8] livepatch: Add tests for klp-build toolchain
Message-ID: <i7i5tbrk5au3udsoigqzwhjwziiiylehaxhauz3pfgongk56hf@dz56fniz7w2a>
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
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aaiI7zv2JVgXZkPm@redhat.com>
X-Rspamd-Queue-Id: A64A3217211
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2127-lists,live-patching=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jpoimboe@kernel.org,live-patching@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Wed, Mar 04, 2026 at 02:33:03PM -0500, Joe Lawrence wrote:
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
> 
> I've been tinkering with ideas in this space, though I took it in a very
> different direction.
> 
> (First a disclaimer, this effort is largely the result of vibe coding
> with Claude to prototype testing concepts, so I don't believe any of it
> is reliable or upstream-worthy at this point.)
> 
> From a top-down perspective, I might start with the generated test
> reports:

Thanks Song and Joe, these are some great ideas.  Testing will be
extremely important for the success of klp-build.

Below are some back of napkin thoughts based on my experiences with
kpatch testing.  In my opinion the unit/integration test split for
kpatch was successful and we should try to continue that tradition with
klp-build.

- unit testing (.o diff)
  - great for preventing past regressions
  - nice and fast
  - tests the most fragile bits
  - catches 99% of bugs (almost everything except for new kernel/compiler features)
  - try to enforce a rule: one test for every regression
  - if we're storing binaries we may need to host the test suite elsewhere
  - extracting .o's could be more of a challenge now that vmlinux.o diff is the norm
    - the making of regression tests needs to be as easy as possible
  - or maybe they can be built on demand with .c and/or .S?
    - that *might* be more difficult
    - we'd need meta-tests to ensure the tests continue to test what they're supposed to

- integration testing: 
  - good for testing "this complex end-to-end operation still works"
  - good for finding issues with new toolchain versions and new kernel features
  - can be used for testing certain runtime-critical features like static branches/calls
  - not necessarily good for testing regressions, the underlying code is free to change at any time
  - I like Song's idea of adding a fake (yet stable) test component in vmlinux for which we can create .patch files to test
  - I also like Joe's idea of scripted patch generation (e.g., automatically patching meminfo_proc_show() somehow)

And in general, we may want to look to porting as many of the kpatch
unit/integration tests as possible so we can take advantage of all those
accumulated testing experiences.

-- 
Josh

