Return-Path: <live-patching+bounces-957-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5370CA01977
	for <lists+live-patching@lfdr.de>; Sun,  5 Jan 2025 13:53:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9863A1881AD0
	for <lists+live-patching@lfdr.de>; Sun,  5 Jan 2025 12:53:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2204014A4C1;
	Sun,  5 Jan 2025 12:52:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="p0fvjz8G"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9777E45016
	for <live-patching@vger.kernel.org>; Sun,  5 Jan 2025 12:52:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736081576; cv=none; b=BVH7Qh5ZvRulC0vQk+Lvh6pyzcaJTAJk4yO1oD0PB43+H50NqXMaDH6iG8eAPHlYd9T3ZdMNxi/jU0ns9z6O/+COJnOvPvl2Sh6tdknev8TpWWPi2u573kCTNsPl9NmeqP9Us07rIGSm1JWq3h6vTgjN4FlyYhxBc2OnYHAUzjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736081576; c=relaxed/simple;
	bh=5UfF6jzmGPHI0cPnrn6XRUmUTB4P+KEml3GX6b/5tzE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jLB+qLQKSNTEPcUar7sYSHQvf2KLLK6beSs63b3iu03Z2y3oaOHSDFUIW5d/Ko14abkBB55jj58MPjhNkoy9ydt2ISVP/DpzLfaSh06lCMYY+GswtftbvFc1ZYuuVC3QM/d/jjDIOQrVhi5FljdxjJVMNARgSsQqjeXMVx23VKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=p0fvjz8G; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2163affd184so95265ad.1
        for <live-patching@vger.kernel.org>; Sun, 05 Jan 2025 04:52:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736081574; x=1736686374; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9CZd9YA/vxsfF1o+1S6lXa7zVfnq9bHCryfS5okIqnQ=;
        b=p0fvjz8G8GHDKm7wNZ5uN4aXtc0sbHW3ZH83tqC8wj/Dm9I/MK6sjE5i8VUWtFMygv
         ntdIAUOl4O+aoZ360zxFewIUNbfPjEENqig0/Eu0Z9Y9+lsXijGphyOTbvl65VzYvsmM
         9m8ej/YJYljPXtcDR/sdl8i3WA/IkIu2vTwKp6A11qFAfFGgA130wn2bhVOs4/spko/C
         z49U0XnrMo7cC8K4ns+z/bdjPl86MT/u/T+tf4lzrlj7VNs/G5i/gac/DdvAYTkXZnOz
         BtUnzYNh7fF15HJQdPonD5TZXqntIACLneIvdWiSU0DmdtGSdTMp0cIZP8X7HsldCXSc
         Y/VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736081574; x=1736686374;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9CZd9YA/vxsfF1o+1S6lXa7zVfnq9bHCryfS5okIqnQ=;
        b=TaXK2kI+gsSzJCyURMLvYlQXV4aCb75HlrvULEaC1/kGN9IQwTrrrM/mNCDVi7lh/5
         eWy3gjeEnpFLJ9ygEsScbRcnIrqCCRb02U+ivU6CnV7dbTzIHC+tdq9pMxiaXJJKWiPj
         4Ajiy4RjBnsiFryR6jZA06RrL7gEoEpAIgVYbqXA8OwrXPQA419l072UfG3ZQ2tl8hwI
         iVgb3/nJ9yWXZkqhp/9PfvyqGfbvUV3Ybl5qmcxaO24aSjv4xhvIv7kzzS6dub9Kwlvd
         XUQsUXCmfoZc10nysCz4XLhXadPkXe2FVtCs1BND8FOcTPLur6t0ZyFNqgWIeKdoeDoM
         7z0Q==
X-Forwarded-Encrypted: i=1; AJvYcCW2cMwjkwVRnaWcNYFxcRyjslFwDtDp92j4Qi+8tBsUdmpx/u/UU+6nojts5gkeh1ZU3LgyRLVA9b28h6yp@vger.kernel.org
X-Gm-Message-State: AOJu0Ywbr21EIzv6DHQns2aUE+4Hlysg3ujO+bfyvG9QApdAwiIrCqba
	AAJGiNdm+IfqNK5zBxnbTWdjhAz63cFbaYfgpW1bBakUIGrxprXNDpt+M0EOGARXAr6EZXgqSfL
	1oSvAqoJkRovFH+d8ypyD3OWDzx8kyqVxbJAP
X-Gm-Gg: ASbGnctT1PzWWsj+XbTcNTIrcZKd8bDWmVFoZxn54Tib+2PVaYgm5DvepF3VQVtBDR1
	Y6g5mRKjmkntnkLUF6AG12wokxBxIxAiQBsNq
X-Google-Smtp-Source: AGHT+IEHA5ba+jpkkdNpDLtsolTeg8E9FnKLL/jtGaf6DdgcjgXXRiauZ5nf4OWT8s7tM+6ZsYXlno3RjzvbYUw9zeI=
X-Received: by 2002:a17:903:120d:b0:216:6dab:8042 with SMTP id
 d9443c01a7336-21a62b6ffb8mr1842805ad.12.1736081573755; Sun, 05 Jan 2025
 04:52:53 -0800 (PST)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <86eba318-464b-4b9b-a79e-64039b17be34@lucifer.local>
 <d48193a3-65fe-4aa9-98f6-dd5869bd9127@citrix.com> <9878d90f-faf3-4853-9a79-a21b4f58ab4c@suse.com>
 <Z3iX2mNtqSYrvYPT@bombadil.infradead.org>
In-Reply-To: <Z3iX2mNtqSYrvYPT@bombadil.infradead.org>
From: =?UTF-8?Q?Marek_Ma=C5=9Blanka?= <mmaslanka@google.com>
Date: Sun, 5 Jan 2025 13:52:27 +0100
Message-ID: <CAGcaFA2Htgu8w6S_Zuz2zn3FwpaetZRbY8n0CWEdh07YfMO==A@mail.gmail.com>
Subject: Re: [PATCH 6/8] modules: switch to execmem API for remapping as RW
 and restoring ROX
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>, 
	Adam Williamson <awilliam@redhat.com>, Andrew Cooper <andrew.cooper3@citrix.com>, 
	lorenzo.stoakes@oracle.com, akpm@linux-foundation.org, 
	anton.ivanov@cambridgegreys.com, bp@alien8.de, brendan.higgins@linux.dev, 
	da.gomez@samsung.com, danielt@kernel.org, dave.hansen@linux.intel.com, 
	davidgow@google.com, dianders@chromium.org, hpa@zytor.com, 
	jason.wessel@windriver.com, jikos@kernel.org, joe.lawrence@redhat.com, 
	johannes@sipsolutions.net, jpoimboe@kernel.org, 
	kgdb-bugreport@lists.sourceforge.net, kirill.shutemov@linux.intel.com, 
	kunit-dev@googlegroups.com, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-modules@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	linux-um@lists.infradead.org, live-patching@vger.kernel.org, luto@kernel.org, 
	mark.rutland@arm.com, mbenes@suse.cz, mhiramat@kernel.org, mingo@redhat.com, 
	peterz@infradead.org, petr.pavlu@suse.com, pmladek@suse.com, richard@nod.at, 
	rmoar@google.com, rostedt@goodmis.org, rppt@kernel.org, 
	samitolvanen@google.com, shuah@kernel.org, song@kernel.org, 
	tglx@linutronix.de, x86@kernel.org, 
	=?UTF-8?Q?Marek_Marczykowski=2DG=C3=B3recki?= <marmarek@invisiblethingslab.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Jan 4, 2025 at 3:07=E2=80=AFAM Luis Chamberlain <mcgrof@kernel.org>=
 wrote:
>
> On Fri, Jan 03, 2025 at 07:58:13AM +0100, J=C3=BCrgen Gro=C3=9F wrote:
> > On 03.01.25 03:06, Andrew Cooper wrote:
> > > > Hi Mike,
> > > >
> > > > This commit is making my intel box not boot in mm-unstable :>) I bi=
sected it to
> > > > this commit.
> > >
> > > For what it's worth, we've found the same under Xen too.
> > >
> > > There's one concrete bug in the series, failing to cope with the abse=
nce
> > > of superpages (fix in
> > > https://lore.kernel.org/xen-devel/6bb03333-74ca-4c2c-85a8-72549b85a5b=
4@suse.com/
> > > but not formally posted yet AFAICT).
> >
> > Now sent out:
> >
> > https://lore.kernel.org/lkml/20250103065631.26459-1-jgross@suse.com/T/#=
u
>
> Thanks,
>
> Marek, Adam, can you try this patch? Although the reply here is for
> another future series being worked on the fix is for commit
> 2e45474ab14f ("execmem: add support for cache of large ROX pages").
>
>   Luis

Hi Luis,

I suppose you're referring to the issue described here
https://lore.kernel.org/linux-mm/CAGcaFA2hdThQV6mjD_1_U+GNHThv84+MQvMWLgEuX=
+LVbAyDxg@mail.gmail.com/T/
Unfortnuetly this patch didn't help.

Best,
Marek

