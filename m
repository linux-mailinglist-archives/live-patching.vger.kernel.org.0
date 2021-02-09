Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A4DE31566C
	for <lists+live-patching@lfdr.de>; Tue,  9 Feb 2021 20:01:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233103AbhBIS6p (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 9 Feb 2021 13:58:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233444AbhBISv6 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 9 Feb 2021 13:51:58 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FDFAC0617AA
        for <live-patching@vger.kernel.org>; Tue,  9 Feb 2021 10:26:40 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id b8so10206305plh.12
        for <live-patching@vger.kernel.org>; Tue, 09 Feb 2021 10:26:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20150623.gappssmtp.com; s=20150623;
        h=content-transfer-encoding:from:mime-version:subject:date:message-id
         :references:cc:in-reply-to:to;
        bh=dgZXefq5Ur84gHyH0jeL4t8oBY1mdlQ4zBj7nzzrp20=;
        b=ZDvJHo02c2NueaZiHJVY9dsPPQfI5TZBk2lx6FMtMBs2S3DsUfh4MDB88Tam5Ne62M
         gqacRfYI29Z5OeW1IFK/YXCbId9cuotvC09kAO1Icl73SgryW35dzMCzpnaHdNveegdN
         ygZqRc9ymtDHpuIMFdGl6mXnJvEjLQKDz6b4CdrV+HgtiWjhus5dLYd4S1Til/XfGpe8
         Pc5Gj/hca/fweWXv6Gkqyp2LdoiwNLgTIlkcmw1ZhjXXWOVW08jDrJL52xMNoK7+TQ71
         Bx+b/3/or6mk3RacVA0J2+7DFASZkaTb7kQNFCaXAzfXP1TZfsX8od8/UJ6PFbZrM6If
         pqDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:from:mime-version
         :subject:date:message-id:references:cc:in-reply-to:to;
        bh=dgZXefq5Ur84gHyH0jeL4t8oBY1mdlQ4zBj7nzzrp20=;
        b=ekewM+0UP4/V46h4uoOLoWiq820xf6DMZqdE1jDza57k6Xsr7BTHwcXr0W436dMbFL
         k/oXWuAYC0jwpXAMZ2QixiM8gfz5Bl884lqCzLufTGHeilckILEohjuHWV/aQTg0Pzav
         DaXH+59Z+2be9hY+2nyE4qPGP5Yf/T1OXGndFd2tq1uyNaqjHoQvr350z2dpblYoPgQZ
         NvnlNafgFDF60jfFzM7zSKPShD/ouheIH+PwSD0fzE1IJs8NNTqo4qgjjl1deA62T3AA
         jLRQRSwr7TQLEca6SQ5a2TmnazKtprJu3HcHmd9e6qNKmWayBbZuqyU+7hgES+1UIzZD
         Nnbg==
X-Gm-Message-State: AOAM5318hWZgw+J4DWnj4z2rIJsB4t9/nsk1uCvWsvkvaGD8pfDcMn5+
        oCXOr574e4VNoVb2rsGIRJJHHmIpQONz7/1p
X-Google-Smtp-Source: ABdhPJz3XrtIvAlXMoRc7qFrUi4rN8p+1C4uGXcWjLTUAKkrtA4IOwCvx+nbFwE9/Jwk7a9j3SHzSw==
X-Received: by 2002:a17:902:d202:b029:e1:8936:cf31 with SMTP id t2-20020a170902d202b02900e18936cf31mr22413279ply.51.1612895199485;
        Tue, 09 Feb 2021 10:26:39 -0800 (PST)
Received: from ?IPv6:2601:646:c200:1ef2:f811:395b:ab09:b007? ([2601:646:c200:1ef2:f811:395b:ab09:b007])
        by smtp.gmail.com with ESMTPSA id i1sm24729351pfb.54.2021.02.09.10.26.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Feb 2021 10:26:38 -0800 (PST)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From:   Andy Lutomirski <luto@amacapital.net>
Mime-Version: 1.0 (1.0)
Subject: Re: [GIT PULL] x86/urgent for v5.11-rc7
Date:   Tue, 9 Feb 2021 10:26:37 -0800
Message-Id: <3C17D187-8691-4521-9B64-F42A0B514F13@amacapital.net>
References: <CAHk-=wgNXnmxjm+kK1ufjHfQPOBbuD5w3CTkSe0azF3NNWEHHQ@mail.gmail.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Peter Zijlstra <peterz@infradead.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Borislav Petkov <bp@suse.de>,
        Dave Hansen <dave.hansen@intel.com>, x86-ml <x86@kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        live-patching@vger.kernel.org
In-Reply-To: <CAHk-=wgNXnmxjm+kK1ufjHfQPOBbuD5w3CTkSe0azF3NNWEHHQ@mail.gmail.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
X-Mailer: iPhone Mail (18D52)
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



> On Feb 9, 2021, at 10:09 AM, Linus Torvalds <torvalds@linux-foundation.org=
> wrote:
>=20
> =EF=BB=BFOn Tue, Feb 9, 2021 at 8:55 AM Andy Lutomirski <luto@amacapital.n=
et> wrote:
>>=20
>> Or we hack up #CP to handle this case. I don=E2=80=99t quite know how I f=
eel about this.
>=20
> I think that's the sane model - if we've replaced the instruction with
> 'int3', and we end up getting #CP due to that, just do the #BP
> handling.
>=20
> Anything else would just be insanely complicated, I feel.

The other model is =E2=80=9Cdon=E2=80=99t do that then.=E2=80=9D

I suppose a nice property of patching ENDBR to INT3 is that, not only is it a=
tomic, but ENDBR is sort of a NOP, so we don=E2=80=99t need to replace the E=
NDBR with anything.

>=20
>             Linus
