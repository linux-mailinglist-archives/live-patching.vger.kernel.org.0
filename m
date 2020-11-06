Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 547702A9797
	for <lists+live-patching@lfdr.de>; Fri,  6 Nov 2020 15:27:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727055AbgKFO1n (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 6 Nov 2020 09:27:43 -0500
Received: from mx2.suse.de ([195.135.220.15]:46544 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726010AbgKFO1m (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 6 Nov 2020 09:27:42 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1604672860;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fneYivF7KPk5Vezwqp16bHvlG7pQia60PP+ozhIKNOI=;
        b=hOSy8tf6Xv9bxsLj3BRpsgcu/m8tXPh77G9b08Scucev/08pfZ/oZN7WOboqt1Phltz0oY
        EY+Z7IhgTgZK8/cheL0CPQ+pGMcTvUW7Ysp6ShK8LBZpwqpEn7fzXD6giDnRBpzEP5qAeT
        BwsA/u4RxQJT0sh1JOGSdIWHppyWK2U=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id CBFB7ABCC;
        Fri,  6 Nov 2020 14:27:39 +0000 (UTC)
Date:   Fri, 6 Nov 2020 15:27:38 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-kernel@vger.kernel.org,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Jonathan Corbet <corbet@lwn.net>, Guo Ren <guoren@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        Helge Deller <deller@gmx.de>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Kees Cook <keescook@chromium.org>,
        Anton Vorontsov <anton@enomsg.org>,
        Colin Cross <ccross@android.com>,
        Tony Luck <tony.luck@intel.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-doc@vger.kernel.org, linux-csky@vger.kernel.org,
        linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-s390@vger.kernel.org, live-patching@vger.kernel.org
Subject: Re: [PATCH 11/11 v3] ftrace: Add recording of functions that caused
 recursion
Message-ID: <20201106142738.GX20201@alley>
References: <20201106023235.367190737@goodmis.org>
 <20201106023548.102375687@goodmis.org>
 <20201106131317.GW20201@alley>
 <20201106084131.7dfc3a30@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201106084131.7dfc3a30@gandalf.local.home>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri 2020-11-06 08:41:31, Steven Rostedt wrote:
> On Fri, 6 Nov 2020 14:13:17 +0100
> Petr Mladek <pmladek@suse.com> wrote:
> 
> > JFYI, the code reading and writing the cache looks good to me.
> > 
> > It is still possible that some entries might stay unused (filled
> > with zeroes) but it should be hard to hit in practice. It
> > is good enough from my POV.
> 
> You mean the part that was commented?

Yeah, it is the comment problem when nr_records is pushed forward.

> > 
> > I do not give Reviewed-by tag just because I somehow do not have power
> > to review the entire patch carefully enough at the moment.
> 
> No problem. Thanks for looking at it.
> 
> I'm adding a link to this thread, so if someone wants proof you helped out
> on this code, you can have them follow the links ;-)
> 
> Anyway, even if I push this to linux-next where I stop rebasing code
> (because of test coverage), I do rebase for adding tags. So if you ever get
> around at looking at this code, I can add that tag later (before the next
> merge window), or if you find something, I could fix it with a new patch and
> give you a Reported-by.

Good to know.

Best Regards,
Petr
