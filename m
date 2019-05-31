Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9882A31555
	for <lists+live-patching@lfdr.de>; Fri, 31 May 2019 21:28:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727249AbfEaT17 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 31 May 2019 15:27:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59586 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727147AbfEaT17 (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 31 May 2019 15:27:59 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id CB42D307D988;
        Fri, 31 May 2019 19:27:57 +0000 (UTC)
Received: from treble (ovpn-124-142.rdu2.redhat.com [10.10.124.142])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id AA3EB19C67;
        Fri, 31 May 2019 19:27:53 +0000 (UTC)
Date:   Fri, 31 May 2019 14:27:51 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Miroslav Benes <mbenes@suse.cz>
Cc:     Petr Mladek <pmladek@suse.com>, Jiri Kosina <jikos@kernel.org>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] stacktrace: Remove superfluous WARN_ONCE() from
 save_stack_trace_tsk_reliable()
Message-ID: <20190531192751.uz2egendytx6lqwv@treble>
References: <20190531074147.27616-1-pmladek@suse.com>
 <20190531074147.27616-2-pmladek@suse.com>
 <alpine.LSU.2.21.1905311418120.742@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.21.1905311418120.742@pobox.suse.cz>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Fri, 31 May 2019 19:27:59 +0000 (UTC)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri, May 31, 2019 at 02:25:15PM +0200, Miroslav Benes wrote:
> On Fri, 31 May 2019, Petr Mladek wrote:
> 
> > WARN_ONCE() in the generic save_stack_trace_tsk_reliable() is superfluous.
> > 
> > The information is passed also via the return value. The only current
> > user klp_check_stack() writes its own warning when the reliable stack
> > traces are not supported. Other eventual users might want its own error
> > handling as well.
> > 
> > Signed-off-by: Petr Mladek <pmladek@suse.com>
> > Acked-by: Miroslav Benes <mbenes@suse.cz>
> > Reviewed-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
> > ---
> >  kernel/stacktrace.c | 1 -
> >  1 file changed, 1 deletion(-)
> > 
> > diff --git a/kernel/stacktrace.c b/kernel/stacktrace.c
> > index 5667f1da3ede..8d088408928d 100644
> > --- a/kernel/stacktrace.c
> > +++ b/kernel/stacktrace.c
> > @@ -259,7 +259,6 @@ __weak int
> >  save_stack_trace_tsk_reliable(struct task_struct *tsk,
> >  			      struct stack_trace *trace)
> >  {
> > -	WARN_ONCE(1, KERN_INFO "save_stack_tsk_reliable() not implemented yet.\n");
> >  	return -ENOSYS;
> >  }
> 
> Do we even need the weak function now after Thomas' changes to 
> kernel/stacktrace.c?
> 
> - livepatch is the only user and it calls stack_trace_save_tsk_reliable()
> - x86 defines CONFIG_ARCH_STACKWALK and CONFIG_HAVE_RELIABLE_STACKTRACE, 
>   so it has stack_trace_save_tsk_reliable() implemented and it calls 
>   arch_stack_walk_reliable()
> - powerpc defines CONFIG_HAVE_RELIABLE_STACKTRACE and does not have 
>   CONFIG_ARCH_STACKWALK. It also has stack_trace_save_tsk_reliable() 
>   implemented and it calls save_stack_trace_tsk_reliable(), which is 
>   implemented in arch/powerpc/
> - all other archs do not have CONFIG_HAVE_RELIABLE_STACKTRACE and there is 
>   stack_trace_save_tsk_reliable() returning ENOSYS for these cases in 
>   include/linux/stacktrace.c

I think you're right.  stack_trace_save_tsk_reliable() in stacktrace.h
returning -ENOSYS serves the same purpose as the old weak version of
save_stack_trace_tsk_reliable() which is no longer called directly.

-- 
Josh
