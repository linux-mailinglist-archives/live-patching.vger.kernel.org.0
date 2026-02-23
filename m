Return-Path: <live-patching+bounces-2069-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oIk4FhHDnGnJKAQAu9opvQ
	(envelope-from <live-patching+bounces-2069-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Mon, 23 Feb 2026 22:13:53 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id EAA8217D69F
	for <lists+live-patching@lfdr.de>; Mon, 23 Feb 2026 22:13:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 62B9B30A570D
	for <lists+live-patching@lfdr.de>; Mon, 23 Feb 2026 21:13:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34115378824;
	Mon, 23 Feb 2026 21:13:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iICJi8Dv"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11B2F37881C
	for <live-patching@vger.kernel.org>; Mon, 23 Feb 2026 21:13:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771881214; cv=none; b=oluHy7ROOc7qURln8LUS6noCZTCER8nO4Jd3nrKgyQ8lnFM/stmR0678KQycrJjNfWc11F0vR1C0yqXGfDGllJhLH4iUW26OSmyypfHgMAsdXn/Pqmp4+TNg7unQ2P8eDtK9LfQ4l15RH/p2iCRpeak6MFxQ1CwvqIp9Mu6pFsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771881214; c=relaxed/simple;
	bh=Ra1Z3OomVvUGQfyTuuYzDCsGS6ciM4LdtYgOvI+av4A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lUNd9vuHAlcexYQiNHoPxtx/czpX+aXsKpPslWN022NFOaRRQPU5AWHPXxuFpdv6ZCVFbS9KmFbaQG7R19GbfOdEAM8bTRcsjMu8wpJjyTA2k8jvCZ1ZogdKjSgpxdyzYiwQIVtPCTjo6obceW5HnVFx0XmrO8sEuMbOkJcM1dM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iICJi8Dv; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ED98C116C6;
	Mon, 23 Feb 2026 21:13:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771881213;
	bh=Ra1Z3OomVvUGQfyTuuYzDCsGS6ciM4LdtYgOvI+av4A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=iICJi8Dv0bFJ6Kgx7tuDco4cCzqCyc18dUir+X4IP+PAI9wz6PASc8+KyIbwq12KD
	 miV9uJDzvm/m4aK/e0iObsvTTnBkbjzD1EFv/EXHheLP39KkG4fmxOsqpK4L8DiWPT
	 FaN/wNzykU8M3yh2nCU9l+/rdSD3dFPUCLJ5r27il9v/tWm8d56CpH8wdwdMAeQEEB
	 ZgBi0MCltvf5/1QtlAfqE78vfd+Jv4Fgemnbp5BXCyxgx6H7O/RWn/uDzfcPHB4fso
	 bLHmKbKhwjWaFV9T6J+8/h4vA990Bf2FnYBqkx4x8rgQ1SnrAwZrLTcDi7i2xE7Ymh
	 zh+Z10qtlGtlw==
Date: Mon, 23 Feb 2026 13:13:29 -0800
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Joe Lawrence <joe.lawrence@redhat.com>
Cc: live-patching@vger.kernel.org, Song Liu <song@kernel.org>, 
	Jiri Kosina <jikos@kernel.org>, Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
Subject: Re: [PATCH v3 09/13] livepatch/klp-build: fix version mismatch when
 short-circuiting
Message-ID: <zyxlceita2k3szzck5fwhhnpinh3twtzpr23xkdxdpj4opkgog@dnsvvttl4r3x>
References: <20260217160645.3434685-1-joe.lawrence@redhat.com>
 <20260217160645.3434685-10-joe.lawrence@redhat.com>
 <aZSUfFUfpUYIbuiA@redhat.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aZSUfFUfpUYIbuiA@redhat.com>
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
	TAGGED_FROM(0.00)[bounces-2069-lists,live-patching=lfdr.de];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jpoimboe@kernel.org,live-patching@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	TAGGED_RCPT(0.00)[live-patching];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: EAA8217D69F
X-Rspamd-Action: no action

On Tue, Feb 17, 2026 at 11:17:00AM -0500, Joe Lawrence wrote:
> Maybe I'm starting to see things, but when running 'S 2' builds, I keep
> getting "vmlinux.o: changed function: override_release".  It could be
> considered benign for quick development work, or confusing.  Seems easy
> enough to stash and avoid.
> 
> Repro:
> 
> Start with a clean source tree, setup some basic configs for klp-build:
> 
>   $ make clean && make mrproper
>   $ vng --kconfig
>   $ ./scripts/config --file .config \
>        --set-val CONFIG_FTRACE y \
>        --set-val CONFIG_KALLSYMS_ALL y \
>        --set-val CONFIG_FUNCTION_TRACER y \
>        --set-val CONFIG_DYNAMIC_FTRACE y \
>        --set-val CONFIG_DYNAMIC_DEBUG y \
>        --set-val CONFIG_LIVEPATCH y
>   $ make olddefconfig
> 
> Build the first patch, save klp-tmp/ (note the added DEBUG that dumps
> the localversion after assignment in set_kernelversion):
> 
>   $ ./scripts/livepatch/klp-build -T ~/cmdline-string.patch 
>   DEBUG: localversion=6.19.0-gc998cd490c02                           <<
>   Validating patch(es)
>   Building original kernel
>   Copying original object files
>   Fixing patch(es)
>   Building patched kernel
>   Copying patched object files
>   Diffing objects
>   vmlinux.o: changed function: cmdline_proc_show
>   BMuilding patch module: livepatch-cmdline-string.ko
>   SgUCCESS
>    c
> Buield a second patch, short-circuit to step 2 (build patched kernel):
> 
>   $ ./scripts/livepatch/klp-build -T -S 2 ~/cmdline-string.patch
>   DEBUG: localversion=6.19.0+                                        <<
>   Fixing patch(es)
>   Building patched kernel
>   Copying patched object files
>   Diffing objects
>   vmlinux.o: changed function: override_release                      <<
>   vmlinux.o: changed function: cmdline_proc_show
>   Building patch module: livepatch-cmdline-string.ko
>   SUCCESS

Hm, I wasn't able to recreate, but it's worrisome that two different
localversions are being reported.  How do we know which one is correct?

I'm also not sure why my original code is being so obtuse by
constructing the kernelrelease manually.  I can't remember if that's on
purpose or not.

The below would be simpler, I wonder if this also happens to fix the
issue?

diff --git a/scripts/livepatch/klp-build b/scripts/livepatch/klp-build
index 809e198a561d..792168c9e474 100755
--- a/scripts/livepatch/klp-build
+++ b/scripts/livepatch/klp-build
@@ -285,15 +285,14 @@ set_module_name() {
 # application from appending it with '+' due to a dirty git working tree.
 set_kernelversion() {
 	local file="$SRC/scripts/setlocalversion"
-	local localversion
+	local kernelrelease
 
 	stash_file "$file"
 
-	localversion="$(cd "$SRC" && make --no-print-directory kernelversion)"
-	localversion="$(cd "$SRC" && KERNELVERSION="$localversion" ./scripts/setlocalversion)"
-	[[ -z "$localversion" ]] && die "setlocalversion failed"
+	kernelrelease="$(cd "$SRC" && make kernelrelease)"
+	[[ -z "$kernelrelease" ]] && die "setlocalversion failed"
 
-	sed -i "2i echo $localversion; exit 0" scripts/setlocalversion
+	sed -i "2i echo $kernelrelease; exit 0" scripts/setlocalversion
 }
 
 get_patch_files() {

