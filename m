Return-Path: <live-patching+bounces-2317-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oLxiGMWO1WlO7gcAu9opvQ
	(envelope-from <live-patching+bounces-2317-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Wed, 08 Apr 2026 01:09:57 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id B74313B56A7
	for <lists+live-patching@lfdr.de>; Wed, 08 Apr 2026 01:09:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E1878301ECE8
	for <lists+live-patching@lfdr.de>; Tue,  7 Apr 2026 23:09:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85D0338D006;
	Tue,  7 Apr 2026 23:09:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RUgDdahx"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 622F538C427
	for <live-patching@vger.kernel.org>; Tue,  7 Apr 2026 23:09:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775603392; cv=none; b=jz3LhhuTWoQuJL4/nN5C3t0nkupcY87YeOrPNdBvdScO0nRDH0GUlqrqTYSNnsaKRFGGkwR2INe27vWnqHhgHPz1kbB5ILAGxXcuKQMUmQSkK3yvhLFAmrCjfOilV9rbQWHpViRbLxLrbumuZJ9SbspWJhtGgX+pjU/klvFbvpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775603392; c=relaxed/simple;
	bh=zZ9xLkjMmNfDs9NIa8a7oJ+jGSEqS686JcL/OgeDwcM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RCnbCewYNZDBeg2ZzWl7PCmFp8wwkjaqgGURJHZM/lc9EZ/wodVvPZDwUDsq8xtOVmA7MDMxzrNJODYvJFb6iC/y8PYBEocCVtBwgJDYIYbpdavSbGSh7tNTaHMmlqQhgxkWPApoGw8jK360S7EpkobqSrwUI5lrHmsPEX3XACE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RUgDdahx; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C13DC2BCB2
	for <live-patching@vger.kernel.org>; Tue,  7 Apr 2026 23:09:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775603392;
	bh=zZ9xLkjMmNfDs9NIa8a7oJ+jGSEqS686JcL/OgeDwcM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=RUgDdahxIm2meNTl1uSPiCttHwtoOX2mL5gApK5HzN4g22ZyCow3gB+T9jElvxurK
	 zrYVNodhnwnHATfWptUtvGeRyKWxbsyM9S5jJgj9Z5IRALYeW6xkjHtN82XSsohoKC
	 l0DdDBaZTAacCa36t/OPBnyuotO2uZwdLFQAI5J5gVo91CJWnLVBAhL6+o3ZNa/cVx
	 I4j1lTob5H6FU/tZUZjey025wpFpUgmxNnI9nx/GnVIww4IYiHOmfQPsjtBXVB9eT5
	 KyEJwGe+80dUQsndSswuMUrPvYKPcO6OcDhO4YL91YfwmINMD2I12g8A+7if8Fu/tj
	 naVn9wPmNoWow==
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-8a5800772f3so49290336d6.2
        for <live-patching@vger.kernel.org>; Tue, 07 Apr 2026 16:09:52 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWFDdwMcBcRVkpuQdELTXbq6JPY8kfxBnep4OQuq8PLOEH1Jqgdd0CyL3D0Q44x7xs1InGZNLK4QmEuWrQT@vger.kernel.org
X-Gm-Message-State: AOJu0Yw5XpcrElKJm1uBkvZV9fy1J1ty3NZDcZyY3p70byRLfei5kk8S
	67EHe9cCgptzMuY32vTKWqSISWW122j7RtuyqOqtoB2wFOJvmq/+nZCxGdhcNzJ1PWZyh8LWgGl
	9cjhqQiV6rGkFqtcDaLknZTd6BUDT8tA=
X-Received: by 2002:a05:6214:c69:b0:89c:d426:3cc9 with SMTP id
 6a1803df08f44-8a7049c6ff0mr323696996d6.35.1775603391153; Tue, 07 Apr 2026
 16:09:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260402092607.96430-4-laoar.shao@gmail.com> <CAPhsuW51Hh7XfN6xXm_uMAoDXBBQoNQ5ynqom+wVNdqCt81f2A@mail.gmail.com>
 <CADBMgpy3e25EH5xbKMN5GeOK47jE6uzviknbt35V49_Y7zFj8A@mail.gmail.com>
 <CAPhsuW6p3YOv3_M_c0ThMcrNqNjT=7i46ekJBrWO_oGzQkxrxA@mail.gmail.com>
 <CALOAHbCbcw2jpjk9JD9yyf+SMpQ-s9FAonSaz7Gs4XUeP+w+2g@mail.gmail.com>
 <CAPhsuW4B00-grg9XJa+AO3xgGwM_u8FC+GH3JrkYZOJx4PuV8Q@mail.gmail.com>
 <adQhpBC2W9I6QW-g@redhat.com> <CAPhsuW66tuF+QZ0pVheWb5sC4NQ-9CXikq=zMrPBXTHcsVPjdg@mail.gmail.com>
 <CALOAHbDN_t-ZRO0g9_sQFCv0J6SPDFfwJCcwSzd4ww5XRkU0QA@mail.gmail.com>
 <CALOAHbCxPA0dtsx7L2kYn8wwBdM=krZyOpfRTBiDW9qfA_zmzQ@mail.gmail.com> <adUd0Mojbtrwmeod@pathway.suse.cz>
In-Reply-To: <adUd0Mojbtrwmeod@pathway.suse.cz>
From: Song Liu <song@kernel.org>
Date: Tue, 7 Apr 2026 16:09:39 -0700
X-Gmail-Original-Message-ID: <CAPhsuW7JhtbniZHFWGMrzeqdS=-EjCySFPgiOBv0zKJNRwzONA@mail.gmail.com>
X-Gm-Features: AQROBzAFcwWWu1p_HFEFrDKUgiZrKu-q9wX5X3PG5dELW_YDDexvEiXyk8M04QY
Message-ID: <CAPhsuW7JhtbniZHFWGMrzeqdS=-EjCySFPgiOBv0zKJNRwzONA@mail.gmail.com>
Subject: Re: [RFC PATCH 3/4] livepatch: Add "replaceable" attribute to klp_patch
To: Petr Mladek <pmladek@suse.com>
Cc: Yafang Shao <laoar.shao@gmail.com>, Joe Lawrence <joe.lawrence@redhat.com>, 
	Dylan Hatch <dylanbhatch@google.com>, jpoimboe@kernel.org, jikos@kernel.org, 
	mbenes@suse.cz, rostedt@goodmis.org, mhiramat@kernel.org, 
	mathieu.desnoyers@efficios.com, kpsingh@kernel.org, mattbobrowski@google.com, 
	jolsa@kernel.org, ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org, 
	martin.lau@linux.dev, eddyz87@gmail.com, memxor@gmail.com, 
	yonghong.song@linux.dev, live-patching@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-2317-lists,live-patching=lfdr.de];
	FREEMAIL_CC(0.00)[gmail.com,redhat.com,google.com,kernel.org,suse.cz,goodmis.org,efficios.com,iogearbox.net,linux.dev,vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[24];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[song@kernel.org,live-patching@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-0.998];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,mail.gmail.com:mid,suse.com:email]
X-Rspamd-Queue-Id: B74313B56A7
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Tue, Apr 7, 2026 at 8:08=E2=80=AFAM Petr Mladek <pmladek@suse.com> wrote=
:
[...]
> > + * @replace:   replace tag:
> > + *             =3D 0: Atomic replace is disabled; however, this patch =
remains
> > + *                  eligible to be superseded by others.
>
> This is weird semantic. Which livepatch tag would be allowed to
> supersede it, please?
>
> Do we still need this category?
>
> > + *             > 0: Atomic replace is enabled. Only existing patches w=
ith a
> > + *                  matching replace tag will be superseded.
> >   * @list:      list node for global list of actively used patches
> >   * @kobj:      kobject for sysfs resources
> >   * @obj_list:  dynamic list of the object entries
> > @@ -137,7 +141,7 @@ struct klp_patch {
> >         struct module *mod;
> >         struct klp_object *objs;
> >         struct klp_state *states;
> > -       bool replace;
> > +       unsigned int replace;
>
> This already breaks the backward compatibility by changing the type
> and semantic of this field.

I was thinking if replace=3D0 means no replace, it is still backward
compatible. Did I miss something?

Thanks,
Song

> I would also change the name to better
> match the new semantic. What about using:
>
>
>   * @replace_set: Livepatch using the same @replace_set will get
>                 atomically replaced, see also conflicts[*].
>
>         unsigned int replace_set;
>
> [*] A livepatch module, livepatching an already livepatches function,
>     can be loaded only when it has the same @replace_set number.
>
>     By other words, two livepatches conflict when they have a different
>     @replace_set number and have at least one livepatched version
>     in common.

[...]

