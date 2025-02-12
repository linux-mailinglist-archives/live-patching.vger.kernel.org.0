Return-Path: <live-patching+bounces-1154-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B9169A31C39
	for <lists+live-patching@lfdr.de>; Wed, 12 Feb 2025 03:43:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5F2D0188B73D
	for <lists+live-patching@lfdr.de>; Wed, 12 Feb 2025 02:43:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73CDE1DC075;
	Wed, 12 Feb 2025 02:43:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Xb6j9SSc"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD8781D54D8
	for <live-patching@vger.kernel.org>; Wed, 12 Feb 2025 02:43:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739328192; cv=none; b=UhsWNAvufDPA0upOwdcYibx7VIcKtHwV7DHTrue1ZtxYe2qwB6hb1//ae+gZGebtNFK34/pCR7YeMxcIbrDyvNl+YXNGdw005J9NufxlJc4CedAr0RG6YRIHWT2dublq/eXvp3SbOuj86drV1AXHx0Kdl3ynS8FKmR255CZVNyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739328192; c=relaxed/simple;
	bh=BfraGQZiomuxijNFcJ4mECDv1Qjj1Ov6Shj1nt9PkyY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HYdzNCCX+r9Y7euY71mEWV1JAGkjzibZWS4doeUinwc3YxxXQj5SXjKMtok6DFjgb4yTu+A/PyMEACmOf1Ysr7XlHftV+juv/g4cJBBMPWHwz2+MsMtQZyx7znnzeNsWPmZVaaWCO5WTaV8b5FYW+tKzHthCjzv5d2UXs9gvP9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Xb6j9SSc; arc=none smtp.client-ip=209.85.219.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-6df83fd01cbso30749466d6.2
        for <live-patching@vger.kernel.org>; Tue, 11 Feb 2025 18:43:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739328189; x=1739932989; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HF2KK4tGKpMkkEiYWTfUwWssl7bNyTNr1bhMTJUJ9h0=;
        b=Xb6j9SSc7GAN9MfnIARrdIgQdUjwiRPr/4Oy7ynlnXV+uDhPfnTf3vhqlYfkUQ1WlP
         ZK6l7XpRHgDUQ858RAuWkxdGPloSYStTvzJItYAFDk4J+p+m0scN7eKPE4lvnYezw1ns
         acJPWxswWqFaxi1zYhOxpKWgN/MIEW05c2E7kdAq4Vlel0zeb18uXRpeGXpn07cv/Kj3
         dgxwvzPeD50eb6F1PvTyhPUBiFBosuhNxHL8FRaeuuitm9ZM72LHUgtyUuUg7KQrmahp
         zyRonUj+e5HUr45nj2Gywld+ilEA4PJi84ee9KskQeEeIpyc3eQ0oW1Djq0qQAg/wWgB
         odsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739328189; x=1739932989;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HF2KK4tGKpMkkEiYWTfUwWssl7bNyTNr1bhMTJUJ9h0=;
        b=gGRzixrutYJVEIYrpaZyyqrUn3ft5A50a+5sFRLu6ANRX734Ufyirh7QuVxXX7MCW4
         JnX1wi9aDt6QrPBvvkKfVXhbByvo80BqxxTxb1ZnYu0gq6UouBxFSkXgPO11Qw8Lx/WA
         UzpqwikfxWiwDkBe/s8tkwj0iz+AsoH34tNizvRIZ6+JIF1itlgNQxiA8EUNch/cU+lr
         A7F8wscBFimkKFpyvjlJFxcFrLK2LxJyDoIXCns+TRxWk1twVb2uhn4X5R3xPZiRkqJq
         XkV8MpouixDjq293QSCu/749JY1XGYlwSsGLvBrw1gh/VGIshutGnpZ1aekReLS8BQyO
         y0AA==
X-Forwarded-Encrypted: i=1; AJvYcCXjeOkfYAZP8IGmAIl8H+kkF6887c1UUaGpSJuU/xuV2gObW7Gto0zONrrG/+SK4pkRl0OEo0YoNIRPjX4I@vger.kernel.org
X-Gm-Message-State: AOJu0YzWG2KJeAEJZ9KjUh8ywu0n6iEh3Sk1hCQNOeLO2dVSwZdo8/97
	X+43Enc1Ty+oJu5XMeRshG7n94+nbSRICAlB5KtdlK5JPUY4dT9HbRzqGyuCFeLvZAhYeQdff2D
	tKpoVfQHDwDimKYFyrneN6umczJ0=
X-Gm-Gg: ASbGncu2qrae90q8SIp+b2OLoUFwJZMVpcN4Dw8qHp4rNqAqEqZgZWC6kW7CWDpSvg+
	84O4t35kIvat3DJH/d/d40oFa9w+kMS3/y+zm4CvBm/jQUM8XXJc12nrSQg12zV6NzjOgj/urN/
	M=
X-Google-Smtp-Source: AGHT+IHEnUkOdcFCEvKy5IJAxPLo+7CjcJ6TBlGH4e3I0wjNtQqYDdgpnB2SLLP+vHO9ZqI9mQCWbr9+ke4GZpaZ0vU=
X-Received: by 2002:a05:6214:4013:b0:6d8:850a:4d77 with SMTP id
 6a1803df08f44-6e46ed77f20mr33196326d6.7.1739328189674; Tue, 11 Feb 2025
 18:43:09 -0800 (PST)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250211062437.46811-1-laoar.shao@gmail.com> <20250211062437.46811-4-laoar.shao@gmail.com>
 <20250212005253.4d6wru5lsrvxch45@jpoimboe>
In-Reply-To: <20250212005253.4d6wru5lsrvxch45@jpoimboe>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Wed, 12 Feb 2025 10:42:33 +0800
X-Gm-Features: AWEUYZmtIKQNGtUq51L9S9OQvm2N_gOz-renZWkTde3e9Y-iyY-yD2H1sx28Guc
Message-ID: <CALOAHbBZ6JGu=39ifyW9Jf8bUwpcBMhr2oe2K2K+wK8VFWo7QA@mail.gmail.com>
Subject: Re: [PATCH 3/3] livepatch: Avoid potential RCU stalls in klp transition
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: jikos@kernel.org, mbenes@suse.cz, pmladek@suse.com, 
	joe.lawrence@redhat.com, live-patching@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 12, 2025 at 8:52=E2=80=AFAM Josh Poimboeuf <jpoimboe@kernel.org=
> wrote:
>
> On Tue, Feb 11, 2025 at 02:24:37PM +0800, Yafang Shao wrote:
> > +++ b/kernel/livepatch/transition.c
> > @@ -491,9 +491,18 @@ void klp_try_complete_transition(void)
> >                       complete =3D false;
> >                       break;
> >               }
> > +
> > +             /* Avoid potential RCU stalls */
> > +             if (need_resched()) {
> > +                     complete =3D false;
> > +                     break;
> > +             }
> >       }
> >       read_unlock(&tasklist_lock);
> >
> > +     /* The above operation might be expensive. */
> > +     cond_resched();
> > +
>
> This is also nasty, yet another reason to use rcu_read_lock() if we can.

The RCU stalls still happen even if we use rcu_read_lock() as it is
still in the RCU read-side critical section.

>
> Also, with the new lazy preemption model, I believe cond_resched() is
> pretty much deprecated.

I'm not familiar with the newly introduced PREEMPT_LAZY, but it
appears to be a configuration option. Therefore, we still need this
cond_resched() for users who don't have PREEMPT_LAZY set as the
default.

>
> Also, for future patch sets, please also add lkml to cc.  Thanks.

Sure.

--
Regards
Yafang

