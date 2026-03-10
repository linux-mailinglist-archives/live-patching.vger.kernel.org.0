Return-Path: <live-patching+bounces-2163-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cPVFGN8lsGnYgQIAu9opvQ
	(envelope-from <live-patching+bounces-2163-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 10 Mar 2026 15:08:31 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B1783251615
	for <lists+live-patching@lfdr.de>; Tue, 10 Mar 2026 15:08:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 43A6C34527EE
	for <lists+live-patching@lfdr.de>; Tue, 10 Mar 2026 13:46:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E38B3537FD;
	Tue, 10 Mar 2026 13:45:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GnJ0Jd51"
X-Original-To: live-patching@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFB1D34846D
	for <live-patching@vger.kernel.org>; Tue, 10 Mar 2026 13:45:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773150353; cv=none; b=GxkvuS9ISI/TS9AoVqjsOePI+QwPaEdCCASNf8txCQEiJPwjtEpXa89VO9NV+1vTj3CUQdsyuc9kb83tYAxo7gj0cSnP/s66LyhMMefmyxyK/Y17rvSN6Apr6v/1ub8gXR4uFpU5Rau7G/jzsSJe285HNIyWiifrXjkbqdEHTfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773150353; c=relaxed/simple;
	bh=rIDVijRCzMlDB4QBnrBvgu7PsK8oP07CVwEZNuNyP2o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ofw6yZeak0bZPJ/JBn0GzRC/kpZ8v7S5JtzRnCeRA9og6UmkRrKsWneaZkyaep6Jzle2gwcwWKGzGwrp+zuXl98UUvwaifQL2nev576G7nJ0f2r07L2yjEC9exfzQwGzGoaw/hLDaTpQ86GDDy7yZj10Ggo5MMICaoURyGrwx3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GnJ0Jd51; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773150350;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nMlOzxcZvyjv0oet07FqAydZ4483A/RM52xgw2T+7HU=;
	b=GnJ0Jd510X4XLYYqxvL+Bf+4Kehy8xN/HVmAsh4tWHhlJj5SL8fQ5lZCU0ldWLuF7VvVu6
	+Y+XaOOc5N0ZrUC6bHHhffnxBCTRcKzfjnLBzxznTJcDeXMsv0kElW25qVW1h4asz6OTK2
	AnBvU0N9ELi+YTzLopzRYZ2UssTs654=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-247-rD13tK_GPUKiyuHzcpVLwQ-1; Tue,
 10 Mar 2026 09:45:47 -0400
X-MC-Unique: rD13tK_GPUKiyuHzcpVLwQ-1
X-Mimecast-MFC-AGG-ID: rD13tK_GPUKiyuHzcpVLwQ_1773150346
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 55D2318002D0;
	Tue, 10 Mar 2026 13:45:46 +0000 (UTC)
Received: from redhat.com (unknown [10.22.80.5])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1E7E41955D87;
	Tue, 10 Mar 2026 13:45:44 +0000 (UTC)
Date: Tue, 10 Mar 2026 09:45:42 -0400
From: Joe Lawrence <joe.lawrence@redhat.com>
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: live-patching@vger.kernel.org, Song Liu <song@kernel.org>,
	Jiri Kosina <jikos@kernel.org>, Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>
Subject: Re: [PATCH] klp-build: Fix inconsistent kernel version
Message-ID: <abAghiWvh3BeJNp9@redhat.com>
References: <20260217160645.3434685-1-joe.lawrence@redhat.com>
 <20260217160645.3434685-10-joe.lawrence@redhat.com>
 <aZSUfFUfpUYIbuiA@redhat.com>
 <zyxlceita2k3szzck5fwhhnpinh3twtzpr23xkdxdpj4opkgog@dnsvvttl4r3x>
 <aaZFUL_yCS3_wHnd@redhat.com>
 <w6uwlcdd7eb247lj4r5khrliiymbpapshmaror3x3olfaamj6a@4ukxobzqj7fo>
 <noyyhysipjm6aw4td6q4mg6n4c637unfgmkn35otopu3rbqugj@ekzuix6lsb6p>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <noyyhysipjm6aw4td6q4mg6n4c637unfgmkn35otopu3rbqugj@ekzuix6lsb6p>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Rspamd-Queue-Id: B1783251615
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[redhat.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2163-lists,live-patching=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[joe.lawrence@redhat.com,live-patching@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_COUNT_FIVE(0.00)[6];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[live-patching];
	RCPT_COUNT_FIVE(0.00)[6]
X-Rspamd-Action: no action

On Thu, Mar 05, 2026 at 02:52:46PM -0800, Josh Poimboeuf wrote:
> If .config hasn't been synced with auto.conf, any recent changes to
> CONFIG_LOCALVERSION* may not get reflected in the kernel version name.
> 
> Use "make syncconfig" to force them to sync, and "make kernelrelease" to
> get the version instead of having to construct it manually.
> 
> Fixes: 24ebfcd65a87 ("livepatch/klp-build: Introduce klp-build script for generating livepatch modules")
> Closes: https://lore.kernel.org/20260217160645.3434685-10-joe.lawrence@redhat.com
> Reported-by: Joe Lawrence <joe.lawrence@redhat.com>
> Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
> ---
>  scripts/livepatch/klp-build | 9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/scripts/livepatch/klp-build b/scripts/livepatch/klp-build
> index 809e198a561d..72f05c40b9f8 100755
> --- a/scripts/livepatch/klp-build
> +++ b/scripts/livepatch/klp-build
> @@ -285,15 +285,14 @@ set_module_name() {
>  # application from appending it with '+' due to a dirty git working tree.
>  set_kernelversion() {
>  	local file="$SRC/scripts/setlocalversion"
> -	local localversion
> +	local kernelrelease
>  
>  	stash_file "$file"
>  
> -	localversion="$(cd "$SRC" && make --no-print-directory kernelversion)"
> -	localversion="$(cd "$SRC" && KERNELVERSION="$localversion" ./scripts/setlocalversion)"
> -	[[ -z "$localversion" ]] && die "setlocalversion failed"
> +	kernelrelease="$(cd "$SRC" && make syncconfig &>/dev/null && make kernelrelease)"

Almost, I needed to add '-s' to the kernelversion target to silence the
make "entering / leaving directory" msgs and then this worked for me.

There's some makefile voodoo going on here where when I manually run
`make kernelrelease` I don't see the verbose msgs, but I printed
"$kernelrelease" here in klp-build and on my machine (make v4.4.1), that
extra output derailed the script.

Anyway, `make help` says:

  kernelrelease   - Output the release version string (use with make -s)

so we should probably use '-s' regardless.

With that, shall I drop my ("livepatch/klp-build: fix version mismatch
when short-circuiting") and carry yours in its place?

--
Joe


