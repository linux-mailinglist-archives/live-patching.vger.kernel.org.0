Return-Path: <live-patching+bounces-1139-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CC53BA2D449
	for <lists+live-patching@lfdr.de>; Sat,  8 Feb 2025 07:42:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DAACA3AA8DD
	for <lists+live-patching@lfdr.de>; Sat,  8 Feb 2025 06:42:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7342F1A314C;
	Sat,  8 Feb 2025 06:42:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HvsqJvHC"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DECD7157E6B;
	Sat,  8 Feb 2025 06:42:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738996925; cv=none; b=ukHx2G38CIrBbJVyJevTv97UQZR0Sbp79yc1ufzZTvODwXJ3U2QYEvj1GqXbmwuVL3O5uPa+iM+T51sjZBpwGsj3hEpIZYSJqCsD+IiMDhYqINlH3nl+O1uHx9KpsHxJH6drV6fdiFWPp1JHNgCNkd3FBa07D6owuIsN3mH112k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738996925; c=relaxed/simple;
	bh=wWMaU7kgqaQKoYCnX/AS8gqZVoCu0I4JE4OFgye+g8E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WOo+Z7gIQIa+AHx7i1352f9D/JrU27ZYtThcuq/c0AjdapTbMqzKg7QCJZN1WlS9wRIcb05U9Ib3E+ybz+We0koV/rDB5WS+Z+INIWl1px4OWfWuff5wcdwz+2KEvGxam5tYOZunTopwryPMlggyEk84rAEnTutDRocFLmQEeHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HvsqJvHC; arc=none smtp.client-ip=209.85.219.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-6e442b79de4so18806156d6.2;
        Fri, 07 Feb 2025 22:42:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738996923; x=1739601723; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KNoF24EWj8YqX5r+Yb0JvKHiF3XwnsqNhDQYoay6GVM=;
        b=HvsqJvHCYRRcgEhpZVy6X7g2H4ET4jp0UXf3e/O4cHeXbO1Ke51NDcsD4Y8t6Jts93
         RTj1A4h63aGdha8NHOkDvw4LrHoUYOvahqJOrCaZw2EDZpFu85HYFZ18zAF297aIlBaY
         V3Q5kG0GyyNSgfFR8JR6pV2hV6RhLbc2Ma35YqZZSUQRKVo97fX8Z7MIet81kAp2nfmX
         a40yeTUl3aCTiIN7kaefhqeKyh+IG45GbMEXxkWYuirNnGEdGk86Mpi9XmnTc8JSqmdK
         jojXLoXQcPNRpOKPFrDusUeLP3TGMz+/BLSEcMywRAu/qM8V0yPkOICOU/19oq1FLDEW
         prbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738996923; x=1739601723;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KNoF24EWj8YqX5r+Yb0JvKHiF3XwnsqNhDQYoay6GVM=;
        b=rnbYILwK8v6Ax7f6su67vswc6h7RhuJQF+tH5kXDAfk5HW268k64I7S9hZATLzyoNA
         O6Mtk2PLK0wsan4e8qKUMarX/yjBPN5++ecS8bAahoRE8EsxZrgNbjbf8g+qChnkXjNR
         QfveaZiazqktsMwUaZcCXdnJ2Ou3nnQBVAcKSPRWrfLTf23M6Z8IfklRc9ycwo0wizDV
         0CFL6DrN4+VyiWSlh9Qo+FdgqI6o/nnqEZIzurJ6wr1WZoh0ejqUndYb/2Nc43C9+g5F
         SQruL7MtBptN9nm8m76HiBQpJ7Wnwxx6bpWaH0yV8p6PpxBSVHTtoSh3uHT1v1zn8Iwy
         I+sQ==
X-Forwarded-Encrypted: i=1; AJvYcCVP0GQfukhZOG146+5VfTvJVpYjHwD+9gAzX5fJIIuizuWG5XJuljSGLEN4eTk369SoMmVkpi7CfsupEPItvg==@vger.kernel.org, AJvYcCVe/KQozHTLNBPHhU5DPQxC9am1O+8hClj0t6/xNQmAFrAZOsMxTrmQhypqxycC6uuX6Hz6MVtdaeJKsTM=@vger.kernel.org
X-Gm-Message-State: AOJu0YyfevUmOZ5YYyhXCIGBlxa8edjfv8MnqJ88oWf+0VVN405uBvLA
	iTGq51iCMCHp11KowcgcBMYS4pEgoY2Q3F0PlWmedm3zLANhSCpK8zEM117AxJ52Au91efMz4wb
	nwYSNuMVTMt7Ale06mHzBhW0AXpc=
X-Gm-Gg: ASbGncuxwNC7K0ayhjln+w+1mpK11DBEQ8fIa90JyT5R6ro1s9594zXnlAquEypDjxO
	Xazk/M2C5A1dXkrUnlpp+XEE2dNBhylmB4/Mg6krimwcDEEFjmwNkV+ik9vhmvDsquNf+Mlvcvk
	M=
X-Google-Smtp-Source: AGHT+IEs9HDzxbSnf4IuE2Us6jRZq5uN6GtBF34aMoCTWAhmW49kkqa8vONjcSMbO5sJv9M9Po/b4dEo6KUDYdx+FNc=
X-Received: by 2002:a05:6214:c6e:b0:6d8:9e16:d08e with SMTP id
 6a1803df08f44-6e445684b70mr70874766d6.26.1738996922769; Fri, 07 Feb 2025
 22:42:02 -0800 (PST)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250127063526.76687-1-laoar.shao@gmail.com> <Z5eOIQ4tDJr8N4UR@pathway.suse.cz>
 <CALOAHbBZc6ORGzXwBRwe+rD2=YGf1jub5TEr989_GpK54P2o1A@mail.gmail.com>
 <alpine.LSU.2.21.2501311414281.10231@pobox.suse.cz> <CALOAHbDwsZqo9inSLNV1FQV3NYx2=eztd556rCZqbRvEu+DDFQ@mail.gmail.com>
 <CAPhsuW4gYKHsmtHsBDUkx7a=apr_tSP_4aFWmmFNfqOJ+3GDGQ@mail.gmail.com>
 <CALOAHbDYFAntFbwMwGgnXkHh1audSoUwG1wFu_4e8P=c=hwZ0w@mail.gmail.com>
 <CAPhsuW4HsTab+w2r23bM52kcM1RBFBKP5ujVdDvxLE9OiqgMdA@mail.gmail.com>
 <CALOAHbAJBwSYju3-XEQwy0O1DNPawuEgmhrV5ECTrL9J388yDw@mail.gmail.com> <CAPhsuW51E4epDCrdNcQCG+SzHiyGhE+AocjmXoD-G0JExs9N1A@mail.gmail.com>
In-Reply-To: <CAPhsuW51E4epDCrdNcQCG+SzHiyGhE+AocjmXoD-G0JExs9N1A@mail.gmail.com>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Sat, 8 Feb 2025 14:41:26 +0800
X-Gm-Features: AWEUYZnkfqwAOyDcshbUwDrxk7zHdHKhEWMZwGV_f1rXNLE-APUdHuKjOXI0J5I
Message-ID: <CALOAHbAaCbvr=F6PBJ+gnQa1WNidELzZW-P2_HmBsZ1tJd6FFg@mail.gmail.com>
Subject: Re: [RFC PATCH 0/2] livepatch: Add support for hybrid mode
To: Song Liu <song@kernel.org>
Cc: bpf <bpf@vger.kernel.org>, Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>, 
	jpoimboe@kernel.org, jikos@kernel.org, joe.lawrence@redhat.com, 
	live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 7, 2025 at 2:01=E2=80=AFAM Song Liu <song@kernel.org> wrote:
>
> On Wed, Feb 5, 2025 at 6:55=E2=80=AFPM Yafang Shao <laoar.shao@gmail.com>=
 wrote:
> [...]
> > > I think we should first understand why the trampoline is not
> > > freed.
> >
> > IIUC, the fexit works as follows,
> >
> >   bpf_trampoline
> >     + __bpf_tramp_enter
> >        + percpu_ref_get(&tr->pcref);
> >
> >     + call do_exit()
> >
> >     + __bpf_tramp_exit
> >        + percpu_ref_put(&tr->pcref);
> >
> > Since do_exit() never returns, the refcnt of the trampoline image is
> > never decremented, preventing it from being freed.
>
> Thanks for the explanation. In this case, I think it makes sense to
> disallow attaching fexit programs on __noreturn functions. I am not
> sure what is the best solution for it though.

There is a tools/objtool/noreturns.h. Perhaps we could create a
similar noreturns.h under kernel/bpf and add all relevant functions to
the fexit deny list.

--
Regards
Yafang

