Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9503B6A722E
	for <lists+live-patching@lfdr.de>; Wed,  1 Mar 2023 18:35:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229463AbjCARfB (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 1 Mar 2023 12:35:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbjCARfA (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 1 Mar 2023 12:35:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F042D457EF
        for <live-patching@vger.kernel.org>; Wed,  1 Mar 2023 09:34:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 74A8861449
        for <live-patching@vger.kernel.org>; Wed,  1 Mar 2023 17:34:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32800C4339B;
        Wed,  1 Mar 2023 17:34:38 +0000 (UTC)
Date:   Wed, 1 Mar 2023 12:34:35 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Josh Poimboeuf <jpoimboe@kernel.org>
Cc:     x86@kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Mark Rutland <mark.rutland@arm.com>,
        live-patching@vger.kernel.org
Subject: Re: [PATCH 6/6] x86,objtool: Split UNWIND_HINT_EMPTY in two
Message-ID: <20230301123435.7acef48f@gandalf.local.home>
In-Reply-To: <fd6212c8b450d3564b855e1cb48404d6277b4d9f.1677683419.git.jpoimboe@kernel.org>
References: <cover.1677683419.git.jpoimboe@kernel.org>
        <fd6212c8b450d3564b855e1cb48404d6277b4d9f.1677683419.git.jpoimboe@kernel.org>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed,  1 Mar 2023 07:13:12 -0800
Josh Poimboeuf <jpoimboe@kernel.org> wrote:

> diff --git a/arch/x86/kernel/ftrace_64.S b/arch/x86/kernel/ftrace_64.S
> index 1265ad519249..0387732e9c3f 100644
> --- a/arch/x86/kernel/ftrace_64.S
> +++ b/arch/x86/kernel/ftrace_64.S
> @@ -340,7 +340,7 @@ STACK_FRAME_NON_STANDARD_FP(__fentry__)
>  
>  #ifdef CONFIG_FUNCTION_GRAPH_TRACER
>  SYM_CODE_START(return_to_handler)
> -	UNWIND_HINT_EMPTY
> +	UNWIND_HINT_UNDEFINED
>  	ANNOTATE_NOENDBR
>  	subq  $16, %rsp
>  

Acked-by: Steven Rostedt (Google) <rostedt@goodmis.org>

-- Steve
