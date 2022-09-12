Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 467145B5974
	for <lists+live-patching@lfdr.de>; Mon, 12 Sep 2022 13:42:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229705AbiILLmQ (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 12 Sep 2022 07:42:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbiILLmP (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 12 Sep 2022 07:42:15 -0400
Received: from gate.crashing.org (gate.crashing.org [63.228.1.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 16FFF3C160;
        Mon, 12 Sep 2022 04:42:13 -0700 (PDT)
Received: from gate.crashing.org (localhost.localdomain [127.0.0.1])
        by gate.crashing.org (8.14.1/8.14.1) with ESMTP id 28CBVGtH009422;
        Mon, 12 Sep 2022 06:31:16 -0500
Received: (from segher@localhost)
        by gate.crashing.org (8.14.1/8.14.1/Submit) id 28CBVEwA009421;
        Mon, 12 Sep 2022 06:31:14 -0500
X-Authentication-Warning: gate.crashing.org: segher set sender to segher@kernel.crashing.org using -f
Date:   Mon, 12 Sep 2022 06:31:14 -0500
From:   Segher Boessenkool <segher@kernel.crashing.org>
To:     Josh Poimboeuf <jpoimboe@kernel.org>
Cc:     linux-toolchains@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
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
Message-ID: <20220912113114.GV25951@gate.crashing.org>
References: <20220909180704.jwwed4zhwvin7uyi@treble>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220909180704.jwwed4zhwvin7uyi@treble>
User-Agent: Mutt/1.4.2.3i
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hi!

On Fri, Sep 09, 2022 at 11:07:04AM -0700, Josh Poimboeuf wrote:
> 2) Noreturn functions:
>    
>    There's no reliable way to determine which functions are designated
>    by the compiler to be noreturn (either explictly via function
>    attribute, or implicitly via a static function which is a wrapper
>    around a noreturn function.)

Or just a function that does not return for any other reason.

The compiler makes no difference between functions that have the
attribute and functions that do not.  There are good reasons to not
have the attribute on functions that do in fact not return.  The
not-returningness of the function may be just an implementation
accident, something you do not want part of the API, so it *should* not
have that attribute; or you may want the callers to a function to not be
optimised according to this knowledge (you cannot *prevent* that, the
compiler can figure it out it other ways, but still) for any other
reason.

>    This information is needed because the
>    code after the call to such a function is optimized out as
>    unreachable and objtool has no way of knowing that.

Since June we (GCC) have -funreachable-traps.  This creates a trap insn
wherever control flow would otherwise go into limbo.


Segher
