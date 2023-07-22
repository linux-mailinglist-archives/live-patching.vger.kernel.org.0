Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC55E75D89A
	for <lists+live-patching@lfdr.de>; Sat, 22 Jul 2023 03:22:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229560AbjGVBWk (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 21 Jul 2023 21:22:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbjGVBWj (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 21 Jul 2023 21:22:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 807972D7E;
        Fri, 21 Jul 2023 18:22:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 081C861DA6;
        Sat, 22 Jul 2023 01:22:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A5AEC433C7;
        Sat, 22 Jul 2023 01:22:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689988957;
        bh=ymdnVGyJNnGUv2HZI8/M1PK0lCyu640ix4SSxWqfV44=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qX6KSrLjUNhNPi02nh+6ca0mclsiX8ngx6MgAoXToVEXfxGVJDqDd+M/xrQSvGPdo
         HnjJABDZ+OFRbofb+JDvnjIEveDSuko/ikgRmWfqsjkq952i36BAMvINTGaChjawkN
         B6OgwD+8AJO8pd8z/xs4a/6K9P/a/2QBnvpuWam+MrqHhLdmuXK4SwdOcmYgpxe7vM
         22q4vDY9qAL+C5nUG3OBKyhHxxOwDvkPnHotsHGxEf6IGBGHRf44LFpW0ECov/5dH/
         YZurOS/9kOxHoWBIWBcbE7057VWjExGXUHZp3YSqZogBmtq6DHFSz4dzR5vmf0EeHL
         9OCfZ4ADrf3gQ==
Date:   Fri, 21 Jul 2023 18:22:35 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Alexander Lobakin <aleksander.lobakin@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Helge Deller <deller@gmx.de>,
        Michael Ellerman <mpe@ellerman.id.au>,
        "Benjamin Herrenschmidt" <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        "Jiri Kosina" <jikos@kernel.org>, Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Colin Ian King <colin.king@canonical.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        "Nicholas Piggin" <npiggin@gmail.com>,
        Jisheng Zhang <jszhang@kernel.org>,
        <linux-csky@vger.kernel.org>, <linux-parisc@vger.kernel.org>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-riscv@lists.infradead.org>,
        <live-patching@vger.kernel.org>,
        =?UTF-8?B?546L6LSH?= <yun.wang@linux.alibaba.com>,
        Guo Ren <guoren@kernel.org>
Subject: Re: [PATCH] tracing: Have all levels of checks prevent recursion
Message-ID: <20230721182235.6617a466@kernel.org>
In-Reply-To: <20230721122632.56b4df6c@gandalf.local.home>
References: <20211015110035.14813389@gandalf.local.home>
        <20211015161702.GF174703@worktop.programming.kicks-ass.net>
        <20211015133504.6c0a9fcc@gandalf.local.home>
        <20211015135806.72d1af23@gandalf.local.home>
        <20211015180429.GK174703@worktop.programming.kicks-ass.net>
        <20211015142033.72605b47@gandalf.local.home>
        <20211015142541.4badd8a9@gandalf.local.home>
        <1b402c0c-1beb-d93f-ff6d-955350995ca3@intel.com>
        <20230721120040.6ed2c02a@gandalf.local.home>
        <035cee53-255b-11a3-d7ac-ca46c05b907b@intel.com>
        <20230721122632.56b4df6c@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri, 21 Jul 2023 12:26:32 -0400 Steven Rostedt wrote:
> > if (!(in_hardirq() || irqs_disabled()))
> >   
> 
> Yeah, probably.
> 
> > , nothing more elegant / already existing / ...?  
> 
> It's not a common check. What would you call that?

Looks like Olek started the weekend already so let me answer.
He's trying to check if we can use a fast path cache which takes
a _bh spin lock.
