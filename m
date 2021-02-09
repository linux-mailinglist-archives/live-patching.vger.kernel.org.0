Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1341331547D
	for <lists+live-patching@lfdr.de>; Tue,  9 Feb 2021 17:56:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233100AbhBIQ4k (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 9 Feb 2021 11:56:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232959AbhBIQ4e (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 9 Feb 2021 11:56:34 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24A26C06174A
        for <live-patching@vger.kernel.org>; Tue,  9 Feb 2021 08:55:54 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id t2so2009515pjq.2
        for <live-patching@vger.kernel.org>; Tue, 09 Feb 2021 08:55:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20150623.gappssmtp.com; s=20150623;
        h=content-transfer-encoding:from:mime-version:subject:date:message-id
         :references:cc:in-reply-to:to;
        bh=1bFvl2bIW4Oh3wbTy7ZymRT/srGmZL+rM5fEH6hBOlE=;
        b=CxCedMb+RMB2rjOGYlf85FglO5AAOwRCDrVJYQqgZJ3h664qF8scVpNpV/nk0Ve6bF
         HEjnDUY5gDFsyQ8iVQrRAuxXEh35W9yseTgpHovrhVPKTehosh/tzsH5759uqnI1E5Wy
         tW6aevBIg9FHOUewdYnhGr4E8JME1JdGZoSMMOTM1uGNpxXYtBOl5oF64/yeGwHysdPw
         /ug4f0ZDK505aiX8XTyznhLVnlb8WxksZl73oxKbSSdi9/FRXIMClEh7Zle8ewUbrBjP
         G8Gap02Yhbea/hUqJqSPcJXJmsm+4qDc7RlCSD6QZnKJLJOXXCDFkOm5KQbgBLp8DbN/
         Xd9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:from:mime-version
         :subject:date:message-id:references:cc:in-reply-to:to;
        bh=1bFvl2bIW4Oh3wbTy7ZymRT/srGmZL+rM5fEH6hBOlE=;
        b=Ypue5WXsMzaBulemFTXjvmGwjarrqpkLH5VyeSA3kEksADGB/HkmmyfxPzWXTHdwqb
         MOfuRPLfNwQ7Pmy0RTQydn9XLvfBq6In+OjGORbigyX2vuRB90PHiVZxdsaNVMnrpdHF
         zHp0Ky3wbZrHhmdOuPZAcHTf/x+4LLZ3An8lCK+DVU50zVBLhmb5fw5LNfXmNfAX7T7N
         fLkAcSeREEf9++JtzKooPZXC2u0sK0NN29nZBa6yeXESuAq7b4tqC8Jgk7/vphU5u2yJ
         3R37mzhF8CjODxHEQnKNJ2GaeyZLsUJjklChM+SFSFcB5t3Q/atz7yshYo1qa8MJo5RA
         wtFA==
X-Gm-Message-State: AOAM5303d9qmbii90nJ0Wb1i8kQpazBJIX76aZ3uhzrDqddja6i4CnCd
        sSt2rB42NChSrmSP/+96MIclqKHchI7jcJon
X-Google-Smtp-Source: ABdhPJwO9CnieT0CraLne733rr1Axe7Z0/TeuoS/LaAA3J09+3wwD2JbNMH5wJ6XjL3/DRuyn6gOMg==
X-Received: by 2002:a17:902:ed95:b029:e2:d080:7e0e with SMTP id e21-20020a170902ed95b02900e2d0807e0emr13163938plj.85.1612889753378;
        Tue, 09 Feb 2021 08:55:53 -0800 (PST)
Received: from ?IPv6:2601:646:c200:1ef2:2db1:f678:b1ca:a522? ([2601:646:c200:1ef2:2db1:f678:b1ca:a522])
        by smtp.gmail.com with ESMTPSA id z31sm2978386pjj.47.2021.02.09.08.55.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Feb 2021 08:55:52 -0800 (PST)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From:   Andy Lutomirski <luto@amacapital.net>
Mime-Version: 1.0 (1.0)
Subject: Re: [GIT PULL] x86/urgent for v5.11-rc7
Date:   Tue, 9 Feb 2021 08:55:51 -0800
Message-Id: <73175691-4AE1-496D-80D1-DC85AE1E9C27@amacapital.net>
References: <CAADnVQK-qdE6mHUogeaQo9Av_58cLptosmfUVmdMzW7gJn5UVw@mail.gmail.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Peter Zijlstra <peterz@infradead.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Borislav Petkov <bp@suse.de>,
        Dave Hansen <dave.hansen@intel.com>, x86-ml <x86@kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        live-patching@vger.kernel.org
In-Reply-To: <CAADnVQK-qdE6mHUogeaQo9Av_58cLptosmfUVmdMzW7gJn5UVw@mail.gmail.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
X-Mailer: iPhone Mail (18D52)
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



> On Feb 9, 2021, at 8:45 AM, Alexei Starovoitov <alexei.starovoitov@gmail.c=
om> wrote:
>=20
> =EF=BB=BFOn Tue, Feb 9, 2021 at 6:49 AM Steven Rostedt <rostedt@goodmis.or=
g> wrote:
>>=20
>>> On Tue, 9 Feb 2021 09:32:34 +0100 (CET)
>>> Miroslav Benes <mbenes@suse.cz> wrote:
>>>=20
>>> powerpc has this
>>>=20
>>> static inline unsigned long klp_get_ftrace_location(unsigned long faddr)=

>>> {
>>>        /*
>>>         * Live patch works only with -mprofile-kernel on PPC. In this ca=
se,
>>>         * the ftrace location is always within the first 16 bytes.
>>>         */
>>>        return ftrace_location_range(faddr, faddr + 16);
>>> }
>>>=20
>>>>> I suppose the trivial fix is to see if it points to endbr64 and if so,=

>>>>> increment the addr by the length of that.
>>>>=20
>>>> I thought of that too. But one thing that may be possible, is to use
>>>> kallsym. I believe you can get the range of a function (start and end o=
f
>>>> the function) from kallsyms. Then ask ftrace for the addr in that range=

>>>> (there should only be one).
>>>=20
>>> And we can do this if a hard-coded value live above is not welcome. If I=

>>> remember correctly, we used to have exactly this in the old versions of
>>> kGraft. We walked through all ftrace records, called
>>> kallsyms_lookup_size_offset() on every record's ip and if the offset+ip
>>> matched faddr (in this case), we returned the ip.
>>=20
>> Either way is fine. Question is, should we just wait till CET is
>> implemented for the kernel before making any of these changes? Just knowi=
ng
>> that we have a solution to handle it may be good enough for now.
>=20
> I think the issue is more fundamental than what appears on the surface.
> According to endbr64 documentation it's not just any instruction.
> The cpu will wait for it and if it's replaced with int3 or not seen at
> the branch target the cpu will throw an exception.
> If I understood the doc correctly it means that endbr64 can never be
> replaced with a breakpoint. If that's the case text_poke_bp and kprobe
> need to do extra safety checks.

Ugh.

Or we hack up #CP to handle this case. I don=E2=80=99t quite know how I feel=
 about this.=
