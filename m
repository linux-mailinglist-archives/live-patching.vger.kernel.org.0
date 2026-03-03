Return-Path: <live-patching+bounces-2099-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IIFAKIlFpmlyNQAAu9opvQ
	(envelope-from <live-patching+bounces-2099-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 03 Mar 2026 03:20:57 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0AD341E7F4B
	for <lists+live-patching@lfdr.de>; Tue, 03 Mar 2026 03:20:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4A32A305DB88
	for <lists+live-patching@lfdr.de>; Tue,  3 Mar 2026 02:20:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D402373C19;
	Tue,  3 Mar 2026 02:20:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XNuWaVjg"
X-Original-To: live-patching@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0415929BD82
	for <live-patching@vger.kernel.org>; Tue,  3 Mar 2026 02:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772504409; cv=none; b=WUuZlt7qaDxSOd/7dDAnutxZM1OZte6M3KBzDK0EAzZkLtFF1DEMKBUpD82Qz4WJZrh9KPHHvUozhRf/q9OMLIWyPo132h/z0Q0JPpAd4z5+AavVxW7UyPIYbFM8RtfchxXf4Gxy6WaHa71cpuNkZUgI4zo0pFNPV9Dyd3HGTUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772504409; c=relaxed/simple;
	bh=jhh7q1BAWYiHFCzMoZJkcgHsMx9Psow38t9CmCmjeOE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jIACKLCxcCd1mPrbVeGC7XHGhMTc2j+iHaHWEwJtfLK/JCc9qCeMA63cZ5bR1OGRv0hLl5s+jtiwZbpwJDhsxkdQbj3DF+n+BeAUujPrlZlG20OAA/s+/yEqWyIJsoqW0B2sV4/KXbyqcjNoTgDaBmpMmfR9mIVThhxAwtzq4Dg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XNuWaVjg; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772504406;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DGyAkuhTV2a+aR7Nnon077g/eLzaKebgbpbntBpKSWg=;
	b=XNuWaVjgV07/vI6Pecxod8KfIB63r+mPpsOWWh/aL0QMBqhVLFsXE0TbFlmu7qHZhg0Z+x
	o3BwvB1KcGukoUMXXpVL0qjv0zVDz0naArMt0o4ONIFPqZ4DAYGppX241l5kTdv/hBVYp7
	8ZWDb7EAq9x0XbmkVhW80KpZx1IJXoQ=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-680-8zqqMzksN62BNwidoqI07g-1; Mon,
 02 Mar 2026 21:20:05 -0500
X-MC-Unique: 8zqqMzksN62BNwidoqI07g-1
X-Mimecast-MFC-AGG-ID: 8zqqMzksN62BNwidoqI07g_1772504404
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4E44919560BF;
	Tue,  3 Mar 2026 02:20:04 +0000 (UTC)
Received: from redhat.com (unknown [10.22.80.5])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 026061800370;
	Tue,  3 Mar 2026 02:20:02 +0000 (UTC)
Date: Mon, 2 Mar 2026 21:20:00 -0500
From: Joe Lawrence <joe.lawrence@redhat.com>
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: live-patching@vger.kernel.org, Song Liu <song@kernel.org>,
	Jiri Kosina <jikos@kernel.org>, Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>
Subject: Re: [PATCH v3 09/13] livepatch/klp-build: fix version mismatch when
 short-circuiting
Message-ID: <aaZFUL_yCS3_wHnd@redhat.com>
References: <20260217160645.3434685-1-joe.lawrence@redhat.com>
 <20260217160645.3434685-10-joe.lawrence@redhat.com>
 <aZSUfFUfpUYIbuiA@redhat.com>
 <zyxlceita2k3szzck5fwhhnpinh3twtzpr23xkdxdpj4opkgog@dnsvvttl4r3x>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <zyxlceita2k3szzck5fwhhnpinh3twtzpr23xkdxdpj4opkgog@dnsvvttl4r3x>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Rspamd-Queue-Id: 0AD341E7F4B
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-2099-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCPT_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[joe.lawrence@redhat.com,live-patching@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[live-patching];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Mon, Feb 23, 2026 at 01:13:29PM -0800, Josh Poimboeuf wrote:
> On Tue, Feb 17, 2026 at 11:17:00AM -0500, Joe Lawrence wrote:
> > Maybe I'm starting to see things, but when running 'S 2' builds, I keep
> > getting "vmlinux.o: changed function: override_release".  It could be
> > considered benign for quick development work, or confusing.  Seems easy
> > enough to stash and avoid.
> > 
> > Repro:
> > 
> > Start with a clean source tree, setup some basic configs for klp-build:
> > 
> >   $ make clean && make mrproper
> >   $ vng --kconfig
> >   $ ./scripts/config --file .config \
> >        --set-val CONFIG_FTRACE y \
> >        --set-val CONFIG_KALLSYMS_ALL y \
> >        --set-val CONFIG_FUNCTION_TRACER y \
> >        --set-val CONFIG_DYNAMIC_FTRACE y \
> >        --set-val CONFIG_DYNAMIC_DEBUG y \
> >        --set-val CONFIG_LIVEPATCH y
> >   $ make olddefconfig
> > 
> > Build the first patch, save klp-tmp/ (note the added DEBUG that dumps
> > the localversion after assignment in set_kernelversion):
> > 
> >   $ ./scripts/livepatch/klp-build -T ~/cmdline-string.patch 
> >   DEBUG: localversion=6.19.0-gc998cd490c02                           <<
> >   Validating patch(es)
> >   Building original kernel
> >   Copying original object files
> >   Fixing patch(es)
> >   Building patched kernel
> >   Copying patched object files
> >   Diffing objects
> >   vmlinux.o: changed function: cmdline_proc_show
> >   BMuilding patch module: livepatch-cmdline-string.ko
> >   SgUCCESS
> >    c
> > Buield a second patch, short-circuit to step 2 (build patched kernel):
> > 
> >   $ ./scripts/livepatch/klp-build -T -S 2 ~/cmdline-string.patch
> >   DEBUG: localversion=6.19.0+                                        <<
> >   Fixing patch(es)
> >   Building patched kernel
> >   Copying patched object files
> >   Diffing objects
> >   vmlinux.o: changed function: override_release                      <<
> >   vmlinux.o: changed function: cmdline_proc_show
> >   Building patch module: livepatch-cmdline-string.ko
> >   SUCCESS
> 
> Hm, I wasn't able to recreate, but it's worrisome that two different
> localversions are being reported.  How do we know which one is correct?
> 
> I'm also not sure why my original code is being so obtuse by
> constructing the kernelrelease manually.  I can't remember if that's on
> purpose or not.
> 
> The below would be simpler, I wonder if this also happens to fix the
> issue?
> 

I finally figured out why you couldn't reproduce, in my tests, I never
built the original kernel, I jumped straight from a clean repo to
starting up klp-build.  If I perform an initial make before running
klp-build, then the sequence works as expected. 

- If skipping the initial vmlinux is an unsupported use-case, then we
  can ignore and drop this patch,
- or perhaps detect and warn/error out 
- If this is something we need to support, then your suggested version
  below didn't work out either...

The following change committed on top of v7.0-rc2:

diff --git a/scripts/livepatch/klp-build b/scripts/livepatch/klp-build
index 809e198a561d..f223395e630e 100755
--- a/scripts/livepatch/klp-build
+++ b/scripts/livepatch/klp-build
@@ -285,15 +285,16 @@ set_module_name() {
 # application from appending it with '+' due to a dirty git working tree.
 set_kernelversion() {
        local file="$SRC/scripts/setlocalversion"
-       local localversion
+       local kernelrelease
 
        stash_file "$file"
 
-       localversion="$(cd "$SRC" && make --no-print-directory kernelversion)"
-       localversion="$(cd "$SRC" && KERNELVERSION="$localversion" ./scripts/setlocalversion)"
-       [[ -z "$localversion" ]] && die "setlocalversion failed"
+       kernelrelease="$(cd "$SRC" && make kernelrelease)"
+       [[ -z "$kernelrelease" ]] && die "setlocalversion failed"
 
-       sed -i "2i echo $localversion; exit 0" scripts/setlocalversion
+       echo "DEBUG: kernelrelease=$kernelrelease"
+
+       sed -i "2i echo $kernelrelease; exit 0" scripts/setlocalversion
 }
 
 get_patch_files() {


$ git clone --branch v7.0-rc2 --depth=1 git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git

[ add the commit above ]

$ git status
On branch master
Your branch is ahead of 'origin/master' by 1 commit.
  (use "git push" to publish your local commits)

nothing to commit, working tree clean

$ vng --kconfig
$ ./scripts/config --file .config \
   --set-val CONFIG_FTRACE y \
   --set-val CONFIG_KALLSYMS_ALL y \
   --set-val CONFIG_FUNCTION_TRACER y \
   --set-val CONFIG_DYNAMIC_FTRACE y \
   --set-val CONFIG_DYNAMIC_DEBUG y \
   --set-val CONFIG_LIVEPATCH y
$ make olddefconfig

$ ./scripts/livepatch/klp-build -T ~/src/linux/cmdline-string.patch 
DEBUG: kernelrelease=7.0.0-rc2-00001-g624702e6338b
Validating patch(es)
Building original kernel
Copying original object files
Fixing patch(es)
Building patched kernel
Copying patched object files
Diffing objects
vmlinux.o: changed function: cmdline_proc_show
Building patch module: livepatch-cmdline-string.ko
SUCCESS

$ strings livepatch-cmdline-string.ko | grep vermagic
vermagic=7.0.0-rc2-00001-g624702e6338b SMP preempt mod_unload

$ ./scripts/livepatch/klp-build -T -S 2 ~/src/linux/cmdline-string.patch 
DEBUG: kernelrelease=7.0.0-rc2+
Fixing patch(es)
Building patched kernel
Copying patched object files
Diffing objects
vmlinux.o: changed function: override_release
vmlinux.o: changed function: cmdline_proc_show
Building patch module: livepatch-cmdline-string.ko
SUCCESS

$ strings livepatch-cmdline-string.ko | grep vermagic
vermagic=7.0.0-rc2+ SMP preempt mod_unload 

--
Joe


