Return-Path: <live-patching+bounces-359-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DBE2E912177
	for <lists+live-patching@lfdr.de>; Fri, 21 Jun 2024 12:04:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9074F281F2E
	for <lists+live-patching@lfdr.de>; Fri, 21 Jun 2024 10:04:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31DFC170858;
	Fri, 21 Jun 2024 10:04:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Rjv/+wfX"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com [209.85.208.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D672170857
	for <live-patching@vger.kernel.org>; Fri, 21 Jun 2024 10:04:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718964275; cv=none; b=J5rj4g97ES95Hue3EERDk/fkLM/FaJKJxvlr5vz+eI62SmjvPMq7MYaxEMFPEUzmaBovoL7+AyklPFqwSt4rdPpeRHaHjJRdGnVESOiRLx/7S9ZWVQ9sd+EyHep26AzcUQJ8wo6+PrBCAXcPgwEl3jcBU8AUpg5W4yseiI9jbH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718964275; c=relaxed/simple;
	bh=okTH1fH2UE0eT0MwPoML2QCMiyCCQ4ppJSdmKy0RV90=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SrS2PnQ8IiDth7651q/Fo0OTyt/2OhrcPlyT5PQPbA+PUUBRxSQXKgvcrZGitkVBtqWO2PbDfQ+egwlhNvHgQ16hAC3Pi/WXfcNL8VV23GSUSLN0rws0AWNqfK5AujWmureE4Wt+I/Xo2tT2wjECLDcWbwV94gGafbQbg/DSNRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Rjv/+wfX; arc=none smtp.client-ip=209.85.208.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-lj1-f174.google.com with SMTP id 38308e7fff4ca-2eaae2a6dc1so34643961fa.0
        for <live-patching@vger.kernel.org>; Fri, 21 Jun 2024 03:04:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1718964270; x=1719569070; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=pafgb2UT+GBPwdqDlzVHRIAZDopwv+DxBej/CtxKC6k=;
        b=Rjv/+wfX7tx0i2FaNM2Z7J0mcuYAjuqcap2RC0AswMVSlvMBjk0SWAxGJqFMH4HBEs
         QR5sOVAEZYKXidmiPE2xb+yDYEBu/NSjVFOBr9WqmMxfvSQahF4VG2PKzOImkoXorn16
         lqrsBnE9p1MrCeBZ+X9FaQO59tjzRJKOGw/r+QJhPfIFhSKP5fWDqe9SRsc4+LtriHug
         4wzKs5mDDV9Dj+RSWqf1jst2U9p9rSdF7dq2M9o8Wl2eAyVrRLQkz7Qif7Hwp6lIgHvD
         3XUNP/LlH6flmSwNaqZ16QC29z3JoE8uttPje81KuUOHRKtwAY7NjiIsMejabi3mWxI6
         IuGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718964270; x=1719569070;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pafgb2UT+GBPwdqDlzVHRIAZDopwv+DxBej/CtxKC6k=;
        b=JwYGrmqufP3G9OvE8t9aP6+M4YGbeG/X81KUc09leEAIPs//jWUKncxKwNK7GVaJ89
         njYNmgaMWFqHEvUBakC/YcUmYA2ClxPBzh1oiXwuzgIwTRNiqCSDBxcCjdw3kG1GSO2x
         iTHfz5bLR/gl0P3Vu5tqAUPvUhpWkb+IBP57K4P7hiQRpZD24PXSYMWcyy7520+qvoAT
         Vn9nN4MNUj4M3MXNdhJIu6Dm9Qc2My1EfOLdeUf0yd/Zlywsqhga35njU8pELpuhUj6L
         T2l5atTICTeM5H+sVpYcYQ9AN2wro3XsEtQ+OS4rCSJUp+M21YPDsv0ahxKuQkb4nGRN
         3CVQ==
X-Forwarded-Encrypted: i=1; AJvYcCUlHTQSOTOiRxdlGOauK/HbAEejL4pN/hhUW/3RPlpw2FujvcooWxm5sfAORDrcDYASyfz2nKi7Uz9OGHReWt/BSBy9/9NFOpuGV0Stww==
X-Gm-Message-State: AOJu0YwmAq31xUKp9txEJGBSsEXAQaz5Vk90s7/32gRS3HTLiGkEiR5n
	QdocCcsIiMAj0IOT95oHQExqr5ypOv5oHvfKjcCULAs6VtOKIvYNWx3efsoK9lo=
X-Google-Smtp-Source: AGHT+IFgdPaTZhub9nD5Lt3rSIEkV2+sM8ujfJaZBq3C+u2vOWAgM5eBAlEuaGs4NTAAcWX0Q26Rww==
X-Received: by 2002:a2e:9bc3:0:b0:2ec:1f9f:2155 with SMTP id 38308e7fff4ca-2ec3cec0e1bmr61575861fa.15.1718964269224;
        Fri, 21 Jun 2024 03:04:29 -0700 (PDT)
Received: from pathway.suse.cz ([176.114.240.50])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2c819db97f8sm1170785a91.39.2024.06.21.03.04.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Jun 2024 03:04:28 -0700 (PDT)
Date: Fri, 21 Jun 2024 12:04:20 +0200
From: Petr Mladek <pmladek@suse.com>
To: Yafang Shao <laoar.shao@gmail.com>
Cc: Song Liu <song@kernel.org>, jpoimboe@kernel.org, jikos@kernel.org,
	mbenes@suse.cz, joe.lawrence@redhat.com,
	live-patching@vger.kernel.org
Subject: Re: [PATCH v2 0/3] livepatch: Add "replace" sysfs attribute
Message-ID: <ZnVQJEoXpaONuTNE@pathway.suse.cz>
References: <20240610013237.92646-1-laoar.shao@gmail.com>
 <CAPhsuW6MB8MgCtttk2QZDCF0Wu-r0c47kVk=a9o1_VUDPHOjVw@mail.gmail.com>
 <CALOAHbDPXDZQJENvN-yZM-OyrTy94kE6wMLGHt83m_y3O23bRQ@mail.gmail.com>
 <ZnUsYf1-Ue59Fjru@pathway.suse.cz>
 <CALOAHbByr3UMy=xzP82LA=D3rW-uw+s3XfzHQMVYxu4RomAANg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALOAHbByr3UMy=xzP82LA=D3rW-uw+s3XfzHQMVYxu4RomAANg@mail.gmail.com>

On Fri 2024-06-21 16:39:40, Yafang Shao wrote:
> On Fri, Jun 21, 2024 at 3:31 PM Petr Mladek <pmladek@suse.com> wrote:
> >
> > On Tue 2024-06-11 10:46:47, Yafang Shao wrote:
> > > On Tue, Jun 11, 2024 at 1:19 AM Song Liu <song@kernel.org> wrote:
> > > >
> > > > Hi Yafang,
> > > >
> > > > On Sun, Jun 9, 2024 at 6:33 PM Yafang Shao <laoar.shao@gmail.com> wrote:
> > > > >
> > > > > Add "replace" sysfs attribute to show whether a livepatch supports
> > > > > atomic replace or not.
> > > >
> > > > I am curious about the use case here.
> > >
> > > We will use this flag to check if there're both atomic replace
> > > livepatch and non atomic replace livepatch running on a single server
> > > at the same time. That can happen if we install a new non atomic
> > > replace livepatch to a server which has already applied an atomic
> > > replace livepatch.
> > >
> > > > AFAICT, the "replace" flag
> > > > matters _before_ the livepatch is loaded. Once the livepatch is
> > > > loaded, the "replace" part is already finished. Therefore, I think
> > > > we really need a way to check the replace flag before loading the
> > > > .ko file? Maybe in modinfo?
> > >
> > > It will be better if we can check it before loading it. However it
> > > depends on how we build the livepatch ko, right? Take the
> > > kpatch-build[0] for example, we have to modify the kpatch-build to add
> > > support for it but we can't ensure all users will use it to build the
> > > livepatch.
> >
> > > [0]. https://github.com/dynup/kpatch
> >
> > I still do not understand how the sysfs attribute would help here.
> > It will show the type of the currently used livepatches. But
> > it won't say what the to-be-installed livepatch would do.
> >
> > Could you please describe how exactly you would use the information?
> > What would be the process/algorithm/logic which would prevent a mistake?
> >
> > Honestly, it sounds like your processes are broken and you try
> > to fix them on the wrong end.
> >
> > Allowing to load random livepatches which are built a random way
> > sounds like a hazard.
> 
> They are not random live patches. Some system administrators maintain
> their own livepatches tailored for specific workloads or develop
> livepatches for A/B testing. Our company’s kernel team maintains the
> general livepatches. This worked well in the past when all livepatches
> were independent. However, the situation changed when we switched from
> non atomic replace livepatches to atomic replace livepatches, causing
> issues due to the uncertain behavior of mixed atomic replace and non
> atomic replace livepatches.

I think that the uncertain behavior has been even before you started
using the atomic replace.

How did the system administrators detect whether the livepatches were
independent?

It looks to me that it worked only by luck. Well, I could imagine
that it has worked for a long time.


> To address this change, we need a robust solution. One approach we
> have identified is developing a CI build system for livepatches. All
> livepatches must be built through this CI system, where they will
> undergo CI tests to verify if they are atomic replace or not.

The important part is that the livepatch authors have to see
all already existing changes. They need to check that
the new change would not break other livepatched code and
vice versa.


> Additionally, in our production environment, we need to ensure that
> there are no non atomic replace livepatches in use. For instance, some
> system administrators might still build livepatches outside of our CI
> system. Detecting whether a single livepatch is atomic replace or not
> is not easy. To simplify this, we propose adding a new sysfs attribute
> to facilitate this check.
> 
> BTW, perhaps we could introduce a new sysctl setting to forcefully
> forbid all non atomic replace livepatches?

I like it. This looks like the most reliable solution. Would it
solve your problem.

Alternative solution would be to forbid installing non-replace
livepatches when there is already installed a livepatch with
the atomic replace. I could imagine that we enforce this for
everyone (without sysctl knob). Would this work for you?

That said, I am not completely against adding the sysfs attribute
"replace". I could imagine that it might be useful when a more
flexible solution is needed. But I think that it would be
hard to make a more flexible solution safe, especially
in your environment.

Best Regards,
Petr

