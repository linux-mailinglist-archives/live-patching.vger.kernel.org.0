Return-Path: <live-patching+bounces-631-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 42B84970368
	for <lists+live-patching@lfdr.de>; Sat,  7 Sep 2024 19:43:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D72B01F2211D
	for <lists+live-patching@lfdr.de>; Sat,  7 Sep 2024 17:43:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79C6115D5BE;
	Sat,  7 Sep 2024 17:43:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kloab355"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A92128FC;
	Sat,  7 Sep 2024 17:43:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725731003; cv=none; b=c//m0dfJogeOUAdIRnInfWghEsQEDRy4UhivcNR2P4VnMNcHn8d5JUpYdTqEeI+a8Soz4Pd318iz9n5w/tP0SOk+LSCF5rZO2lh8i8/vO0YPtZvRCdZXAfv1rcaJSntH+WWX2o76ZrIGUZUfTivwceclRg91GONmR1Gbz1Syt8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725731003; c=relaxed/simple;
	bh=tWBBNdt/dYMq0tke26EksUosMIf92AiKQaL3UfDcgmo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KGMJ0QRJwjnEFC+Rrp8+hsHK2ocYTu9LBdyKnh4IpO+A0xTbSqCZhYZceOz1ZzTWbDwS7PLN9nEnVLhdlEgFKvsEnDp9P6TljvvEp+oY3OAy/23ANt4xVMlT1X8fGalnSIYBGj4EB7KNIPXd5iQofq7zFGn8PKbN6JTXhSdIqK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kloab355; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2A1DC4CECA;
	Sat,  7 Sep 2024 17:43:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725731002;
	bh=tWBBNdt/dYMq0tke26EksUosMIf92AiKQaL3UfDcgmo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=kloab355DLmr6NPhmn/O/KEWqasPT3fNVSuj7Nwh8phzPBiE12PB7FOYgfq1XfS/R
	 s1gL16Zg2v02Deey4nJvyYTk4PYxb39a35OOkBLlEEyRYJ9dwznx8lWBZw2RKNd0yF
	 cxIo5FFY3ntWoUonxvu8N/SfLbVqlWZbaKWs3xaoHMnHVHaMUP0sU25m/vyIBQT5ts
	 5fW8HbwPagkC99Zc5c+43VCkYsAOVA7izEc97XYbLbUzSBeuJHvzZr9NKR4DupKOtg
	 gs+uy+vvWKUvGjrIbHbNJAV7365KZNEPH2ak4XGhfHw9HxQmMdGiTMSO8yeyNUZ37Y
	 oYaz+YWThyTAw==
Received: by mail-io1-f45.google.com with SMTP id ca18e2360f4ac-829f7911eecso168242839f.1;
        Sat, 07 Sep 2024 10:43:22 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCV4Jh1GQSDm/55OTS08PvYwknzWr7hWj02OpyvpLKuP/xYEuw9Z7h6rWrZ0MtVlVe+TNdPay1xghbpTlgY=@vger.kernel.org
X-Gm-Message-State: AOJu0YzoICd6u11zUzSH0HRLsZYtp4X5ay6Q6Gb9GrqfIJikoIesdVru
	gWz/bW0OCes1FIe6nu4kUKYckF4gRiO8oiSvNSVWTrcMX9fw1MHxadgIxjlPFY0eCnIPztdCk/C
	kzKgznXAWrdjuzKrK9fJWFGhu0WA=
X-Google-Smtp-Source: AGHT+IELCgF7CcmYKX9geNKewtHJmL3zUEEwyRLfSHhKpfy8DOcoiHlRC9V4HR/6k0CGzpVUx/FoevC+JvYcQGN+RcM=
X-Received: by 2002:a05:6e02:20e2:b0:3a0:4fb8:ceda with SMTP id
 e9e14a558f8ab-3a0523999bdmr60359045ab.17.1725731002162; Sat, 07 Sep 2024
 10:43:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1725334260.git.jpoimboe@kernel.org> <CAPhsuW6V-Scxv0yqyxmGW7e5XHmkSsHuSCdQ2qfKVbHpqu92xg@mail.gmail.com>
 <20240907064656.bkefak6jqpwxffze@treble>
In-Reply-To: <20240907064656.bkefak6jqpwxffze@treble>
From: Song Liu <song@kernel.org>
Date: Sat, 7 Sep 2024 10:43:10 -0700
X-Gmail-Original-Message-ID: <CAPhsuW4hNABZRWiUrWzA6kbiiU1+LpnsSCaor=Wi8hrCzHwONQ@mail.gmail.com>
Message-ID: <CAPhsuW4hNABZRWiUrWzA6kbiiU1+LpnsSCaor=Wi8hrCzHwONQ@mail.gmail.com>
Subject: Re: [RFC 00/31] objtool, livepatch: Livepatch module generation
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: live-patching@vger.kernel.org, linux-kernel@vger.kernel.org, 
	x86@kernel.org, Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>, 
	Joe Lawrence <joe.lawrence@redhat.com>, Jiri Kosina <jikos@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Marcos Paulo de Souza <mpdesouza@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 6, 2024 at 11:46=E2=80=AFPM Josh Poimboeuf <jpoimboe@kernel.org=
> wrote:
>
> On Tue, Sep 03, 2024 at 10:32:00AM -0700, Song Liu wrote:
> > +++ w/tools/objtool/elf.c
> > @@ -468,10 +468,8 @@ static void elf_add_symbol(struct elf *elf,
> > struct symbol *sym)
> >          *
> >          * TODO: is this still true?
> >          */
> > -#if 0
> > -       if (sym->type =3D=3D STT_NOTYPE && !sym->len)
> > +       if (sym->type =3D=3D STT_NOTYPE && !sym->len && false)
> >                 __sym_remove(sym, &sym->sec->symbol_tree);
> > -#endif
>
> Song, can you explain this change?  Was there a warning about
> __sym_remove() not being used?  Not sure how that would be possible
> since it should be static inline:
>
> INTERVAL_TREE_DEFINE(struct symbol, node, unsigned long, __subtree_last,
>                      __sym_start, __sym_last, static inline, __sym)
>                                               ^^^^^^^^^^^^^
>

clang gives the following:

elf.c:102:1: error: unused function '__sym_remove' [-Werror,-Wunused-functi=
on]
  102 | INTERVAL_TREE_DEFINE(struct symbol, node, unsigned long, __subtree_=
last,
      | ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~=
~~~~~
  103 |                      __sym_start, __sym_last, static inline, __sym)
      |                      ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
/data/users/songliubraving/kernel/linux-git/tools/include/linux/interval_tr=
ee_generic.h:65:15:
note: expanded from macro 'INTERVAL_TREE_DEFINE'
   65 | ITSTATIC void ITPREFIX ## _remove(ITSTRUCT *node,
               \
      |               ^~~~~~~~~~~~~~~~~~~
<scratch space>:155:1: note: expanded from here
  155 | __sym_remove
      | ^~~~~~~~~~~~
1 error generated.

gcc didn't complain here.

Thanks,
Song

