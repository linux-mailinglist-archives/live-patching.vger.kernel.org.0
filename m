Return-Path: <live-patching+bounces-366-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 47867915C21
	for <lists+live-patching@lfdr.de>; Tue, 25 Jun 2024 04:17:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EA7B8284E4F
	for <lists+live-patching@lfdr.de>; Tue, 25 Jun 2024 02:17:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C6C32E83F;
	Tue, 25 Jun 2024 02:17:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fA4NlU5R"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75C3918E1F
	for <live-patching@vger.kernel.org>; Tue, 25 Jun 2024 02:16:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719281821; cv=none; b=eYyWuC+GFMZMvVSw8TDwXsYaZ1uSMkNHQ07LHQ02WG/9iurJMSjNojqupTFIb/dWydMw3f2hy9LwHx3XbrGDxTg6IrVICYiTeL4NiKWOYyFAaGCWY1RW3TiBlbj8FqQEu4vKcQSN5MAuOPvCF+9RirwOhtEO5f9o246jO/cGd3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719281821; c=relaxed/simple;
	bh=9LfLVfiocMzSvaLF8tEEIaDMMxJziWiig1Qkl62Jb24=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Dgpy5102MreQlfZMXKwn1XQiAnnuXxDmwW1IQtn33EJtOAllxErC75AAaY3ZfDVD1jIRukeIPX569KaIwAFdamq8/nKfLE9q9N0h3qgETYyXv7fY8S7omR5FPTxaaxE1g1jzoDwRWcCjJaK+MMUBefI/U9LdLnVy6TX3YpZb3Sc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fA4NlU5R; arc=none smtp.client-ip=209.85.222.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-79c056a7d4eso6875685a.2
        for <live-patching@vger.kernel.org>; Mon, 24 Jun 2024 19:16:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1719281818; x=1719886618; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vONck8ZhDb6MPPS7J7rMvRu+N440Ak4RPQbckX/gTXs=;
        b=fA4NlU5RdQr8AIoydVFVeLW1VqZWm/BfFdsWskSO7e8Cq3dL9lJg6iTcVl5BiDqufK
         wDG229Mzu7XPIqfAXX79WPZBhN14lTjN5Z8b+Wkaru0iULC8aLKCcIIQFbXCrNlTc/5O
         8wmW7C2LFci3xEdce/okqPM8inY4FMeyubidBg1bnV1LRHLpK/dr5kMTAv+nnvNSTgXP
         IDOt/SvABsvmv7TPYZx0vW0n/vCYc9DL7QqKEd8GVEkRBkSYD5h46q6fYC5OURDyjn3n
         oZUv/TiV6kp8KzG9hDR6us80H9yE8cXsZqE2DD7FZQCKAQ4vTveL6kLqTB2M3q71LpCn
         NR1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719281818; x=1719886618;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vONck8ZhDb6MPPS7J7rMvRu+N440Ak4RPQbckX/gTXs=;
        b=Qji49umLSTq5dGXVSPjhRdjOKMo2OKymkl73NdicokyxUugCxgykpbx95lE30uzQJt
         e39rdC7RJuNA7kvTHnx+FsFP4JEuvX3Yvghf+GpnMB8I/hsJaHODZPcmVQNiBGsWiGVb
         m/DLln0P5N5EX6+9I8TVHhXwcoZLJEcQKHQGdsQakEu6P3HuJS+VND99a2dU9Uqlrx+V
         apUFHKy1MpHnR6aHzesjTmWnP74slIWNXrD0XDbitp/8QZpg4747z0mD4TeBFiK+aYgg
         e2gzHatfYhwZ/lfIP4FmCx4W3L/MGieQt+D80YQn8J8U/bKmrUNs7NNt5grKICeP2dHs
         78Aw==
X-Forwarded-Encrypted: i=1; AJvYcCWnLZBjlDP37YWBbuFzQV5HietmokMOaYxHyGas5Bj42qeyqgWjLkVoHqxeatPpWw7N3AvlypL3ipPD21PHfALLzHCq9SZ6qfcks8Zumg==
X-Gm-Message-State: AOJu0Yzci3r8qSKz7YbHwM75zd9QWRhnblgv6Px5gYC7kv3EHgtRGsTD
	4/ZcfT6f6R0rQkfP4nqHg6UahlVzsKyApYMBm03ogO22vjwj84iUFBdM9Ux/Mo8F2W1g/NySmF5
	+jSxSNT7BisbmUDXRm6MoECh/fww=
X-Google-Smtp-Source: AGHT+IHSdoTcsQZK+F8okRBg3rcHW0RlOWqFVhxMClJ6ageyeKkrGnYYhMtJBVH5Sd+pp9xYYmyGa6hXZ849o7BtRM0=
X-Received: by 2002:ad4:44a9:0:b0:6b4:dd2a:aa44 with SMTP id
 6a1803df08f44-6b53bbd1232mr71089606d6.37.1719281818408; Mon, 24 Jun 2024
 19:16:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240610013237.92646-1-laoar.shao@gmail.com> <CAPhsuW6MB8MgCtttk2QZDCF0Wu-r0c47kVk=a9o1_VUDPHOjVw@mail.gmail.com>
 <CALOAHbDPXDZQJENvN-yZM-OyrTy94kE6wMLGHt83m_y3O23bRQ@mail.gmail.com>
 <ZnUsYf1-Ue59Fjru@pathway.suse.cz> <CALOAHbByr3UMy=xzP82LA=D3rW-uw+s3XfzHQMVYxu4RomAANg@mail.gmail.com>
 <ZnVQJEoXpaONuTNE@pathway.suse.cz> <CALOAHbALyUdQqvjEiZ+2=3HaAyY94UL5ZTLT0ZzNPJH-vv=3GQ@mail.gmail.com>
 <Znl885YvzfHFH_GF@pathway.suse.cz>
In-Reply-To: <Znl885YvzfHFH_GF@pathway.suse.cz>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Tue, 25 Jun 2024 10:16:21 +0800
Message-ID: <CALOAHbBFsnzd5_2cP_=9_vwifzgUD33cNA8apiWQs-70VP+U=g@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] livepatch: Add "replace" sysfs attribute
To: Petr Mladek <pmladek@suse.com>
Cc: Song Liu <song@kernel.org>, jpoimboe@kernel.org, jikos@kernel.org, mbenes@suse.cz, 
	joe.lawrence@redhat.com, live-patching@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 24, 2024 at 10:04=E2=80=AFPM Petr Mladek <pmladek@suse.com> wro=
te:
>
> On Sun 2024-06-23 10:52:40, Yafang Shao wrote:
> > On Fri, Jun 21, 2024 at 6:04=E2=80=AFPM Petr Mladek <pmladek@suse.com> =
wrote:
> > > On Fri 2024-06-21 16:39:40, Yafang Shao wrote:
> > > > On Fri, Jun 21, 2024 at 3:31=E2=80=AFPM Petr Mladek <pmladek@suse.c=
om> wrote:
> > > > > On Tue 2024-06-11 10:46:47, Yafang Shao wrote:
> > > > > > On Tue, Jun 11, 2024 at 1:19=E2=80=AFAM Song Liu <song@kernel.o=
rg> wrote:
> > > > > > > On Sun, Jun 9, 2024 at 6:33=E2=80=AFPM Yafang Shao <laoar.sha=
o@gmail.com> wrote:
> > > > They are not random live patches. Some system administrators mainta=
in
> > > > their own livepatches tailored for specific workloads or develop
> > > > livepatches for A/B testing. Our company=E2=80=99s kernel team main=
tains the
> > > > general livepatches. This worked well in the past when all livepatc=
hes
> > > > were independent. However, the situation changed when we switched f=
rom
> > > > non atomic replace livepatches to atomic replace livepatches, causi=
ng
> > > > issues due to the uncertain behavior of mixed atomic replace and no=
n
> > > > atomic replace livepatches.
> > >
> > > I think that the uncertain behavior has been even before you started
> > > using the atomic replace.
> > >
> > > How did the system administrators detect whether the livepatches were
> > > independent?
> > >
> > > It looks to me that it worked only by luck. Well, I could imagine
> > > that it has worked for a long time.
> >
> > We have a limited number of livepatches in our system, primarily
> > intended to address critical issues that could potentially cause
> > system instability. Therefore, the likelihood of conflicts between two
> > livepatches is relatively low. While I acknowledge that there is
> > indeed a potential risk involved, it is the atomic replace livepatch
> > that poses this risk.
>
> I see.
>
> > >
> > >
> > > > To address this change, we need a robust solution. One approach we
> > > > have identified is developing a CI build system for livepatches. Al=
l
> > > > livepatches must be built through this CI system, where they will
> > > > undergo CI tests to verify if they are atomic replace or not.
> > >
> > > The important part is that the livepatch authors have to see
> > > all already existing changes. They need to check that
> > > the new change would not break other livepatched code and
> > > vice versa.
> >
> > Exactly. Through this CI system, all developers have visibility into
> > all the livepatches currently running on our system.
>
> Sounds good.
>
> > > > Additionally, in our production environment, we need to ensure that
> > > > there are no non atomic replace livepatches in use. For instance, s=
ome
> > > > system administrators might still build livepatches outside of our =
CI
> > > > system. Detecting whether a single livepatch is atomic replace or n=
ot
> > > > is not easy. To simplify this, we propose adding a new sysfs attrib=
ute
> > > > to facilitate this check.
> > > >
> > > > BTW, perhaps we could introduce a new sysctl setting to forcefully
> > > > forbid all non atomic replace livepatches?
> > >
> > > I like it. This looks like the most reliable solution. Would it
> > > solve your problem.
> > >
> > > Alternative solution would be to forbid installing non-replace
> > > livepatches when there is already installed a livepatch with
> > > the atomic replace. I could imagine that we enforce this for
> > > everyone (without sysctl knob). Would this work for you?
> >
> > Perhaps we can add this sysctl knob as follows?
> >
> > kernel.livepatch.forbid_non_atomic_replace:
> >     0 - Allow non atomic replace livepatch. (Default behavior)
> >     1 - Completely forbid non atomic replace livepatch.
> >     2 - Forbid non atomic replace livepatch only if there is already
> > an atomic replace livepatch running.
>
> Feel free to send a patch if it would be useful for you.

I will do it in a separate patch.

--=20
Regards
Yafang

