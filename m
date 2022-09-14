Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 806565B8A7A
	for <lists+live-patching@lfdr.de>; Wed, 14 Sep 2022 16:28:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229814AbiINO2v (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 14 Sep 2022 10:28:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230042AbiINO23 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 14 Sep 2022 10:28:29 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D73393ED5C;
        Wed, 14 Sep 2022 07:28:28 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 884331FAC1;
        Wed, 14 Sep 2022 14:28:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1663165707; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rNlI3zlemkHtad6UJYVAQefl5OerSoDA86fMBi08vO4=;
        b=IMcU+sMzPrtf2swXGKoltws1DQ4PgrmVnuO6T/Q8delDYm0q8pNrJpq1MOP7xd6pZAf/Jb
        Fj9kKS+pmhqrUq9gHQbLKe9xjwQzs0XXFM41HygdB74Nb7ZvF9w5/0sBD/TJQ6ijUhNld2
        ovmAUy7zEQzNfJwAOOA+Lerl2Xz07qg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1663165707;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rNlI3zlemkHtad6UJYVAQefl5OerSoDA86fMBi08vO4=;
        b=3fJIRsrioi8AmmHGURizF9ChVKr3QoUbkZwIJ7IgJ5my1PvR3SHrnTkZipLA9y0w31fOb6
        QBhZcoLjuWM9F4Bw==
Received: from wotan.suse.de (wotan.suse.de [10.160.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 0A94B2C141;
        Wed, 14 Sep 2022 14:28:27 +0000 (UTC)
Received: by wotan.suse.de (Postfix, from userid 10510)
        id EFA0E62AF; Wed, 14 Sep 2022 14:28:26 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
        by wotan.suse.de (Postfix) with ESMTP id EDC3C62AE;
        Wed, 14 Sep 2022 14:28:26 +0000 (UTC)
Date:   Wed, 14 Sep 2022 14:28:26 +0000 (UTC)
From:   Michael Matz <matz@suse.de>
To:     Peter Zijlstra <peterz@infradead.org>
cc:     Josh Poimboeuf <jpoimboe@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
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
In-Reply-To: <YyHecBM8D0i1lRu8@hirez.programming.kicks-ass.net>
Message-ID: <alpine.LSU.2.20.2209141415340.8265@wotan.suse.de>
References: <20220909180704.jwwed4zhwvin7uyi@treble> <Yx8PcldkdOLN8eaw@nazgul.tnic> <alpine.LSU.2.20.2209121200120.8265@wotan.suse.de> <20220914000416.daxbgccbxwpknn2q@treble> <YyHecBM8D0i1lRu8@hirez.programming.kicks-ass.net>
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

On Wed, 14 Sep 2022, Peter Zijlstra wrote:

> > Maybe this is semantics, but I wouldn't characterize objtool's existence
> > as being based on the mistrust of tools.  It's main motivation is to
> > fill in the toolchain's blind spots in asm and inline-asm, which exist
> > by design.
> 
> That and a fairly deep seated loathing for the regular CFI annotations
> and DWARF in general. Linus was fairly firm he didn't want anything to
> do with DWARF for in-kernel unwinding.

I was referring only to the check-stuff functionality of objtool, not to 
its other parts.  Altough, of course, "deep seated loathing" is a special 
form of mistrust as well ;-)

> That left us in a spot that we needed unwind information in a 'better'
> format than DWARF.
> 
> Objtool was born out of those contraints. ORC not needing the CFI
> annotations and ORC being *much* faster at unwiding and generation
> (debug builds are slow) were all good.

Don't mix DWARF debug info with DWARF-based unwinding info, the latter 
doesn't imply the former.  Out of interest: how does ORC get around the 
need for CFI annotations (or equivalents to restore registers) and what 
makes it fast?  I want faster unwinding for DWARF as well, when there's 
feature parity :-)  Maybe something can be learned for integration into 
dwarf-unwind.


Ciao,
Michael.
