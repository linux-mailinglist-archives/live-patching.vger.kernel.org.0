Return-Path: <live-patching+bounces-386-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6CEAA92C214
	for <lists+live-patching@lfdr.de>; Tue,  9 Jul 2024 19:15:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 900341C22325
	for <lists+live-patching@lfdr.de>; Tue,  9 Jul 2024 17:15:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B736518C17F;
	Tue,  9 Jul 2024 17:07:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oKcK3PHI"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0DAA18C17B
	for <live-patching@vger.kernel.org>; Tue,  9 Jul 2024 17:06:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720544820; cv=none; b=C38uvuem0nbfyUEeXJBjwQr2PajBTiX7cuNUJfSWSE6O4MB3rk4NY7xy6V6dUKww6jvDwZ2nbtQEHptT/3E8GC2KZbB1y/cKw5+pz0kkEWWcgFspM5u4hxnvyXcQVfodR8IEO9fDHSEnI/pzkXRI3bkhkciLzCm/ye7lpPegp1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720544820; c=relaxed/simple;
	bh=3AY26J0E7pTWnnJ6v9xWJHnTo22p5NqVNojFSJ4mZbY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KhVmrclhiXb2z4yenfg1OvD6khHZyE1wDj5PBhiF/UNXaJ6gqt/brQN4LPN3qkfRQG/kKzrxLLuKAOe53ITrOVJWxQnubWO/tyWYtUhh3b1axwRwSeH1W7+yolYAJ27EXVDWkOqmnKmhRxdhhNVPo1LtB/zvrGhXLR3kPOd8piU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=oKcK3PHI; arc=none smtp.client-ip=209.85.167.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-518948e1ec8so148e87.0
        for <live-patching@vger.kernel.org>; Tue, 09 Jul 2024 10:06:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1720544817; x=1721149617; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3AY26J0E7pTWnnJ6v9xWJHnTo22p5NqVNojFSJ4mZbY=;
        b=oKcK3PHI5KoL0IsMAgldvkGpaPXv70L1DutdHhnWiJ1Bs9eAUbFWPbnJsG0CjSWMox
         JdGnB1LeUIl3Lo+eb++ywhP3AlmF8oeKFrOtpwoMsRsd/sMj8EY9aKh6TLZIIqo9MeV+
         j+KdajZU6oILUP6Ig7cERzD6Ftjn+1gJjWZqdWAvp4mQ5XOWl+39DuJ7tfU/jllCLISG
         FG4icvAf4XhZmHkdagB+vjdYmJZmB8NWAOimyYvfV5caK1UpyM1D1tvVKuhipjcgmkOm
         3VbTctZI1hcgZ60OxISUu8tvd4cssV3rqKSOkq5JBi/IiHmsewBgVwG5eJxx2H64JEvD
         y13A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720544817; x=1721149617;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3AY26J0E7pTWnnJ6v9xWJHnTo22p5NqVNojFSJ4mZbY=;
        b=jsR9Lz3RYkwZHrY9MHJ8Lrhdrvs0vQ1sv2ncJUitbbJkf/Fb6LrPCd1SnerF3KAHEm
         GzNRz+IF/swjzFQlcU9u10VkXM9FZ5bRXuuyKbHeinKMliv/XaQoJflAkgeI/anTNWNB
         /jUppKyYVtqW3lnYR1azQ2Sl+lIkmxkBDYu64l3aGsIhM2dzKIqzd6dBRHWIqU8gbPhz
         8pvPvqZwnaqxwlgstY/hC91cxvkIf7pCLMJV03a/RPQoH94EydBTfcs3mL2vZkADFKrp
         ELsWB4jRIn9eC3rwMikHAZ13zUMC0nOd6zVqFatuFl/lMwu2IPkpDH6SejjRkB+fdah0
         YJxw==
X-Forwarded-Encrypted: i=1; AJvYcCXh104retiA8rhmFPnXsQphvZNIaF4sT6uYJWHvuke15i4kD+svR+MdZ8otKi6i4qe2xaWimKmXGs42CdlN/3oJYLaWhfidOyoOpxgwVg==
X-Gm-Message-State: AOJu0YzF9K1wwcYd9AVTQAOUtFQRCuf1GaPaoRdnPcSs9+MBA4Ah6W3G
	JUlOUDHpV1kACiWfbyygOIfWNcPIjAfQu1OXrqXf67egjK+RaIYiojizo8782nz0OD2TgxDRQ/Y
	DydVxPkH4fMt4F65ZwJ4YoO9/f+HQkmmwy1Iu
X-Google-Smtp-Source: AGHT+IHTw8zetyHtmdpJevdGfX9dcYSkvFXlivPz1/Rx8YslHZ7sCnHMlbE4CgbKlpbepJz0z8+n5+erKZncraSwyx0=
X-Received: by 2002:a05:6512:4016:b0:52c:dd42:cf57 with SMTP id
 2adb3069b0e04-52eb9783b46mr194539e87.0.1720544816796; Tue, 09 Jul 2024
 10:06:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240605032120.3179157-1-song@kernel.org> <alpine.LSU.2.21.2406071458531.29080@pobox.suse.cz>
 <CAPhsuW5th55V3PfskJvpG=4bwacKP8c8DpVYUyVUzt70KC7=gw@mail.gmail.com>
 <alpine.LSU.2.21.2406281420590.15826@pobox.suse.cz> <Zn70rQE1HkJ_2h6r@bombadil.infradead.org>
 <ZoKrWU7Gif-7M4vL@pathway.suse.cz> <20240703055641.7iugqt6it6pi2xy7@treble>
 <ZoVumd-b4CaRu5nW@bombadil.infradead.org> <ZoZlGnVDzVONxUDs@pathway.suse.cz>
 <ZoxbEEsK40ASi1cY@bombadil.infradead.org> <CABCJKucSUA_fc1eWecWAZ3z8J-T=s5zsZunJHF2VgB=9V5c3tA@mail.gmail.com>
In-Reply-To: <CABCJKucSUA_fc1eWecWAZ3z8J-T=s5zsZunJHF2VgB=9V5c3tA@mail.gmail.com>
From: Matthew Maurer <mmaurer@google.com>
Date: Tue, 9 Jul 2024 10:06:44 -0700
Message-ID: <CAGSQo03R+HYcX2JJDSm7LA8V370s_3hrbTBc2s51Pp9nxWTz5w@mail.gmail.com>
Subject: Re: [PATCH] kallsyms, livepatch: Fix livepatch with CONFIG_LTO_CLANG
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>, Petr Mladek <pmladek@suse.com>, Gary Guo <gary@garyguo.net>, 
	Masahiro Yamada <masahiroy@kernel.org>, =?UTF-8?Q?Michal_Such=C3=A1nek?= <msuchanek@suse.de>, 
	Lucas De Marchi <lucas.demarchi@intel.com>, Andreas Hindborg <nmi@metaspace.dk>, 
	Josh Poimboeuf <jpoimboe@kernel.org>, Miroslav Benes <mbenes@suse.cz>, Song Liu <song@kernel.org>, 
	live-patching@vger.kernel.org, linux-kernel@vger.kernel.org, jikos@kernel.org, 
	joe.lawrence@redhat.com, nathan@kernel.org, morbo@google.com, 
	justinstitt@google.com, thunder.leizhen@huawei.com, kees@kernel.org, 
	kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 8, 2024 at 5:07=E2=80=AFPM Sami Tolvanen <samitolvanen@google.c=
om> wrote:
>
> On Mon, Jul 8, 2024 at 2:33=E2=80=AFPM Luis Chamberlain <mcgrof@kernel.or=
g> wrote:
> >
> > Looking at this again its not to me why Masahiro Yamada's suggestion on
> > that old patch series to just increase the length and put long symbols
> > names into its own section [0] could not be embraced with a new kconfig
> > option, so new kernels and new userspace could support it:
> >
> > https://lore.kernel.org/lkml/CAK7LNATsuszFR7JB5ZkqVS1W=3DhWr9=3DE7bTf+M=
vgJ+NXT3aZNwg@mail.gmail.com/
>
> Matt, was there a reason we didn't move forward with Masahiro's
> proposal? It sounds reasonable to me, but I might be missing some
> background here.

I liked Masahiro's proposal, and implemented it [1], but in the first
version of the patch, folks complained [2] that I was touching code
that was hard to reason about, and that I should clean it up. In the
second version of the patch, I cleaned it up, and was told the cleanup
patch was too big and needed to be broken down [3].

If we want to revive that, it appears there's one or two PPC userspace
tool issues I need to address first, but I could do so, and attempt to
break the cleanup patch into smaller pieces to be more reviewable. I
had abandoned it because even if completed, without the new work Sami
did on extracting a hash from debug symbols, it would not have been
accepted as a way to enable MODVERSIONS. When we generated this new
approach, I suggested we do hashes to avoid modifying the module
loading code given the previous reaction.

[1]: https://lore.kernel.org/all/20231118025748.2778044-1-mmaurer@google.co=
m/
[2]: https://lore.kernel.org/all/ZVZNh%2FPA5HiVRkeb@bombadil.infradead.org/
[3]: https://lore.kernel.org/all/2023111818-agent-verdict-99a5@gregkh/

