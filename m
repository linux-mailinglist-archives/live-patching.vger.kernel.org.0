Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC45D5B883D
	for <lists+live-patching@lfdr.de>; Wed, 14 Sep 2022 14:28:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229683AbiINM2Z (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 14 Sep 2022 08:28:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229832AbiINM2Y (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 14 Sep 2022 08:28:24 -0400
Received: from gate.crashing.org (gate.crashing.org [63.228.1.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BF95C2E6A4;
        Wed, 14 Sep 2022 05:28:21 -0700 (PDT)
Received: from gate.crashing.org (localhost.localdomain [127.0.0.1])
        by gate.crashing.org (8.14.1/8.14.1) with ESMTP id 28ECGMjO020934;
        Wed, 14 Sep 2022 07:16:22 -0500
Received: (from segher@localhost)
        by gate.crashing.org (8.14.1/8.14.1/Submit) id 28ECGLVD020933;
        Wed, 14 Sep 2022 07:16:21 -0500
X-Authentication-Warning: gate.crashing.org: segher set sender to segher@kernel.crashing.org using -f
Date:   Wed, 14 Sep 2022 07:16:20 -0500
From:   Segher Boessenkool <segher@kernel.crashing.org>
To:     Josh Poimboeuf <jpoimboe@kernel.org>
Cc:     Mark Rutland <mark.rutland@arm.com>,
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
        "Jose E. Marchesi" <jemarch@gnu.org>, Michael Matz <matz@suse.de>
Subject: Re: [RFC] Objtool toolchain proposal: -fannotate-{jump-table,noreturn}
Message-ID: <20220914121620.GY25951@gate.crashing.org>
References: <20220909180704.jwwed4zhwvin7uyi@treble> <20220912113114.GV25951@gate.crashing.org> <20220914102100.thl5ad35plvazark@treble>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220914102100.thl5ad35plvazark@treble>
User-Agent: Mutt/1.4.2.3i
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, Sep 14, 2022 at 11:21:00AM +0100, Josh Poimboeuf wrote:
> On Mon, Sep 12, 2022 at 06:31:14AM -0500, Segher Boessenkool wrote:
> > On Fri, Sep 09, 2022 at 11:07:04AM -0700, Josh Poimboeuf wrote:
> > > 2) Noreturn functions:
> > >    
> > >    There's no reliable way to determine which functions are designated
> > >    by the compiler to be noreturn (either explictly via function
> > >    attribute, or implicitly via a static function which is a wrapper
> > >    around a noreturn function.)
> > 
> > Or just a function that does not return for any other reason.
> > 
> > The compiler makes no difference between functions that have the
> > attribute and functions that do not.  There are good reasons to not
> > have the attribute on functions that do in fact not return.  The
> > not-returningness of the function may be just an implementation
> > accident, something you do not want part of the API, so it *should* not
> > have that attribute; or you may want the callers to a function to not be
> > optimised according to this knowledge (you cannot *prevent* that, the
> > compiler can figure it out it other ways, but still) for any other
> > reason.
> 
> Yes, many static functions that are wrappers around noreturn functions
> have this "implicit noreturn" property.

I meant functions that are noreturn intrinsically.  The trivial example:

void f(void)
{
	for (;;)
		;
}

>  I agree we would need to know
> about those functions (or, as Michael suggested, their call sites) as
> well.

Many "potentially does not return" functions (there are very many such
functions!) turn into "never returns" functions, for some inputs (or
something in the environment).  If the compiler specialises a code path
that does not return, you'll not see that marked up any way.  Of course
such a path should not be taken in the kernel, normally :-)

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

The trap handler can see where the trap came from.  And then look up
that address in some tables or such.  Just like __bug_table?


Segher
