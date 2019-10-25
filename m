Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92FB7E46E3
	for <lists+live-patching@lfdr.de>; Fri, 25 Oct 2019 11:16:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727638AbfJYJQ5 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 25 Oct 2019 05:16:57 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:35966 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726409AbfJYJQ5 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 25 Oct 2019 05:16:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=4HNQYHclJdpz6RgSoEiA+TUKr4RT5EnizppRlQ3bps8=; b=qiISsN8DPpzxJuDWz5BDD7Vsb
        nyk65gVZOZKlJdImt/zQ93JZf06MrUU84AZ2Rsfj9ptyTwWjr0D3qFev4YZQfFPwJTMmDobsN0BIk
        BjQ5xOzlgeGTMGH/nj+hTq32C+lTp3YOmIQQjx690HEJY53zroXK96U1kgH2zoh/q6D+yAR7fxkCR
        NbWzxkhobMh986G8cityFONFpJ+3Kz3hnTzKbLn0NepyOKE4bk0Ic96FQ5eI9MaWJNoVq2rAnv1bg
        zC0/oopErZGmxqjGq2sEPyLSJLd+UMv9VuOpm84Rd7H5jLuP4VkpiYrpLY9ByFMTMEMhCU+USTsNm
        TJq8gTq9A==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iNvi1-00055a-9Y; Fri, 25 Oct 2019 09:16:37 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 3873A3006E3;
        Fri, 25 Oct 2019 11:15:36 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 07F88201A6624; Fri, 25 Oct 2019 11:16:35 +0200 (CEST)
Date:   Fri, 25 Oct 2019 11:16:34 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Petr Mladek <pmladek@suse.com>
Cc:     Josh Poimboeuf <jpoimboe@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, rostedt@goodmis.org,
        mhiramat@kernel.org, bristot@redhat.com, jbaron@akamai.com,
        torvalds@linux-foundation.org, tglx@linutronix.de,
        mingo@kernel.org, namit@vmware.com, hpa@zytor.com, luto@kernel.org,
        ard.biesheuvel@linaro.org, jeyu@kernel.org,
        live-patching@vger.kernel.org
Subject: Re: [PATCH v4 15/16] module: Move where we mark modules RO,X
Message-ID: <20191025091634.GA4114@hirez.programming.kicks-ass.net>
References: <20191018073525.768931536@infradead.org>
 <20191018074634.801435443@infradead.org>
 <20191021135312.jbbxsuipxldocdjk@treble>
 <20191021141402.GI1817@hirez.programming.kicks-ass.net>
 <20191023114835.GT1817@hirez.programming.kicks-ass.net>
 <20191023170025.f34g3vxaqr4f5gqh@treble>
 <20191024131634.GC4131@hirez.programming.kicks-ass.net>
 <20191025064456.6jjrngm4m3mspaxw@pathway.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191025064456.6jjrngm4m3mspaxw@pathway.suse.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri, Oct 25, 2019 at 08:44:56AM +0200, Petr Mladek wrote:
> On Thu 2019-10-24 15:16:34, Peter Zijlstra wrote:

> > Right, that really should be able to run early. Esp. after commit
> > 
> >   11e86dc7f274 ("x86/paravirt: Detect over-sized patching bugs in paravirt_patch_call()")
> > 
> > paravirt patching is unconditional. We _never_ run with the indirect
> > call except very early boot, but modules should have them patched way
> > before their init section runs.
> > 
> > We rely on this for spectre-v2 and friends.
> 
> Livepatching has the same requirement. The module code has to be fully
> livepatched before the module gets actually used.

Right, and that is just saying that all paravirt RELAs (pv_ops) can
basically be deleted from modules.

Which avoids the reported problem in yet another way.

> It means before mod->init() is called and before the module is moved
> into MODULE_STATE_LIVE state.

Funny thing, currently ftrace is running code before all that. It runs
code before klp_module_coming(), before jump_label patching.

My other patch in this thread fixes that.
