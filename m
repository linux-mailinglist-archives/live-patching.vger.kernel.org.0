Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F29B16D18
	for <lists+live-patching@lfdr.de>; Tue,  7 May 2019 23:24:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727947AbfEGVYb (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 7 May 2019 17:24:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58342 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726811AbfEGVYb (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Tue, 7 May 2019 17:24:31 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C7D465AFE9;
        Tue,  7 May 2019 21:24:30 +0000 (UTC)
Received: from treble (ovpn-123-166.rdu2.redhat.com [10.10.123.166])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 36B665C21F;
        Tue,  7 May 2019 21:24:27 +0000 (UTC)
Date:   Tue, 7 May 2019 16:24:25 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Petr Mladek <pmladek@suse.com>
Cc:     Jiri Kosina <jikos@kernel.org>, Miroslav Benes <mbenes@suse.cz>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] livepatch: Remove duplicate warning about missing
 reliable stacktrace support
Message-ID: <20190507212425.7gfqx5e3yc4fbdfy@treble>
References: <20190430091049.30413-1-pmladek@suse.com>
 <20190430091049.30413-2-pmladek@suse.com>
 <20190507004032.2fgddlsycyypqdsn@treble>
 <20190507014332.l5pmvjyfropaiui2@treble>
 <20190507112950.wejw6nmfwzmm3vaf@pathway.suse.cz>
 <20190507120350.gpazr6xivzwvd3az@treble>
 <20190507142847.pre7tvm4oysimfww@pathway.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190507142847.pre7tvm4oysimfww@pathway.suse.cz>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.39]); Tue, 07 May 2019 21:24:30 +0000 (UTC)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, May 07, 2019 at 04:28:47PM +0200, Petr Mladek wrote:
> > > > > Also this check is effectively the same as the klp_have_reliable_stack()
> > > > > check which is done in kernel/livepatch/core.c.  So I think it would be
> > > > > clearer and more consistent if the same check is done here:
> > > > > 
> > > > > 	if (!klp_have_reliable_stack())
> > > > > 		return -ENOSYS;
> > > 
> > > Huh, it smells with over engineering to me.
> > 
> > How so?  It makes the code more readable and the generated code should
> > be much better because it becomes a build-time check.
> 
> save_stack_trace_tsk_reliable() returns various error codes.
> We catch a specific one because otherwise the message below
> might be misleading.
> 
> I do not see why we should prevent this error by calling
> a custom hack: klp_have_reliable_stack()?

I wouldn't call it a hack.  It's a simple build-time check.

> Regarding reliability. If anyone changes semantic of
> save_stack_trace_tsk_reliable() error codes, they would likely
> check if all users (one at the moment) handle it correctly.
> 
> On the other hand, the dependency between the -ENOSYS
> return value and klp_have_reliable_stack() is far from
> obvious.

I don't follow your point.

> If we want to discuss and fix this to the death. We should change
> the return value from -ENOSYS to -EOPNOTSUPP. The reason
> is the same as in the commit 375bfca3459db1c5596
> ("livepatch: core: Return EOPNOTSUPP instead of ENOSYS").
> 
> Note that EOPNOTSUPP is the same errno as ENOTSUP, see
> man 3 errno.

Sure, but that's a separate issue.

> > But I think Miroslav's suggestion to revert 1d98a69e5cef would be even
> > better.
> 
> AFAIK, Miroslav wanted to point out that your opinion was inconsistent.

How is my opinion inconsistent?

Is there something wrong with the original approach, which was reverted
with

  1d98a69e5cef ("livepatch: Remove reliable stacktrace check in klp_try_switch_task()")

?

As I mentioned, that has some advantages:

- The generated code is simpler/faster because it uses a build-time
  check.

- The code is more readable IMO.  Especially if the check is done higher
  up the call stack by reverting 1d98a69e5cef.  That way the arch
  support short-circuiting is done in the logical place, before doing
  any more unnecessary work.  It's faster, but also, more importantly,
  it's less surprising.

- It's also more consistent with other code, since the intent of this
  check is the same as the klp_have_reliable_stack() use in
  klp_enabled_patch().

If you disagree with those, please explain why.

> > > > > 	ret = save_stack_trace_tsk_reliable(task, &trace);
> > > > > 
> > > > > 	[ no need to check ret for ENOSYS here ]
> > > > > 
> > > > > Then, IMO, no comment is needed.
> > > > 
> > > > BTW, if you agree with this approach then we can leave the
> > > > WARN_ON_ONCE() in save_stack_trace_tsk_reliable() after all.
> > > 
> > > I really like the removal of the WARN_ON_ONCE(). I consider
> > > it an old fashioned way used when people are lazy to handle
> > > errors. It might make sense when the backtrace helps to locate
> > > the context but the context is well known here. Finally,
> > > WARN() should be used with care. It might cause reboot
> > > with panic_on_warn.
> > 
> > The warning makes the function consistent with the other weak functions
> > in stacktrace.c and clarifies that it should never be called unless an
> > arch has misconfigured something.  And if we aren't even checking the
> > specific ENOSYS error as I proposed then this warning would make the
> > error more obvious.
> 
> I consider both WARN() and error value as superfluous. I like the
> error value because it allows users to handle the situation as
> they need it.

... but if there are no users of the weak function then the point is
moot.

> Best Regards,
> Petr
> 
> PS: This is my last mail in the thread this week. I will eventually
> return to it with a clear head next week. It is all nitpicking from
> my POV and I have better things to do.

I don't think it's helpful to characterize it as nitpicking.  The
details of the code are important.

-- 
Josh
