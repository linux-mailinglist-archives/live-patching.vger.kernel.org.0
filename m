Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A72AC5B58C1
	for <lists+live-patching@lfdr.de>; Mon, 12 Sep 2022 12:52:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229642AbiILKwd (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 12 Sep 2022 06:52:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbiILKwb (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 12 Sep 2022 06:52:31 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72880263B;
        Mon, 12 Sep 2022 03:52:27 -0700 (PDT)
Received: from nazgul.tnic (unknown [185.122.133.20])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 642B61EC04F0;
        Mon, 12 Sep 2022 12:52:21 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1662979941;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=FgvRemfYbKJ8Gn7+wP5vaCT+FhTTeor282QL7mPb06M=;
        b=GAA4f6zA1Q6IHDz2IsvfdeVTJQZIyGU+2XcK84evnx9QsQFTVuUiQn8z6Hj17Tykekb7cI
        KGL7zUPl0vo7bMDpyNUoacP25QtdXp5YI3Ib2B7rPxYMA+YZJPmfxBdgjrD87xox95Nomk
        ZN+TjlNyCYIXoPN/StONY8ThF7Sv9ME=
Date:   Mon, 12 Sep 2022 12:52:34 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Josh Poimboeuf <jpoimboe@kernel.org>, Michael Matz <matz@suse.de>
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
Subject: Re: [RFC] Objtool toolchain proposal:
 -fannotate-{jump-table,noreturn}
Message-ID: <Yx8PcldkdOLN8eaw@nazgul.tnic>
References: <20220909180704.jwwed4zhwvin7uyi@treble>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220909180704.jwwed4zhwvin7uyi@treble>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

+ matz.

Micha, any opinions on the below are appreciated.

Thx.

On Fri, Sep 09, 2022 at 11:07:04AM -0700, Josh Poimboeuf wrote:
> Hi,
> 
> Here's a preview of what I'm planning to discuss at the LPC toolchains
> microconference.  Feel free to start the discussion early :-)
> 
> This is a proposal for some new minor GCC/Clang features which would
> help objtool greatly.
> 
> 
> Background
> ----------
> 
> Objtool is a kernel-specific tool which reverse engineers the control
> flow graph (CFG) of compiled objects.  It then performs various
> validations, annotations, and modifications, mostly with the goal of
> improving robustness and security of the kernel.
> 
> Objtool features which use the CFG include include:
> validation/generation of unwinding metadata; validation of Intel SMAP
> rules; and validation of kernel "noinstr" rules (preventing compiler
> instrumentation in certain critical sections).
> 
> In general it's not feasible for the traditional toolchain to do any of
> this work, because the kernel has a lot of "blind spots" which the
> toolchain doesn't have visibility to, notably asm and inline asm.
> Manual .cfi annotations are very difficult to maintain and even more
> difficult to ensure correctness.  Also, due to kernel live patching, the
> kernel relies on 100% correctness of unwinding metadata, whereas the
> toolchain treats it as a best effort.
> 
> 
> Challenges
> ----------
> 
> Reverse engineering the control flow graph is mostly quite
> straightforward, with two notable exceptions:
> 
> 1) Jump tables (e.g., switch statements):
> 
>    Depending on the architecture, it's somewhere between difficult and
>    impossible to reliabily identify which indirect jumps correspond to
>    jump tables, and what are their corresponding intra-function jump
>    destinations.
> 
> 2) Noreturn functions:
>    
>    There's no reliable way to determine which functions are designated
>    by the compiler to be noreturn (either explictly via function
>    attribute, or implicitly via a static function which is a wrapper
>    around a noreturn function.)  This information is needed because the
>    code after the call to such a function is optimized out as
>    unreachable and objtool has no way of knowing that.
> 
> 
> Proposal
> --------
> 
> Add the following new compiler flags which create non-allocatable ELF
> sections which "annotate" control flow:
> 
> (Note this is purely hypothetical, intended for starting a discussion.
> I'm not a compiler person and I haven't written any compiler code.)
> 
> 
> 1) -fannotate-jump-table
> 
> Create an .annotate.jump_table section which is an array of the
> following variable-length structure:
> 
>   struct annotate_jump_table {
> 	void *indirect_jmp;
> 	long num_targets;
> 	void *targets[];
>   };
> 
> 
> For example, given the following switch statement code:
> 
>   .Lswitch_jmp:
> 	// %rax is .Lcase_1 or .Lcase_2
> 	jmp %rax
> 
>   .Lcase_1:
> 	...
>   .Lcase_2:
> 	...
> 
> 
> Add the following code:
> 
>   .pushsection .annotate.jump_table
> 	// indirect JMP address
> 	.quad .Lswitch_jmp
> 
> 	// num jump targets
> 	.quad 2
> 
> 	// indirect JMP target addresses
> 	.quad .Lcase_1
> 	.quad .Lcase_2
>   .popsection
> 
> 
> 2) -fannotate-noreturn
> 
> Create an .annotate.noreturn section which is an array of pointers to
> noreturn functions (both explicit/implicit and defined/undefined).
> 
> 
> For example, given the following three noreturn functions:
> 
>   // explicit noreturn:
>   __attribute__((__noreturn__)) void func1(void)
>   {
> 	exit(1);
>   }
> 
>   // explicit noreturn (extern):
>   extern __attribute__((__noreturn__)) void func2(void);
> 
>   // implicit noreturn:
>   static void func3(void)
>   {
>   	// call noreturn function
> 	func2();
>   }
> 
> 
> Add the following code:
> 
>   .pushsection .annotate.noreturn
> 	.quad func1
> 	.quad func2
> 	.quad func3
>   .popsection
> 
> 
> Alternatives
> ------------
> 
> Another idea which has been floated in the past is for objtool to read
> DWARF (or .eh_frame) to help it figure out the control flow.  That
> hasn't been tried yet, but would be considerably more difficult and
> fragile IMO.
> 
> 
> -- 
> Josh

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
