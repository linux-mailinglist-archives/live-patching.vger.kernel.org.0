Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61B0E196AE
	for <lists+live-patching@lfdr.de>; Fri, 10 May 2019 04:29:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726839AbfEJC3C (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 9 May 2019 22:29:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:51516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726810AbfEJC3C (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 9 May 2019 22:29:02 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ACE73217F5;
        Fri, 10 May 2019 02:29:00 +0000 (UTC)
Date:   Thu, 9 May 2019 22:28:58 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        live-patching@vger.kernel.org,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Borislav Petkov <bp@alien8.de>
Subject: Re: [RFC][PATCH] ftrace/x86: Remove mcount support
Message-ID: <20190509222858.3ef96113@gandalf.local.home>
In-Reply-To: <CAHk-=wgZGWpXdscUHyuoRqkJ8XD5Wh2Q-320KGFBhGoBJGzAWQ@mail.gmail.com>
References: <20190509154902.34ea14f8@gandalf.local.home>
        <CAHk-=wgZGWpXdscUHyuoRqkJ8XD5Wh2Q-320KGFBhGoBJGzAWQ@mail.gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu, 9 May 2019 13:12:55 -0700
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Thu, May 9, 2019 at 12:49 PM Steven Rostedt <rostedt@goodmis.org> wrote:
> >
> > diff --git a/arch/x86/include/asm/livepatch.h b/arch/x86/include/asm/livepatch.h
> > index ed80003ce3e2..2f2bdf0662f8 100644
> > --- a/arch/x86/include/asm/livepatch.h
> > +++ b/arch/x86/include/asm/livepatch.h
> > @@ -26,9 +26,6 @@
> >
> >  static inline int klp_check_compiler_support(void)
> >  {
> > -#ifndef CC_USING_FENTRY
> > -       return 1;
> > -#endif
> >         return 0;
> >  }  
> 
> Please remove this entirely.
> 
> There are now three copies of klp_check_compiler_support(), and all
> three are now trivial "return 0" functions.
> 
> Remove the whole thing, and remove the single use in kernel/livepatch/core.c.
> 
> The only reason for this function existing was literally "mcount isn't
> good enough", so with mcount removed, the function should be removed
> too.
>

As this patch is simply a "remove mcount" patch, I'd like to have the
removal of klp_check_compiler_support() be a separate patch.

Jiri or Josh, care to send a patch on top of this one?

Thanks!

-- Steve
