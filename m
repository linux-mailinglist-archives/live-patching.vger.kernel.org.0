Return-Path: <live-patching+bounces-1143-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 767FCA2DAB8
	for <lists+live-patching@lfdr.de>; Sun,  9 Feb 2025 04:57:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F364E1655D9
	for <lists+live-patching@lfdr.de>; Sun,  9 Feb 2025 03:57:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 001381B95B;
	Sun,  9 Feb 2025 03:57:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CtmT0bJj"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FCEC14F70;
	Sun,  9 Feb 2025 03:57:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739073425; cv=none; b=tyJnwPtVFjShuYaqagyCDOaW3Wi2CeMG3ciN07UiDsb43/gParU9onJ6cMOONVBI9CPlL0LA7iB3xNiQdqCCRVS+GM+zg6O4IUrFjwXAg34X6imBra8evlBlfgGb26lF3GI7pWpvz0a2fUBWhNHw/VMXnQVrRIF8NgKYFuopRMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739073425; c=relaxed/simple;
	bh=abo4VuyuuChxbEXDy2RGRYYYHBxzQJgpTOdZ1NYxoSQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sbOXcOmDOle3J8hmyrPN5Fh3RwqP5mU6cnJix8apEXIAid3BsU7h88671dBILF2iDXfiJR8mYG6BUHUeE2QamPovcaMkpweH5SvIUkC6QP8W1s2zLobFthCHoE1ki/bFGwBOq+CIKEf62JyMA5DkE0734c1giQ+Mh6Yc/WePRYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CtmT0bJj; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-38dd0dc2226so1164343f8f.2;
        Sat, 08 Feb 2025 19:57:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739073422; x=1739678222; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tEfu0T4M+EpepKDscRwBKRkl9O4AhIe/Wi41/MnZPsc=;
        b=CtmT0bJjcAw72pVLILbNZsD69fVeZaPGWSmofUeU2pnVtRGnqfSDZLafNITbyTMhbq
         URO1SOd8m9KyG9Kpkge7xvradmlYSvmm7Q0E5MlmIRq5eFezD7OPMSGAr24hxmy0tfjv
         FjIdFPHJx1Vl9YnVg8cKrDxp6xH/NvhbvctfMGSJ78pEhTM2/RCf3LNa5acamqUen/T5
         0O+1W9O9t60yuCt5pNQB1/1xYus6iugb3YNP2JIDCImQhFbLpfR8ZRSX14SabiLuWipf
         cW2bIhn4U2vY6AXQQSa5OWESNi+v73X/hlRC5x509DSP6doFVZ9t4uAFRoiBavIBST5H
         K8Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739073422; x=1739678222;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tEfu0T4M+EpepKDscRwBKRkl9O4AhIe/Wi41/MnZPsc=;
        b=r2XVKLD7+f8koRPC1dC/JB1Vytth0+Wm681d8REO+yab7ELhIID09Fc42VFqCkZBvK
         +m/Ldj3GvY64uea/bgcwBmhpgs5MKcv33r6tZkdH3wCBeuL2l4OqG4Z7o9PYk9CsQ6kP
         tf3/ncykMxYcRwTbC7WxHOdD/YN1fNNa0J14vUfRX4G/RKLKAxtwFMNu+hioDRTRsPJd
         +hGTkk2PJwJyGkXDYMgE/1g4u+pVoM2jEXs3iIZnUMoHALDqv9WP0IubS5JDAMl3BMOZ
         VwKVWnCX8CrwinhU+ZtyPToT4+7DFr7ynkJE0AZrFcbMzxPW3mxWwwKosTZQHybSAbrG
         kF0A==
X-Forwarded-Encrypted: i=1; AJvYcCXdD61RBO+X06XwOy1GsszITac2ueMtfmd56SDH7sk9aDUBml6A8zstLYgHV18pOOdrDVc=@vger.kernel.org, AJvYcCXgC6l/PGUYiEThDmreX3VLJQH9u5diBi0x6uHEzXU82CQ0mnRSDMxQBPVpPxPfbEPKX1xzDS9R5zJyj1Sq@vger.kernel.org, AJvYcCXlem2zJMWKjKH1rWq7KHgvHupeb8JRx3PyUcASMN9TQP2NK40W2E6aT6LsIwhLidDaioPaAW6MMHOqQsOF7A==@vger.kernel.org
X-Gm-Message-State: AOJu0YyNsL+GCh0seIZIsygcSzKaOmFQEV4xmPozM7CmtYfrmDg4eVZv
	LEpBMVzCfbyN0uBc4jf3SR1dAzHxFhbnbNrqF9Cj/xcQdqs6H/nmJD0HJIXgvoRaRdy4cQFpZwV
	VbLbE6/5ts+YaRpCxIiJS/e9E/Ek=
X-Gm-Gg: ASbGncuOrWcsItdhAuiLURSji9t01qknY26hXUw03/nY/iXoxIA6YGA5AFmhek8/4XL
	ypmOXRlr9L71tYYZPAhcwsSmxahcoQTCgE5jZ7TMTYd5Cq/edr5qMdgjW2koBxmbgMjMQ13JFqb
	eQ27T/azjiFtI3jwdfHJxi8vdP8ZPd
X-Google-Smtp-Source: AGHT+IFVdKm/TbRZBCUYcxfboKUecCnZzAtotdQ9hdNs8NDSOP5z+PAwZ9Es9sIm9jwZJAHaojI3AdLsMmi+L7AZFNc=
X-Received: by 2002:a05:6000:1a85:b0:38d:d906:dbb0 with SMTP id
 ffacd0b85a97d-38dd906dcbcmr832823f8f.7.1739073422435; Sat, 08 Feb 2025
 19:57:02 -0800 (PST)
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
 <CAADnVQJZCE-Rh4xghLrruY8DW00cRUq9-ct6d=qfKk8Yc+8=pQ@mail.gmail.com> <20250208193237.w3zjcyovgurrin55@jpoimboe>
In-Reply-To: <20250208193237.w3zjcyovgurrin55@jpoimboe>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Sat, 8 Feb 2025 19:56:51 -0800
X-Gm-Features: AWEUYZniDJypeymOyz7fFdjC93KTr-2QZvKTC8wuH--pd8yPgT5EFAzAHC-HqLc
Message-ID: <CAADnVQKXgPTQsjUDB3tjZ46aPWvoEcxBCnDXro8WPtNhkGNFyg@mail.gmail.com>
Subject: Re: [RFC PATCH 0/2] livepatch: Add support for hybrid mode
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Yafang Shao <laoar.shao@gmail.com>, Song Liu <song@kernel.org>, bpf <bpf@vger.kernel.org>, 
	Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>, Jiri Kosina <jikos@kernel.org>, 
	Joe Lawrence <joe.lawrence@redhat.com>, live-patching@vger.kernel.org, 
	LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Feb 8, 2025 at 11:32=E2=80=AFAM Josh Poimboeuf <jpoimboe@kernel.org=
> wrote:
>
> On Sat, Feb 08, 2025 at 07:47:12AM -0800, Alexei Starovoitov wrote:
> > On Fri, Feb 7, 2025 at 10:42=E2=80=AFPM Yafang Shao <laoar.shao@gmail.c=
om> wrote:
> > >
> > > On Fri, Feb 7, 2025 at 2:01=E2=80=AFAM Song Liu <song@kernel.org> wro=
te:
> > > >
> > > > On Wed, Feb 5, 2025 at 6:55=E2=80=AFPM Yafang Shao <laoar.shao@gmai=
l.com> wrote:
> > > > [...]
> > > > > > I think we should first understand why the trampoline is not
> > > > > > freed.
> > > > >
> > > > > IIUC, the fexit works as follows,
> > > > >
> > > > >   bpf_trampoline
> > > > >     + __bpf_tramp_enter
> > > > >        + percpu_ref_get(&tr->pcref);
> > > > >
> > > > >     + call do_exit()
> > > > >
> > > > >     + __bpf_tramp_exit
> > > > >        + percpu_ref_put(&tr->pcref);
> > > > >
> > > > > Since do_exit() never returns, the refcnt of the trampoline image=
 is
> > > > > never decremented, preventing it from being freed.
> > > >
> > > > Thanks for the explanation. In this case, I think it makes sense to
> > > > disallow attaching fexit programs on __noreturn functions. I am not
> > > > sure what is the best solution for it though.
> > >
> > > There is a tools/objtool/noreturns.h. Perhaps we could create a
> > > similar noreturns.h under kernel/bpf and add all relevant functions t=
o
> > > the fexit deny list.
> >
> > Pls avoid copy paste if possible.
> > Something like:
> >
> > BTF_SET_START(fexit_deny)
> > #define NORETURN(fn) BTF_ID(func, fn)
> > #include "../../tools/objtool/noreturns.h"
> >
> > Should work?
> >
> > Josh,
> > maybe we should move noreturns.h to some common location?
>
> The tools code is meant to be independent from the kernel, but it could
> be synced by copying it to both include/linux and tools/include/linux,
> and then make sure it stays in sync with tools/objtool/sync-check.sh.
>
> However, noreturns.h is manually edited, and only for some arches.  And
> even for those arches it's likely not exhaustive: we only add to it when
> we notice an objtool warning, and not all calls to noreturns will
> necessarily trigger a warning.  So I'd be careful about relying on that.
>
> Also that file is intended to be temporary, there have been proposals to
> add compiler support for annotating noreturns.  That hasn't been
> implemented yet, help wanted!
>
> I think the noreturn info is available in DWARF, can that be converted
> to BTF?

There are 30k+ noreturn funcs in dwarf. So pahole would need to have
some heuristic to filter out the noise.
It's doable, but we need to stop the bleeding the simplest way
and the fix would need to be backported too.
We can copy paste noreturns.h or #include it from the current location
for now and think of better ways for -next.

> Or is there some way to release outstanding trampolines in do_exit()?

we can walk all trampolines in do_exit,
but we'd still need to:
if (trampoline->func.addr =3D=3D do_exit || ...addr =3D=3D __x64_sys_exit |=
|
before dropping the refcnt.
which is the same thing, but worse.

