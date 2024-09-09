Return-Path: <live-patching+bounces-639-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0AE209724A1
	for <lists+live-patching@lfdr.de>; Mon,  9 Sep 2024 23:44:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B63DD1F24376
	for <lists+live-patching@lfdr.de>; Mon,  9 Sep 2024 21:43:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C32618C035;
	Mon,  9 Sep 2024 21:43:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GA2n0SOM"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6DB418030;
	Mon,  9 Sep 2024 21:43:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725918234; cv=none; b=IA4KMZv4SKpW/b2g0uCNCsIseHD0t/lMh2rBKnIJIwaVHJfQycxV/ioA3bj4An42CO8K/fgeY6SasXyGavKlvnigy1+5/9fUcGzi3fLu8t2QCJclMSuSQIQBbVWt55oZEyTcyeaBeqz1uOGw1PX3r3DHPvFsaNFqA5Mz8XPpbw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725918234; c=relaxed/simple;
	bh=79UI1RgdHCAz7Z4Iqu6nE2LQ79fwcuO4rH0u18JtymA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ly0khxSMUyQ/X3/kAcOZ6GmQzALo3QepCySmqIaBQ+h+msmBhZSOhouqLtT3gRWH3jttD+B8Pss3Ast36sfcAphiNZx2V6Az38NJWUa80GK91Kghxd9mmaGbRsJ7XQxIJBLdh9mO0SQZXS2qiDjh2ed6gDvp0betGPNBKHPSpPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GA2n0SOM; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66784C4CEC6;
	Mon,  9 Sep 2024 21:43:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725918234;
	bh=79UI1RgdHCAz7Z4Iqu6nE2LQ79fwcuO4rH0u18JtymA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=GA2n0SOMH4q2t2GS53UIww9gKKloFkmIgxzq8pzRrLQ/0TNXGVhPtHwh1fi3bTeym
	 z/6E/Q+VSdIVA4p7ssb/yy5Ol7NrLZi+kjC96z0CCK4/MWdB/837EJ6fpBx4Somj4S
	 D5T4OXrt4n2c1K+ZAoUVSiQcGllte0JycmWqUBzA4ZflXrf7ZkQHPvUGmXczLd+LJk
	 oeXb48lYoYmc4s9WHVxVLnvNCu/lFo8VqfAvqeeivd8kTe0nTlBm6rgHawkLMClOC1
	 Nh57G6zl3Z6tmIVeRVZ9QIqopMYRUSTu+PwDubzNsxt+9cuObjMHkTRwJwePEAYX6d
	 mRRgZT1DMzSSQ==
Received: by mail-il1-f177.google.com with SMTP id e9e14a558f8ab-39d47a9ffd5so269045ab.2;
        Mon, 09 Sep 2024 14:43:54 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVpTnf/qv2+jl8w+PJFdq+ZohBhR8YND7wPk4ujbMyckrmgLMkErekIyvAFI+yjTbIps6lno87P5X0EphI=@vger.kernel.org
X-Gm-Message-State: AOJu0YwPeyRbI9/TkF6bIjkCdqHkanptyJ4Znn9tOInwxQFsGBl/SigF
	FgVoVaUQYGkj4/T5AhRqhdDdSheQJK0LspAiH3p/+casWgHcy2W864SspHx1NqefzDacp5oOZjg
	NUWK/E56fvW4jI4eaj1q6Y6euFhs=
X-Google-Smtp-Source: AGHT+IHVQEP3XJMT3yC7dw9uKpb9nBVj4z60x9CU4JnXOwl2vUMuXJh4xOQ+oRQI5d3wSqa2dW6wrYC4KA8m2xc09Vs=
X-Received: by 2002:a05:6e02:b43:b0:39a:eb57:dc7 with SMTP id
 e9e14a558f8ab-3a04f0734a1mr134054315ab.1.1725918233783; Mon, 09 Sep 2024
 14:43:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1725334260.git.jpoimboe@kernel.org> <CAPhsuW6V-Scxv0yqyxmGW7e5XHmkSsHuSCdQ2qfKVbHpqu92xg@mail.gmail.com>
 <20240907064656.bkefak6jqpwxffze@treble> <CAPhsuW4hNABZRWiUrWzA6kbiiU1+LpnsSCaor=Wi8hrCzHwONQ@mail.gmail.com>
 <20240907201445.pzdgxcmqwusipwzh@treble> <CAPhsuW4TyQSSnAR70cE8FChkkqX-3jFAP=GKS7cuaLSNxz00MA@mail.gmail.com>
 <20240909211902.3tvzxp6wryqvbbhr@treble>
In-Reply-To: <20240909211902.3tvzxp6wryqvbbhr@treble>
From: Song Liu <song@kernel.org>
Date: Mon, 9 Sep 2024 14:43:42 -0700
X-Gmail-Original-Message-ID: <CAPhsuW7srL16mtEUKTaPPOvhrt1XAHMZGbtYbta1qeyWEmDpiA@mail.gmail.com>
Message-ID: <CAPhsuW7srL16mtEUKTaPPOvhrt1XAHMZGbtYbta1qeyWEmDpiA@mail.gmail.com>
Subject: Re: [RFC 00/31] objtool, livepatch: Livepatch module generation
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: live-patching@vger.kernel.org, linux-kernel@vger.kernel.org, 
	x86@kernel.org, Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>, 
	Joe Lawrence <joe.lawrence@redhat.com>, Jiri Kosina <jikos@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Marcos Paulo de Souza <mpdesouza@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 9, 2024 at 2:19=E2=80=AFPM Josh Poimboeuf <jpoimboe@kernel.org>=
 wrote:
>
> On Sat, Sep 07, 2024 at 10:04:25PM -0700, Song Liu wrote:
> > I think gcc doesn't complain, but clang does:
> >
> > $ cat ttt.c
> > static inline void ret(void)
> > {
> >   return;
> > }
> >
> > int main(void)
> > {
> >   return 0;
> > }
>
> Ah...  That's probably why the kernel adds "__maybe_unused" to its
> inline macro (which the tools don't have).
>
> Does this fix?

Yes! It fixes this problem.

Thanks,
Song

