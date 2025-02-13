Return-Path: <live-patching+bounces-1169-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D37AA33792
	for <lists+live-patching@lfdr.de>; Thu, 13 Feb 2025 06:52:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B9A483A1853
	for <lists+live-patching@lfdr.de>; Thu, 13 Feb 2025 05:52:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A587206F09;
	Thu, 13 Feb 2025 05:52:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gYMvtdHB"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2DF6204F85
	for <live-patching@vger.kernel.org>; Thu, 13 Feb 2025 05:52:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739425945; cv=none; b=st5nOwOOU9KCwZKvWrtLoOWmWtr/FU5Zvv56apTeciGgWrQJJgOnfgSoNx1JjOXIGwKwiDzGlQ7oWzvmVzZFa3uhxhTEpmrTqLVs3Ip1zMU9/3clrMg+DT4H1lU59Dy/Ydu5N5WUEQdQmO9Ls3s0Gjc1Fo32elc2BbW7KqhBDOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739425945; c=relaxed/simple;
	bh=j9gxxNP8fsiPrnRxrXQlj0bPEZV2bMg1ftCbO+HL1Do=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TKDx6FO6/12AYTqQHY6QVNQf2CYfQOYOa6MeihJiphz+p+8jrriadInX4oosO1jVPEmkixL9cZKQArBOZDK10ajDJPz3xoT23GqFN78J+AUe7Gb3hTztuoTcPIKkNj8yzdm/JQ3sEYw2vHj2bbuEHYksOvDu4Wf0l4Gaw5vtLA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gYMvtdHB; arc=none smtp.client-ip=209.85.219.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-6e41e18137bso4801046d6.1
        for <live-patching@vger.kernel.org>; Wed, 12 Feb 2025 21:52:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739425942; x=1740030742; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c/So+eA3NaNTQ/l4Kc9O3OFwA7bJxQieD/89HFvFz3Y=;
        b=gYMvtdHBz+bd1WZBI1l1wU/0QhlcE46qdd2FDa9QkNM5gQ4GP7qa1oFrOCtJUhltHO
         ky0S0oEBzfQIXHLun04jFCYfv5AkI0eX0YjqGvGn53yhZnteSywkaNWO6fn3ZZlju5Xi
         rRLZkPuMzg75J1VmuQMWcUjcNr9spp3PRbltF6af8+4bhNnv8h04QWwQr1iFPCRPuwb2
         XY3px3GYZ3Sz1kbReuWI6+LJa+XjEMV4/OI6Wx6pm94B8Cu13SCTsvlGXN8EMp+SJNEH
         5jgr+nW+hCz946zbWXO6ylPJyEVmLtOMPGK4ldEaNNB8/NVmmB7A1Xi5IkP7pOegCjCb
         cN8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739425942; x=1740030742;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=c/So+eA3NaNTQ/l4Kc9O3OFwA7bJxQieD/89HFvFz3Y=;
        b=WbrK1n1BlcMDfONoc6YrvgIvhVMpKp3vjsdAoJS/Sm3Z7oCkSwiGRSYPo2wd5c296+
         RywTBvF8KtFrETL7YL4eUu3K2gsxd5dxala/1Dd6m94d3XZ6UHLtJxdHmLW+a82k0FN4
         8PiBbkUwlWmenh4V9sjtzGhFa37IcjRtJ86AuP4qxl6usnKgLbwLWvKtP+ZCIHzZ9+7F
         xANP2JpoOSWUReE9tZlWMm9J9dkFInSeb4Hknc1yRN3pr/GelQ1Fp4KYmDxsxrZJ31+i
         gcd/Z7sW6pP4HpsrBm7mI790Uh2hLPQLNtxKKjJq5wMNjqlJdCvri+I4W77klO8IwcdB
         jxkQ==
X-Forwarded-Encrypted: i=1; AJvYcCV/sfJ+DtsXUr72rViywuLTCurCxOt9QzbvUyVomRNtHGV5pgNc2BlKw/+cdvMPKOZ4NcDBAQ51xrh75UuP@vger.kernel.org
X-Gm-Message-State: AOJu0YzEx0DKAoIIhZ6qSUDP6QFDxGjfrPMrkDqyE2QljbnV12Cgegh6
	ym6EcF1Xr8/agn/DqlBQesSHg2vDWv0Xif2p83ADowqtMQbwH/Ei95+Mknm6pb7nYcxO+re9uw6
	X7/1bk3EWZJ/JXOcKhzoPTX5uOhI=
X-Gm-Gg: ASbGncvIIgUfW1VJMi83MOeiO2LWLlQSANjOUr8bGMIoySOM4YhVMmJIF8x1/yXVQ0U
	ySJFVXemGK75BjT9hs1rESqtrgFEBWOBcgNlQlcim6uDN3EiRuNy7w9DIE5cAcXhaM7XyNpfXdC
	w=
X-Google-Smtp-Source: AGHT+IF2wXCL+/04TEuXi+A+oZ2Clzxmgk8TtO1cwcbXG016NPxABj73Bre2EcbWWhMnKqVpAOiJR69e4ugnSHZ35pc=
X-Received: by 2002:a05:6214:d4b:b0:6d8:a5da:3aba with SMTP id
 6a1803df08f44-6e46ed8a83emr103877496d6.20.1739425942590; Wed, 12 Feb 2025
 21:52:22 -0800 (PST)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250211062437.46811-1-laoar.shao@gmail.com> <20250211062437.46811-4-laoar.shao@gmail.com>
 <20250212005253.4d6wru5lsrvxch45@jpoimboe> <CALOAHbBZ6JGu=39ifyW9Jf8bUwpcBMhr2oe2K2K+wK8VFWo7QA@mail.gmail.com>
 <20250213015852.gtsfdwsz4on3i4x2@jpoimboe>
In-Reply-To: <20250213015852.gtsfdwsz4on3i4x2@jpoimboe>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Thu, 13 Feb 2025 13:51:46 +0800
X-Gm-Features: AWEUYZm7N4cO84GoijB23tPgSEjYSRDkISn3fYHmooMspO-y4T4upNovmv5zHvo
Message-ID: <CALOAHbAFLaw2k-66W5hTKKD-c82sYpew=AmDoOTZGYbFTVDkaQ@mail.gmail.com>
Subject: Re: [PATCH 3/3] livepatch: Avoid potential RCU stalls in klp transition
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: jikos@kernel.org, mbenes@suse.cz, pmladek@suse.com, 
	joe.lawrence@redhat.com, live-patching@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 13, 2025 at 9:58=E2=80=AFAM Josh Poimboeuf <jpoimboe@kernel.org=
> wrote:
>
> On Wed, Feb 12, 2025 at 10:42:33AM +0800, Yafang Shao wrote:
> > On Wed, Feb 12, 2025 at 8:52=E2=80=AFAM Josh Poimboeuf <jpoimboe@kernel=
.org> wrote:
> > >
> > > On Tue, Feb 11, 2025 at 02:24:37PM +0800, Yafang Shao wrote:
> > > > +++ b/kernel/livepatch/transition.c
> > > > @@ -491,9 +491,18 @@ void klp_try_complete_transition(void)
> > > >                       complete =3D false;
> > > >                       break;
> > > >               }
> > > > +
> > > > +             /* Avoid potential RCU stalls */
> > > > +             if (need_resched()) {
> > > > +                     complete =3D false;
> > > > +                     break;
> > > > +             }
> > > >       }
> > > >       read_unlock(&tasklist_lock);
> > > >
> > > > +     /* The above operation might be expensive. */
> > > > +     cond_resched();
> > > > +
> > >
> > > This is also nasty, yet another reason to use rcu_read_lock() if we c=
an.
> >
> > The RCU stalls still happen even if we use rcu_read_lock() as it is
> > still in the RCU read-side critical section.
> >
> > >
> > > Also, with the new lazy preemption model, I believe cond_resched() is
> > > pretty much deprecated.
> >
> > I'm not familiar with the newly introduced PREEMPT_LAZY, but it
> > appears to be a configuration option. Therefore, we still need this
> > cond_resched() for users who don't have PREEMPT_LAZY set as the
> > default.
>
> IIRC, the goal is to get rid of PREEMPT_NONE and PREEMPT_VOLUNTARY (and
> PREEMPT_DYNAMIC) and to remove almost all the cond_resched() calls.  So
> we should really avoid adding them at this point.
>
> The patch already breaks out of the loop for need_resched(), is the
> cond_resched() really needed there?  For the PREEMPT_VOLUNTARY case I
> think it should already get preempted anyway when it releases the lock.
>
> And regardless, by that point it's fairly close to scheduling the
> delayed work and returning back to the user.  That could happen even
> sooner by skipping the "swapper" task loop.

You're correct. I=E2=80=99ve verified that it can avoid the RCU stalls even
without the cond_resched().

--=20
Regards
Yafang

