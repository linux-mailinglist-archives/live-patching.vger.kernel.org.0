Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 824166C6893
	for <lists+live-patching@lfdr.de>; Thu, 23 Mar 2023 13:38:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231903AbjCWMio (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 23 Mar 2023 08:38:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231926AbjCWMid (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 23 Mar 2023 08:38:33 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30F022A98A
        for <live-patching@vger.kernel.org>; Thu, 23 Mar 2023 05:38:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=IUAjpgywdEv9m2kYI9XNVC5x6XA0EKoC2enruDplZ2g=; b=s6KI97mtOQKlhamo8U8JGA1Nyw
        T1JiZdEeyLwhRChj0KMzY8+Lb0dFAZbyx/84x5qqgn62WTEwctVVDdA1C9YSZdgwacz1vELO9DYOL
        Z2TUJhvwe5/QTaIu2iF+Tej/HRGLm53tIrfjMlTf53FI95PAsVAvCVB3aiyZwDrlqglRFKZDUMrxp
        Tmogs/UcgDUyA6zHqsJuF3V421AP7hnjgQc+ymn/DeDs8dvoQpmbYDuibkP2mr5+cbFzg4Fk3tn0P
        OpEnrMqVFi2J5W/0MF7l9loV9CoHyEsPEuBXUHxhnGo7OqA2bnExnx9MF9Yd6HafVuZWT4A/jwXnl
        m3n0w3ZA==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pfKCw-003wrc-Lw; Thu, 23 Mar 2023 12:38:18 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id A6C8E300237;
        Thu, 23 Mar 2023 13:38:17 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 8388E2420A896; Thu, 23 Mar 2023 13:38:17 +0100 (CET)
Date:   Thu, 23 Mar 2023 13:38:17 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Josh Poimboeuf <jpoimboe@kernel.org>
Cc:     x86@kernel.org, Mark Rutland <mark.rutland@arm.com>,
        live-patching@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 0/6] x86,objtool: Split UNWIND_HINT_EMPTY in two
Message-ID: <20230323123817.GA2512024@hirez.programming.kicks-ass.net>
References: <cover.1677683419.git.jpoimboe@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1677683419.git.jpoimboe@kernel.org>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, Mar 01, 2023 at 07:13:06AM -0800, Josh Poimboeuf wrote:
> Based on tip/objtool/core.
> 
> Mark reported that the ORC unwinder incorrectly marks an unwind as
> reliable when the unwind terminates prematurely in the dark corners of
> return_to_handler() due to lack of information about the next frame.
> 
> The problem is UNWIND_HINT_EMPTY is used in two different situations:
> end-of-stack marker and undefined stack state.
> 
> Split it up into UNWIND_HINT_END_OF_STACK and UNWIND_HINT_UNDEFINED.
> 
> Josh Poimboeuf (6):
>   objtool: Add objtool_types.h
>   objtool: Use relative pointers for annotations
>   objtool: Change UNWIND_HINT() argument order
>   x86,objtool: Introduce ORC_TYPE_*
>   x86,objtool: Separate unret validation from unwind hints
>   x86,objtool: Split UNWIND_HINT_EMPTY in two

Quite a bit of churn, but the end result does seem cleaner.

Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
