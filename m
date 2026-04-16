Return-Path: <live-patching+bounces-2373-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wFrfD8sP4WnoogAAu9opvQ
	(envelope-from <live-patching+bounces-2373-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 16 Apr 2026 18:35:23 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A129411BC5
	for <lists+live-patching@lfdr.de>; Thu, 16 Apr 2026 18:35:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B63B53022057
	for <lists+live-patching@lfdr.de>; Thu, 16 Apr 2026 16:33:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 472BE303A37;
	Thu, 16 Apr 2026 16:33:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JryX6xzy"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2474E2ECEB9
	for <live-patching@vger.kernel.org>; Thu, 16 Apr 2026 16:33:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776357181; cv=none; b=peu9lCjenjnZMYCPiGqGsxUT7LP8ZRQoZMTILrQKhkwYRG22FQDVY71ft8F2/cCokFMdnZr2oElU9tWnm+mVJCGJL5CkJX2sm90LdX4/znOvIODYmvwDpJNHXZUm05ZJ5w1N0g82H7cY3FF7I4Vwhh09Z0h6Z5OmG3lUG9GQraA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776357181; c=relaxed/simple;
	bh=WCG2bBnOmPMKn+6vVzsLIxixeAy1MQ1vs+leWAcNSsA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YoQe1GjBNLhtw/IUy0NkngVUHC9lymvjP8LOrKw+6bdofwPJTzJrBxYNoOFFJWkamMVKiFq/D6jaijBuHVUsKpHk1SBCmf0OTDWBsQCy2sLUJutFQ7Jdx7X8WUEhImVGFaYklyA927srxhq3TbqfMd87JtE0uTyM3y1VEUSz1mU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JryX6xzy; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B465AC2BCB4
	for <live-patching@vger.kernel.org>; Thu, 16 Apr 2026 16:33:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776357180;
	bh=WCG2bBnOmPMKn+6vVzsLIxixeAy1MQ1vs+leWAcNSsA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=JryX6xzy4Mp2aILAAnVM6ZWoO8n8UHqJi28/wxFnU/qBjVVaTwIAHWg39ktiYqCKN
	 bpEjs0lyhOpRNqyIe7WGDo5sq/9cHOvgDpoiLSLO8pHhD5KMuE4eBd9GVtZnyCgZ/1
	 igHdPGIrFFmQ6e1bhf9rzK4LSZ3G0t80TRPzSkqKM7ZaILyUlqM9wWEk8yVTjBSyI+
	 b9vDh+6umgpCPlbqjOqmj/GeGAjQx8hkNixO2F5yT7JyGzsCw4OyoRNzmmkIIcON4A
	 QPg9ieDwS8zy++NPJMD8EsLHfeg7H1EqujgHdi7WIzArbTuv/fEObihZx9H8R55tK7
	 ND56oQ88MKy4A==
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-8a032383008so89954066d6.1
        for <live-patching@vger.kernel.org>; Thu, 16 Apr 2026 09:33:00 -0700 (PDT)
X-Gm-Message-State: AOJu0YxuPVP02WoyS3p2rgn0oQF+i7aJxlsVYY0n6FxJzeArsejrVN7b
	vIeWrDLzulwsPdOSP9YMbJkbfJZq5pPss6EsJdfhHbJeO3ePcpA+eSMM6KARvL3NsTp72huvkOf
	0GHe7+aOWAfcPPwyIYvMUGTmhZnUxwX0=
X-Received: by 2002:a05:6214:da4:b0:8ad:bccd:94cf with SMTP id
 6a1803df08f44-8adbccd95c9mr189994196d6.18.1776357179131; Thu, 16 Apr 2026
 09:32:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260416001628.2062468-1-song@kernel.org> <CALOAHbDSpofLCQ-LCU2uVtkc9w+zib0PPgBr+6sEv5FD5+Hd=g@mail.gmail.com>
In-Reply-To: <CALOAHbDSpofLCQ-LCU2uVtkc9w+zib0PPgBr+6sEv5FD5+Hd=g@mail.gmail.com>
From: Song Liu <song@kernel.org>
Date: Thu, 16 Apr 2026 09:32:46 -0700
X-Gmail-Original-Message-ID: <CAPhsuW5=oXwQQyOU7Hf6Qf5=tK=-J75Xr+p+dcGiPs2vVEeMFw@mail.gmail.com>
X-Gm-Features: AQROBzD75ocK44IvuXkZxu1jKMpMFfT6xZClyQ8WCn-rzhuB3TMiQGiiQOieiXk
Message-ID: <CAPhsuW5=oXwQQyOU7Hf6Qf5=tK=-J75Xr+p+dcGiPs2vVEeMFw@mail.gmail.com>
Subject: Re: [PATCH] samples/livepatch: Add BPF struct_ops integration sample
To: Yafang Shao <laoar.shao@gmail.com>
Cc: live-patching@vger.kernel.org, linux-kernel@vger.kernel.org, 
	jpoimboe@kernel.org, jikos@kernel.org, mbenes@suse.cz, pmladek@suse.com, 
	joe.lawrence@redhat.com, kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-2373-lists,live-patching=lfdr.de];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[song@kernel.org,live-patching@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[live-patching];
	RCPT_COUNT_SEVEN(0.00)[9];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 9A129411BC5
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Thu, Apr 16, 2026 at 12:46=E2=80=AFAM Yafang Shao <laoar.shao@gmail.com>=
 wrote:
[...]
> > +
> > +static struct klp_patch patch =3D {
> > +       .mod =3D THIS_MODULE,
> > +       .objs =3D objs,
>
>   Nit: I suggest enabling the replace flag for this patch to align
> with the recommended implementation.
>
>     .replace =3D true,

This is an interesting topic. To fully take advantage of the replace
feature, we need more work on the BPF side.

For this sample, I guess we are OK either way.

>
> Other than that, it looks good to me:
>
>   Tested-and-acked-by: Yafang Shao <laoar.shao@gmail.com>

Thanks,
Song

