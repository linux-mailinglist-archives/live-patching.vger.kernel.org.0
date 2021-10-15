Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22A6542F7F5
	for <lists+live-patching@lfdr.de>; Fri, 15 Oct 2021 18:17:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237338AbhJOQT6 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 15 Oct 2021 12:19:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236917AbhJOQT6 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 15 Oct 2021 12:19:58 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DC6BC061570;
        Fri, 15 Oct 2021 09:17:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=4G571e+7WIYw8I8DxxzASA83VdzBwRS9bXXbSuaKaJk=; b=BOf7V74lD3FXPUP4kCK2U0TLoV
        SAznVCk8FeJ+WeewdASQRvl3LuAkpeUPeUYt7Yezk4dwcdYMeynJPLMmXX2ketg/uIbydVfP3fx8i
        4IFF/PRVghZskAnfs53YUmskIsiWSmMUiZqjhTPe2PmaC9LPuznv8Q8JxnB/Lk+IXoOffuE21e2zN
        4QFyJJFjuCIGlI7Rxldtg9k0stkjBnL/ARkashob96yYMpeLCBfkQx787ELuOwu+KLpO4wtbU8EZc
        64hcntxiBp7R1+VdlnNysKcyoHyA19AEgiAw6E5CIm3GsV2jlF1r0Te0gVoh+BTh2SRD+pD6oIJjU
        sHkd9clg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=worktop.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mbPtJ-00A1p8-2k; Fri, 15 Oct 2021 16:17:05 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
        id 02CA79857C7; Fri, 15 Oct 2021 18:17:02 +0200 (CEST)
Date:   Fri, 15 Oct 2021 18:17:02 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Helge Deller <deller@gmx.de>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Colin Ian King <colin.king@canonical.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        Jisheng Zhang <jszhang@kernel.org>, linux-csky@vger.kernel.org,
        linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-riscv@lists.infradead.org, live-patching@vger.kernel.org,
        =?utf-8?B?546L6LSH?= <yun.wang@linux.alibaba.com>,
        Guo Ren <guoren@kernel.org>
Subject: Re: [PATCH] tracing: Have all levels of checks prevent recursion
Message-ID: <20211015161702.GF174703@worktop.programming.kicks-ass.net>
References: <20211015110035.14813389@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211015110035.14813389@gandalf.local.home>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri, Oct 15, 2021 at 11:00:35AM -0400, Steven Rostedt wrote:
> From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
> 
> While writing an email explaining the "bit = 0" logic for a discussion on

>  	bit = trace_get_context_bit() + start;

While there, you were also going to update that function to match/use
get_recursion_context(). Because your version is still branch hell.
