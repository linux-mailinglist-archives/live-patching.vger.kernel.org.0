Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5F064F9555
	for <lists+live-patching@lfdr.de>; Fri,  8 Apr 2022 14:06:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232481AbiDHMIc (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 8 Apr 2022 08:08:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235913AbiDHMIT (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 8 Apr 2022 08:08:19 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F164F38D86;
        Fri,  8 Apr 2022 05:06:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=nigdLwVfEQ2J3jfM763Hz6LH2QveHz51UWg9LJkBT4w=; b=MUP+uMkfw7IEy5HJN+0xfUDICZ
        mdTL2aBbAbBZXv+Zqw23HXvzG9oQ17G5U3CsmhNEvpT8Gfl1Z+bHoONo2PYZ7FqrBYmRfAvM6TD76
        ZsKh7s3dcRlFgQh9EokiUCJi8sXaIYRA2aC5/D7OQ70Jtm7zGSLoT59SZqQS3pdh4/fuakX4YJ/cf
        2Mgqub5CSYvvOSVxYTRY3ONImgVx2wn33UliU5bAHm2ZEMAwuCx0hkSuNKIH1GEEPvfU9tGVQX3Oh
        Rc5OFTuEgaV6gidlRYZUPC4WlR8gj22dGTxtd4sfldRDJf1IzG8JhHyRDeC9hSocDPRUdIFdFQc4B
        +lK4riUw==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ncnNN-009nL9-Gn; Fri, 08 Apr 2022 12:06:05 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 0019A30017F;
        Fri,  8 Apr 2022 14:06:03 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id CD061302DDE0B; Fri,  8 Apr 2022 14:06:03 +0200 (CEST)
Date:   Fri, 8 Apr 2022 14:06:03 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     madvenka@linux.microsoft.com
Cc:     mark.rutland@arm.com, broonie@kernel.org, jpoimboe@redhat.com,
        ardb@kernel.org, nobuta.keiya@fujitsu.com,
        sjitindarsingh@gmail.com, catalin.marinas@arm.com, will@kernel.org,
        jmorris@namei.org, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v1 0/9] arm64: livepatch: Use DWARF Call Frame
 Information for frame pointer validation
Message-ID: <YlAlK+94gBlVlv2J@hirez.programming.kicks-ass.net>
References: <95691cae4f4504f33d0fc9075541b1e7deefe96f>
 <20220407202518.19780-1-madvenka@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220407202518.19780-1-madvenka@linux.microsoft.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu, Apr 07, 2022 at 03:25:09PM -0500, madvenka@linux.microsoft.com wrote:
> The solution
> ============
> 
> The goal here is to use the absolute minimum CFI needed to compute the FP at
> every instruction address. The unwinder can compute the FP in each frame,
> compare the actual FP with the computed one and validate the actual FP.
> 
> Objtool is enhanced to parse the CFI, extract just the rules required,
> encode them in compact data structures and create special sections for
> the rules. The unwinder uses the special sections to find the rules for
> a given instruction address and compute the FP.
> 
> Objtool can be invoked as follows:
> 
> 	objtool dwarf generate <object-file>
> 
> The version of the DWARF standard supported in this work is version 4. The
> official documentation for this version is here:
> 
> 	https://dwarfstd.org/doc/DWARF4.pdf
> 
> Section 6.4 contains the description of the CFI.

The problem is of course that DWARF is only available for compiler
generated code and doesn't cover assembly code, of which is there is
always lots.

I suppose you can go add DWARF annotations to all the assembly, but IIRC
those are pretty terrible. We were *REALLY* happy to delete all that
nasty from the x86 code.

On top of that, AFAIK compilers don't generally consider DWARF
generation to be a correctness issue. For them it's debug info and
having it be correct is nice but not required. So using it as input for
something that's required to be correct, seems unfortunate.
