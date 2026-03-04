Return-Path: <live-patching+bounces-2104-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4PhtBB2JqGn2vQAAu9opvQ
	(envelope-from <live-patching+bounces-2104-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Wed, 04 Mar 2026 20:33:49 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 24BC620721A
	for <lists+live-patching@lfdr.de>; Wed, 04 Mar 2026 20:33:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 5A159301C6A6
	for <lists+live-patching@lfdr.de>; Wed,  4 Mar 2026 19:33:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56FF4378D9C;
	Wed,  4 Mar 2026 19:33:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="F32gMeE0"
X-Original-To: live-patching@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC3513D34AA
	for <live-patching@vger.kernel.org>; Wed,  4 Mar 2026 19:33:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772652795; cv=none; b=XuM9OEJAZEw5fg04+5+wY//3fx79Q9viZD62sc03IoMWH3pr2kqu++iCOscmBBGJlTdomgW3T/w9qxtKRFPfFNA1z0SQYS/4b0tJwyFdJOm4OB3nQbcY9k3TxHsensfpy0E5upU9DN0VBsW9RV1ifWE2FVqbpqV8wNb+K4ojHIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772652795; c=relaxed/simple;
	bh=nXAB2F4pJOB4Zs0kZBe7znQk35FPML5mqjjRVugs05Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uz1e9AFm2Gs6HcZfwVWYDc13LvXKgOmnIVmrWUcMnpUMZhVS2GoW5oxNgHXG/5UbveRKcyWhl1rgdlzH/bVBnaYjDCTCOvoIwqF2wb94W2V16NfhdbhqVtbCxqWqaL5PXsntu8kSOyYazQbFxauJXf4pHD3iTtU1bAGFikChVvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=F32gMeE0; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772652792;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LmznLQtlxiigKrwGSkd9992ayKsv9WTHzL1gQBYduNU=;
	b=F32gMeE0QEOyZ79HbiSZNcm3Hcp+cIGthRDSY7yL8Tk1J2dqBIKLjFpPG2igzyHitxEA/M
	vJbeVzubpcvJGjLuJJyuHWhQowSiHjE0Z4/UvZVo30CSEyO2RuLjCP+f7xY/gTGsmbGtmv
	TwYEkHat0KfirFoo223M98HoGRUmL50=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-583-l4MAJEJKN7SOF6zs93GQ7A-1; Wed,
 04 Mar 2026 14:33:09 -0500
X-MC-Unique: l4MAJEJKN7SOF6zs93GQ7A-1
X-Mimecast-MFC-AGG-ID: l4MAJEJKN7SOF6zs93GQ7A_1772652788
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CF2BF1800283;
	Wed,  4 Mar 2026 19:33:07 +0000 (UTC)
Received: from redhat.com (unknown [10.22.80.5])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 615511800361;
	Wed,  4 Mar 2026 19:33:06 +0000 (UTC)
Date: Wed, 4 Mar 2026 14:33:03 -0500
From: Joe Lawrence <joe.lawrence@redhat.com>
To: Miroslav Benes <mbenes@suse.cz>
Cc: Song Liu <song@kernel.org>, live-patching@vger.kernel.org,
	jpoimboe@kernel.org, jikos@kernel.org, pmladek@suse.com,
	kernel-team@meta.com
Subject: Re: [PATCH v3 8/8] livepatch: Add tests for klp-build toolchain
Message-ID: <aaiI7zv2JVgXZkPm@redhat.com>
References: <20260226005436.379303-1-song@kernel.org>
 <20260226005436.379303-9-song@kernel.org>
 <alpine.LSU.2.21.2602271052240.374@pobox.suse.cz>
 <CAPhsuW69EZTcMGyXSKv2fEjh7mhtYaSxriZrSgX0nTPCEYKS7A@mail.gmail.com>
 <alpine.LSU.2.21.2603020930540.21479@pobox.suse.cz>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.21.2603020930540.21479@pobox.suse.cz>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Rspamd-Queue-Id: 24BC620721A
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2104-lists,live-patching=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[joe.lawrence@redhat.com,live-patching@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[7];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo,klp_object.name:url,functions.sh:url]
X-Rspamd-Action: no action

On Mon, Mar 02, 2026 at 09:38:17AM +0100, Miroslav Benes wrote:
> Him
> 
> > > We store test modules in tools/testing/selftests/livepatch/test_modules/
> > > now. Could you move klp_test_module.c there, please? You might also reuse
> > > existing ones for the purpose perhaps.
> > 
> > IIUC, tools/testing/selftests/livepatch/test_modules/ is more like an out
> > of tree module. In the case of testing klp-build, we prefer to have it to
> > work the same as in-tree modules. This is important because klp-build
> > is a toolchain, and any changes of in-tree Makefiles may cause issues
> > with klp-build. Current version can catch these issues easily. If we build
> > the test module as an OOT module, we may miss some of these issues.
> > In the longer term, we should consider adding klp-build support to build
> > livepatch for OOT modules. But for now, good test coverage for in-tree
> > modules are more important.
> 
> Ok. I thought it would not matter but it is a fair point.
> 
> > > What about vmlinux? I understand that it provides a lot more flexibility
> > > to have separate functions for testing but would it be somehow sufficient
> > > to use the existing (real) kernel functions? Like cmdline_proc_show() and
> > > such which we use everywhere else? Or would it be to limited? I am fine if
> > > you find it necessary in the end. I just think that reusing as much as
> > > possible is generally a good approach.
> > 
> > I think using existing functions would be too limited, and Joe seems to
> > agree with this based on his experience. To be able to test corner cases
> > of the compiler/linker, such as LTO, we need special code patterns.
> > OTOH, if we want to use an existing kernel function for testing, it needs
> > to be relatively stable, i.e., not being changed very often. It is not always
> > easy to find some known to be stable code that follows specific patterns.
> > If we add dedicated code as test targets, things will be much easier
> > down the road.
> 
> Fair enough.
> 

I've been tinkering with ideas in this space, though I took it in a very
different direction.

(First a disclaimer, this effort is largely the result of vibe coding
with Claude to prototype testing concepts, so I don't believe any of it
is reliable or upstream-worthy at this point.)

From a top-down perspective, I might start with the generated test
reports:

- https://file.rdu.redhat.com/~jolawren/artifacts/report.html
- https://file.rdu.redhat.com/~jolawren/artifacts/report.txt

and then in my own words:

1- I'm interested in testing several kernel configurations (distros,
debug, thinLTO) as well as toolchains (gcc, llvm) against the same
source tree and machine.  I call these config/toolchain pairs a testing
"profile".  In the report examples, these are combos like "fedora-43 +
virtme-ng" and "virtme-ng + thin-lto".

2- For test cases, a few possible results:

  PASS    - should build / load / run
            e.g. cmdline-string.patch
  FAIL*   - unexpected failure to build / load / run
            e.g. some new bug in klp-build
  XFAIL   - expected to build / load / run failure
            e.g. "no changed detected" patch
  XPASS*  - unexpected build / load / run success
            e.g. "no changed detected" patch actually created a .ko

* These would be considered interesting to look at.  Did we find a new
  bug, or maybe an existing bug is now fixed?

3- Test cases and makefile target workflows are split into build and
runtime parts.

4- Based on kpatch-build experience, test cases are further divided into
"quick" and "long" sets with the understanding that klp-build testing
takes a non-trivial amount of time.

5- Two patch targets:

a) current-tree - target the user's current source tree
b) patched-tree - (temporarily) patch the user's tree to *exactly* what
                  we need to target

Why?  In the kpatch-build project, patching the current-tree meant we
had to rebase patches for every release.  We also had to hunt and find
precise scenarios across the kernel tree to test, hoping they wouldn't
go away in future versions.  In other cases, the kernel or compiler
changed and we weren't testing the original problem any longer.

That said, patching a dummy patched-tree isn't be perfect either,
particularly in the runtime sense.  You're not testing a release kernel,
but something slightly different.

(Tangent: kpatch-build implemented a unit test scheme that cached object
files for even greater speed and fixed testing.  I haven't thought about
how a similar idea might work for klp-build.)

6- Two patch models:

a) static .patch files
b) scripted .patch generation

Why?  Sometimes a test like cmdline-string.patch is sufficient and
stable.  Other times it's not.  For example, the recount-many-file test
in this branch is implemented via a script.  This allows the test to be
dynamic and potentially avoid the rebasing problem mentioned above.

7- Build verification including ELF analysis.  Not very mature in this
branch, but it would be nice to be able to build on it:

  ======================================================================
  BUILD VERIFICATION
  ======================================================================
 
  klp-build exit code is 0
  Module exists: livepatch-cmdline-string.ko
  verify_diff_log_contains('changed function: cmdline_proc_show'): OK 
 
  ELF Analysis:
  klp_object[0]:
    .name = NULL (vmlinux)
  VERIFIED: klp_object.name = NULL (vmlinux)
      klp_func[0]:
        .old_name = "cmdline_proc_show"  [-> .rodata+0x15d]
        .new_func -> cmdline_proc_show
        .old_sympos = 0
      VERIFIED: klp_func.old_name = 'cmdline_proc_show'
      VERIFIED: klp_func.new_func -> cmdline_proc_show

Perhaps even extending this to the intermediate klp-tmp/ files?  This
would aid in greater sanity checking of what's produced, but also in
verifying that our test is still testing what it originally set out to.
(i.e. Is the thinLTO suffix test still generating two common symbols
with a different hash suffix?)

8- Probably more I've already forgotten about :) Cross-compilation may
be interesting for build testing in the future.  For the full AI created
commentary, there's https://github.com/joe-lawrence/linux/blob/klp-build-selftests/README.md 

> > I was using kpatch for testing. I can replace it with insmod.
> 

Do the helpers in functions.sh for safely loading and unloading
livepatches (that wait for the transition, etc.) aid here?

> > > And a little bit of bikeshedding at the end. I think it would be more
> > > descriptive if the new config options and tests (test modules) have
> > > klp-build somewhere in the name to keep it clear. What do you think?
> > 
> > Technically, we can also use these tests to test other toolchains, for
> > example, kpatch-build. I don't know ksplice or kGraft enough to tell
> > whether they can benefit from these tests or not. OTOH, I am OK
> > changing the name/description of these config options.
> 
> I would prefer it, thank you. Unless someone else objects of course.
> 

To continue the bike shedding, in my branch, I had dumped this all under
a new tools/testing/klp-build subdirectory as my focus was to put
klp-build through the paces.  It does load the generated livepatches in
the runtime testing, but as only as a sanity check.  With that, it
didn't touch CONFIG or intermix testing with the livepatch/ set.

If we do end up supplementing the livepatch/ with klp-build tests, then
I agree that naming them (either filename prefix or subdirectory) would
be nice.

But first, is it goal for klp-build to be the build tool (rather than
simple module kbuild) for the livepatching .ko selftests?

--
Joe


