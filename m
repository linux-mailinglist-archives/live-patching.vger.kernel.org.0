Return-Path: <live-patching+bounces-2330-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yNJVHp6L22nuDAkAu9opvQ
	(envelope-from <live-patching+bounces-2330-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Sun, 12 Apr 2026 14:10:06 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 0AAB83E3B81
	for <lists+live-patching@lfdr.de>; Sun, 12 Apr 2026 14:10:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7D8ED3006178
	for <lists+live-patching@lfdr.de>; Sun, 12 Apr 2026 12:09:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6185337B015;
	Sun, 12 Apr 2026 12:09:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jrduKbKu"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-yw1-f179.google.com (mail-yw1-f179.google.com [209.85.128.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01A183783DB
	for <live-patching@vger.kernel.org>; Sun, 12 Apr 2026 12:09:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.179
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775995797; cv=pass; b=Z1HjvZU35V8AP/BQC5W3eTJHUgvygOs1+D3j8J4/cbFW15vpqXMupshFxgdrUx60WUXBQhDs3mLWyq/cXeWwVUWnAGoqhiO9N9Yp0QECVjbZDl0A30j9F/nyHiBe9GhF8z3xAmM+hd6fRo4yl5J8HTR8Ww+Fw8dl2cZ1LBCMVL8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775995797; c=relaxed/simple;
	bh=SVTNVJLn1VqDWx0HDz8tbsYxcEIfkMoVv4id3LOHg7s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fDi0cijOb2o4jHTwWn3pYLLtbxxS3gVMtj3oZYo7jWcspdeEg01Wz3gAAQU1IdbTIjTOsxYMMWSHXZTzaXSdMulVwgW+poYMPQEVhcfQcfH+atKASeh1Tmzt1sm9BfLG+gHuu4JQ7698A5TnPTifJzQMJgV1HgRzN4BPRGCOOSI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jrduKbKu; arc=pass smtp.client-ip=209.85.128.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yw1-f179.google.com with SMTP id 00721157ae682-79cd8f8e261so21595527b3.3
        for <live-patching@vger.kernel.org>; Sun, 12 Apr 2026 05:09:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775995795; cv=none;
        d=google.com; s=arc-20240605;
        b=kozka6WW6fScU14sdEnvJlosWZ5Q4+reXbWaQgxU6fFkSrkUBjWTUOufW9yh7V9Kjm
         /skcgzeEavly9HQ2mBmuoSBv2tU1qBYlvP6wqtPDrbdwKbCOIQk5Rx7biFei88zjXTvU
         RjyJdVdDPUNpAQAs7/oek/SEamkHoWI0qDI5Jh6O7BBSnhu/C5mZ3aU63jy15ntmMNVg
         DDm2QHVshfupWOTxRh+9lquD7/pp+6biZL3V2sbcEvvbWmhuqMoS0hrFfsA/1OSxVWxX
         sdwotxyqvuKdZNDou71qyZqqhYbRnVOqG5nxI3OVn+rSMW+lVxcTzkfHdVZPv/B3dWzV
         Lqrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=3yi7Jufl9MZ6r9E9T+DntWdpQRPYoo/vSgS2eY9Rp+c=;
        fh=s8iZ21UYYTraGwYLAvxSLqxAAaQemwOfjziq6/H/LDs=;
        b=WqkkVu/BRKD4P5D6Pqib3HtQ6dFMf/apvvJCCmcjf2WZKx6L2WtbWlKik3d1zTSKZ+
         pHkSZ35dZXxomlj4n9o6t0wpb3yuNYJvEmdJZZBsSCkIFeCL/344cAqdbdJrbdiV0ODs
         mGe/AUQjEPaXNf23pWG3lE+H7d3PIkmUw6WhXRMaybmYe8nbi1B8UiLK+5+yFfMB6x0+
         JGHPuf+tKSidIOj7bLlTMq47dD2AkLtt9p9OWwB7VMEDsEC4ts6GDiPiFO4W6dyZv4sR
         M38qBn8bJXQ/TTFhFTXBbiREQ1tEn7QMXhf1TeRAtk7XuLpIzdo0YhNwtYBSWxH7uc8z
         hz5Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775995795; x=1776600595; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3yi7Jufl9MZ6r9E9T+DntWdpQRPYoo/vSgS2eY9Rp+c=;
        b=jrduKbKucOJ0CrdEhOzQjksun3glLXXyDIsHC29QDod3cu+as1tdU/z//zLc3j771F
         Ww0mpRkjrNeekX5PJhDel6R4DMkc6Ea5uPdNN8QAEvd2w2v9BWeqEgh81fUyMRKCYoaz
         PKjzJ1ADdJLkpXk9OsWoHjE4qpRTULett3nyv/g16kMfC/HsuxD/CBtq7KDTa/Q50WfX
         IGmN9R4IaIlJhNnocOiKpGnjeqM6Ob+Ym6X/+JxHmIEuW+GzceECvAJan3e9NKQ5tB8t
         4SnhUenVs+FFcdLic6qX9rVRaofoOzUPQ6B4l5TAYm2AmbSyukIT2c/v4XbvLqPuvyd4
         SlhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775995795; x=1776600595;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3yi7Jufl9MZ6r9E9T+DntWdpQRPYoo/vSgS2eY9Rp+c=;
        b=dgIAKxnhemlE4c0WqNStrykjNlqGXViB0ZVo4kwjN32Ne8S9sIlJK0oaUZ+cvdAqzK
         GHZGhdLfE2qurn/sFJ+lBf5q/UVMkCd3bfGG3bHk0UyVRIqEVYokJxlBEBfSD5bQxwYt
         1Ki9CxEAp6d0P00X52q6aZ44EyrBtF2Ejr5yVdsWFAsHvdwcKaIUpfCfb0A2b+DhMwJG
         mjTV4d/oC+GULuMnOkElT//OoTUdef1tqkGE/gnxoLXtHRQYJxeNF7S35f8F9jipL/+f
         cqT3XE2GSVlh2QL2D+WPLpLZa+aY+7pugkh+fMzsT2AHQsu8m2ckOHfBabnx11zHCz8e
         8cng==
X-Forwarded-Encrypted: i=1; AFNElJ8pPRyWPWS/euwpF5694MRlB/jaE3SQUc/c6I90KIsMbyR75Lp/F4nuzEj/f3/wCdgZwlE6+2M3cPv5xnTi@vger.kernel.org
X-Gm-Message-State: AOJu0YwDFt0qXYWKcGUuo83pZfIZHm4W0gKs9rXEfOgL7O+YXHpySTwu
	WW7kqd9Y5Z7VDJ6dhNNx6+BSol7HfmOl2YmNLESwd/qCrSHPDn0Dlz/m0zJVkWBgLcZsDtIIKbE
	OoqxCHINW5si5s8UQFUGiA7qHGCbmfHg=
X-Gm-Gg: AeBDievytdsMLgAD4elGH5elah4Hwqizp2/3qdL/TgfKwD2K3o6Xn06hr4FgGDc3ICI
	MlndG2HkNEq/3Iw5njtcYpy5cmUGj92UviOzb+Gl1vwH8szgiT+XMTWl1s/GeqMdfk2knPQ7ACx
	lMIecyYGqtxttLqITeCEmSRL3HrjUg4VMAfBbZTz0MyC+IbQ3tPeI+OubKVbmKb+bkuf5PYdLQu
	F6cjDAazgVxksvRxP3lWyVW6y7RkAqGeH3HO4kgQYtFk0HQYB97TkXjNCFqu6OjzldZx1vzjm3/
	oM1MhLYqMgpP4JcuKGTubJbOjtCNMUj35RHV6y1Q
X-Received: by 2002:a05:690c:dc3:b0:79a:cc64:886e with SMTP id
 00721157ae682-7af7282b96bmr107487127b3.52.1775995794798; Sun, 12 Apr 2026
 05:09:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CADBMgpy3e25EH5xbKMN5GeOK47jE6uzviknbt35V49_Y7zFj8A@mail.gmail.com>
 <CAPhsuW6p3YOv3_M_c0ThMcrNqNjT=7i46ekJBrWO_oGzQkxrxA@mail.gmail.com>
 <CALOAHbCbcw2jpjk9JD9yyf+SMpQ-s9FAonSaz7Gs4XUeP+w+2g@mail.gmail.com>
 <CAPhsuW4B00-grg9XJa+AO3xgGwM_u8FC+GH3JrkYZOJx4PuV8Q@mail.gmail.com>
 <adQhpBC2W9I6QW-g@redhat.com> <CAPhsuW66tuF+QZ0pVheWb5sC4NQ-9CXikq=zMrPBXTHcsVPjdg@mail.gmail.com>
 <CALOAHbDN_t-ZRO0g9_sQFCv0J6SPDFfwJCcwSzd4ww5XRkU0QA@mail.gmail.com>
 <CALOAHbCxPA0dtsx7L2kYn8wwBdM=krZyOpfRTBiDW9qfA_zmzQ@mail.gmail.com>
 <adUd0Mojbtrwmeod@pathway.suse.cz> <CALOAHbDG9mq1iJv5suct=cqJ+2r8VvJ-dXN=nuvMw0XYqnUjxA@mail.gmail.com>
 <adY_WgA54CDtWBq6@pathway.suse.cz>
In-Reply-To: <adY_WgA54CDtWBq6@pathway.suse.cz>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Sun, 12 Apr 2026 20:09:18 +0800
X-Gm-Features: AQROBzCu-w_ClAxqsNaksL5y_dXr6lYJTZQFfWsBZznnXM9_LWPtoFPm4-st89c
Message-ID: <CALOAHbB8Kt-RTVUcy66Bx__Bqu_YWKjgJoRBRNTGXk=CNmXGPQ@mail.gmail.com>
Subject: Re: [RFC PATCH 3/4] livepatch: Add "replaceable" attribute to klp_patch
To: Petr Mladek <pmladek@suse.com>
Cc: Song Liu <song@kernel.org>, Joe Lawrence <joe.lawrence@redhat.com>, 
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
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-2330-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[kernel.org,redhat.com,google.com,suse.cz,goodmis.org,efficios.com,iogearbox.net,linux.dev,gmail.com,vger.kernel.org];
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
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[live-patching];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,mail.gmail.com:mid]
X-Rspamd-Queue-Id: 0AAB83E3B81
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Wed, Apr 8, 2026 at 7:43=E2=80=AFPM Petr Mladek <pmladek@suse.com> wrote=
:
>
> On Wed 2026-04-08 10:40:10, Yafang Shao wrote:
> > On Tue, Apr 7, 2026 at 11:08=E2=80=AFPM Petr Mladek <pmladek@suse.com> =
wrote:
> > >
> > > On Tue 2026-04-07 17:45:31, Yafang Shao wrote:
> > > > On Tue, Apr 7, 2026 at 11:16=E2=80=AFAM Yafang Shao <laoar.shao@gma=
il.com> wrote:
> > > > >
> > > > > On Tue, Apr 7, 2026 at 10:54=E2=80=AFAM Song Liu <song@kernel.org=
> wrote:
> > > > > >
> > > > > > On Mon, Apr 6, 2026 at 2:12=E2=80=AFPM Joe Lawrence <joe.lawren=
ce@redhat.com> wrote:
> > > > > > [...]
> > > > > > > > > > - The regular livepatches are cumulative, have the repl=
ace flag; and
> > > > > > > > > >   are replaceable.
> > > > > > > > > > - The occasional "off-band" livepatches do not have the=
 replace flag,
> > > > > > > > > >   and are not replaceable.
> > > > > > > > > >
> > > > > > > > > > With this setup, for systems with off-band livepatches =
loaded, we can
> > > > > > > > > > still release a cumulative livepatch to replace the pre=
vious cumulative
> > > > > > > > > > livepatch. Is this the expected use case?
> > > > > > > > >
> > > > > > > > > That matches our expected use case.
> > > > > > > >
> > > > > > > > If we really want to serve use cases like this, I think we =
can introduce
> > > > > > > > some replace tag concept: Each livepatch will have a tag, u=
32 number.
> > > > > > > > Newly loaded livepatch will only replace existing livepatch=
 with the
> > > > > > > > same tag. We can even reuse the existing "bool replace" in =
klp_patch,
> > > > > > > > and make it u32: replace=3D0 means no replace; replace > 0 =
are the
> > > > > > > > replace tag.
> > > > > > > >
> > > > > > > > For current users of cumulative patches, all the livepatch =
will have the
> > > > > > > > same tag, say 1. For your use case, you can assign each use=
r a
> > > > > > > > unique tag. Then all these users can do atomic upgrades of =
their
> > > > > > > > own livepatches.
> > > > > > > >
> > > > > > > > We may also need to check whether two livepatches of differ=
ent tags
> > > > > > > > touch the same kernel function. When that happens, the late=
r
> > > > > > > > livepatch should fail to load.
> > >
> > > I still think how to make the hybrid mode more secure:
> > >
> > >     + The isolated sets of livepatched functions look like a good rul=
e.
> > >     + What about isolating the shadow variables/states as well?
> >
> > We might consider extending the klp_shadow_* API to support the new
> > livepatch tag.
>
> It would be nice to associate shadow variables with states so that
> we could check which shadow variables are used by each livepatch.
>
> It is partially implemented in my earlier RFC, see
> https://lore.kernel.org/all/20250115082431.5550-3-pmladek@suse.com/

This patch is still pending acceptance, but it offers a nice
improvement. With your modifications, the remaining task would be to
integrate a new replace_set into klp_state and update the API
accordingly

[...]

--=20
Regards
Yafang

