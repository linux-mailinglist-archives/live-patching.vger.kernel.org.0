Return-Path: <live-patching+bounces-384-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id F181992ACF0
	for <lists+live-patching@lfdr.de>; Tue,  9 Jul 2024 02:07:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A76311F220C4
	for <lists+live-patching@lfdr.de>; Tue,  9 Jul 2024 00:07:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8201D63A;
	Tue,  9 Jul 2024 00:07:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HxAjad3P"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-ua1-f51.google.com (mail-ua1-f51.google.com [209.85.222.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 001F5620
	for <live-patching@vger.kernel.org>; Tue,  9 Jul 2024 00:07:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720483666; cv=none; b=OscA3sMAoJeEcOZbm6rqL/xhuuRfSU0T2/H52sL6wSmdJYG8bS7fJQ4qAIyNwLLqN/q/BgKhCfOeW3xI1UMpIdHOdRdSvuFk3iW3ZOryTmZP8yFFU7EMiq4P7/Zcc2LYAjNCfYwjd0g6X3EOre2plSv2gIdQ7udlz+NT/b1I+tw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720483666; c=relaxed/simple;
	bh=dqA93HQg2usj3F7De2CQ8lrpCWOPOjJm7LpwpGMb+d4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fsZSg70Mx0keFjMs3sKyjiNbGihyzctVI2MA2wNig+YXheaIquJv6yE0yhkSZ4gyxr0seudxtl+MIBtfMT1zl3n8kNKXpLNlhOMXCdDk0/bqbK5a1/rpHOa3c+zuS1tDJk5i34cvVRdMKR2LsHTINS6+by0CqA1RH9qnsT6snUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HxAjad3P; arc=none smtp.client-ip=209.85.222.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ua1-f51.google.com with SMTP id a1e0cc1a2514c-81028024ec8so1022848241.3
        for <live-patching@vger.kernel.org>; Mon, 08 Jul 2024 17:07:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1720483664; x=1721088464; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dqA93HQg2usj3F7De2CQ8lrpCWOPOjJm7LpwpGMb+d4=;
        b=HxAjad3PaWR6vnNDEvBpYMVvlynPcT3I2Sj3c6tHQZ1wbETORji/ihjI6iuvcI3Dxj
         gPpcDPiYEf4htKq9loTm9uW2l1YNIfcgPHLcWhZ8TBsWANXuwkYNaY0vkMM7e5d4Q0AL
         MtzRl4DWrBXP6DbeHXONZoVCQeHoigIr8OlAiCESA9PdGM2vMSbbedXP/6043WgZbIVf
         9b5WQo9zbXSaLvXMUGwrR+xD3JFJghXEU6Mi5lUP87L71kiOt9Y3XgJLPrCCzOoW3pwd
         BD0SizkKVPVUpvN9VBwdH2LiJa84kH30QK4qAKn7FyNs4mM03Mg7Gp3OHeaQWRHo3DdF
         FPiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720483664; x=1721088464;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dqA93HQg2usj3F7De2CQ8lrpCWOPOjJm7LpwpGMb+d4=;
        b=Ng4z+ZLwM5q3paZ9g6YtBxfPILKkU5fyBR8z1u3+0IODOm69BXSS4OA+QAz5+dUL25
         5UCZJT7aa9CSXyAeEz3+3zyi+4ktASAHryFhn1/KMNKCqFGsIZvY2FexfJuFzHVQ+1Qi
         BHwygBoDABdyqmiZpJsQANkf+HUFrhNHOTOiWBwuQKyjEuA5Bj1aeN+2wDDxariSuKtU
         ZtbT8DfzhAvi/jzrzqTzVtLzYBFiFIVgreBr326A2RibDnYmKkNabCGHKj/bwBd7FEQi
         I9tNqzUSELalDvpiIGv1tbGmKsDwUgqmCftF1MeJgdPkMOvan5WKjjyxvDESwYG7ssfv
         h3ZA==
X-Forwarded-Encrypted: i=1; AJvYcCX6YV5D2zt5qwRUm1P0EyQ9Qc6iuwj+7v6w8+frlmyNAjEa3cRtKxNF2jbG/KSQLFwxIBkNNUr2QNKWQcNhjsap4i/WoXkCwzc052YgvA==
X-Gm-Message-State: AOJu0YzF0OlesuFvfZS85SDoaqfhho1255+xW5kZNfjHAjmq7AshtPKp
	juY/jG7s8K4F6gHb2MOWFBP0EcOTPhVHyLyhc0J1IkriD/Bj/sOu5dVNa+z57x8Ec5GHYtzzUy5
	DxRHYxNe6Ud0ZfshEKRFZ/E4udaZJrJY45GqD
X-Google-Smtp-Source: AGHT+IE3hXFlYFoVOFU0UJC+y1MJl5OnSIhHT8uqYSudjha0MxXIm6lSQSbeNUfOdK2HnHolICtBIDM2iFaTkzFmBbY=
X-Received: by 2002:a05:6102:304e:b0:48f:9897:8385 with SMTP id
 ada2fe7eead31-4903212d7c5mr1199444137.9.1720483663696; Mon, 08 Jul 2024
 17:07:43 -0700 (PDT)
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
 <ZoVumd-b4CaRu5nW@bombadil.infradead.org> <ZoZlGnVDzVONxUDs@pathway.suse.cz> <ZoxbEEsK40ASi1cY@bombadil.infradead.org>
In-Reply-To: <ZoxbEEsK40ASi1cY@bombadil.infradead.org>
From: Sami Tolvanen <samitolvanen@google.com>
Date: Mon, 8 Jul 2024 17:07:05 -0700
Message-ID: <CABCJKucSUA_fc1eWecWAZ3z8J-T=s5zsZunJHF2VgB=9V5c3tA@mail.gmail.com>
Subject: Re: [PATCH] kallsyms, livepatch: Fix livepatch with CONFIG_LTO_CLANG
To: Luis Chamberlain <mcgrof@kernel.org>, Matthew Maurer <mmaurer@google.com>
Cc: Petr Mladek <pmladek@suse.com>, Gary Guo <gary@garyguo.net>, 
	Masahiro Yamada <masahiroy@kernel.org>, =?UTF-8?Q?Michal_Such=C3=A1nek?= <msuchanek@suse.de>, 
	Lucas De Marchi <lucas.demarchi@intel.com>, Andreas Hindborg <nmi@metaspace.dk>, 
	Josh Poimboeuf <jpoimboe@kernel.org>, Miroslav Benes <mbenes@suse.cz>, Song Liu <song@kernel.org>, 
	live-patching@vger.kernel.org, linux-kernel@vger.kernel.org, jikos@kernel.org, 
	joe.lawrence@redhat.com, nathan@kernel.org, morbo@google.com, 
	justinstitt@google.com, thunder.leizhen@huawei.com, kees@kernel.org, 
	kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 8, 2024 at 2:33=E2=80=AFPM Luis Chamberlain <mcgrof@kernel.org>=
 wrote:
>
> Looking at this again its not to me why Masahiro Yamada's suggestion on
> that old patch series to just increase the length and put long symbols
> names into its own section [0] could not be embraced with a new kconfig
> option, so new kernels and new userspace could support it:
>
> https://lore.kernel.org/lkml/CAK7LNATsuszFR7JB5ZkqVS1W=3DhWr9=3DE7bTf+Mvg=
J+NXT3aZNwg@mail.gmail.com/

Matt, was there a reason we didn't move forward with Masahiro's
proposal? It sounds reasonable to me, but I might be missing some
background here.

> > I am a bit scared because using hashed symbol names in backtraces, gdb,
> > ... would be a nightmare. Hashes are not human readable and
> > they would complicate the life a lot. And using different names
> > in different interfaces would complicate the life either.
>
> All great points.
>
> The scope of the Rust issue is self contained to modversion_info,
> whereas for CONFIG_LTO_CLANG issue commit 8b8e6b5d3b013b0
> ("kallsyms: strip ThinLTO hashes from static functions") describes
> the issue with userspace tools (it doesn't explain which ones)
> which don't expect the function name to change. This seems to happen
> to static routines so I can only suspect this isn't an issue with
> modversioning as the only symbols that would be used there wouldn't be
> static.
>
> Sami, what was the exact userspace issue with CONFIG_LTO_CLANG and these
> long symbols?

The issue with LTO wasn't symbol length. IIRC the compiler renaming
symbols with ThinLTO caused issues for folks using dynamic kprobes,
and I seem to recall it also breaking systrace in Android, at which
point we decided to strip the postfix in kallsyms to avoid breaking
anything else.

Sami

