Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C935B5B87CD
	for <lists+live-patching@lfdr.de>; Wed, 14 Sep 2022 14:08:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229565AbiINMIn (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 14 Sep 2022 08:08:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229607AbiINMIl (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 14 Sep 2022 08:08:41 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F23FA7F272;
        Wed, 14 Sep 2022 05:08:39 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 98EE41F88E;
        Wed, 14 Sep 2022 12:08:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1663157318; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=EROMvm9onlQ1pv6K+o0p8csnLRDwiei6BOviFGwrA7g=;
        b=N6rGNIhNKxdXp806QI0zAk4xPAhf+SEyit3RuVKUnJWTuttnyMc/XWf4ndMQI1e25mB6Xy
        w3n2Udc44IREotKfsObWytw9LP2JWoTa4JrdA/fpK10/bGM/9SF10Ddg58EgDLKASTNZpE
        j0pdgUmJ6VEPjp3jycWUfmlpohhWukw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1663157318;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=EROMvm9onlQ1pv6K+o0p8csnLRDwiei6BOviFGwrA7g=;
        b=vzhve7Qqk2E+FT99nQbYNPPECnhq+NbJpp9DLURo5qsFj7GVE1Y4WsygcjY8gIQs5BDi35
        c3wm4mBhowD40ADw==
Received: from wotan.suse.de (wotan.suse.de [10.160.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id E0D6F2C141;
        Wed, 14 Sep 2022 12:08:37 +0000 (UTC)
Received: by wotan.suse.de (Postfix, from userid 10510)
        id B964D62AF; Wed, 14 Sep 2022 12:08:37 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
        by wotan.suse.de (Postfix) with ESMTP id B7682628B;
        Wed, 14 Sep 2022 12:08:37 +0000 (UTC)
Date:   Wed, 14 Sep 2022 12:08:37 +0000 (UTC)
From:   Michael Matz <matz@suse.de>
To:     Josh Poimboeuf <jpoimboe@kernel.org>
cc:     Segher Boessenkool <segher@kernel.crashing.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        linuxppc-dev@lists.ozlabs.org,
        Chen Zhongjin <chenzhongjin@huawei.com>, x86@kernel.org,
        Nick Desaulniers <ndesaulniers@google.com>,
        linux-kernel@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Sathvika Vasireddy <sv@linux.ibm.com>,
        linux-toolchains@vger.kernel.org,
        Indu Bhagat <indu.bhagat@oracle.com>,
        live-patching@vger.kernel.org, Miroslav Benes <mbenes@suse.cz>,
        Will Deacon <will@kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        "Jose E. Marchesi" <jemarch@gnu.org>
Subject: Re: [RFC] Objtool toolchain proposal:
 -fannotate-{jump-table,noreturn}
In-Reply-To: <20220914102100.thl5ad35plvazark@treble>
Message-ID: <alpine.LSU.2.20.2209141201400.8265@wotan.suse.de>
References: <20220909180704.jwwed4zhwvin7uyi@treble> <20220912113114.GV25951@gate.crashing.org> <20220914102100.thl5ad35plvazark@treble>
User-Agent: Alpine 2.20 (LSU 67 2015-01-07)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hello,

On Wed, 14 Sep 2022, Josh Poimboeuf wrote:

> > >    This information is needed because the
> > >    code after the call to such a function is optimized out as
> > >    unreachable and objtool has no way of knowing that.
> > 
> > Since June we (GCC) have -funreachable-traps.  This creates a trap insn
> > wherever control flow would otherwise go into limbo.
> 
> Ah, that's interesting, though I'm not sure if we'd be able to
> distinguish between "call doesn't return" traps and other traps or
> reasons for UD2.

There are two reasons (which will turn out to be the same) for a trap (say 
'UD2' on x86-64) directly after a call insn:
1) "the call shall not have returned"
2) something else jumps to that trap because it was __builtin_unreachable 
   (or equivalent), and the compiler happened to put that ud2 directly 
   after the call.  It could have done that only when the call itself was 
   noreturn:
     cmp $foo, %rax
     jne do_trap
     call noret
    do_trap:
     ud2

So, it's all the same.  If there's an ud2 (or whatever the trap maker is) 
after a call then it was because it's noreturn.

(But, of course this costs (little) code size, unlike the non-alloc 
checker sections)


Ciao,
Michael.
