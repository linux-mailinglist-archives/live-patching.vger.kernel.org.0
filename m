Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8797042FABF
	for <lists+live-patching@lfdr.de>; Fri, 15 Oct 2021 20:05:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242208AbhJOSHO (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 15 Oct 2021 14:07:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232557AbhJOSHN (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 15 Oct 2021 14:07:13 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF842C061570;
        Fri, 15 Oct 2021 11:05:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=iWFwLZtUtGK6QLeN9kwkzrG0DnPld05nUJlKzTSNq1M=; b=TKkIy9uEfgJwhj+gTY4uzfwmax
        0baqH8O8KrNb7Doua0roTYth1ckXfoqjJX8Hv3nGZY1RCjvoWMPFgBJ34IchV6bUKqVwvl6mZ37xR
        KPcdgndusraTnnK1v5Rfu6CofOx2h1PE0cxZ76Hd9WMDzAjpt32VjEZ2sSVF0URwEL0NThy7DPrlx
        EykTH3PUtC5GXcI4Hz32VKVum7ZMTccNVuPV95N0AMVWs+C5ILIINZVLzx+Em8f5rR4g0d4WKFsdq
        YD7XzC33MY60aXEZ1XypRY552W2gWeIrYFpp362bmOro2661TWvpH2L081WYfpvK81qTIbzl1CX8U
        aGpOAyTg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=worktop.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mbRZF-00A2dk-VJ; Fri, 15 Oct 2021 18:04:30 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
        id 8542C9857C7; Fri, 15 Oct 2021 20:04:29 +0200 (CEST)
Date:   Fri, 15 Oct 2021 20:04:29 +0200
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
Message-ID: <20211015180429.GK174703@worktop.programming.kicks-ass.net>
References: <20211015110035.14813389@gandalf.local.home>
 <20211015161702.GF174703@worktop.programming.kicks-ass.net>
 <20211015133504.6c0a9fcc@gandalf.local.home>
 <20211015135806.72d1af23@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211015135806.72d1af23@gandalf.local.home>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri, Oct 15, 2021 at 01:58:06PM -0400, Steven Rostedt wrote:
> Something like this:

I think having one copy of that in a header is better than having 3
copies. But yes, something along them lines.
