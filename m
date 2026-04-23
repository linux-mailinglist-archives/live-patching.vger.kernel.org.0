Return-Path: <live-patching+bounces-2497-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id AENnKFJr6mmhzAIAu9opvQ
	(envelope-from <live-patching+bounces-2497-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 20:56:18 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 1620345640D
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 20:56:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E95A53009148
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 18:54:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 867D13A7831;
	Thu, 23 Apr 2026 18:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Cti8mG8g"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62E1F1A681D
	for <live-patching@vger.kernel.org>; Thu, 23 Apr 2026 18:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776970491; cv=none; b=NeBgfZQbIrYfqH7f3yaZrVg19uvzS84C2lR2R0jt3k49YOPOREzT+ozNSezUYaBJ0DltXluR2I36ZIOrODBWS4paZMB4xe9wC7RP69NpsMxqZqjF4m28ogaQUPthldIP7uh2TBOsA6Uj2TSZYdRh+gy7jXKyL7nbXpXXhSkc/fI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776970491; c=relaxed/simple;
	bh=0b8rPXR6kI1C23bykPlRAMFrY9pDwjy/F1uL9LgC1jo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZlZAMMsnAUmNrQWXzV1L1An66D62QDyALeM35eNwoY9L3Nr6/9w76B07zDX9MmV8x1mkIPkEb/twfcK47vFvAby7YH+h9bzqxNthnUzBBSX4e8eRP8/Wvzuio826nw/xLR7/CIvN3bL7r2mDHuQUVRmo1LcOKbll7RY4fCy1WTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Cti8mG8g; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 459A6C2BCB2
	for <live-patching@vger.kernel.org>; Thu, 23 Apr 2026 18:54:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776970491;
	bh=0b8rPXR6kI1C23bykPlRAMFrY9pDwjy/F1uL9LgC1jo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=Cti8mG8gi9zPLFkKR5CE0OpctBXUPWZfZHxy+vnTQdocqRc/2e9uMd1ACRP1Fc6YN
	 OBjouRCmxV8riexq0DEVwZXLmJHGbGLr71UMJjZOMYV4hhACgWO7zEMnD3IcE7h2yt
	 abtqR8wusPWPXXEyuQqT4TYnGGvAEJI7nf0JJedMTSJW8hjzPvkcTLI0uRK5mJXPpr
	 d7I9vlujmTQ7jCJ8/Ri+lAE1HEEJ/O5l3y97eHW6/t6kXI+0rxJzqFFim0u3z0/9VN
	 7k2re3Igk0T4R6QNIyCTf4L+wQj/xWQpx/pMFzlM7sjX8kb+ZK/VGajNqkoY2NIrJZ
	 QEY3B+Q8RMRRw==
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-50d87610513so76808201cf.3
        for <live-patching@vger.kernel.org>; Thu, 23 Apr 2026 11:54:51 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ+MkAHdhF4npkksE+d9YJku7tpnmiB+pLw/QNp2cnZvsLPyinAGxsQmyXy/u3oEBTlijiBFU0Pw2rJX7j35@vger.kernel.org
X-Gm-Message-State: AOJu0YzSk4c4VmIHbRpHQ9Rk4ziosdDj6nPQnTWOVo1RyADAsRH/ZPpn
	n+Y/EaW4bRxpTMUiq+4iFcVR+d2Y9QTwkeao3VE7ZpeZKIpbjU+AyJ1G3RLkBZ/aP30IV9TTJN2
	TcETMqw9Lw4nznCil1IJIsyHKPZE8tvY=
X-Received: by 2002:a05:622a:17cc:b0:50f:d54b:34c6 with SMTP id
 d75a77b69052e-50fd54b3b6fmr26409781cf.12.1776970490489; Thu, 23 Apr 2026
 11:54:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1776916871.git.jpoimboe@kernel.org> <f34990d29dd7642ada7843613c96c563043c28a5.1776916871.git.jpoimboe@kernel.org>
In-Reply-To: <f34990d29dd7642ada7843613c96c563043c28a5.1776916871.git.jpoimboe@kernel.org>
From: Song Liu <song@kernel.org>
Date: Thu, 23 Apr 2026 11:54:39 -0700
X-Gmail-Original-Message-ID: <CAPhsuW7rmG_tybJwKdrX+DsKx9a7xA-Qa57njW5r+NyvhT3DUA@mail.gmail.com>
X-Gm-Features: AQROBzD5zsLmFMdjkX0qMlRXXgP_4Fuzm0vjtJ5ONJloF5TpXFx8YgQ-FPvPOXM
Message-ID: <CAPhsuW7rmG_tybJwKdrX+DsKx9a7xA-Qa57njW5r+NyvhT3DUA@mail.gmail.com>
Subject: Re: [PATCH 02/48] objtool/klp: Fix .data..once static local non-correlation
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
	live-patching@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, 
	Joe Lawrence <joe.lawrence@redhat.com>, Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2497-lists,live-patching=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[song@kernel.org,live-patching@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[live-patching];
	RCPT_COUNT_SEVEN(0.00)[8];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,mail.gmail.com:mid]
X-Rspamd-Queue-Id: 1620345640D
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Wed, Apr 22, 2026 at 9:04=E2=80=AFPM Josh Poimboeuf <jpoimboe@kernel.org=
> wrote:
>
> While there was once a section named .data.once, it has since been
> renamed to .data..once with commit dbefa1f31a91 ("Rename .data.once to
> .data..once to fix resetting WARN*_ONCE").  Fix it.
>
> Fixes: dd590d4d57eb ("objtool/klp: Introduce klp diff subcommand for diff=
ing object files")
> Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>

Acked-by: Song Liu <song@kernel.org>

Nitpick: shall we match both ".data.once" and ".data..once", so that whoeve=
r
backports klp-build to older kernels will not have a surprise.

> ---
>  tools/objtool/klp-diff.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/tools/objtool/klp-diff.c b/tools/objtool/klp-diff.c
> index b1b068e9b4c7..cb26c1c92a74 100644
> --- a/tools/objtool/klp-diff.c
> +++ b/tools/objtool/klp-diff.c
> @@ -257,7 +257,8 @@ static bool is_uncorrelated_static_local(struct symbo=
l *sym)
>         if (!is_object_sym(sym) || !is_local_sym(sym))
>                 return false;
>
> -       if (!strcmp(sym->sec->name, ".data.once"))
> +       /* WARN_ONCE, etc */
> +       if (!strcmp(sym->sec->name, ".data..once"))
>                 return true;
>
>         dot =3D strchr(sym->name, '.');
> --
> 2.53.0
>
>

