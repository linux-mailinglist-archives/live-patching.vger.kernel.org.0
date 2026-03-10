Return-Path: <live-patching+bounces-2166-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6KlUHjRHsGnFhgIAu9opvQ
	(envelope-from <live-patching+bounces-2166-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 10 Mar 2026 17:30:44 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id C45E0254CFB
	for <lists+live-patching@lfdr.de>; Tue, 10 Mar 2026 17:30:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 307E13087D05
	for <lists+live-patching@lfdr.de>; Tue, 10 Mar 2026 16:30:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1ED23C661D;
	Tue, 10 Mar 2026 16:30:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fXEHKOjn"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 769963C661C
	for <live-patching@vger.kernel.org>; Tue, 10 Mar 2026 16:30:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773160214; cv=none; b=Rjhr13Af6AlTFvMTh1ZPZnksaPXGCPAs3/T0pxGaG2MinMs2mE3NZvx6qN9hWIksxfrVDo8ODl3Zt1vJZh3boQO8YxJiC2r86PVFVgd5LwL2eHfsvGl/iXFXW7IwvibCKXtssvy+SYxbof2wL7Od1U7BjTMzF49+6FgNuHZ6diU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773160214; c=relaxed/simple;
	bh=5XnO/g+StMbdOtdCAcOUsbMZq3I3/Q+hndGMcymELng=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IoonX5DtfA8ln0VZRtqe9xYOoDSF5y2Cubca+e2UD6uV9Wk8oaAvnZNSUl3jnG9NYa1HTa7sYNIVsI0HNWHpp/i0LBkxSZkBDMjTA9ipgPDfmHjeCtqsaEEdT+ifSqZApp5DAQantodYMJxoH94TsuiodQK8qgvix2oCiwZNFK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fXEHKOjn; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CF89C2BC86;
	Tue, 10 Mar 2026 16:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773160214;
	bh=5XnO/g+StMbdOtdCAcOUsbMZq3I3/Q+hndGMcymELng=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fXEHKOjn9FP/OT+HZdx8blhldqXzHYG+v5asub/dBQuVToGc5HA12sI/h+2lHV86i
	 bZj2tnzIr9Xn0CFhunQdsuSd/PeGuZgbK8dcpRqZH/+vKtTym0GVLucYpmA2k00uoe
	 naEUj/7LEfiDWyxY0Qwdr+u/Vlgtvf+NBS0hAT7TfbPMjngrR4EgJ+Xgr60BhsYIyV
	 rsueZ5y95JgBQnEPeKZX94N/Is3FUOSXjuPRKDfK7lO3ubMWp1pthq9UzGILkVvtsC
	 qpkpsWDo1+2U5nJriV+wpcoKFiDOJLWz1PeE33Z2m6dTKU4t/y+qo8nObcKaUPXD30
	 sGKROLM8wl1NA==
Date: Tue, 10 Mar 2026 09:30:10 -0700
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Joe Lawrence <joe.lawrence@redhat.com>
Cc: live-patching@vger.kernel.org, Song Liu <song@kernel.org>, 
	Jiri Kosina <jikos@kernel.org>, Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
Subject: Re: [PATCH] klp-build: Fix inconsistent kernel version
Message-ID: <umzh2l3j4yaaaeibfwbdsn6swts44axwjo6locvrsod75vgid3@w2vdenem7erp>
References: <20260217160645.3434685-1-joe.lawrence@redhat.com>
 <20260217160645.3434685-10-joe.lawrence@redhat.com>
 <aZSUfFUfpUYIbuiA@redhat.com>
 <zyxlceita2k3szzck5fwhhnpinh3twtzpr23xkdxdpj4opkgog@dnsvvttl4r3x>
 <aaZFUL_yCS3_wHnd@redhat.com>
 <w6uwlcdd7eb247lj4r5khrliiymbpapshmaror3x3olfaamj6a@4ukxobzqj7fo>
 <noyyhysipjm6aw4td6q4mg6n4c637unfgmkn35otopu3rbqugj@ekzuix6lsb6p>
 <abAghiWvh3BeJNp9@redhat.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <abAghiWvh3BeJNp9@redhat.com>
X-Rspamd-Queue-Id: C45E0254CFB
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
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2166-lists,live-patching=lfdr.de];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jpoimboe@kernel.org,live-patching@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	TAGGED_RCPT(0.00)[live-patching];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Tue, Mar 10, 2026 at 09:45:42AM -0400, Joe Lawrence wrote:
> On Thu, Mar 05, 2026 at 02:52:46PM -0800, Josh Poimboeuf wrote:
> > If .config hasn't been synced with auto.conf, any recent changes to
> > CONFIG_LOCALVERSION* may not get reflected in the kernel version name.
> > 
> > Use "make syncconfig" to force them to sync, and "make kernelrelease" to
> > get the version instead of having to construct it manually.
> > 
> > Fixes: 24ebfcd65a87 ("livepatch/klp-build: Introduce klp-build script for generating livepatch modules")
> > Closes: https://lore.kernel.org/20260217160645.3434685-10-joe.lawrence@redhat.com
> > Reported-by: Joe Lawrence <joe.lawrence@redhat.com>
> > Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
> > ---
> >  scripts/livepatch/klp-build | 9 ++++-----
> >  1 file changed, 4 insertions(+), 5 deletions(-)
> > 
> > diff --git a/scripts/livepatch/klp-build b/scripts/livepatch/klp-build
> > index 809e198a561d..72f05c40b9f8 100755
> > --- a/scripts/livepatch/klp-build
> > +++ b/scripts/livepatch/klp-build
> > @@ -285,15 +285,14 @@ set_module_name() {
> >  # application from appending it with '+' due to a dirty git working tree.
> >  set_kernelversion() {
> >  	local file="$SRC/scripts/setlocalversion"
> > -	local localversion
> > +	local kernelrelease
> >  
> >  	stash_file "$file"
> >  
> > -	localversion="$(cd "$SRC" && make --no-print-directory kernelversion)"
> > -	localversion="$(cd "$SRC" && KERNELVERSION="$localversion" ./scripts/setlocalversion)"
> > -	[[ -z "$localversion" ]] && die "setlocalversion failed"
> > +	kernelrelease="$(cd "$SRC" && make syncconfig &>/dev/null && make kernelrelease)"
> 
> Almost, I needed to add '-s' to the kernelversion target to silence the
> make "entering / leaving directory" msgs and then this worked for me.
> 
> There's some makefile voodoo going on here where when I manually run
> `make kernelrelease` I don't see the verbose msgs, but I printed
> "$kernelrelease" here in klp-build and on my machine (make v4.4.1), that
> extra output derailed the script.
> 
> Anyway, `make help` says:
> 
>   kernelrelease   - Output the release version string (use with make -s)
> 
> so we should probably use '-s' regardless.
> 
> With that, shall I drop my ("livepatch/klp-build: fix version mismatch
> when short-circuiting") and carry yours in its place?

Yes, I think so.  Thanks!

-- 
Josh

