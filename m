Return-Path: <live-patching+bounces-1168-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 13CB2A33789
	for <lists+live-patching@lfdr.de>; Thu, 13 Feb 2025 06:50:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AE81A168450
	for <lists+live-patching@lfdr.de>; Thu, 13 Feb 2025 05:49:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69992206F3E;
	Thu, 13 Feb 2025 05:49:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Bl9XPFIH"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B80E7206F22
	for <live-patching@vger.kernel.org>; Thu, 13 Feb 2025 05:49:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739425792; cv=none; b=lN3v9jeJcdasK6CIW6uf59DEsEh3picZPTPNOgIMJZ6exoeAblCfxguFUEABhrflsTqmH4BXvYaHLvw3TRRiDT+CvpvtYq56StV/pAZhUl36gBIcVBTm6fZzq1aVpkOHhDF2t7OY6ND0iEbGsnpJdmSAEujU4sDA9Q6OS2wiP40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739425792; c=relaxed/simple;
	bh=X4/hY43lBe5BOzKs2/P88v79xDm8GMSdtwyv2lBpcIk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kfN7uqTrAnrso3ntDa4bwQ7NJwQqzo5SDHiI8NSwXjSMuPjVbstuUj/6VRpu15yTHu8yaj7odrlXDSXV/sTsGNdHykby+OV5yMAABXv512wEnBIZZB7Sd6CcVR4PpAJOYrZCZAMxzHElJUX093wukNLo9Zc1E8IJa3cwHukQRdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Bl9XPFIH; arc=none smtp.client-ip=209.85.219.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-6e65be7d86fso7009086d6.1
        for <live-patching@vger.kernel.org>; Wed, 12 Feb 2025 21:49:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739425789; x=1740030589; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7ySMiB3B+dSZmEmRFzXD0kwW7pQNBbBizRWZtHLRUJ0=;
        b=Bl9XPFIH0NbZ5ATRzuquXCrPO/CgM5hx3S3Tz5soUp3JGr8X2nSvRZHlTrnICARxpB
         MxBl2a9Bf+5mao4PIO+baoxMosG8l6DRrIGcacj5419fqCi5SxjiKJ4ZSwFmVN5FZJkF
         fh10avq+CUQNmkeMc3fl3hayuMSgyI0fcBS2Dnv524A8h6ehvB1ktNKO7J99iAgASr+N
         lHnDH2yNhhICwpj1Jca1bIKg4rO0luXef1X/B0DwDGnMSapTtKRm4l8rv4x5NI7FldXV
         TIe23jgp9ldYfuURLeK8cWYlP28b/PdmCP4rYnCFNaPElo2rFsi/FwYoGU4zXfj9HXYh
         SC5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739425789; x=1740030589;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7ySMiB3B+dSZmEmRFzXD0kwW7pQNBbBizRWZtHLRUJ0=;
        b=B4Fgp1ctaBcAbsqfYZdZKgxPBt8QK0dfmo44s5rytgpyKDkmUwWy1vIWGBMLXN/TVf
         ygjp9CxVo2uKzSP1Kf6Tf/5D+o4lRt2qfUerDxkReeE0cEOC2nEkEbFm61W4w9nYrWcb
         ziF6tP4mT7wIuwpAlRYmKqZZxXHhnyAfkhoais/VFgsG+njZP+X6kHZHH+Gk4nWDWV89
         mDCVjIgJaHW34K/hL4nRSwOghVOSwSuiblBwFTE8vrvqyWlLL1fnencFRtrkEHUMTVi0
         HkVjVJLUw+84qHcMrDLbq1K0M9Xv/RD7hqPGmlddBjaT9eHYX9oyp+1v5DQLemu7Eiwe
         /jEg==
X-Forwarded-Encrypted: i=1; AJvYcCV+F9CIwhnxmQY85dIbl8BDaS6qCB48zRFf8YtBpJc1e1I7T00piqlXYM83SqNuGHUayH+DJh8RoDNTtzLS@vger.kernel.org
X-Gm-Message-State: AOJu0Yx9JYMbxtvN6z5NwhHfoXJHDNnM6jzQoURlqjSeSJQzpgxO6upd
	jg3r6JKcsZFuAJbjHh/5Aq5BZvrPKK8gO3wINTlMyRdgNEZNRSA3dYFIxOsKaz4DyJYDZsQx8f7
	lgAo0pMNwMCoTVDdZk15q80gYrxc=
X-Gm-Gg: ASbGncsuZCWhu5Ju3cOj2UVJB1Ws9mueiSIkjaArTYNAxzgZEA+DEpH4vAcdAC0jp9V
	GlxVOxOPuTbtw65vRlYixzetSwmRPFSl3lPfj9ALkDLtD2KSuQLda5v5PiA4FMwxkcns7RSSvT0
	w=
X-Google-Smtp-Source: AGHT+IGlMY2p5FMb0qBCklic0myYjveu+UawAF5MCP/36+6U5GPeQFw7YvyLA+6FQ9Dsc16VZSadzsdQbf97NqyElMQ=
X-Received: by 2002:a05:6214:20cc:b0:6e6:5a83:dcf5 with SMTP id
 6a1803df08f44-6e65c9040acmr29300546d6.21.1739425789579; Wed, 12 Feb 2025
 21:49:49 -0800 (PST)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250211062437.46811-1-laoar.shao@gmail.com> <20250211062437.46811-2-laoar.shao@gmail.com>
 <Z6yZSBxbLBktQaXP@pathway.suse.cz>
In-Reply-To: <Z6yZSBxbLBktQaXP@pathway.suse.cz>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Thu, 13 Feb 2025 13:49:13 +0800
X-Gm-Features: AWEUYZkGqd2hm3xKGfzu7_ghmR2QWMUCtKuHbJ30TNUIn_xGi1_gJrkvzSfMHZE
Message-ID: <CALOAHbCBQQkNqB2Km2nD8d9GCZfh1gM+Cd0GdD0DSaWPXKZ-mw@mail.gmail.com>
Subject: Re: [PATCH 1/3] livepatch: Add comment to clarify klp_add_nops()
To: Petr Mladek <pmladek@suse.com>
Cc: jpoimboe@kernel.org, jikos@kernel.org, mbenes@suse.cz, 
	joe.lawrence@redhat.com, live-patching@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 12, 2025 at 8:51=E2=80=AFPM Petr Mladek <pmladek@suse.com> wrot=
e:
>
> On Tue 2025-02-11 14:24:35, Yafang Shao wrote:
> > Add detailed comments to clarify the purpose of klp_add_nops() function=
.
> > These comments are based on Petr's explanation[0].
> >
> > Link: https://lore.kernel.org/all/Z6XUA7D0eU_YDMVp@pathway.suse.cz/ [0]
> > Suggested-by: Josh Poimboeuf <jpoimboe@kernel.org>
> > Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> > Cc: Petr Mladek <pmladek@suse.com>
> > ---
> >  kernel/livepatch/core.c | 3 +++
> >  1 file changed, 3 insertions(+)
> >
> > diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
> > index 0cd39954d5a1..5b2a52e7c2f6 100644
> > --- a/kernel/livepatch/core.c
> > +++ b/kernel/livepatch/core.c
> > @@ -604,6 +604,9 @@ static int klp_add_object_nops(struct klp_patch *pa=
tch,
> >   * Add 'nop' functions which simply return to the caller to run
> >   * the original function. The 'nop' functions are added to a
> >   * patch to facilitate a 'replace' mode.
> > + *
> > + * The 'nop' entries are added only for functions which are currently
> > + * livepatched but are no longer included in the new livepatch.
> >   */
>
> The new comment makes perfect sense. But I would re-shuffle the text a bi=
t
> to to make it more clear that it is used only in the 'replace' mode.
> Something like:
>
> /*
>  * Add 'nop' functions which simply return to the caller to run the origi=
nal
>  * function.
>  *
>  * They are added only when the atomic replace mode is used and only for
>  * functions which are currently livepatched but are no longer included
>  * in the new livepatch.
>  */

Thanks for your suggestion. I=E2=80=99ll make the change in the next versio=
n.

--
Regards
Yafang

