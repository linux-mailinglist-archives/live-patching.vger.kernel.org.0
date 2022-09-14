Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5E415B89B9
	for <lists+live-patching@lfdr.de>; Wed, 14 Sep 2022 16:02:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229669AbiINOCb (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 14 Sep 2022 10:02:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229987AbiINOB4 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 14 Sep 2022 10:01:56 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2740F25F1;
        Wed, 14 Sep 2022 07:01:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=6QAWxLdMZL2HrdyA2qxKWv8rmsu40qWwB6+Piak/frU=; b=grvdlhiDJot2FEpq+aFmAKpbVL
        618tCmlcl9TPnZnLX8PT4AhesK8/j7mmZuPujaIwSXumYee6m/OP3I9Z8QFflX21DFKDV/1eCyZSO
        1tXouQhREH2V6O6uTrrhCur9gYWzcDGFuM3KczBsBLsHjAH+g6vjLnj4+SbI8pdwWgVG/nIGTDvyD
        DiHFFwPKYeMxg+uODtM74++NkL63AwP3uz/GHM1UJwCvDU+S0s8jHC8bfF+pJP8Ip02ArlO2XX031
        PYJx514ksqOpuNFWFgGMNIp/Q19glVLvHb4u8/vmi0+mnjAgBbMDj0XzSWSfa/KX4gkD96/5qTrfO
        EMxpDi1g==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oYSw9-000EDJ-E2; Wed, 14 Sep 2022 14:00:21 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id A70D43002AE;
        Wed, 14 Sep 2022 16:00:16 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 8BBF52B8AD401; Wed, 14 Sep 2022 16:00:16 +0200 (CEST)
Date:   Wed, 14 Sep 2022 16:00:16 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Josh Poimboeuf <jpoimboe@kernel.org>
Cc:     Michael Matz <matz@suse.de>, Borislav Petkov <bp@alien8.de>,
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
        Chen Zhongjin <chenzhongjin@huawei.com>,
        Sathvika Vasireddy <sv@linux.ibm.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Mark Brown <broonie@kernel.org>
Subject: Re: [RFC] Objtool toolchain proposal:
 -fannotate-{jump-table,noreturn}
Message-ID: <YyHecBM8D0i1lRu8@hirez.programming.kicks-ass.net>
References: <20220909180704.jwwed4zhwvin7uyi@treble>
 <Yx8PcldkdOLN8eaw@nazgul.tnic>
 <alpine.LSU.2.20.2209121200120.8265@wotan.suse.de>
 <20220914000416.daxbgccbxwpknn2q@treble>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220914000416.daxbgccbxwpknn2q@treble>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, Sep 14, 2022 at 01:04:16AM +0100, Josh Poimboeuf wrote:

> > I will mention that objtool's existence is based on mistrust, of persons 
> > (not correctly annotating stuff) and of tools (not correctly heeding those 
> > annotations).  The mistrust in persons is understandable and can be dealt 
> > with by tools, but the mistrust in tools can't be fixed by making tools 
> > more complicated by emitting even more information; there's no good reason 
> > to assume that one piece of info can be trusted more than other pieces.  
> > So, if you mistrust the tools you have already lost.  That's somewhat 
> > philosophical, so I won't beat that horse much more either.
> 
> Maybe this is semantics, but I wouldn't characterize objtool's existence
> as being based on the mistrust of tools.  It's main motivation is to
> fill in the toolchain's blind spots in asm and inline-asm, which exist
> by design.

That and a fairly deep seated loathing for the regular CFI annotations
and DWARF in general. Linus was fairly firm he didn't want anything to
do with DWARF for in-kernel unwinding.

That left us in a spot that we needed unwind information in a 'better'
format than DWARF.

Objtool was born out of those contraints. ORC not needing the CFI
annotations and ORC being *much* faster at unwiding and generation
(debug builds are slow) were all good.


