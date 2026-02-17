Return-Path: <live-patching+bounces-2030-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aPXdLZmUlGl3FgIAu9opvQ
	(envelope-from <live-patching+bounces-2030-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 17 Feb 2026 17:17:29 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id A0BE614E002
	for <lists+live-patching@lfdr.de>; Tue, 17 Feb 2026 17:17:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id AA32F3013254
	for <lists+live-patching@lfdr.de>; Tue, 17 Feb 2026 16:17:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1AB136EA98;
	Tue, 17 Feb 2026 16:17:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MUPNoven"
X-Original-To: live-patching@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C6EC36E47E
	for <live-patching@vger.kernel.org>; Tue, 17 Feb 2026 16:17:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771345036; cv=none; b=d1al+cWLQT4lE9qGuBy5Cd93aXQan9wlMZgaG9LlKKT+17ItNLwUjpzU5KVRPnV1bfmrs2DHzHcotks4LgyGaRqwj3qNagtXyPC21Yzn/dcC1Jz3RZ6vuxjKKGAyPvD5fddwOkRvu8WevbVRsKNsW51KGvFH1gEjwDGBAJPQ5qo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771345036; c=relaxed/simple;
	bh=F1CMkJGDSu1tS0L2GMAprkTU3W9vwBf52i1ppY8OVNA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IetWNsSj90Az3L6R6f9gYPMQcgd4CvPNtzJcZcZik96DzqQ0JYnARlu3lioWrTfg+m1sTR/E83qT8Y7BeBOU7A78rPm+d4uszsvtRxz6lFdrVDWSAO75Gt/zA2aMDZ2DT1oSNTAL2DTZ9th3YXQIknvprSWekvhLv5EOtjhiLlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MUPNoven; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771345034;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3iHirftN7fkE9iDzpgbOYRuE9aDol/EAccyAvDcjW9s=;
	b=MUPNovenwyvdKfFHW5jY7qBsj5hEymufYQpJdC6jyqU3R5HEiWGIBa4pvY7/apsW5N7nne
	v6ENzlauex17qExb28bHubdofS0asHMrBclORqnvWOFGe2ORK3YeZGwLULvfDjVNtaMWJj
	9Sj2PAlQ8MbCzI8FIzfduQEpsmHJz1I=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-646-CXkE05ZbPsOTR1qoDzaQbQ-1; Tue,
 17 Feb 2026 11:17:06 -0500
X-MC-Unique: CXkE05ZbPsOTR1qoDzaQbQ-1
X-Mimecast-MFC-AGG-ID: CXkE05ZbPsOTR1qoDzaQbQ_1771345025
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 931351800578;
	Tue, 17 Feb 2026 16:17:05 +0000 (UTC)
Received: from redhat.com (unknown [10.22.80.197])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AB3FE18008FF;
	Tue, 17 Feb 2026 16:17:03 +0000 (UTC)
Date: Tue, 17 Feb 2026 11:17:00 -0500
From: Joe Lawrence <joe.lawrence@redhat.com>
To: live-patching@vger.kernel.org
Cc: Josh Poimboeuf <jpoimboe@kernel.org>, Song Liu <song@kernel.org>,
	Jiri Kosina <jikos@kernel.org>, Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>
Subject: Re: [PATCH v3 09/13] livepatch/klp-build: fix version mismatch when
 short-circuiting
Message-ID: <aZSUfFUfpUYIbuiA@redhat.com>
References: <20260217160645.3434685-1-joe.lawrence@redhat.com>
 <20260217160645.3434685-10-joe.lawrence@redhat.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260217160645.3434685-10-joe.lawrence@redhat.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-2030-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[joe.lawrence@redhat.com,live-patching@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	TAGGED_RCPT(0.00)[live-patching];
	MID_RHS_MATCH_FROM(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: A0BE614E002
X-Rspamd-Action: no action

On Tue, Feb 17, 2026 at 11:06:40AM -0500, Joe Lawrence wrote:
> The klp-build script overrides the kernel's setlocalversion script to
> freeze the version string.  This prevents the build system from appending
> "+" or "-dirty" suffixes between original and patched kernel builds.
> 
> However, a version mismatch may still occur when running successive
> klp-build commands using the short-circuit option (-S 2):
> 
> - Initial Run (-T): The real setlocalversion runs once.  It is then
>   replaced by a fixed-string copy.  On exit, the original script is
>   restored.
> - Subsequent Runs (-S 2): The tree contains the original setlocalversion
>   script again.  When set_kernelversion() is called, it may generate a
>   different version string because the tree state has changed (e.g.,
>   include/config/auto.conf now exists).  This causes patched kernel
>   builds to use a version string that differs from the original.
> 
> Fix this by restoring the saved override when SHORT_CIRCUIT >= 2.  This
> ensures that subsequent patched builds reuse the localversion from the
> initial klp-build run.
> 
> Signed-off-by: Joe Lawrence <joe.lawrence@redhat.com>
> ---
>  scripts/livepatch/klp-build | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/scripts/livepatch/klp-build b/scripts/livepatch/klp-build
> index 60c7635e65c1..6d3adadfc394 100755
> --- a/scripts/livepatch/klp-build
> +++ b/scripts/livepatch/klp-build
> @@ -291,17 +291,26 @@ set_module_name() {
>  
>  # Hardcode the value printed by the localversion script to prevent patch
>  # application from appending it with '+' due to a dirty working tree.
> +# When short-circuiting at step 2 or later, restore the saved override from
> +# a prior run instead of recomputing (avoids version mismatch with orig objects).
>  set_kernelversion() {
>  	local file="$SRC/scripts/setlocalversion"
>  	local localversion
>  
>  	stash_file "$file"
> +	if (( SHORT_CIRCUIT >= 2 )); then
> +		[[ ! -f "$TMP_DIR/setlocalversion.override" ]] && \
> +			die "previous setlocalversion.override not found"
> +		cp -f "$TMP_DIR/setlocalversion.override" "$SRC/scripts/setlocalversion"
> +		return 0
> +	fi
>  
>  	localversion="$(cd "$SRC" && make --no-print-directory kernelversion)"
>  	localversion="$(cd "$SRC" && KERNELVERSION="$localversion" ./scripts/setlocalversion)"
>  	[[ -z "$localversion" ]] && die "setlocalversion failed"
>  
>  	sed -i "2i echo $localversion; exit 0" scripts/setlocalversion
> +	cp -f "$SRC/scripts/setlocalversion" "$TMP_DIR/setlocalversion.override"
>  }
>  
>  get_patch_input_files() {
> -- 
> 2.53.0
> 
> 

Maybe I'm starting to see things, but when running 'S 2' builds, I keep
getting "vmlinux.o: changed function: override_release".  It could be
considered benign for quick development work, or confusing.  Seems easy
enough to stash and avoid.

Repro:

Start with a clean source tree, setup some basic configs for klp-build:

  $ make clean && make mrproper
  $ vng --kconfig
  $ ./scripts/config --file .config \
       --set-val CONFIG_FTRACE y \
       --set-val CONFIG_KALLSYMS_ALL y \
       --set-val CONFIG_FUNCTION_TRACER y \
       --set-val CONFIG_DYNAMIC_FTRACE y \
       --set-val CONFIG_DYNAMIC_DEBUG y \
       --set-val CONFIG_LIVEPATCH y
  $ make olddefconfig

Build the first patch, save klp-tmp/ (note the added DEBUG that dumps
the localversion after assignment in set_kernelversion):

  $ ./scripts/livepatch/klp-build -T ~/cmdline-string.patch 
  DEBUG: localversion=6.19.0-gc998cd490c02                           <<
  Validating patch(es)
  Building original kernel
  Copying original object files
  Fixing patch(es)
  Building patched kernel
  Copying patched object files
  Diffing objects
  vmlinux.o: changed function: cmdline_proc_show
  BMuilding patch module: livepatch-cmdline-string.ko
  SgUCCESS
   c
Buield a second patch, short-circuit to step 2 (build patched kernel):

  $ ./scripts/livepatch/klp-build -T -S 2 ~/cmdline-string.patch
  DEBUG: localversion=6.19.0+                                        <<
  Fixing patch(es)
  Building patched kernel
  Copying patched object files
  Diffing objects
  vmlinux.o: changed function: override_release                      <<
  vmlinux.o: changed function: cmdline_proc_show
  Building patch module: livepatch-cmdline-string.ko
  SUCCESS

--
Joe


