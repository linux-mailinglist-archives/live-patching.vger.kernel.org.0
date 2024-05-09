Return-Path: <live-patching+bounces-258-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ED1638C0B3C
	for <lists+live-patching@lfdr.de>; Thu,  9 May 2024 07:54:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1BEF91C217D4
	for <lists+live-patching@lfdr.de>; Thu,  9 May 2024 05:54:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 538EC1494B7;
	Thu,  9 May 2024 05:53:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="b/R2geSR"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D00C51494B2;
	Thu,  9 May 2024 05:53:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715234037; cv=none; b=VSOjYmDp6pasg0r92ShdeLFu/wDyb6MIONCfTRF4D8g9K+kCF2Q63XeK3unNpqu7Kc3RmPwQHhiJeO/v0ElZMr5UukeIY7CBrdauO4fQk3iczpvJ5jqxg+ln/mM+Jfvld1QPB7zCVbbKsVw3U1yiqSFHwIlgN04qFeTgyb/AmuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715234037; c=relaxed/simple;
	bh=AjV4HPIEm8zbNFZV+mZ+xQbZPYEN+O2vQcAM8KrhH84=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NUBr3C+E+dvk4e8J2CmKHf7BOmjActjPWxgvBa/1aN9AMtpXs984vrDPprSUtY/pKnAqW109WM5jbzp5SN/2DYQf8S+8vA216F5XCI064+f5bDocG2npivvW4bsWuDmdVaWu0/y197G13IC0BI6382wXJ5Q76GpD0nKPiatWkY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=b/R2geSR; arc=none smtp.client-ip=209.85.219.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-6a0ce3e823fso3047376d6.1;
        Wed, 08 May 2024 22:53:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1715234035; x=1715838835; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NisROruOOmEQz/yNJzjIKf5w2xFa1pbI+43xZbmizOE=;
        b=b/R2geSR5yIR0rhQRvNBLhksTwBPsUTF68Pf6Vi+GSAtlmAy0rmmTahjqsdBecllmN
         WXJbUcJ/cL6sfS6KykGcfBNybk4zSEfTSTQ8A7MwNTenlPY3rWtjVlpko697xGIjWntt
         I0kKmoAT0AGPJo+dSAy6ly0dSJwrjgxFqoos2nteulkZmxyHloZcXEbpRMvMC+e3aF0L
         La/BDyY9cY0G5/qLziXbnFW5vvKC69XIlmL4jogAv6hHA+RYXUXB0t8F/ODydwXuhv4V
         gD7tpyl5axv/iTBikc2Yzc3BfCmWmrJQsnM3fUCPzgiMLLf4v/fR6V4RoS8OPmE85g0b
         WZQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715234035; x=1715838835;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NisROruOOmEQz/yNJzjIKf5w2xFa1pbI+43xZbmizOE=;
        b=CZOXNNY+fG1x7SEdniP8JI3g9IzYCFuN+CiJ4oL2nZq4cB0m5H9PdjT92HXxDlMU0r
         YlpGLlpQhergUaxpJ4b+o7wG2Xsdaa/Wc7VB2p8Kowt5eIB0V9/HVWUWErfBsD7o0GGW
         nDRi16SuuAAI9c5CSCF4hhkR21fUvfyfPf8r234Wp5jxImUGMpXSWNlPcxu3XXbY61dG
         3owJ94ytPcUWqtodhnt8y7kk0To9C+YrSZ0aebE2JzconsU6GloT72JXk9lcB5s42Svg
         Xzj54jryjlEaSKxbYGBG/08ftiPH27hAWEosODY3tk3wGbNopON8sRNNAr6lsq5cIm+L
         i7Dg==
X-Forwarded-Encrypted: i=1; AJvYcCWIK3zIZ+fqptYJIJBMT/gExNwxZz2+sEbq5NwI2lghESf3Rl4b1NY6HDD+VkH7X7ImrstbaKzi3YDsmnjDgGH6BpgCcEefz5ZbEVYgVIshB8ieG5HquCtdJc6a7R+I3otstoEDohCXIwkL3wQ=
X-Gm-Message-State: AOJu0Yz9GbxTCXDUPsXE/ejbr7HDxhzZVE/Hao4P71v4XXbQU4l6k1sT
	Td8NUzd4EiTVlvyYV+eSZnEM5WWuqxEDxD9hIyvXb68z55YbgNsqVsHJZybG9KapGvNqyljGPf2
	OrXJoKsIlyk3utnTnLEfpZyH4kHc=
X-Google-Smtp-Source: AGHT+IHMVD6moGkYOoqfo8Tlo+PvXHFwpr1KdaRVtCyK2U7azpphEpDCyaAcQBmdSXaaaPXo5neMD/N491Slvc/IC/0=
X-Received: by 2002:a05:6214:268a:b0:6a0:a55b:9539 with SMTP id
 6a1803df08f44-6a1514e4e6bmr53922356d6.60.1715234034741; Wed, 08 May 2024
 22:53:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240407035730.20282-1-laoar.shao@gmail.com> <20240407035730.20282-3-laoar.shao@gmail.com>
 <20240503211434.wce2g4gtpwr73tya@treble> <Zji_w3dLEKMghMxr@pathway.suse.cz>
 <20240507023522.zk5xygvpac6gnxkh@treble> <CALOAHbArS+WVnfU-RUzbgFJTH5_H=m_x44+GvXPS_C3AKj1j8w@mail.gmail.com>
 <20240508051629.ihxqffq2xe22hwbh@treble> <CALOAHbDn=t7=Q9upg1MGwNcbo5Su9W5JTAc901jq2BAyNGSDrg@mail.gmail.com>
 <20240508070308.mk7vnny5d27fo5l6@treble> <CALOAHbCdO+myNZ899CQ6yD24k0xK6ZQtLYxqg4vU53c32Nha4w@mail.gmail.com>
 <20240509052007.jhsnssdoaumxmkbs@treble>
In-Reply-To: <20240509052007.jhsnssdoaumxmkbs@treble>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Thu, 9 May 2024 13:53:17 +0800
Message-ID: <CALOAHbBAQ580+qjxYbc1bNJxZ8wxxDqP3ua__pqKzCg9An3yGA@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] livepatch: Delete the associated module of
 disabled livepatch
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Petr Mladek <pmladek@suse.com>, jikos@kernel.org, mbenes@suse.cz, 
	joe.lawrence@redhat.com, mcgrof@kernel.org, live-patching@vger.kernel.org, 
	linux-modules@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, May 9, 2024 at 1:20=E2=80=AFPM Josh Poimboeuf <jpoimboe@kernel.org>=
 wrote:
>
> On Thu, May 09, 2024 at 10:17:43AM +0800, Yafang Shao wrote:
> > On Wed, May 8, 2024 at 3:03=E2=80=AFPM Josh Poimboeuf <jpoimboe@kernel.=
org> wrote:
> > >
> > > On Wed, May 08, 2024 at 02:01:29PM +0800, Yafang Shao wrote:
> > > > On Wed, May 8, 2024 at 1:16=E2=80=AFPM Josh Poimboeuf <jpoimboe@ker=
nel.org> wrote:
> > > > > If klp_patch.replace is set on the new patch then it will replace=
 all
> > > > > previous patches.
> > > >
> > > > A scenario exists wherein a user could simultaneously disable a loa=
ded
> > > > livepatch, potentially resulting in it not being replaced by the ne=
w
> > > > patch. While theoretical, this possibility is not entirely
> > > > implausible.
> > >
> > > Why does it matter whether it was replaced, or was disabled beforehan=
d?
> > > Either way the end result is the same.
> >
> > When users disable the livepatch, the corresponding kernel module may
> > sometimes be removed, while other times it remains intact. This
> > inconsistency has the potential to confuse users.
>
> I'm afraid I don't understand.  Can you give an example scenario?
>

As previously mentioned, this scenario may occur if user-space tools
remove all pertinent kernel modules from /sys/livepatch/* while a user
attempts to load a new atomic-replace livepatch.

For instance:

User-A                                                       User-B

echo 0 > /sys/livepatch/A/enable              insmod atomic-replace-patch.k=
o

From User-A's viewpoint, the A.ko module might sometimes be removed,
while at other times it remains intact. The reason is that User-B
removed a module that he shouldn't remove.

--=20
Regards
Yafang

