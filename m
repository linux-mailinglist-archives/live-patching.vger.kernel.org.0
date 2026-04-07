Return-Path: <live-patching+bounces-2313-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id Zh6yK1N31GkxuQcAu9opvQ
	(envelope-from <live-patching+bounces-2313-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 07 Apr 2026 05:17:39 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 47FB43A95DA
	for <lists+live-patching@lfdr.de>; Tue, 07 Apr 2026 05:17:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 883CD3004F10
	for <lists+live-patching@lfdr.de>; Tue,  7 Apr 2026 03:17:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 106E9373BEC;
	Tue,  7 Apr 2026 03:17:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="s1kt9KFh"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-yx1-f44.google.com (mail-yx1-f44.google.com [74.125.224.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B50302D8DDB
	for <live-patching@vger.kernel.org>; Tue,  7 Apr 2026 03:17:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775531855; cv=pass; b=Jwkv+xcOGBDaekWIzcbeUyXaz/HXF5LMg+Yr2+mqs3SbvJtaZh18veRvQ3TO9of67Ik78rIOkgJOy1loTiDPeJ0l9sBYe8lxQLTOCW3RHUxMqoAr37q69qgkBu9nN47apeSkd5ympa9R9RfxFg2jveE3aa96J6Mtng2rDYr4c5Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775531855; c=relaxed/simple;
	bh=6CnKNasyITD4j1QE4XtIgi0X7ZJLQxlz/57w101u5co=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Z5QixngZ9fdXtyXL752OnOZtyvKWoPOFQts20bUyVvyP7Ws2H+KPddmdoUuASc06+SGBfZzBldjSVK3A39gHtK0uMn7lDxqauovtA9Q3M+QVlrMkAU3VTMC0wl6RrW6ge1TSeyABwAzSf4Gr3qJf3MfSkBLTL6fGvAJHLD4xdXo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=s1kt9KFh; arc=pass smtp.client-ip=74.125.224.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yx1-f44.google.com with SMTP id 956f58d0204a3-6501e465a8eso5013783d50.1
        for <live-patching@vger.kernel.org>; Mon, 06 Apr 2026 20:17:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775531853; cv=none;
        d=google.com; s=arc-20240605;
        b=NmNROkLaag1Arx9+838uwhpfOof+OoVOCMk9SuufhbH55Pn3lsafInfyXOwIL3G4Dn
         HEd57iRGuRz3wYta6yzLmegmwYpEI7DGeDJpoLToMnXfC+KFATkcB7aOq/+2dHZNwaEW
         fnDOEiLqF/wd2998pcFzkOXJoBZMrYp4c26tPR5h2x1hn0Au3E1bcRdC1VMHxxTE8HYr
         Ieu4X+IvAEG4gO5Y+XFX3ZoA+h6v+Br4qHHv3jJzvG2Fz04fMrI9jgXidabRxfkLD2U9
         WtKZbWC7+puVyCitSvG8A2iQg7GSttaOgU2uDqYJQyLVbnTedE7FvIZ1dJg9emZj8Sr4
         y0bw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=n13KGfoQXw/JheUE7BLN4ftaWLYzsgUyZfU3shLQ6UE=;
        fh=4nVau39i+ddM9XN1R6gmfOhEIq9bSIuRNtmSodCjrUY=;
        b=SM9ffiLGsg0mcD7dUl7IiMVKQsTiQlxkf1Vz7SC0oidm2W8IXHSAC2jlOY+CBZfAoa
         svG1HLK76PNclP4D4Wh7Q83SYxvOL9OD2OADliSoXqXJvJolVCq/Sb55G64sc+1Q+Koo
         OwEzhzmE++rjsZOe1zMlTqeuqmUh+foea2uA0TlA+g5wng8ii0MJd1QqC7v+8CbdW9lE
         P1XWbhhObjT2+kwgbOLR9927XNWfyAPqW3BGEWYWJupLdMa/fsiQ4LKMykxXzTZorHNq
         bCnuBlyVF9Uf6qMuWsa+a6Zhi+bdw/n/pYcFRU6Xl+uF+c+emmQbGgbu6fCPx0K5Hfka
         cuPQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775531853; x=1776136653; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n13KGfoQXw/JheUE7BLN4ftaWLYzsgUyZfU3shLQ6UE=;
        b=s1kt9KFh5RKKNomECIut4vs912QYz8t6mRnyIuks8WbKpdymCjd99HDaBQf0ZMKu6A
         tDF/q+L3Yodlx5dhvQwJRmFlggUPqJ27A4GcIL5YagBNkhdyJgOAO/i78q55J4SE4lJa
         GOlx12r59F7wbWfjlmfta+70FjXODYtV1mxacIrr2aLt3UYcZQPptsdMxfm8r3hXfui3
         k3dd3JjxvPwJ2lX1Q/yU8jxr4fPtof5A9s1rSbgeIMZWXzTYbVPCQccBCiDPi8+M3gRF
         tKHUgYZu8stbCmEgclbqWCzC24m8QVX8b6FVHIR3Wt/hCVON11rxhaFDQ7y++FnpFhGF
         4n0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775531853; x=1776136653;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=n13KGfoQXw/JheUE7BLN4ftaWLYzsgUyZfU3shLQ6UE=;
        b=huJBIVOlfxv5Z0j/lC8AmTS7XMBpqSGsltMbe9HiMO1/0zSNrIkDiyrvvXAKqOK40L
         PAcDGU+rUN48MYz+GXvyCles4f9e/N7JG6eCuZtStoJwTIKS5eW5I3WCYwzQyuhcISfX
         ofuoBrl3iAYks0LiomFYsS5yrHLOd3p93tzvNWGDNyZt31ofaYXDK06GI2jIKy+Q1iKj
         Mr2Dux7bBl/1jTobrAPUvn+qPsey1sK+WYFOfvQ45K7prN7E5c3ROz373FzVINBTLoJq
         9Fl7DeGS2SgFu+nQnpmq1tj9X4wVnLpRHEVeB6iL+IWmp3C0SHD3TiA9r4mjdAeEA4Et
         xM/g==
X-Forwarded-Encrypted: i=1; AJvYcCWcyZPgK8ckdHoj3ukqOFRAojnrJe1kMe3sgU3k9EDZcVJLzXiSn3xD/GSCTkAQUJalN9a5X24zGsTD3X5C@vger.kernel.org
X-Gm-Message-State: AOJu0Yyi75nhAX4OXgIR1aNgqkuL7VZSLe+Q4gES2gDTCGgIgH0VnA9Q
	47mWEaHEviK0INfeFT+QenI8mKrfUjMHrNVJokX97nzQgoSv0JxTLH8hIj5Xpp02FXR05Lsu2G0
	8c3/71NKum6gmv/KqGp+GtMg6KAb1WoY=
X-Gm-Gg: AeBDieveaZ00bq5BLXAvFCjL3S5RlDMlTndHYN6hkXYifKTOpRkDhyXzk8ouEFeND2m
	+6XxlwT9T9rmpuBTqdi0udXl77QZjSwbdrAsdNG3f8VTfts5dvAM7p+jtMEvSvBbUD3fcVbToZT
	J5r2zToaqYR6Hlb39zqAM6UdtbM5EsQyZvZCMzvKrjywHfnbCHRz9mXGpe6B4ACQhtneQlWniVc
	23f3WS4+/5VAKxXiZ1peipsuuVHEd/P0aETfz7MeFRYu0kIGAxx659ZkYMu0J79AF6fLTOeF1+4
	DwZ1+JF2vMpmJGAUv4BYudFsd9wPZgTN+gh9oDXWhU+i92OUb6M=
X-Received: by 2002:a05:690e:1c09:b0:650:7b9f:2cdd with SMTP id
 956f58d0204a3-6507b9f3331mr921741d50.19.1775531852696; Mon, 06 Apr 2026
 20:17:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260402092607.96430-1-laoar.shao@gmail.com> <20260402092607.96430-4-laoar.shao@gmail.com>
 <CAPhsuW51Hh7XfN6xXm_uMAoDXBBQoNQ5ynqom+wVNdqCt81f2A@mail.gmail.com>
 <CADBMgpy3e25EH5xbKMN5GeOK47jE6uzviknbt35V49_Y7zFj8A@mail.gmail.com>
 <CAPhsuW6p3YOv3_M_c0ThMcrNqNjT=7i46ekJBrWO_oGzQkxrxA@mail.gmail.com>
 <CALOAHbCbcw2jpjk9JD9yyf+SMpQ-s9FAonSaz7Gs4XUeP+w+2g@mail.gmail.com>
 <CAPhsuW4B00-grg9XJa+AO3xgGwM_u8FC+GH3JrkYZOJx4PuV8Q@mail.gmail.com>
 <adQhpBC2W9I6QW-g@redhat.com> <CAPhsuW66tuF+QZ0pVheWb5sC4NQ-9CXikq=zMrPBXTHcsVPjdg@mail.gmail.com>
In-Reply-To: <CAPhsuW66tuF+QZ0pVheWb5sC4NQ-9CXikq=zMrPBXTHcsVPjdg@mail.gmail.com>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Tue, 7 Apr 2026 11:16:56 +0800
X-Gm-Features: AQROBzAxg6OOezCNjm_WO_2NQj3cYCfJeAVYvX9rzsZKOm4J2VwnmP_iFBuGkkQ
Message-ID: <CALOAHbDN_t-ZRO0g9_sQFCv0J6SPDFfwJCcwSzd4ww5XRkU0QA@mail.gmail.com>
Subject: Re: [RFC PATCH 3/4] livepatch: Add "replaceable" attribute to klp_patch
To: Song Liu <song@kernel.org>
Cc: Joe Lawrence <joe.lawrence@redhat.com>, Dylan Hatch <dylanbhatch@google.com>, jpoimboe@kernel.org, 
	jikos@kernel.org, mbenes@suse.cz, pmladek@suse.com, rostedt@goodmis.org, 
	mhiramat@kernel.org, mathieu.desnoyers@efficios.com, kpsingh@kernel.org, 
	mattbobrowski@google.com, jolsa@kernel.org, ast@kernel.org, 
	daniel@iogearbox.net, andrii@kernel.org, martin.lau@linux.dev, 
	eddyz87@gmail.com, memxor@gmail.com, yonghong.song@linux.dev, 
	live-patching@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-2313-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[redhat.com,google.com,kernel.org,suse.cz,suse.com,goodmis.org,efficios.com,iogearbox.net,linux.dev,gmail.com,vger.kernel.org];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[24];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[laoarshao@gmail.com,live-patching@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	TAGGED_RCPT(0.00)[live-patching];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 47FB43A95DA
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Tue, Apr 7, 2026 at 10:54=E2=80=AFAM Song Liu <song@kernel.org> wrote:
>
> On Mon, Apr 6, 2026 at 2:12=E2=80=AFPM Joe Lawrence <joe.lawrence@redhat.=
com> wrote:
> [...]
> > > > > - The regular livepatches are cumulative, have the replace flag; =
and
> > > > >   are replaceable.
> > > > > - The occasional "off-band" livepatches do not have the replace f=
lag,
> > > > >   and are not replaceable.
> > > > >
> > > > > With this setup, for systems with off-band livepatches loaded, we=
 can
> > > > > still release a cumulative livepatch to replace the previous cumu=
lative
> > > > > livepatch. Is this the expected use case?
> > > >
> > > > That matches our expected use case.
> > >
> > > If we really want to serve use cases like this, I think we can introd=
uce
> > > some replace tag concept: Each livepatch will have a tag, u32 number.
> > > Newly loaded livepatch will only replace existing livepatch with the
> > > same tag. We can even reuse the existing "bool replace" in klp_patch,
> > > and make it u32: replace=3D0 means no replace; replace > 0 are the
> > > replace tag.
> > >
> > > For current users of cumulative patches, all the livepatch will have =
the
> > > same tag, say 1. For your use case, you can assign each user a
> > > unique tag. Then all these users can do atomic upgrades of their
> > > own livepatches.
> > >
> > > We may also need to check whether two livepatches of different tags
> > > touch the same kernel function. When that happens, the later
> > > livepatch should fail to load.

That sounds like a viable solution. I'll look into it and see how we
can implement it.

> > >
> > > Does this make sense?
> > >
> >
> > I haven't been following the thread carefully, but could the Livepatch
> > system state API (see Documentation/livepatch/system-state.rst) be
> > leveraged somehow instead of adding further replace semantics?
>
> AFAICT, system state will not help Yafang's use case.

Right.

--=20
Regards
Yafang

