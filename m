Return-Path: <live-patching+bounces-2846-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0ED9MiWEC2oZIwUAu9opvQ
	(envelope-from <live-patching+bounces-2846-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Mon, 18 May 2026 23:27:01 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3EF0B573CDC
	for <lists+live-patching@lfdr.de>; Mon, 18 May 2026 23:27:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4925A30488FB
	for <lists+live-patching@lfdr.de>; Mon, 18 May 2026 21:25:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0A303932FD;
	Mon, 18 May 2026 21:25:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X8vRuxZ7"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADAF6392C2C
	for <live-patching@vger.kernel.org>; Mon, 18 May 2026 21:25:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779139516; cv=none; b=nouPe8eqGvOVfxiN4Xqu9Zo3Zr6qFSINOtrfyK0keho9YU/TLXTZmz1le000XZeOC/Npy/X875T0KuM3ICwNl0jF+kV0qbexoWXqQzFaZN+9knoj7j2x+sOqnfUMXCqjfLP3Yr7dadkvIiCRrtsr7o4NokHGZ8hsoJIuPFYmI4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779139516; c=relaxed/simple;
	bh=ne9M8LhUlpwpLPzMt+gybQlXyVxeVjlocxm2pVrYNWs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TyjsCKMJt0yewtOFI8mMMtmE+kZ2FeI4ZYb55rdTbdaysOfyrYxZJetndxDZGgXcC/hAM2rS5mDE/jn5EZ8HkEcfnUpRyEyqQV/mxHiOq7qCWvQpwA2UFv8ZNvYF7WsWMX33K+K/K2Nyyx4BdIz5WFiGwsievnzSejsjYdCXn+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X8vRuxZ7; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 532C8C2BCF6
	for <live-patching@vger.kernel.org>; Mon, 18 May 2026 21:25:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779139516;
	bh=ne9M8LhUlpwpLPzMt+gybQlXyVxeVjlocxm2pVrYNWs=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=X8vRuxZ7Fr1qPiVsb3FJ1wtHzSGsnevYAap4UzkXmhqtBpCx1Ij2W4BAfwsvCzs98
	 R8L3LwiVwMJ3cDq1lEQVHQ5pFXYygImLvZesUY05hOODWoXcOfkt/P52GBP9a5mW6K
	 Pkx8Ch8HbVLANxskx0k4e3Shwgnk8bV7mvUoRKkJ7HfLsVxnPJzetv60GEFhVOSajl
	 nAXdU0cOYkrR6lF9gQ3nio6Je+DPhHinDv6GG0HoGkBfY9DWvxlVKs4z0oWSCsMNaF
	 CTToKme+F3qysxMeXHaDSrQAG0m4OiAofC0JMihZ319si7CdqbGpnqzqDLnbvxCb7L
	 zzVPoSWlwru7A==
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-8acb856a674so39859096d6.0
        for <live-patching@vger.kernel.org>; Mon, 18 May 2026 14:25:16 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ9UDCS6RJu7UoiiT+xuJPWBLZzcyCIhdFdIH6rQMuGyvKY2XGV8Iiug4lDgu5XiKX0ihZ8WwoS8rwzddzSw@vger.kernel.org
X-Gm-Message-State: AOJu0YznhnqWhIZpFW+Vzc86RCUB7dIKx5tHD0c0i/dPG9mF6GeSspXw
	DNej1rDC7DO6r4O+OW6Jax9L5HRUtQbWPzIM7b7wbSflE7QLnsTuxW3mAzEcHsO31jPShR9N/a1
	s7ZWcBXTMGHyDFVvtk3Z4kkQWkg4u3kY=
X-Received: by 2002:a05:6214:4a92:b0:89c:ac42:e119 with SMTP id
 6a1803df08f44-8c8fb63de9cmr329406306d6.8.1779139515558; Mon, 18 May 2026
 14:25:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260513143321.26185-1-laoar.shao@gmail.com> <20260513143321.26185-2-laoar.shao@gmail.com>
In-Reply-To: <20260513143321.26185-2-laoar.shao@gmail.com>
From: Song Liu <song@kernel.org>
Date: Mon, 18 May 2026 14:25:04 -0700
X-Gmail-Original-Message-ID: <CAPhsuW6Aa8Tu5aWGVYzRVVNEnJiHrNzsa4aKXoOEa_gwhp3XfQ@mail.gmail.com>
X-Gm-Features: AVHnY4JCIzAOeSeuo5iNA1vMJp0wZqoDkEFKaDYC1PoFsBR0yBvYHsB-xBpcAjE
Message-ID: <CAPhsuW6Aa8Tu5aWGVYzRVVNEnJiHrNzsa4aKXoOEa_gwhp3XfQ@mail.gmail.com>
Subject: Re: [RFC PATCH 1/6] livepatch: Support scoped atomic replace using
 replace set
To: Yafang Shao <laoar.shao@gmail.com>
Cc: jpoimboe@kernel.org, jikos@kernel.org, mbenes@suse.cz, pmladek@suse.com, 
	joe.lawrence@redhat.com, live-patching@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-2846-lists,live-patching=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[song@kernel.org,live-patching@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Queue-Id: 3EF0B573CDC
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Wed, May 13, 2026 at 7:34=E2=80=AFAM Yafang Shao <laoar.shao@gmail.com> =
wrote:
>
> Convert the replace attribute from a boolean to a u32 to function as a
> "replace set." A newly loaded livepatch will now atomically replace
> existing patches that belong to the same set.
>
> This change currently supports function replacement only; support for
> state and shadow variables will be introduced in subsequent patches.
>
> Suggested-by: Song Liu <song@kernel.org>
> Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> ---
>  .../livepatch/cumulative-patches.rst          | 17 ++++++++------
>  Documentation/livepatch/livepatch.rst         | 23 +++++++++++--------
>  include/linux/livepatch.h                     |  5 ++--
>  kernel/livepatch/core.c                       | 16 ++++++++-----
>  kernel/livepatch/state.c                      | 17 +++++++-------
>  kernel/livepatch/transition.c                 | 10 ++++----
>  scripts/livepatch/init.c                      |  7 +-----
>  scripts/livepatch/klp-build                   | 14 +++++------
>  8 files changed, 59 insertions(+), 50 deletions(-)
>
> diff --git a/Documentation/livepatch/cumulative-patches.rst b/Documentati=
on/livepatch/cumulative-patches.rst
> index 1931f318976a..6ef49748110e 100644
> --- a/Documentation/livepatch/cumulative-patches.rst
> +++ b/Documentation/livepatch/cumulative-patches.rst
> @@ -17,18 +17,20 @@ from all older livepatches and completely replace the=
m in one transition.
>  Usage
>  -----
>
> -The atomic replace can be enabled by setting "replace" flag in struct kl=
p_patch,
> -for example::
> +The "replace_set" attribute in ``struct klp_patch`` acts as a **replace =
set**,
> +defining the scope of the replacement. By default, the replace set is 1.
> +
> +For example::
>
>         static struct klp_patch patch =3D {
>                 .mod =3D THIS_MODULE,
>                 .objs =3D objs,
> -               .replace =3D true,
> +               .replace_set =3D 1,
>         };

I wonder whether we should have "replace_set =3D 0" means no replace.
This will simplify the transition for users of the existing replace=3Dfalse
option. I would like to hear other folks' thoughts on this.

Thanks,
Song

