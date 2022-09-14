Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F04F25B8E52
	for <lists+live-patching@lfdr.de>; Wed, 14 Sep 2022 19:47:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229777AbiINRr4 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 14 Sep 2022 13:47:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbiINRrz (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 14 Sep 2022 13:47:55 -0400
Received: from gate.crashing.org (gate.crashing.org [63.228.1.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3221430543;
        Wed, 14 Sep 2022 10:47:54 -0700 (PDT)
Received: from gate.crashing.org (localhost.localdomain [127.0.0.1])
        by gate.crashing.org (8.14.1/8.14.1) with ESMTP id 28EHYR2K002376;
        Wed, 14 Sep 2022 12:34:27 -0500
Received: (from segher@localhost)
        by gate.crashing.org (8.14.1/8.14.1/Submit) id 28EHYPMf002375;
        Wed, 14 Sep 2022 12:34:25 -0500
X-Authentication-Warning: gate.crashing.org: segher set sender to segher@kernel.crashing.org using -f
Date:   Wed, 14 Sep 2022 12:34:25 -0500
From:   Segher Boessenkool <segher@kernel.crashing.org>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Michael Matz <matz@suse.de>, Josh Poimboeuf <jpoimboe@kernel.org>,
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
Subject: Re: [RFC] Objtool toolchain proposal: -fannotate-{jump-table,noreturn}
Message-ID: <20220914173425.GZ25951@gate.crashing.org>
References: <20220909180704.jwwed4zhwvin7uyi@treble> <Yx8PcldkdOLN8eaw@nazgul.tnic> <alpine.LSU.2.20.2209121200120.8265@wotan.suse.de> <20220914000416.daxbgccbxwpknn2q@treble> <YyHecBM8D0i1lRu8@hirez.programming.kicks-ass.net> <alpine.LSU.2.20.2209141415340.8265@wotan.suse.de> <YyHrX/fTMwfv24W7@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YyHrX/fTMwfv24W7@hirez.programming.kicks-ass.net>
User-Agent: Mutt/1.4.2.3i
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, Sep 14, 2022 at 04:55:27PM +0200, Peter Zijlstra wrote:
> On Wed, Sep 14, 2022 at 02:28:26PM +0000, Michael Matz wrote:
> > Don't mix DWARF debug info with DWARF-based unwinding info, the latter 
> > doesn't imply the former.  Out of interest: how does ORC get around the 
> > need for CFI annotations (or equivalents to restore registers) and what 
> 
> Objtool 'interprets' the stackops. So it follows the call-graph and is
> an interpreter for all instructions that modify the stack. Doing that it
> konws what the stackframe is at 'most' places.

To get correct backtraces on e.g. PowerPC you need to emulate many of
the integer insns.  That is why GCC enables -fasynchronous-unwind-tables
by default for us.

The same is true for s390, aarch64, and x86 (unless 32-bit w/ frame
pointer).

The problem is that you do not know how to access anything on the stack,
whether in the current frame or in a previous frame, from a random point
in the program.  GDB has many heuristics for this, and it still does not
get it right in all cases.

> > makes it fast?  I want faster unwinding for DWARF as well, when there's 
> > feature parity :-)  Maybe something can be learned for integration into 
> > dwarf-unwind.
> 
> I think we have some details here:
> 
>  https://www.kernel.org/doc/html/latest/x86/orc-unwinder.html

It is faster because it does a whole lot less.  Is that still enough?
It's not clear (to me) what exact information it wants to provide :-(


Segher
