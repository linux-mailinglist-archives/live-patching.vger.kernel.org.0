Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50B1B5BEB56
	for <lists+live-patching@lfdr.de>; Tue, 20 Sep 2022 18:49:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230110AbiITQtw (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 20 Sep 2022 12:49:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229779AbiITQtu (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 20 Sep 2022 12:49:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEF2D13DDD;
        Tue, 20 Sep 2022 09:49:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B0502B828D3;
        Tue, 20 Sep 2022 16:49:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6318CC43470;
        Tue, 20 Sep 2022 16:49:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663692586;
        bh=vmyvq1aUOmre0E18ZlTOn9QV1cEhyDcjVLUmO5iK2lI=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=FbjFfJIq2m+Nxif0jMsvbr+hIADfvpyb6qNxQyAL08pZxUZKDCbA79J+mtyY5g/L0
         t1SqU6AVg158djYCu+OA6imNwsP5D2zDP8o003yhguUxX6U27NuGHF8HifmAqWAEWV
         WGXjT/bFl0zznSVGUFuCFsWx94Vt2ETGBFw6dN1x2aMh28I1Fb/NafyKdlmFeLSgum
         kJI805UmX5jj/hOjpnzuqJM0dg1Z5KUdcNnqiAQJ41gYMI/uv9j3U21bEr9W/wY6Qq
         Xcs98+Qndy5g/1+UNaHl/qGv2oou1rP9wL4xFBg0RusYn2XdCXXKa2kmK4BRbD4rY5
         En9G5F62vNbFQ==
Received: by mail-lj1-f175.google.com with SMTP id b6so3699104ljr.10;
        Tue, 20 Sep 2022 09:49:46 -0700 (PDT)
X-Gm-Message-State: ACrzQf05mPrlWk8wn3VsIcjkUeOnYefeF27nuy7ghOlS9y8Sm3F/jYpc
        7Bc01TrN2ThFzm7r0Mx/Exxl4v13GqVcOqegIG4=
X-Google-Smtp-Source: AMsMyM5uPplRBbNk8KwaMSLyjriPjQasS2fkIsUEtjL7XSBKzzbCRhdfBYv0bnsu6GsemWK7B38+lm296jjp7PBFcjA=
X-Received: by 2002:a2e:9115:0:b0:26a:c086:5138 with SMTP id
 m21-20020a2e9115000000b0026ac0865138mr6796874ljg.189.1663692584393; Tue, 20
 Sep 2022 09:49:44 -0700 (PDT)
MIME-Version: 1.0
References: <20220909180704.jwwed4zhwvin7uyi@treble> <Yx8PcldkdOLN8eaw@nazgul.tnic>
 <alpine.LSU.2.20.2209121200120.8265@wotan.suse.de> <6a61aa57-141f-039c-5a2d-b2d79fecb8c2@huawei.com>
 <YyLmhUxTUaNzaieC@hirez.programming.kicks-ass.net>
In-Reply-To: <YyLmhUxTUaNzaieC@hirez.programming.kicks-ass.net>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Tue, 20 Sep 2022 18:49:33 +0200
X-Gmail-Original-Message-ID: <CAMj1kXGa7D6TLOQruYF+0czWwxcRxN7k1rWTrhB2xnjTQ32c9Q@mail.gmail.com>
Message-ID: <CAMj1kXGa7D6TLOQruYF+0czWwxcRxN7k1rWTrhB2xnjTQ32c9Q@mail.gmail.com>
Subject: Re: [RFC] Objtool toolchain proposal: -fannotate-{jump-table,noreturn}
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Chen Zhongjin <chenzhongjin@huawei.com>,
        Michael Matz <matz@suse.de>, Borislav Petkov <bp@alien8.de>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        linux-toolchains@vger.kernel.org,
        Indu Bhagat <indu.bhagat@oracle.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        linux-kernel@vger.kernel.org, "Jose E. Marchesi" <jemarch@gnu.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will@kernel.org>, x86@kernel.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Sathvika Vasireddy <sv@linux.ibm.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Mark Brown <broonie@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu, 15 Sept 2022 at 10:47, Peter Zijlstra <peterz@infradead.org> wrote:
>
> On Thu, Sep 15, 2022 at 10:56:58AM +0800, Chen Zhongjin wrote:
>
> > We have found some anonymous information on x86 in .rodata.
>
> Well yes, but that's still a bunch of heuristics on our side.
>
> > I'm not sure if those are *all* of Josh wanted on x86, however for arm64 we
> > did not found that in the same section so it is a problem on arm64 now.
>
> Nick found Bolt managed the ARM64 jumptables:
>
>   https://github.com/llvm/llvm-project/blob/main/bolt/lib/Target/AArch64/AArch64MCPlusBuilder.cpp#L484
>
> But that does look like a less than ideal solution too.
>
> > Does the compiler will emit these for all arches? At lease I tried and
> > didn't find anything meaningful (maybe I omitted it).
>
> That's the question; can we get the compiler to help us here in a well
> defined manner.

Do BTI landing pads help at all here? I.e., I assume that objtool just
treats any indirect call as a dangling edge in the control flow graph,
and the problem is identifying the valid targets. In the BTI case,
those will all start with a 'BTI J' instruction.
