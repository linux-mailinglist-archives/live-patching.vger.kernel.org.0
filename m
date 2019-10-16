Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1FDFDD88C1
	for <lists+live-patching@lfdr.de>; Wed, 16 Oct 2019 08:51:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388546AbfJPGvb (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 16 Oct 2019 02:51:31 -0400
Received: from mx2.suse.de ([195.135.220.15]:35846 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388363AbfJPGvb (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Wed, 16 Oct 2019 02:51:31 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 2435DB715;
        Wed, 16 Oct 2019 06:51:29 +0000 (UTC)
Date:   Wed, 16 Oct 2019 08:51:27 +0200 (CEST)
From:   Miroslav Benes <mbenes@suse.cz>
To:     Joe Lawrence <joe.lawrence@redhat.com>
cc:     Peter Zijlstra <peterz@infradead.org>,
        Jessica Yu <jeyu@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, mhiramat@kernel.org,
        bristot@redhat.com, jbaron@akamai.com,
        torvalds@linux-foundation.org, tglx@linutronix.de,
        mingo@kernel.org, namit@vmware.com, hpa@zytor.com, luto@kernel.org,
        ard.biesheuvel@linaro.org, jpoimboe@redhat.com,
        live-patching@vger.kernel.org
Subject: Re: [PATCH v3 5/6] x86/ftrace: Use text_poke()
In-Reply-To: <88bab814-ea24-ece9-2bc0-7a1e10a62f12@redhat.com>
Message-ID: <alpine.LSU.2.21.1910160843420.7750@pobox.suse.cz>
References: <20191007081945.10951536.8@infradead.org> <20191008104335.6fcd78c9@gandalf.local.home> <20191009224135.2dcf7767@oasis.local.home> <20191010092054.GR2311@hirez.programming.kicks-ass.net> <20191010091956.48fbcf42@gandalf.local.home>
 <20191010140513.GT2311@hirez.programming.kicks-ass.net> <20191010115449.22044b53@gandalf.local.home> <20191010172819.GS2328@hirez.programming.kicks-ass.net> <20191011125903.GN2359@hirez.programming.kicks-ass.net> <20191015130739.GA23565@linux-8ccs>
 <20191015135634.GK2328@hirez.programming.kicks-ass.net> <alpine.LSU.2.21.1910151611000.13169@pobox.suse.cz> <88bab814-ea24-ece9-2bc0-7a1e10a62f12@redhat.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, 15 Oct 2019, Joe Lawrence wrote:

> On 10/15/19 10:13 AM, Miroslav Benes wrote:
> > Yes, it does. klp_module_coming() calls module_disable_ro() on all
> > patching modules which patch the coming module in order to call
> > apply_relocate_add(). New (patching) code for a module can be relocated
> > only when the relevant module is loaded.
> 
> FWIW, would the LPC blue-sky2 model (ie, Steve's suggestion @ plumber's where
> livepatches only patch a single object and updates are kept on disk to handle
> coming module updates as they are loaded) eliminate those outstanding
> relocations and the need to perform this late permission flipping?

Yes, it should, but we don't have to wait for it. PeterZ proposed a 
different solution to this specific issue in 
https://lore.kernel.org/lkml/20191015141111.GP2359@hirez.programming.kicks-ass.net/

It should not be a problem to create a live patch module like that and the 
code in kernel/livepatch/ is almost ready. Something like 
module_section_disable_ro(mod, section) (and similar for X protection) 
should be enough. Module reloads would still require juggling with the 
protections, but I think it is all feasible.

Miroslav
