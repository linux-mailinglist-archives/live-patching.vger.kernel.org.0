Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4606C6E2B0D
	for <lists+live-patching@lfdr.de>; Fri, 14 Apr 2023 22:22:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229647AbjDNUWW (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 14 Apr 2023 16:22:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbjDNUWW (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 14 Apr 2023 16:22:22 -0400
Received: from mail-oa1-x34.google.com (mail-oa1-x34.google.com [IPv6:2001:4860:4864:20::34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAF6319BE
        for <live-patching@vger.kernel.org>; Fri, 14 Apr 2023 13:22:20 -0700 (PDT)
Received: by mail-oa1-x34.google.com with SMTP id 586e51a60fabf-183f4efa98aso29444756fac.2
        for <live-patching@vger.kernel.org>; Fri, 14 Apr 2023 13:22:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681503740; x=1684095740;
        h=content-transfer-encoding:mime-version:message-id:references
         :in-reply-to:user-agent:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=vHKZLVX+k1/dGwjwJm//D639s6Y5qHMQ3TcJNyPiBHo=;
        b=GgaFjVW5oEcNN2Vk8jrHsJA2oPQFUwQF+SJn/dZTnOUUrpsvH2wgkqbijWY+dcpvbI
         XkX8SNlScP3hdmbFPzT7hVQgQdcdnuImeyIiQElCAbUKzPCTyQWcCI7O3jrfIFSvI3Hf
         fdjev8KDx57O3jquhjWQPT9g1d6cYf5z6FK9517CcK/HhAF4lrYQqQp2hZ9QXeeCndrB
         kO9DlCwJoko+PKf2rRmTpXyLG6d5jJ/XJ3ETjXpG7O+6RF292FoaeqFmNDhP+S4bqosR
         0gGHpnlzbtkt71fjLvPtHrXkdC+peus3FFILntQt+lLFIunu103lmAw1bjj1p0vjKHq/
         rnWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681503740; x=1684095740;
        h=content-transfer-encoding:mime-version:message-id:references
         :in-reply-to:user-agent:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vHKZLVX+k1/dGwjwJm//D639s6Y5qHMQ3TcJNyPiBHo=;
        b=V5gE+o1477iG/od/qGBZmK+KG37JMHSAlGDotkNFkxjhFfWL81vx9jlPUkvfCYr6Iv
         QZ1qrO7ZMK6u37GhUPUnBfemH6UpQKmJwvhgun+eX8YQTzveGaoj8BmJSxTIWHcLcYkN
         jiQOAmWi3HxtYrA4fesHb3OTwriF++/eg0JOM2iwNN0anbpKgJbXuOPkm6H8QGx+JAeK
         6litbkAGQe+qPYSVfStJZQIxOsuFmNwOtW6Hcao73zk7xL53QzGYhznrQuOq1ZeSNFt8
         ojmQIz2uuYXb58yqdw7xUhkeVgT/cwE+t6hcNNdLBE3K1BadKLTuwaIm4ySCDVuIYUxl
         9iaA==
X-Gm-Message-State: AAQBX9cclsDGo8GXwgh7jhCJ9k9U4oBnk3vRLpuY+KS86kES0txDEaEB
        oo4bzVmdqsXTnLkNJL/JOKk=
X-Google-Smtp-Source: AKy350aVCiIGLVLalBGjNXzfL0gSnEP+pavvpv8JhtFX54X7bHXxA/n6G01cq+YTSVSkKcMZTJrdDg==
X-Received: by 2002:a05:6870:c38a:b0:187:c001:7096 with SMTP id g10-20020a056870c38a00b00187c0017096mr606317oao.26.1681503739951;
        Fri, 14 Apr 2023 13:22:19 -0700 (PDT)
Received: from [127.0.0.1] ([187.19.238.117])
        by smtp.gmail.com with ESMTPSA id zf24-20020a0568716a9800b0017ae6741157sm2189528oab.4.2023.04.14.13.22.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Apr 2023 13:22:19 -0700 (PDT)
Date:   Fri, 14 Apr 2023 17:22:13 -0300
From:   Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
To:     Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>
CC:     Mark Rutland <mark.rutland@arm.com>,
        Miroslav Benes <mbenes@suse.cz>, jikos@kernel.org,
        pmladek@suse.com, joe.lawrence@redhat.com, nstange@suse.de,
        mpdesouza@suse.de, broonie@kernel.org,
        live-patching@vger.kernel.org,
        Nick Desaulniers <ndesaulniers@google.com>,
        "Jose E. Marchesi" <jose.marchesi@oracle.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Subject: Re: Live Patching Microconference at Linux Plumbers
User-Agent: K-9 Mail for Android
In-Reply-To: <CANiq72mWVwNfbCiKWdyyX=LXMrXsndO6gnwz_0tgVRt9Nk1KzA@mail.gmail.com>
References: <alpine.LSU.2.21.2303291339090.21599@pobox.suse.cz> <ZDkif0cu/jh/KKC+@FVFF77S0Q05N> <20230414171255.oylmsdizl4waao4t@treble> <CANiq72mWVwNfbCiKWdyyX=LXMrXsndO6gnwz_0tgVRt9Nk1KzA@mail.gmail.com>
Message-ID: <F9956FA2-BF3E-40D1-AE2A-8F83C83EE72D@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



On April 14, 2023 4:04:36 PM GMT-03:00, Miguel Ojeda <miguel=2Eojeda=2Esan=
donis@gmail=2Ecom> wrote:
>On Fri, Apr 14, 2023 at 7:12=E2=80=AFPM Josh Poimboeuf <jpoimboe@kernel=
=2Eorg> wrote:
>>
>> Not to mention how objtool will react to compiled rust code (has it
>> already been tried?)
>
>Rust uses LLVM, so it should be generally fine -- at least some of the
>checks appear to work=2E For instance, I can trigger:
>
>      RUSTC L rust/kernel=2Eo
>    rust/kernel=2Eo: warning: objtool: =2Etext+0x0: unreachable instructi=
on
>
>      RUSTC [M] samples/rust/rust_minimal=2Eo
>    samples/rust/rust_minimal=2Eo: warning: objtool:
>_R=2E=2E=2E_6kernel6Module4init+0x172: unreachable instruction
>
>via a random instruction in the middle of nowhere in the former (with
>`global_asm!`) and a jumped-over instruction in the latter (with
>`asm!`)=2E
>
>Moreover, we were already getting warnings when rethunk / x86 IBT is
>enabled (since we got `objtool` called for `vmlinux=2Eo`), e=2Eg=2E
>
>    vmlinux=2Eo: warning: objtool: =2Erodata+0x18c58: data relocation to
>!ENDBR: _R=2E=2E=2EIsWhitespaceEEB4_+0x0
>
>    vmlinux=2Eo: warning: objtool: _R=2E=2E=2Einto_foreign+0x5: 'naked' r=
eturn
>found in RETHUNK build
>
>I can send the patch to run it for all Rust object files via
>`$(cmd_objtool)`, unless you think it is a bad idea=2E
>
>Having said that, tooling may indeed have issues, e=2Eg=2E Arnaldo (Cc'd)
>is improving `pahole` to avoid assumptions around struct layout like
>field reordering (which Rust does by default)=2E

That part should be dealt with the recently released pahole 1=2E25:

https://git=2Ekernel=2Eorg/pub/scm/devel/pahole/pahole=2Egit/commit/?id=3D=
c4eb1897d1f3841d291ee39dc969c4212750cf2c
https://git=2Ekernel=2Eorg/pub/scm/devel/pahole/pahole=2Egit/commit/?id=3D=
1231b6b9b4d88e0084bef4254eb1a05eb9935c99

But there are more issues, I'll resume work on Rust soon, after a detour o=
n Go, and I think the changes made for Go make the DWARF loading more robus=
t and may even have helped with Rust already:

https://git=2Ekernel=2Eorg/pub/scm/devel/pahole/pahole=2Egit/commit/?h=3Dn=
ext&id=3D31bc0d7410572f6e03e3ed9da7c8c6f0d8df23c8

- Arnaldo

>
>Cheers,
>Miguel
