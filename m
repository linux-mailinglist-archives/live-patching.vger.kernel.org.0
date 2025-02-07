Return-Path: <live-patching+bounces-1130-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8AD47A2C43B
	for <lists+live-patching@lfdr.de>; Fri,  7 Feb 2025 14:58:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 41A5F7A5797
	for <lists+live-patching@lfdr.de>; Fri,  7 Feb 2025 13:57:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11D6F1F4E48;
	Fri,  7 Feb 2025 13:58:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="SZwTBrRS"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E491B1F4169
	for <live-patching@vger.kernel.org>; Fri,  7 Feb 2025 13:58:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738936717; cv=none; b=RDjCELqh5glPtfxAmsvLzJNWD7FxO6kTiLxLVMUqr4us+uUQXAXX64JASe/RvQhKVgUJK6AZz0kykYpZzvTLCmof4gdLOcolMLhTf15F2D5ip0Ewd0uLW4hAP9/R5LnYCngzT/6Mg6IXOFXlOduncxx5b3JsE0dIcQdA3rvTmpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738936717; c=relaxed/simple;
	bh=W5ViNorkjSF6Ys/b81fOd5g5McYJaJtYUlgHhfAmXQg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Fp8+7DDZIEgOvvzUWthml2IHa0irWCBy5k+nUp0qBwxSOnThpt3sYcm0gqJmLpiEOIN8Z7iyeB0QJ9h5NVrmYIiji8EJY6KEBmuKRKVsomjcWwDJ6o+T2ZerTVjpwFYTplK3X3YkD8MuEB6Ng+kUjc6/ekG4oXBOzUmMbfBSnw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=SZwTBrRS; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-388cae9eb9fso1087350f8f.3
        for <live-patching@vger.kernel.org>; Fri, 07 Feb 2025 05:58:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1738936713; x=1739541513; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=7R0XzIQPBWeuoHVAZKueOVfEVTS7EAGJqsFJKc5q2fU=;
        b=SZwTBrRSaLRLOuI3yxPdKISEp5YnDT6F8pFg6nGGfbgHQR4DW40KayismObUwqoeAa
         b4PLPthnLlPvmweowW3egDd1tukybz8aXZCTaSbTiPDF8CydZllvh3BB8ikHg6WrTZ3u
         YO0z6VC/x7+7NwSQyo/jgNzYTqZ3QaxmyuMRKe1OOzplTxexfyuWgHI2taMDkqfJKcSE
         SxOnIOGEwvPq5tadI4Q0tv4EvR+3cKn7EsO+K29sC9nxY7iMMx4pfOV5itjMhcXvEUmB
         TcpGwjkqEQYuJLPNSZ77VPduxhbThdqJ+AWmYsNo7+Ng3j8zY1HawQ0jq16nV/s4uK+B
         1XGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738936713; x=1739541513;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7R0XzIQPBWeuoHVAZKueOVfEVTS7EAGJqsFJKc5q2fU=;
        b=XI2gNdu4q8eWp1gNL+AL9xOXdg8o/U9da/9imnGKl+whYkrN4eO9GWz5qYDfZHQYV9
         H7Sf/gt2igOyHJA3HaycETNknUYJ0e1DOKE5ioTiK3bG/Rf1DkZ5fPzR+aZqUewUVHWC
         7DGeQowgcJeRFJ91eoHNeP5EUZIyDKZIRXJVU1alvw7AgrHx67E0/7QuT4kX/8XKj/JW
         TK+5YlXak0LdFxMVmRiEYrxXZ3l9P8lXtaL4nIQtxDHd6venllETnDHRTXllS8Yn+ZjU
         9NyYAusnp2kTWByrxwFPQb77xtvRBS3LKgILaFyUrYjfaPmw1f5Q4HIjpg/VP2E9btXB
         mEXA==
X-Forwarded-Encrypted: i=1; AJvYcCVFHIIifDWYdhY2Zpn4v5v9Mr9rjEBWgL8SeJqweoWiBX8XTRYk09A3Ck2PEwtaEVPDRHUOqTkERrrFv4bv@vger.kernel.org
X-Gm-Message-State: AOJu0Yw4FtU3hPJ8TnUIOp2GkfJUfUYrSdXKucvJK+i8MAZkvWhvI13Z
	dgqvFdfQWW8TXdrXamoQZO6fuJNhPKjr1CjklssRXtfSx61btHnzz4dQb0VIc3k=
X-Gm-Gg: ASbGnctnykDvQJS+KEdoLb82iirPTloRF9uGJezNxbgDQxoyUz23OIrr4FeAMI9v5JN
	5laO+YCS1DJuYNIoFjgBMZYe48i3Z0I0dAwIhwwPotl930cY9AiLvQqek/ySkQKG7qXRmNLc1ob
	mGNv2NlhMxZiETnd82iYy+gWLePNRXYNxsTwPbDctwNU8Hr+/exWST7RYFr9L6MT2DbqTdEHwmB
	n/TdieGGtK27M7L/QYIDJ2W6CFmGC8zSyvABMGJeSm5UKBbqomnUaBANP316q5Qg5i8eM6sCNOA
	jDV5jm13OfU71GpG3g==
X-Google-Smtp-Source: AGHT+IGBvGmEjsGiCnNO+lJQCkmvxHMeLXRWr5PfiUkRF3pY7JCK7ver9B91WIHw3prF8M5Zrj8x6Q==
X-Received: by 2002:a05:6000:18a3:b0:38a:a037:a517 with SMTP id ffacd0b85a97d-38dc8dd27f1mr2168975f8f.19.1738936713088;
        Fri, 07 Feb 2025 05:58:33 -0800 (PST)
Received: from pathway.suse.cz ([176.114.240.130])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38dcb55b7a5sm1720053f8f.14.2025.02.07.05.58.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Feb 2025 05:58:32 -0800 (PST)
Date: Fri, 7 Feb 2025 14:58:30 +0100
From: Petr Mladek <pmladek@suse.com>
To: Yafang Shao <laoar.shao@gmail.com>
Cc: jpoimboe@kernel.org, jikos@kernel.org, mbenes@suse.cz,
	joe.lawrence@redhat.com, live-patching@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 2/2] livepatch: Implement livepatch hybrid mode
Message-ID: <Z6YRhjQA4wkBxP0v@pathway.suse.cz>
References: <20250127063526.76687-1-laoar.shao@gmail.com>
 <20250127063526.76687-3-laoar.shao@gmail.com>
 <Z5eYzcF5JLR4o5Yl@pathway.suse.cz>
 <CALOAHbANtpY+ee9Wd+HV6-uPOw+Kq1JcU5UdOXjz8m_UJ_-XRA@mail.gmail.com>
 <Z6IUcbeCSAzlZEGP@pathway.suse.cz>
 <CALOAHbBWKL5MJz3DB+y02oqOrxy5xa3WZwTg0JPpqeQsMSVXmA@mail.gmail.com>
 <Z6OLvQ6KlVeuOkoO@pathway.suse.cz>
 <CALOAHbCJRce9-VYNgUO5szU4kMSktXyvkY9+ZFX_kyVXeoQ1ig@mail.gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALOAHbCJRce9-VYNgUO5szU4kMSktXyvkY9+ZFX_kyVXeoQ1ig@mail.gmail.com>

On Thu 2025-02-06 10:35:11, Yafang Shao wrote:
> On Thu, Feb 6, 2025 at 12:03 AM Petr Mladek <pmladek@suse.com> wrote:
> >
> > On Wed 2025-02-05 10:54:47, Yafang Shao wrote:
> > > On Tue, Feb 4, 2025 at 9:21 PM Petr Mladek <pmladek@suse.com> wrote:
> > > >
> > > > On Mon 2025-01-27 23:34:50, Yafang Shao wrote:

I am not sure if you still would want the hybrid model.
It is possible that the timeout in klp_try_complete_transition()
would remove the hardlockup watchdog warnings, see
https://lore.kernel.org/r/Z6Tmqro6CSm0h-E3@pathway.suse.cz

I reply to this mail just for record because there were some
unanswered questions...

> > > To clarify the hybrid model, I'll illustrate it with the following Fixes:
> > >
> > > Fix1 livepatches: funcA
> > > Fix2  livepatches: funcC
> > > Fix3 livepatches: funcA, funcB
> >
> > How does look the livepatched FuncA here?
> > Does it contain changes only for Fix3?
> > Or is it cummulative livepatches_funA includes both Fix1 + Fix3?
> 
> It is cumulative livepatches_funA includes both Fix1 + Fix3.

It makes sense.

I have missed this in the previous mail. I see it there now (after
re-reading). But trick was somehow encrypted in long sentences.


> > > Fix4  livepatches: funcD
> > > Fix5 livepatches: funcB
> > >
> > > Each FixN represents a single /sys/kernel/livepatch/FixN.
> > > By default, all Fixes are set to non-replaceable.
> > >
> > > Step-by-step process:
> > > 1. Loading Fix1
> > >    Loaded Fixes: Fix1
> > > 2. Loading Fix2
> > >    Loaded Fixes: Fix1 Fix2
> > > 3. Loading Fix3
> > >     Before loading, set Fix1 to replaceable and replace it with Fix3,
> > > which is a cumulative patch of Fix1 and Fix3.
> >
> > Who will modify the "replaceable" flag of "Fix1"? Userspace or kernel?
> 
> Userspace scripts. Modify it before loading a new one.

This is one mine concern. Such a usespace script would be
more complex for the the hybrid model then for cumulative livepatches.
Any user of the hybrid model would have their own scripts
and eventual bugs.

Anyway, the more possibilities there more ways to break things
and the more complicated is to debug eventual problems.

If anyone would still like the hybrid model then I would like
to enforce some safe behavior from the kernel. I mean to do
as much as possible in the common (kernel) code.

I have the following ideas:

  1. Allow to load a livepatch with .replace enabled only when
     all conflicting[*] livepatches are allowed to be replaced.

  2. Automatically replace all conflicting[*] livepatches.

  3. Allow to define a list of to-be-replaced livepatches
     into struct patch.


The 1st or 2nd idea would make the hybrid model more safe.

The 2nd idea would even work without the .replaceable flag.

The 3rd idea would allow to replace even non-conflicting[*]
patches.

[*] I would define that two livepatches are "conflicting" when
    at least one function is modified by both of them. e.g.

	+ Patch1: funcA, funcB   \
	+ Patch2: funcC, funcD   - non-conflicting 

	+ Patch1: funcA, funcB          \
	+ Patch2:        funcB, funcC   - conflicting 

    Or a bit weaker definition. Two patches are "conflicting"
    when the new livepatch provides only partial replacement
    for already livepatch functions, .e.g.

	+ Patch1: funcA, funcB                \
	+ Patch2:               funcC, funcD  - non-conflicting anyway

	+ Patch1: funcA, funcB          - Patch1 can't replace Patch2 (conflict)
	+ Patch2: funcA, funcB, funcC   - Patch2 can replace Patch1 (no conflict)

	+ Patch1: funcA, funcB          \
	+ Patch2:        funcB, funcC   - conflicting anyway


Especially, the automatic replacement of conflicting patches might
make the hybrid model safe and easier to use. And it would resolve
most of my fears with this approach.

Best Regards,
Petr

