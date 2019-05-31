Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC83130E0F
	for <lists+live-patching@lfdr.de>; Fri, 31 May 2019 14:25:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727267AbfEaMZR (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 31 May 2019 08:25:17 -0400
Received: from mx2.suse.de ([195.135.220.15]:33508 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726330AbfEaMZR (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 31 May 2019 08:25:17 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 42AA4AD76;
        Fri, 31 May 2019 12:25:16 +0000 (UTC)
Date:   Fri, 31 May 2019 14:25:15 +0200 (CEST)
From:   Miroslav Benes <mbenes@suse.cz>
To:     Petr Mladek <pmladek@suse.com>
cc:     Jiri Kosina <jikos@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] stacktrace: Remove superfluous WARN_ONCE() from
 save_stack_trace_tsk_reliable()
In-Reply-To: <20190531074147.27616-2-pmladek@suse.com>
Message-ID: <alpine.LSU.2.21.1905311418120.742@pobox.suse.cz>
References: <20190531074147.27616-1-pmladek@suse.com> <20190531074147.27616-2-pmladek@suse.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri, 31 May 2019, Petr Mladek wrote:

> WARN_ONCE() in the generic save_stack_trace_tsk_reliable() is superfluous.
> 
> The information is passed also via the return value. The only current
> user klp_check_stack() writes its own warning when the reliable stack
> traces are not supported. Other eventual users might want its own error
> handling as well.
> 
> Signed-off-by: Petr Mladek <pmladek@suse.com>
> Acked-by: Miroslav Benes <mbenes@suse.cz>
> Reviewed-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
> ---
>  kernel/stacktrace.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/kernel/stacktrace.c b/kernel/stacktrace.c
> index 5667f1da3ede..8d088408928d 100644
> --- a/kernel/stacktrace.c
> +++ b/kernel/stacktrace.c
> @@ -259,7 +259,6 @@ __weak int
>  save_stack_trace_tsk_reliable(struct task_struct *tsk,
>  			      struct stack_trace *trace)
>  {
> -	WARN_ONCE(1, KERN_INFO "save_stack_tsk_reliable() not implemented yet.\n");
>  	return -ENOSYS;
>  }

Do we even need the weak function now after Thomas' changes to 
kernel/stacktrace.c?

- livepatch is the only user and it calls stack_trace_save_tsk_reliable()
- x86 defines CONFIG_ARCH_STACKWALK and CONFIG_HAVE_RELIABLE_STACKTRACE, 
  so it has stack_trace_save_tsk_reliable() implemented and it calls 
  arch_stack_walk_reliable()
- powerpc defines CONFIG_HAVE_RELIABLE_STACKTRACE and does not have 
  CONFIG_ARCH_STACKWALK. It also has stack_trace_save_tsk_reliable() 
  implemented and it calls save_stack_trace_tsk_reliable(), which is 
  implemented in arch/powerpc/
- all other archs do not have CONFIG_HAVE_RELIABLE_STACKTRACE and there is 
  stack_trace_save_tsk_reliable() returning ENOSYS for these cases in 
  include/linux/stacktrace.c

Miroslav
