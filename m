Return-Path: <live-patching+bounces-2070-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6AXmJpHDnGnJKAQAu9opvQ
	(envelope-from <live-patching+bounces-2070-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Mon, 23 Feb 2026 22:16:01 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 32C4717D756
	for <lists+live-patching@lfdr.de>; Mon, 23 Feb 2026 22:16:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 53C6B301981F
	for <lists+live-patching@lfdr.de>; Mon, 23 Feb 2026 21:16:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B37C21CA13;
	Mon, 23 Feb 2026 21:15:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Hw5FhDl8"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68A46F4F1
	for <live-patching@vger.kernel.org>; Mon, 23 Feb 2026 21:15:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771881358; cv=none; b=dW7BJOrFgJdcXmH6g74F8roVsCOQOureMCNtL0eu5OMilX9WeP86S/wMBYoHSt30bveG6ZI9cKEM6v7V14YwBKOls9L51xAoxrnfdCop6MCrIuthx5RfQJ9gJEmbKfFydPxFRmJcVWd5Cf87eKw80CkcAtGD6mn+KIL/V2BHSr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771881358; c=relaxed/simple;
	bh=zVaGJPxxGh1FRWPGrsuqYG0GGirUnZ+nwoKFKtPTb/o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OUiuRlGwgKLfQm0Aa8AYuZbqBRnSYfcwkMfwFkt8/0Qd2IHs0pBzfuKY0RawACGPN1F0z6UR6LSxDyslb/YecKU/Tybr2mJECG9lrvU1ei9eTwhOCkapJ8CgrmRpHsLr3wP0NNodL68g0LNfwZ5l7UDuiMhDGeJ/svZuzpNxgvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Hw5FhDl8; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53CFDC116C6;
	Mon, 23 Feb 2026 21:15:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771881358;
	bh=zVaGJPxxGh1FRWPGrsuqYG0GGirUnZ+nwoKFKtPTb/o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Hw5FhDl8UIQ46UA5nwQ3mKKm9kUzklR6ylNO3BOEQDQ0vYrKPo6Yde60vxhI1PwQt
	 U9IORDj4ZsENfHkUxQqLyCyi0wgCrdnvhyM+tWXvFlT39TTxP6jy8f9XrfU+UAzkQv
	 yZLygvG9wlDsdqFXJcC0KsCqi7NrkSBMEDlfTaG4WQc72g1vIMynUUqk2IF6j8vFk9
	 o1IXtuZf31aFEZ2mrqWIqiFt4EBJte10pibHMO+TEDdcmvUueQZaiGr3tZ912aa6HR
	 JiD1R0BLqoVNSnxdTAwfD6cYgjBjE2WDA+nTvzmn1gyK0gze9dWOcVJc4jpxFoWezq
	 56CSCQ+rQhZQQ==
Date: Mon, 23 Feb 2026 13:15:55 -0800
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Joe Lawrence <joe.lawrence@redhat.com>
Cc: live-patching@vger.kernel.org, Song Liu <song@kernel.org>, 
	Jiri Kosina <jikos@kernel.org>, Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
Subject: Re: [PATCH v3 10/13] livepatch/klp-build: provide friendlier error
 messages
Message-ID: <g27qxnginju67wz2eqhfy4mnaerydaw5mh3tbtlb5zo5pj5unu@th5y2kq7xokf>
References: <20260217160645.3434685-1-joe.lawrence@redhat.com>
 <20260217160645.3434685-11-joe.lawrence@redhat.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260217160645.3434685-11-joe.lawrence@redhat.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2070-lists,live-patching=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 32C4717D756
X-Rspamd-Action: no action

On Tue, Feb 17, 2026 at 11:06:41AM -0500, Joe Lawrence wrote:
> Provide more context for common klp-build failure modes.  Clarify which
> user-provided patch is unsupported or failed to apply, and explicitly
> identify which kernel build (original or patched) failed.
> 
> Signed-off-by: Joe Lawrence <joe.lawrence@redhat.com>
> ---
>  scripts/livepatch/klp-build | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/scripts/livepatch/klp-build b/scripts/livepatch/klp-build
> index 6d3adadfc394..80703ec4d775 100755
> --- a/scripts/livepatch/klp-build
> +++ b/scripts/livepatch/klp-build
> @@ -351,7 +351,7 @@ check_unsupported_patches() {
>  		for file in "${files[@]}"; do
>  			case "$file" in
>  				lib/*|*.S)
> -					die "unsupported patch to $file"
> +					die "$patch unsupported patch to $file"

Can we add a colon here, like

  foo.patch: unsupported patch to bar.c

-- 
Josh

