Return-Path: <live-patching+bounces-364-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 26A6A914F85
	for <lists+live-patching@lfdr.de>; Mon, 24 Jun 2024 16:05:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 494F81C2119B
	for <lists+live-patching@lfdr.de>; Mon, 24 Jun 2024 14:05:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D131A14375B;
	Mon, 24 Jun 2024 14:04:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="THj41FO/"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com [209.85.208.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76ADA142E87
	for <live-patching@vger.kernel.org>; Mon, 24 Jun 2024 14:04:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719237889; cv=none; b=GjSfl0vJMi0zkres38a0+jL9oOM9pA0Uwgtq7OWirK1kP88Y87HjqvzQIW6fRuVDWxAg8+rLQ/9fQlFn0WkMxOLcTjBM6HNvERZuW4inJVp5XRh6UmuRIIJTIcgJ4Cf3KA6IQShEhicpzsMJodcPb4vvZiTm2tLNejCdIRZafuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719237889; c=relaxed/simple;
	bh=qFejyMEGQJOgD5BBqCHCiQOM35H8PtCLev4xTyUiP9s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dmJFS2LpwVQeGa9I15ZcsCQM2942Lq7nwVY8DcdsloBCjJQuOTQwoL8LxZpueOCbuWVnFlJD1rj7wm3ECR9cV4ogbH7DyHz7ckMI8YKl4s9RTOVyyJXGkZ6lmhsf2n7JQbVBLV3y4jhMJEic479GhVHyzOXhiSzA4Io9f7qFECQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=THj41FO/; arc=none smtp.client-ip=209.85.208.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-lj1-f179.google.com with SMTP id 38308e7fff4ca-2ec4eefbaf1so33001761fa.1
        for <live-patching@vger.kernel.org>; Mon, 24 Jun 2024 07:04:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1719237886; x=1719842686; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=yX6ZULcVKzwIbPb3pZMq9G0PVJ4pLRBjz2Z1tEflNag=;
        b=THj41FO/CpeJcHyukcZZmWR8JKUWU/Hqgnpz8mtUQLHOO6j5UYk6KkLQIZarHsVcRS
         OvXzQfAOrYvzQTIMFTrdtRhn8mrrXAaQRXMTUqifjPycyYZOObI8WRAGO+5Mq8Bn1aDp
         oEaKvjdjq1R4sKTKJAplao61MJoRSW2KzsyBtZQFEy8bQwiDFbLjfY8ph4N0jyJSXEtG
         OtIxU356S6z6d4d2ZsNFh29n3PoqgDJLUIXqbkYXN1MMW9tDMdP1eewx4uspzbmLG60E
         bVDWkW46wo3FZNyP/D//jRT8Qu/1Eg3OJ0JBQHI9em5IcrzV1AVwjknJ8StQ6pe2ugHO
         qwkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719237886; x=1719842686;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yX6ZULcVKzwIbPb3pZMq9G0PVJ4pLRBjz2Z1tEflNag=;
        b=IDq6lHxuVdBBaPq1Pn4JWjrYPo6jC4Y7bS4cM/CJ4l5tWE2mTQvGeYGeF68OYYP7N/
         b0sTIPvRYhTFI3LsAGutbZbYFTxhgyl9BmNqXuYsrMDenU3h6TrMzEYuZCTA2uuctwpP
         fjkJsuzLgT9ssguKKZtUD7/+ftmotTUIgeI9G7bTf1ARuBlh9zokBb2VAxNSHuCey837
         rkkgJefmT1vUnaf0ql7qoMJErU7R55X7stYU/y+nbT/K96S1RBoVHAv7dboPRmU0JLz3
         jH0ZbVjBnvQEbs6jwJw/DOGApdDzRqd2zqVrpJzeaEPrfOI3SPuGacQkKb9uTqfgO2Kr
         94Rw==
X-Forwarded-Encrypted: i=1; AJvYcCWKPiKfVVHARSkTEmcgcJuCx4g/ytmgijEdavgwwe5y5XdqtVzaRJeTAwIpD5uuL3wGHMJYMZP/5c69fCcYGD/tavwHoAb702/xfl4HUQ==
X-Gm-Message-State: AOJu0YyrC/6W6Edua57EOsH8dra+naGqX7tSNWC/tf26uNv2zBSnN89h
	YBbOkSHMgRlhakuWRe/EUyFrOG/HiEu1TA0eYgSaA/VlNDrxgCk66Gep+ls+pd8B0EBQl8pCI8s
	R
X-Google-Smtp-Source: AGHT+IE0TxLpp/yUVvoCXcdSFqr/Ix6apqnWgqD0X3ghAfqTqPuHvVov8MpREqjSxU3izdEJ3qBIOg==
X-Received: by 2002:a2e:a78f:0:b0:2ec:5de4:9083 with SMTP id 38308e7fff4ca-2ec5de49156mr29716291fa.49.1719237885627;
        Mon, 24 Jun 2024 07:04:45 -0700 (PDT)
Received: from pathway.suse.cz ([176.114.240.50])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-70675684c35sm3024846b3a.130.2024.06.24.07.04.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jun 2024 07:04:45 -0700 (PDT)
Date: Mon, 24 Jun 2024 16:04:35 +0200
From: Petr Mladek <pmladek@suse.com>
To: Yafang Shao <laoar.shao@gmail.com>
Cc: Song Liu <song@kernel.org>, jpoimboe@kernel.org, jikos@kernel.org,
	mbenes@suse.cz, joe.lawrence@redhat.com,
	live-patching@vger.kernel.org
Subject: Re: [PATCH v2 0/3] livepatch: Add "replace" sysfs attribute
Message-ID: <Znl885YvzfHFH_GF@pathway.suse.cz>
References: <20240610013237.92646-1-laoar.shao@gmail.com>
 <CAPhsuW6MB8MgCtttk2QZDCF0Wu-r0c47kVk=a9o1_VUDPHOjVw@mail.gmail.com>
 <CALOAHbDPXDZQJENvN-yZM-OyrTy94kE6wMLGHt83m_y3O23bRQ@mail.gmail.com>
 <ZnUsYf1-Ue59Fjru@pathway.suse.cz>
 <CALOAHbByr3UMy=xzP82LA=D3rW-uw+s3XfzHQMVYxu4RomAANg@mail.gmail.com>
 <ZnVQJEoXpaONuTNE@pathway.suse.cz>
 <CALOAHbALyUdQqvjEiZ+2=3HaAyY94UL5ZTLT0ZzNPJH-vv=3GQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALOAHbALyUdQqvjEiZ+2=3HaAyY94UL5ZTLT0ZzNPJH-vv=3GQ@mail.gmail.com>

On Sun 2024-06-23 10:52:40, Yafang Shao wrote:
> On Fri, Jun 21, 2024 at 6:04 PM Petr Mladek <pmladek@suse.com> wrote:
> > On Fri 2024-06-21 16:39:40, Yafang Shao wrote:
> > > On Fri, Jun 21, 2024 at 3:31 PM Petr Mladek <pmladek@suse.com> wrote:
> > > > On Tue 2024-06-11 10:46:47, Yafang Shao wrote:
> > > > > On Tue, Jun 11, 2024 at 1:19 AM Song Liu <song@kernel.org> wrote:
> > > > > > On Sun, Jun 9, 2024 at 6:33 PM Yafang Shao <laoar.shao@gmail.com> wrote:
> > > They are not random live patches. Some system administrators maintain
> > > their own livepatches tailored for specific workloads or develop
> > > livepatches for A/B testing. Our company’s kernel team maintains the
> > > general livepatches. This worked well in the past when all livepatches
> > > were independent. However, the situation changed when we switched from
> > > non atomic replace livepatches to atomic replace livepatches, causing
> > > issues due to the uncertain behavior of mixed atomic replace and non
> > > atomic replace livepatches.
> >
> > I think that the uncertain behavior has been even before you started
> > using the atomic replace.
> >
> > How did the system administrators detect whether the livepatches were
> > independent?
> >
> > It looks to me that it worked only by luck. Well, I could imagine
> > that it has worked for a long time.
> 
> We have a limited number of livepatches in our system, primarily
> intended to address critical issues that could potentially cause
> system instability. Therefore, the likelihood of conflicts between two
> livepatches is relatively low. While I acknowledge that there is
> indeed a potential risk involved, it is the atomic replace livepatch
> that poses this risk.

I see.

> >
> >
> > > To address this change, we need a robust solution. One approach we
> > > have identified is developing a CI build system for livepatches. All
> > > livepatches must be built through this CI system, where they will
> > > undergo CI tests to verify if they are atomic replace or not.
> >
> > The important part is that the livepatch authors have to see
> > all already existing changes. They need to check that
> > the new change would not break other livepatched code and
> > vice versa.
> 
> Exactly. Through this CI system, all developers have visibility into
> all the livepatches currently running on our system.

Sounds good.

> > > Additionally, in our production environment, we need to ensure that
> > > there are no non atomic replace livepatches in use. For instance, some
> > > system administrators might still build livepatches outside of our CI
> > > system. Detecting whether a single livepatch is atomic replace or not
> > > is not easy. To simplify this, we propose adding a new sysfs attribute
> > > to facilitate this check.
> > >
> > > BTW, perhaps we could introduce a new sysctl setting to forcefully
> > > forbid all non atomic replace livepatches?
> >
> > I like it. This looks like the most reliable solution. Would it
> > solve your problem.
> >
> > Alternative solution would be to forbid installing non-replace
> > livepatches when there is already installed a livepatch with
> > the atomic replace. I could imagine that we enforce this for
> > everyone (without sysctl knob). Would this work for you?
> 
> Perhaps we can add this sysctl knob as follows?
> 
> kernel.livepatch.forbid_non_atomic_replace:
>     0 - Allow non atomic replace livepatch. (Default behavior)
>     1 - Completely forbid non atomic replace livepatch.
>     2 - Forbid non atomic replace livepatch only if there is already
> an atomic replace livepatch running.

Feel free to send a patch if it would be useful for you.

> > That said, I am not completely against adding the sysfs attribute
> > "replace". I could imagine that it might be useful when a more
> > flexible solution is needed. But I think that it would be
> > hard to make a more flexible solution safe, especially
> > in your environment.
> 
> This sysfs attribute remains valuable as it aids in monitoring
> livepatches, specifically allowing us to track which type of livepatch
> is currently operating on a server.

Fair enough. I am fine with it. I would only like to improve the
commit message explaining the motivation, see my reply to the patch.

Best Regards,
Petr

