Return-Path: <live-patching+bounces-2106-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +OZREETfqGmjyAAAu9opvQ
	(envelope-from <live-patching+bounces-2106-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 05 Mar 2026 02:41:24 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 91D15209F48
	for <lists+live-patching@lfdr.de>; Thu, 05 Mar 2026 02:41:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id CB882301C3CD
	for <lists+live-patching@lfdr.de>; Thu,  5 Mar 2026 01:39:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E13A225788;
	Thu,  5 Mar 2026 01:39:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AugBe6iB"
X-Original-To: live-patching@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDBD013AA2D
	for <live-patching@vger.kernel.org>; Thu,  5 Mar 2026 01:39:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772674767; cv=none; b=MovcKrHByYZH+RoQoFjgy0iQhutifyhogK5dYnj/C0bYJQeZ7h01Bt1INOsUgNSZNyGdhXYDHBisPOVNOYlnback4ruMF/j+giXSsEiermeAsIZTPt+yilzAL+e5AHFwhURmIqMqrfEpcgh0H7kheCK5OnAcHcQRai96LD4NsvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772674767; c=relaxed/simple;
	bh=Zqq910QU2hy2XXAqCXjZY4Ffdxpli1QO/Sl3+LL4V+U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fmHz4k8copElRlehpdbvyHdUrARkeQcqnBxPBz6KEZ+0y+E4TeHsvRXq8zfkLKyN6bUbSirEqCE+Wyk8HSRj92lVWwO2sUi5QaFtxtWb0ldMfphlGtjOu9lGrnAHjHPPCL0tt9P12JkDmYtcw9hY5MMS92FVOMLUxrmzeBEN5EI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AugBe6iB; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772674764;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UAJR9K/A35m6+EiyZW1j3TQ/5tY7yre7tTN4GFdLUaw=;
	b=AugBe6iBSl/vbZKt07UZtNRQo1UMxQbpHB2GxxQviHI2ic1Px8sM79iQLSSfM3BreZOGR2
	HLSuQPDsqhG2HO+AdgfG1inOUhX9em3c5c1a+PPEck3SqGQa8O7jL/nFWiA4/gCy7snwJp
	C0tujQ/oRw6e7c1RnDHnA6eobSrU+/c=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-256-BniLXzLOPZGcH2gWidTRKw-1; Wed,
 04 Mar 2026 20:39:22 -0500
X-MC-Unique: BniLXzLOPZGcH2gWidTRKw-1
X-Mimecast-MFC-AGG-ID: BniLXzLOPZGcH2gWidTRKw_1772674761
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D67A3195608F;
	Thu,  5 Mar 2026 01:39:20 +0000 (UTC)
Received: from redhat.com (unknown [10.22.80.5])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2E80A30001A1;
	Thu,  5 Mar 2026 01:39:19 +0000 (UTC)
Date: Wed, 4 Mar 2026 20:39:16 -0500
From: Joe Lawrence <joe.lawrence@redhat.com>
To: Song Liu <song@kernel.org>
Cc: Miroslav Benes <mbenes@suse.cz>, live-patching@vger.kernel.org,
	jpoimboe@kernel.org, jikos@kernel.org, pmladek@suse.com,
	kernel-team@meta.com
Subject: Re: [PATCH v3 8/8] livepatch: Add tests for klp-build toolchain
Message-ID: <aajexDFNdFz_Lsrp@redhat.com>
References: <20260226005436.379303-1-song@kernel.org>
 <20260226005436.379303-9-song@kernel.org>
 <alpine.LSU.2.21.2602271052240.374@pobox.suse.cz>
 <CAPhsuW69EZTcMGyXSKv2fEjh7mhtYaSxriZrSgX0nTPCEYKS7A@mail.gmail.com>
 <alpine.LSU.2.21.2603020930540.21479@pobox.suse.cz>
 <aaiI7zv2JVgXZkPm@redhat.com>
 <CAPhsuW6Nx6meWVCkTJXmp5BzTX_2s2dt1j+C-=AtMzQ8ZV396A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPhsuW6Nx6meWVCkTJXmp5BzTX_2s2dt1j+C-=AtMzQ8ZV396A@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Rspamd-Queue-Id: 91D15209F48
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2106-lists,live-patching=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[joe.lawrence@redhat.com,live-patching@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[7];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Wed, Mar 04, 2026 at 03:12:48PM -0800, Song Liu wrote:
> On Wed, Mar 4, 2026 at 11:33 AM Joe Lawrence <joe.lawrence@redhat.com> wrote:
> [...]
> 
> > I've been tinkering with ideas in this space, though I took it in a very
> > different direction.
> >
> > (First a disclaimer, this effort is largely the result of vibe coding
> > with Claude to prototype testing concepts, so I don't believe any of it
> > is reliable or upstream-worthy at this point.)
> >
> > From a top-down perspective, I might start with the generated test
> > reports:
> >
> > - https://file.rdu.redhat.com/~jolawren/artifacts/report.html
> > - https://file.rdu.redhat.com/~jolawren/artifacts/report.txt
> 
> I cannot access these two links.
> 

Gah, sorry about those internal links.

Try:

https://joe-lawrence.github.io/klp-build-selftest-artifacts/report.html
https://joe-lawrence.github.io/klp-build-selftest-artifacts/report.txt

> > and then in my own words:
> >
> [...]
> >
> > 5- Two patch targets:
> >
> > a) current-tree - target the user's current source tree
> > b) patched-tree - (temporarily) patch the user's tree to *exactly* what
> >                   we need to target
> >
> > Why?  In the kpatch-build project, patching the current-tree meant we
> > had to rebase patches for every release.  We also had to hunt and find
> > precise scenarios across the kernel tree to test, hoping they wouldn't
> > go away in future versions.  In other cases, the kernel or compiler
> > changed and we weren't testing the original problem any longer.
> 
> I would prefer making patched-tree as upstream + some different
> CONFIG_s. Otherwise, we will need to carry .patch files for the
> patched-tree in selftests, which seems weird.
> 

It is strange, but for my experiment, I wanted minimal disruption to the
tree.  For the "real" changeset, upstream + some testing CONFIG_ sounds
good to me.

> > That said, patching a dummy patched-tree isn't be perfect either,
> > particularly in the runtime sense.  You're not testing a release kernel,
> > but something slightly different.
> 
> This should not be a problem. The goal is to test the klp-build toolchain.
> 

Right, perhaps klp-build testing always targets a slightly modified
kernel (or at least CONFIG_) while livepatching testing operates against
the stock tree?

> > (Tangent: kpatch-build implemented a unit test scheme that cached object
> > files for even greater speed and fixed testing.  I haven't thought about
> > how a similar idea might work for klp-build.)
> 
> I think it is a good idea to have similar .o file tests for klp-diff
> in klp-build.
> 

kpatch-build uses a git submodule (a joy to work with /s), but maybe
upstream tree can fetch the binary objects from some external
(github/etc.) source?  I wonder if there is any kselftest precident for
this, we'll need to investigate that.

> >
> > 6- Two patch models:
> >
> > a) static .patch files
> > b) scripted .patch generation
> >
> > Why?  Sometimes a test like cmdline-string.patch is sufficient and
> > stable.  Other times it's not.  For example, the recount-many-file test
> > in this branch is implemented via a script.  This allows the test to be
> > dynamic and potentially avoid the rebasing problem mentioned above.
> 
> I think we can have both a) and b).
> 
> > 7- Build verification including ELF analysis.  Not very mature in this
> > branch, but it would be nice to be able to build on it:
> 
> If we test the behavior after loading the patches, ELF analysis might
> be optional. But we can also do both.
> 

Maybe, though doing so during the build test would give us that analysis
for future cross-compiled test cases without having to actually boot and
load them somewhere.

> [...]
> 
> >
> > 8- Probably more I've already forgotten about :) Cross-compilation may
> > be interesting for build testing in the future.  For the full AI created
> > commentary, there's https://github.com/joe-lawrence/linux/blob/klp-build-selftests/README.md
> 
> Yes, cross-compilation can be really useful.
> 

Agreed (I think Josh may be working on arm64 klp-build?) how many
dimensions of testing are we up to now :)

> > > > I was using kpatch for testing. I can replace it with insmod.
> > >
> >
> > Do the helpers in functions.sh for safely loading and unloading
> > livepatches (that wait for the transition, etc.) aid here?
> 
> Yes, we can reuse those.
> [...]
> 
> > To continue the bike shedding, in my branch, I had dumped this all under
> > a new tools/testing/klp-build subdirectory as my focus was to put
> > klp-build through the paces.  It does load the generated livepatches in
> > the runtime testing, but as only as a sanity check.  With that, it
> > didn't touch CONFIG or intermix testing with the livepatch/ set.
> >
> > If we do end up supplementing the livepatch/ with klp-build tests, then
> > I agree that naming them (either filename prefix or subdirectory) would
> > be nice.
> >
> > But first, is it goal for klp-build to be the build tool (rather than
> > simple module kbuild) for the livepatching .ko selftests?
> 
> I think we don't have to use klp-build for livepatch selftests. Existing
> tests work well as-is.
> 

--
Joe


