Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEA085B9694
	for <lists+live-patching@lfdr.de>; Thu, 15 Sep 2022 10:47:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229642AbiIOIrs (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 15 Sep 2022 04:47:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229641AbiIOIrr (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 15 Sep 2022 04:47:47 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B93E197ED8;
        Thu, 15 Sep 2022 01:47:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=ivQ/eNxqEghjLz7rraJxCT2L5vao4XynCLSzvaLXpmQ=; b=AaYWHotkjSaBPPaDMgKlOP0sp2
        4WoMIWcg2PRmd499ZOSulGJU2/YqW9WK5yskc8Fp3dF6h0rApS22AkYrNsPLKnjxBpmSKhAmw/GvV
        SLDooue6nA3ZPzjl/NmBqFcg3VhJopSpsio0BqirDsuQda7KKG+g4ha5WfObKQ1Bczbe+VaOgqp3D
        KD0sX5hw7trhBFVQNceUF62xl/pAOB6AQ3rtJgvpHauySZUM8pJDpHw9JbABUs9xsk97ZJHRcjHru
        H2wmb1hKmnl15Wfetkb+BkoskakzoCKDB982K4R78EBUD1oUP2wSfnuL0SYCCEwyObsL1nAN/mx4p
        mG5RPjeg==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oYkWY-000w90-8S; Thu, 15 Sep 2022 08:47:06 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 26C6530010B;
        Thu, 15 Sep 2022 10:47:02 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 04DBC201ABB97; Thu, 15 Sep 2022 10:47:01 +0200 (CEST)
Date:   Thu, 15 Sep 2022 10:47:01 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Chen Zhongjin <chenzhongjin@huawei.com>
Cc:     Michael Matz <matz@suse.de>, Borislav Petkov <bp@alien8.de>,
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
        Ard Biesheuvel <ardb@kernel.org>,
        Sathvika Vasireddy <sv@linux.ibm.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Mark Brown <broonie@kernel.org>
Subject: Re: [RFC] Objtool toolchain proposal:
 -fannotate-{jump-table,noreturn}
Message-ID: <YyLmhUxTUaNzaieC@hirez.programming.kicks-ass.net>
References: <20220909180704.jwwed4zhwvin7uyi@treble>
 <Yx8PcldkdOLN8eaw@nazgul.tnic>
 <alpine.LSU.2.20.2209121200120.8265@wotan.suse.de>
 <6a61aa57-141f-039c-5a2d-b2d79fecb8c2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6a61aa57-141f-039c-5a2d-b2d79fecb8c2@huawei.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu, Sep 15, 2022 at 10:56:58AM +0800, Chen Zhongjin wrote:

> We have found some anonymous information on x86 in .rodata.

Well yes, but that's still a bunch of heuristics on our side.

> I'm not sure if those are *all* of Josh wanted on x86, however for arm64 we
> did not found that in the same section so it is a problem on arm64 now.

Nick found Bolt managed the ARM64 jumptables:

  https://github.com/llvm/llvm-project/blob/main/bolt/lib/Target/AArch64/AArch64MCPlusBuilder.cpp#L484

But that does look like a less than ideal solution too.

> Does the compiler will emit these for all arches? At lease I tried and
> didn't find anything meaningful (maybe I omitted it).

That's the question; can we get the compiler to help us here in a well
defined manner.
