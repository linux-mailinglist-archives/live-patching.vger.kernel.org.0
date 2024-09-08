Return-Path: <live-patching+bounces-635-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B909F97051C
	for <lists+live-patching@lfdr.de>; Sun,  8 Sep 2024 07:04:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4ADDB1F21A23
	for <lists+live-patching@lfdr.de>; Sun,  8 Sep 2024 05:04:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D7852C18C;
	Sun,  8 Sep 2024 05:04:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mw3sUb/l"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51D7928FC;
	Sun,  8 Sep 2024 05:04:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725771878; cv=none; b=Hw1l6FZiCReawNQRH2yZ74U7XxwxsnY1o+OLaA5SpX5j4lZ3qytTGZB9L/AMJIujxh4UOeu4hrvI38eZLWUyCeTBs2/I3qxsloEs6xED+i95uXbXo4q2LwtF3Qsv8ouzT3PkqmKKxW6j+p3hMkDe40VPTg/Rk9ZYZWIYdNWv28A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725771878; c=relaxed/simple;
	bh=gWTjenl//fl5JKTsIMMhtHISqWDl35YgXIHuX1nrkEc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VjJjZ3XFNzC8RdZ7xIZ6QQbjI/xidjN7HncAwazwGpRMP0HJfSgBe91Ijvzl1wLk+Kr10eMmI/ruGb+/Ief6cuzNO3+mv9IT8nimMDlEmMJuOykvQB26xb6dnTGN8I+99ML3PqW/8ibx9su7J8yPtYpswznWc7vBwV5UzsBkaKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mw3sUb/l; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3F4BC4CEC9;
	Sun,  8 Sep 2024 05:04:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725771877;
	bh=gWTjenl//fl5JKTsIMMhtHISqWDl35YgXIHuX1nrkEc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=mw3sUb/liROHoWUPAWj1EtLJeKdpN1zJiP2PGPanqDThCo1D8twKCcj20bLy1rga5
	 4un14C+zqwHtSKGc4KIpsQOHpD8tmL3xNkUaM7NamdSjAyQQN8wA9zUFzYYAGacd5m
	 GC+NxBkH31Ymr5K6QeSa2BBbEF0sDQ1yZdmBd/becgOV1nCY6zNj6BbYtHa2sB0zha
	 FqnrFrRtv9/v2PD3IusxSB/Jg8S/JbmPlsJsA8ZK7tG3FfM39iD4sRh8MOUrm0wj2z
	 6a4TtEqBIpsojgB1d1OYTJUdrRWZGynZovLrKdrayyOWceuO0vHPallYK6/590ztO6
	 Xj7uh5YypeyRg==
Received: by mail-il1-f172.google.com with SMTP id e9e14a558f8ab-39e6a1e0079so13603985ab.0;
        Sat, 07 Sep 2024 22:04:37 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVspTJofipVWmFAzogZI2+nzEQ7RQeb4ZvRxTZnmgtjXIxEyoU3dXf0AK/drxNRCsxzkemTiWu7fowfklM=@vger.kernel.org
X-Gm-Message-State: AOJu0YxiCKPqHwK3xJKJSO6bN9UqakPlbAUwNvJh6KWtZm5EmTWMc4Fe
	RCu7sQh9e4NEv6tr3IL8D853WM7ckbmzC1VkCGBWDqro4zKLLG3o4Ilb/GBd3V8T7F/H7EW2/QO
	4//bCipCckAE1nAVcZiQH67ZfH7A=
X-Google-Smtp-Source: AGHT+IGNOw8MvXM0Whm9t8FdBfBaTZLKRA0fGYNYR5KZyzHU8Bi6QdyP4nAFyDWziVw+MvIosQIwUVmkJ+aKmU9anQI=
X-Received: by 2002:a92:cdab:0:b0:39f:7318:c1c6 with SMTP id
 e9e14a558f8ab-3a04f0af164mr84296455ab.15.1725771877132; Sat, 07 Sep 2024
 22:04:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1725334260.git.jpoimboe@kernel.org> <CAPhsuW6V-Scxv0yqyxmGW7e5XHmkSsHuSCdQ2qfKVbHpqu92xg@mail.gmail.com>
 <20240907064656.bkefak6jqpwxffze@treble> <CAPhsuW4hNABZRWiUrWzA6kbiiU1+LpnsSCaor=Wi8hrCzHwONQ@mail.gmail.com>
 <20240907201445.pzdgxcmqwusipwzh@treble>
In-Reply-To: <20240907201445.pzdgxcmqwusipwzh@treble>
From: Song Liu <song@kernel.org>
Date: Sat, 7 Sep 2024 22:04:25 -0700
X-Gmail-Original-Message-ID: <CAPhsuW4TyQSSnAR70cE8FChkkqX-3jFAP=GKS7cuaLSNxz00MA@mail.gmail.com>
Message-ID: <CAPhsuW4TyQSSnAR70cE8FChkkqX-3jFAP=GKS7cuaLSNxz00MA@mail.gmail.com>
Subject: Re: [RFC 00/31] objtool, livepatch: Livepatch module generation
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: live-patching@vger.kernel.org, linux-kernel@vger.kernel.org, 
	x86@kernel.org, Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>, 
	Joe Lawrence <joe.lawrence@redhat.com>, Jiri Kosina <jikos@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Marcos Paulo de Souza <mpdesouza@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Sep 7, 2024 at 1:14=E2=80=AFPM Josh Poimboeuf <jpoimboe@kernel.org>=
 wrote:
>
> On Sat, Sep 07, 2024 at 10:43:10AM -0700, Song Liu wrote:
> > clang gives the following:
> >
> > elf.c:102:1: error: unused function '__sym_remove' [-Werror,-Wunused-fu=
nction]
> >   102 | INTERVAL_TREE_DEFINE(struct symbol, node, unsigned long, __subt=
ree_last,
> >       | ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~=
~~~~~~~~~
> >   103 |                      __sym_start, __sym_last, static inline, __=
sym)
> >       |                      ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~=
~~~~
> > /data/users/songliubraving/kernel/linux-git/tools/include/linux/interva=
l_tree_generic.h:65:15:
> > note: expanded from macro 'INTERVAL_TREE_DEFINE'
> >    65 | ITSTATIC void ITPREFIX ## _remove(ITSTRUCT *node,
> >                \
> >       |               ^~~~~~~~~~~~~~~~~~~
> > <scratch space>:155:1: note: expanded from here
> >   155 | __sym_remove
> >       | ^~~~~~~~~~~~
> > 1 error generated.
>
> Here's how __sym_remove() is created:
>
> #define INTERVAL_TREE_DEFINE(ITSTRUCT, ITRB, ITTYPE, ITSUBTREE,          =
     \
>                              ITSTART, ITLAST, ITSTATIC, ITPREFIX)        =
     \
> ...
>
> ITSTATIC void ITPREFIX ## _remove(ITSTRUCT *node,                        =
     \
>                                   struct rb_root_cached *root)           =
     \
>
> INTERVAL_TREE_DEFINE(struct symbol, node, unsigned long, __subtree_last,
>                      __sym_start, __sym_last, static inline, __sym)
>
> ITSTATIC is 'static inline' so it shouldn't be complaining about it
> being unused, right?

I think gcc doesn't complain, but clang does:

$ cat ttt.c
static inline void ret(void)
{
  return;
}

int main(void)
{
  return 0;
}

$ gcc  ttt.c  -Werror -Wunused-function
$ clang ttt.c  -Werror -Wunused-function
ttt.c:1:20: error: unused function 'ret' [-Werror,-Wunused-function]
    1 | static inline void ret(void)
      |                    ^~~
1 error generated.

>
> If you add -E to the cflags to get preprocessed output, can you confirm
> __sym_remove() is 'static inline'?

Yes, it is 'static inline'.

Song

