Return-Path: <live-patching+bounces-1144-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B9B21A2E24B
	for <lists+live-patching@lfdr.de>; Mon, 10 Feb 2025 03:40:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C71CD188739A
	for <lists+live-patching@lfdr.de>; Mon, 10 Feb 2025 02:40:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 014E135972;
	Mon, 10 Feb 2025 02:39:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ahFLupzQ"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D1A23596A;
	Mon, 10 Feb 2025 02:39:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739155198; cv=none; b=PE2XOJL1lgpo4GlCUqDctd2R1ukGR7qo4JIMsI+rhZSF8aqnJ1R94ABXtfZdc8euSMXu0CxSMqNtin2otuQWvuGwHUfmtlOm4shOp5kOPfCBVaFX1vKX1lPzxeqG6JcT2WvvvKpC4EWIp6jXFwaWxfjD9zBH6QqooKfnBA53k0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739155198; c=relaxed/simple;
	bh=UhFTGgwzcnw5Nbv7fzNfdqujcOVb1PoFfj1hZWJwqLo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sBclgL/RtFN+34QwGjhIK8bO5M3iHiX7bAU7gOmGn++u3ZbpPxpVq4rUe3ADlrEYxZ62mcegOLwasNBMJxSvgOUfixyWPSyYRxpcpfktKUONoLDX74yYwtQVgJwX4GE3GIxQVRHo2Xri0/134sL7YX9aLGOjF3307F08halJELY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ahFLupzQ; arc=none smtp.client-ip=209.85.219.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-6e432beabbdso29188626d6.3;
        Sun, 09 Feb 2025 18:39:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739155196; x=1739759996; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uTr+ihH+SIThNdHSUEBbV3Pz5Z6x2IToXzqKj18NNvI=;
        b=ahFLupzQHL/NeNJXJdYJ8tnsbjO/omqebcY5tFixRZxV5vbHOrYnJx3GpbDwNQOCot
         SzYqo38ODzrImJiVviYnreOX+IZvLAvCMV1UKrnd/zTu1a6jxeZhQW9uO7nVsHLsZRgo
         2xsue7AXAY3wlvlqsRYLbfmkzyX/lCPxZ0lPxjTa9MxME8skYYXi9hkL6hf7JR7X2Qja
         wdJD1ZXYkvLF3RxiZWHnMe0KSSXaXP+ZZ+nT9S4r8t15Su4ocJlD0tshyW+YFJ2LQSCA
         QYMcPer0QPaHXvbAkhSITAG16XTZyHtymQAf6B4IQcAiWiPkmI3R4LU4Xyq4N0a36lUD
         5ctw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739155196; x=1739759996;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uTr+ihH+SIThNdHSUEBbV3Pz5Z6x2IToXzqKj18NNvI=;
        b=Pi8LvYAGNh06mXKYTLS+FtlispBO2NXUr04KvNqVYU3VQYYYU9i/hrGy8E95fjzQh0
         +uCMnPBcSsaTrU0xXc4JF9lRmXBJMA2nf4bSkfXVV/e72XHsiDfzfR/gn6fYZJxarTE1
         xNCVRHgKNfld6jQBss7p9miAeHEIM+cPgCPrFBTXIBj+T2UxUyp8cY4mg6xQGzWZ7bM0
         weyRdBa+FHjPwReG4nRhkQUu4XiokYHCDCOF+rtULiFWfU3W4KfFFTkOX5QAgqQODnbs
         t6ijOt/KlthcO6wLWkN60wOpdly35Qkpb1cB2mMCojhTm3tIEXA/NvhchgvqX6fbPemo
         g9cg==
X-Forwarded-Encrypted: i=1; AJvYcCUeya9YS9zNI5mqVfLu/RfMvg+v9d2Aag8GUSLfBQrSuRjgw66ZcBTbKKh+Udh2reTajVM+13Du2JFnDLUr@vger.kernel.org, AJvYcCVcBSPFBd/HtdbItQ1RjC2WLoGvxDGA9OKVumhSEUMtb5Av+1MXYEI+MBYLGDucLGHvVL4=@vger.kernel.org, AJvYcCVo8W9Yx5qxcSVCww2c65gG/P4rv6em6BoTpo5pPaoxqoog5fX6iiezJPIxUpXdGn2zfrjyjKXvsIfry0ty7w==@vger.kernel.org
X-Gm-Message-State: AOJu0YybTTdLTJ/vMy63+0QJVfYWaB2Rd1lDEo7eXb2/6hc73z7qB4PX
	YwKJM4DOXngaktjkfaHn3aA/s2MOAP9t3fm8pQ3hFguydsu+l1qP9dWEbUhj+7/3hWGaMNMoc1R
	HzhM9WF0xHjIJDaJDEDCEI7Mrufo=
X-Gm-Gg: ASbGncu10nwAmfvVXt/dt67/qgAextLbr6gUMLrOW11xhMye+JHLgAZmPQwvTz/Nlam
	QG4w+OVq8cDtkx3sNV9ncqCAYQ5j0p9LU2SNXp6QYKH9wR2UAQ2cW3GuTTnhHzaMjkE6Ru5n4kg
	==
X-Google-Smtp-Source: AGHT+IFLrFBz6Qp5UmsNcvQKbR+6E4Vb1a1I8rs9sYIdfJy934iEvNVJWhKe/odmZj33+Zxi6aLCSljLajjPpFIrbC4=
X-Received: by 2002:ad4:5caf:0:b0:6da:dc79:a3cd with SMTP id
 6a1803df08f44-6e4453fdde1mr190364136d6.0.1739155196103; Sun, 09 Feb 2025
 18:39:56 -0800 (PST)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CALOAHbBZc6ORGzXwBRwe+rD2=YGf1jub5TEr989_GpK54P2o1A@mail.gmail.com>
 <alpine.LSU.2.21.2501311414281.10231@pobox.suse.cz> <CALOAHbDwsZqo9inSLNV1FQV3NYx2=eztd556rCZqbRvEu+DDFQ@mail.gmail.com>
 <CAPhsuW4gYKHsmtHsBDUkx7a=apr_tSP_4aFWmmFNfqOJ+3GDGQ@mail.gmail.com>
 <CALOAHbDYFAntFbwMwGgnXkHh1audSoUwG1wFu_4e8P=c=hwZ0w@mail.gmail.com>
 <CAPhsuW4HsTab+w2r23bM52kcM1RBFBKP5ujVdDvxLE9OiqgMdA@mail.gmail.com>
 <CALOAHbAJBwSYju3-XEQwy0O1DNPawuEgmhrV5ECTrL9J388yDw@mail.gmail.com>
 <CAPhsuW51E4epDCrdNcQCG+SzHiyGhE+AocjmXoD-G0JExs9N1A@mail.gmail.com>
 <CALOAHbAaCbvr=F6PBJ+gnQa1WNidELzZW-P2_HmBsZ1tJd6FFg@mail.gmail.com>
 <CAADnVQJZCE-Rh4xghLrruY8DW00cRUq9-ct6d=qfKk8Yc+8=pQ@mail.gmail.com>
 <20250208193237.w3zjcyovgurrin55@jpoimboe> <CAADnVQKXgPTQsjUDB3tjZ46aPWvoEcxBCnDXro8WPtNhkGNFyg@mail.gmail.com>
In-Reply-To: <CAADnVQKXgPTQsjUDB3tjZ46aPWvoEcxBCnDXro8WPtNhkGNFyg@mail.gmail.com>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Mon, 10 Feb 2025 10:39:20 +0800
X-Gm-Features: AWEUYZmgld-_uIP6BOREIBxqILTdQPJGEJW8vgOokSCTnEDDFnCrZ3Rg66itDXg
Message-ID: <CALOAHbA3b8GOxKn9FkbiWEBDkXJ+kY=pVkYMruQyki_0K=1DtQ@mail.gmail.com>
Subject: Re: [RFC PATCH 0/2] livepatch: Add support for hybrid mode
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>, Song Liu <song@kernel.org>, bpf <bpf@vger.kernel.org>, 
	Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>, Jiri Kosina <jikos@kernel.org>, 
	Joe Lawrence <joe.lawrence@redhat.com>, live-patching@vger.kernel.org, 
	LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Feb 9, 2025 at 11:57=E2=80=AFAM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Sat, Feb 8, 2025 at 11:32=E2=80=AFAM Josh Poimboeuf <jpoimboe@kernel.o=
rg> wrote:
> >
> > On Sat, Feb 08, 2025 at 07:47:12AM -0800, Alexei Starovoitov wrote:
> > > On Fri, Feb 7, 2025 at 10:42=E2=80=AFPM Yafang Shao <laoar.shao@gmail=
.com> wrote:
> > > >
> > > > On Fri, Feb 7, 2025 at 2:01=E2=80=AFAM Song Liu <song@kernel.org> w=
rote:
> > > > >
> > > > > On Wed, Feb 5, 2025 at 6:55=E2=80=AFPM Yafang Shao <laoar.shao@gm=
ail.com> wrote:
> > > > > [...]
> > > > > > > I think we should first understand why the trampoline is not
> > > > > > > freed.
> > > > > >
> > > > > > IIUC, the fexit works as follows,
> > > > > >
> > > > > >   bpf_trampoline
> > > > > >     + __bpf_tramp_enter
> > > > > >        + percpu_ref_get(&tr->pcref);
> > > > > >
> > > > > >     + call do_exit()
> > > > > >
> > > > > >     + __bpf_tramp_exit
> > > > > >        + percpu_ref_put(&tr->pcref);
> > > > > >
> > > > > > Since do_exit() never returns, the refcnt of the trampoline ima=
ge is
> > > > > > never decremented, preventing it from being freed.
> > > > >
> > > > > Thanks for the explanation. In this case, I think it makes sense =
to
> > > > > disallow attaching fexit programs on __noreturn functions. I am n=
ot
> > > > > sure what is the best solution for it though.
> > > >
> > > > There is a tools/objtool/noreturns.h. Perhaps we could create a
> > > > similar noreturns.h under kernel/bpf and add all relevant functions=
 to
> > > > the fexit deny list.
> > >
> > > Pls avoid copy paste if possible.
> > > Something like:
> > >
> > > BTF_SET_START(fexit_deny)
> > > #define NORETURN(fn) BTF_ID(func, fn)
> > > #include "../../tools/objtool/noreturns.h"
> > >
> > > Should work?
> > >
> > > Josh,
> > > maybe we should move noreturns.h to some common location?
> >
> > The tools code is meant to be independent from the kernel, but it could
> > be synced by copying it to both include/linux and tools/include/linux,
> > and then make sure it stays in sync with tools/objtool/sync-check.sh.
> >
> > However, noreturns.h is manually edited, and only for some arches.  And
> > even for those arches it's likely not exhaustive: we only add to it whe=
n
> > we notice an objtool warning, and not all calls to noreturns will
> > necessarily trigger a warning.  So I'd be careful about relying on that=
.
> >
> > Also that file is intended to be temporary, there have been proposals t=
o
> > add compiler support for annotating noreturns.  That hasn't been
> > implemented yet, help wanted!
> >
> > I think the noreturn info is available in DWARF, can that be converted
> > to BTF?
>
> There are 30k+ noreturn funcs in dwarf. So pahole would need to have
> some heuristic to filter out the noise.
> It's doable, but we need to stop the bleeding the simplest way
> and the fix would need to be backported too.
> We can copy paste noreturns.h or #include it from the current location
> for now and think of better ways for -next.

It seems like the simplest way at present.
I will send a patch.


--
Regards
Yafang

