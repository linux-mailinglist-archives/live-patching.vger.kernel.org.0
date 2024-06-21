Return-Path: <live-patching+bounces-358-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E843F911EF8
	for <lists+live-patching@lfdr.de>; Fri, 21 Jun 2024 10:40:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5A7C9B220B2
	for <lists+live-patching@lfdr.de>; Fri, 21 Jun 2024 08:40:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39F5516D30C;
	Fri, 21 Jun 2024 08:40:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BAcfJs6b"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E1D116D4DA
	for <live-patching@vger.kernel.org>; Fri, 21 Jun 2024 08:40:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718959220; cv=none; b=o4+RN6sYMD+RP1bQULbC1gT4gc1CqJxHNhpYUzHg4Hn902O3NEZaSmmPUNar/J+GrXsHolAlC18LdduBmy2oguOtqZo2KygLvpjkf/qHAht4B6LDiyzMGbDDd2HtlUCvbqfVqsmoC/gDF5yMTn2FRrj8ozYb2XlWchyZMLcUdl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718959220; c=relaxed/simple;
	bh=kXpRAcHTq19HnoK7WkVNCZH1sMhpNwx0o5NA2UMv3GY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bl0JfAtJTILozXYdHd34thGHY+uqWhlNhyds87MK07nYz6hrLj8PpiHvvgz8mOM4dQn0tzjSjbvvDMAzy0RLgxmFBsW7bp+xxL06CXGdpy1dCLKMW+Hi2I7bNOpj6VFiJ1pZALzqhKdlKsMpOEmG7JfhXw4jXWLlGFGGhoUhtTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BAcfJs6b; arc=none smtp.client-ip=209.85.219.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-6b505f11973so19386156d6.1
        for <live-patching@vger.kernel.org>; Fri, 21 Jun 2024 01:40:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718959217; x=1719564017; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kXpRAcHTq19HnoK7WkVNCZH1sMhpNwx0o5NA2UMv3GY=;
        b=BAcfJs6behIF9695Ps+gi/iTLc7PEhdt+xgUWERaetC2TbpkdYtWnyZRkOi1NlWxTP
         B/vGZb72+hNv5Y58WkwbHdvpWEaA5Wa7nDdPqlxbO3F+lD8oNGSbDpTuGjCsP19oH/XU
         l+Tm2/WRb7yljMYIKWTih081bGPHr0RtzU8ouO8bblXKBF93NRpnAsGtvlO5pdHN8G6i
         b2ery8aHhL9uJkICc+7WJyaQ3bRBv1EdVFSjhu5D6QN3hZ+lei/tmptHlvmSH785Pkw0
         O27J1e03jH7I9vb+II4p8ZEV7+gH5UvFnLc1qpB/+iaZTvW1lteKH6gdF0U166UDnqCP
         aB8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718959217; x=1719564017;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kXpRAcHTq19HnoK7WkVNCZH1sMhpNwx0o5NA2UMv3GY=;
        b=L4WhlxtrH5InRSepSvasJxIiZgjH6XGLj9ad80idO2aiNxbItenAnsqXTKsb2Em3mg
         SQUKP+3MuA1SsbktrSYlrvMO5Po4BPiWjSRBWAuqFqAT0D3txR1YSVRPxKq1CD6gNidr
         icdhJNI1tfdIOB/d4h4sop9acquE1dPUk3JP1EHt0I9MvrtK92YSPI5D7lPtFFJGgzIA
         4q9lPNpnDTNShKGENXMY9JzdTSkIIeIY/BVBhW5G7vdnV2Fa0Q3L6YufVUHTH1zR0HRs
         L+7q0Fou23R9NtHMUI1OZv05z2zdqGviIvhMfAplyg7zNcDZ9e4Oc+RshgrACGQf4R8y
         Fezw==
X-Forwarded-Encrypted: i=1; AJvYcCX5g1iXaL46+WRMskHTV33/2wh4qIgbr7P+HO1ElIFyE8PAq0zHmb3VS47ud2WrXsq0loEK8HvFWlnaGCx9Ekpe5qaU/Fuw3STr6ZK8VQ==
X-Gm-Message-State: AOJu0YwneQ9dmmCnn91rtSLzYGwkY3dMDsRPdhxEsrz39Mzw3wQqJKla
	ESdvvEsi1q/YlQUJZ2X+1QdLAJuH5AvRrfdwd+K2au99l6EYukWO6VqyzcsS66IcdKsh9XA/1OV
	dRADywOkEphVMLmqcTMw90JgfWOU=
X-Google-Smtp-Source: AGHT+IE4F1dXGLSkRkwHhnhn/Z0S8OzCy1GQq4kVNQNWQF79R6LuZYkcNWoKtgx1SF3tpvMZkcmdyYi/FembFPfolXE=
X-Received: by 2002:a05:6214:761:b0:6b0:6625:135 with SMTP id
 6a1803df08f44-6b2e2492236mr187481546d6.28.1718959216897; Fri, 21 Jun 2024
 01:40:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240610013237.92646-1-laoar.shao@gmail.com> <CAPhsuW6MB8MgCtttk2QZDCF0Wu-r0c47kVk=a9o1_VUDPHOjVw@mail.gmail.com>
 <CALOAHbDPXDZQJENvN-yZM-OyrTy94kE6wMLGHt83m_y3O23bRQ@mail.gmail.com> <ZnUsYf1-Ue59Fjru@pathway.suse.cz>
In-Reply-To: <ZnUsYf1-Ue59Fjru@pathway.suse.cz>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Fri, 21 Jun 2024 16:39:40 +0800
Message-ID: <CALOAHbByr3UMy=xzP82LA=D3rW-uw+s3XfzHQMVYxu4RomAANg@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] livepatch: Add "replace" sysfs attribute
To: Petr Mladek <pmladek@suse.com>
Cc: Song Liu <song@kernel.org>, jpoimboe@kernel.org, jikos@kernel.org, mbenes@suse.cz, 
	joe.lawrence@redhat.com, live-patching@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 21, 2024 at 3:31=E2=80=AFPM Petr Mladek <pmladek@suse.com> wrot=
e:
>
> On Tue 2024-06-11 10:46:47, Yafang Shao wrote:
> > On Tue, Jun 11, 2024 at 1:19=E2=80=AFAM Song Liu <song@kernel.org> wrot=
e:
> > >
> > > Hi Yafang,
> > >
> > > On Sun, Jun 9, 2024 at 6:33=E2=80=AFPM Yafang Shao <laoar.shao@gmail.=
com> wrote:
> > > >
> > > > Add "replace" sysfs attribute to show whether a livepatch supports
> > > > atomic replace or not.
> > >
> > > I am curious about the use case here.
> >
> > We will use this flag to check if there're both atomic replace
> > livepatch and non atomic replace livepatch running on a single server
> > at the same time. That can happen if we install a new non atomic
> > replace livepatch to a server which has already applied an atomic
> > replace livepatch.
> >
> > > AFAICT, the "replace" flag
> > > matters _before_ the livepatch is loaded. Once the livepatch is
> > > loaded, the "replace" part is already finished. Therefore, I think
> > > we really need a way to check the replace flag before loading the
> > > .ko file? Maybe in modinfo?
> >
> > It will be better if we can check it before loading it. However it
> > depends on how we build the livepatch ko, right? Take the
> > kpatch-build[0] for example, we have to modify the kpatch-build to add
> > support for it but we can't ensure all users will use it to build the
> > livepatch.
>
> > [0]. https://github.com/dynup/kpatch
>
> I still do not understand how the sysfs attribute would help here.
> It will show the type of the currently used livepatches. But
> it won't say what the to-be-installed livepatch would do.
>
> Could you please describe how exactly you would use the information?
> What would be the process/algorithm/logic which would prevent a mistake?
>
> Honestly, it sounds like your processes are broken and you try
> to fix them on the wrong end.
>
> Allowing to load random livepatches which are built a random way
> sounds like a hazard.

They are not random live patches. Some system administrators maintain
their own livepatches tailored for specific workloads or develop
livepatches for A/B testing. Our company=E2=80=99s kernel team maintains th=
e
general livepatches. This worked well in the past when all livepatches
were independent. However, the situation changed when we switched from
non atomic replace livepatches to atomic replace livepatches, causing
issues due to the uncertain behavior of mixed atomic replace and non
atomic replace livepatches.

To address this change, we need a robust solution. One approach we
have identified is developing a CI build system for livepatches. All
livepatches must be built through this CI system, where they will
undergo CI tests to verify if they are atomic replace or not.

Additionally, in our production environment, we need to ensure that
there are no non atomic replace livepatches in use. For instance, some
system administrators might still build livepatches outside of our CI
system. Detecting whether a single livepatch is atomic replace or not
is not easy. To simplify this, we propose adding a new sysfs attribute
to facilitate this check.

BTW, perhaps we could introduce a new sysctl setting to forcefully
forbid all non atomic replace livepatches?

>
> It should be possible to load only livepatches which passed some
> testing (QA). And the testing (QA) should check if the livepatch
> successfully replaced the previous version.
>
> Or do you want to use the sysfs attribute in QA?
> So that only livepatches witch "replace" flag set would pass QA?
>


--=20
Regards
Yafang

