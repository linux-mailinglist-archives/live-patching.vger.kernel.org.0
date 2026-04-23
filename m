Return-Path: <live-patching+bounces-2505-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gCSjKy+x6mlPCgAAu9opvQ
	(envelope-from <live-patching+bounces-2505-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 24 Apr 2026 01:54:23 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 563E945870D
	for <lists+live-patching@lfdr.de>; Fri, 24 Apr 2026 01:54:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 3AAB7300CA2E
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 23:54:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 249BF3CAE8E;
	Thu, 23 Apr 2026 23:54:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tXQunbW0"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF585378815
	for <live-patching@vger.kernel.org>; Thu, 23 Apr 2026 23:54:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776988460; cv=none; b=Xw3j8+VHWVt0DY3ec1Aae8gihUogdlFFXViLAK1huyMa5MBRV0OExyGyCWCxQVcIbJaDrPJbQVCQN2yvL5XLwmxb52dsI32uSbBFueNfSXqXi78nbn0O4g3TP/7mvKhNQo611m0wUqM2XK2wr/yuaZU8uAbWrrXUAO7rb7yuEks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776988460; c=relaxed/simple;
	bh=3QFSv0U2fFgLudtNwV9TzoT6SWsPZW4/F4F78GlgQJQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=H1TE/r2vgWTalFCr3L/pSdiIc8m1/Pufmc+td7DF5pAIptwFoyB7BpL9YWwZI9wWg0WqiWJ/MgGwjT1mxyIGRbSeEPZKekaWqfpI5eZL1QV4cLQXlXKPBhLqeBaHpvDd6DDLk7ix2Lfub02IbjDBKRZ29w3V0iDqzZ2ousnHN0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tXQunbW0; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98BC2C2BCC4
	for <live-patching@vger.kernel.org>; Thu, 23 Apr 2026 23:54:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776988459;
	bh=3QFSv0U2fFgLudtNwV9TzoT6SWsPZW4/F4F78GlgQJQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=tXQunbW0QyH2LN/jzbEnd5CEKICaaeIJLM2V7Nl9hdvk01WjjnFnlolWOaEDA4S1G
	 2wWIS7W5NtGGcgTaqrmh9fAvlZw+e6AJuc/fwcow42/zgOQDGKQ5cfs7vkf++x6n5f
	 OcRsOAozIEbXg6EYcIS6HyPHIS3fqXrLlpO4V3cpoBvLQ9+2C6Ib5zt9gd4EErTLj4
	 q9gpe/jYd/OO88xsO1zgS8MDc/dMqsGvgJAIM4Mj6ZhcpB4U0tEqhQhI0CWUehuUaN
	 ZiLTK8FjSE9ZhBQk5s4IIi36ED9hIQesGh7S8wHIyIJBJ2xuEh4pm2RWYXRYKkmm6z
	 lmEHK+1Q/n+Jw==
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-899a9f445cbso86107546d6.0
        for <live-patching@vger.kernel.org>; Thu, 23 Apr 2026 16:54:19 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ/eYblyCWRzAryV/8848NUOa9SzMxkfIiNZRRESpqZ2DIzzn+sfTUJ7X6NL7eJTeq3zulIA6haNrU5r1PMh@vger.kernel.org
X-Gm-Message-State: AOJu0Yzuwm0lpWQwxshfRwPojecBdoUH1R1Q2BoJBbkXR+E883trmjop
	qgCxTxVRb1WOX8lozDH2RVHk8XUacj059ouqlCjfNc2JHdb7NqqqbzxglO3lf+RI3iwAp+yKdas
	59W4EiKpY7+I4jYNNtrLJhmpX2IAMGsU=
X-Received: by 2002:a05:6214:e65:b0:8b1:f784:7ecc with SMTP id
 6a1803df08f44-8b1f784822dmr207045716d6.46.1776988458723; Thu, 23 Apr 2026
 16:54:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1776916871.git.jpoimboe@kernel.org> <f34990d29dd7642ada7843613c96c563043c28a5.1776916871.git.jpoimboe@kernel.org>
 <CAPhsuW7rmG_tybJwKdrX+DsKx9a7xA-Qa57njW5r+NyvhT3DUA@mail.gmail.com> <tzunpmsnca3pi5ziak6cwrqftdl7oa34jcuy7cm4nrzzfd6276@jkates4giayx>
In-Reply-To: <tzunpmsnca3pi5ziak6cwrqftdl7oa34jcuy7cm4nrzzfd6276@jkates4giayx>
From: Song Liu <song@kernel.org>
Date: Thu, 23 Apr 2026 16:54:07 -0700
X-Gmail-Original-Message-ID: <CAPhsuW7MqJH-Tof6u8iSYoACY_hDC_3WFQ0y-sxpmiF0rULxYQ@mail.gmail.com>
X-Gm-Features: AQROBzDpTYR2x4JjBf6fx3p2pVZCefHLIYEuvowZAmzN-SXmJtI6IRaB7ZMYSQw
Message-ID: <CAPhsuW7MqJH-Tof6u8iSYoACY_hDC_3WFQ0y-sxpmiF0rULxYQ@mail.gmail.com>
Subject: Re: [PATCH 02/48] objtool/klp: Fix .data..once static local non-correlation
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
	live-patching@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, 
	Joe Lawrence <joe.lawrence@redhat.com>, Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 563E945870D
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2505-lists,live-patching=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[song@kernel.org,live-patching@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[live-patching];
	RCPT_COUNT_SEVEN(0.00)[8];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]

On Thu, Apr 23, 2026 at 4:34=E2=80=AFPM Josh Poimboeuf <jpoimboe@kernel.org=
> wrote:
>
> On Thu, Apr 23, 2026 at 11:54:39AM -0700, Song Liu wrote:
> > On Wed, Apr 22, 2026 at 9:04=E2=80=AFPM Josh Poimboeuf <jpoimboe@kernel=
.org> wrote:
> > >
> > > While there was once a section named .data.once, it has since been
> > > renamed to .data..once with commit dbefa1f31a91 ("Rename .data.once t=
o
> > > .data..once to fix resetting WARN*_ONCE").  Fix it.
> > >
> > > Fixes: dd590d4d57eb ("objtool/klp: Introduce klp diff subcommand for =
diffing object files")
> > > Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
> >
> > Acked-by: Song Liu <song@kernel.org>
> >
> > Nitpick: shall we match both ".data.once" and ".data..once", so that wh=
oever
> > backports klp-build to older kernels will not have a surprise.
>
> Hm, I'm a bit hesitant to do that.  One of the nice things about having
> this code upstream is that we don't have to start collecting all the
> cruft for old kernels.

Agreed. Instead of matching both, we can probably cover this with a
test case.

Thanks,
Song

