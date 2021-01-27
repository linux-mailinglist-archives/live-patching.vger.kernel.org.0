Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B45273058BD
	for <lists+live-patching@lfdr.de>; Wed, 27 Jan 2021 11:47:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343492AbhA0Kqu (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 27 Jan 2021 05:46:50 -0500
Received: from mx2.suse.de ([195.135.220.15]:39968 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236145AbhA0Kpo (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Wed, 27 Jan 2021 05:45:44 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 02C94ACBA;
        Wed, 27 Jan 2021 10:45:02 +0000 (UTC)
Date:   Wed, 27 Jan 2021 11:45:01 +0100 (CET)
From:   Miroslav Benes <mbenes@suse.cz>
To:     Mark Brown <broonie@kernel.org>
cc:     linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>, Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>, x86@kernel.org,
        linux-s390@vger.kernel.org, live-patching@vger.kernel.org
Subject: Re: [PATCH] stacktrace: Move documentation for arch_stack_walk_reliable()
 to header
In-Reply-To: <20210118211021.42308-1-broonie@kernel.org>
Message-ID: <alpine.LSU.2.21.2101271141460.27114@pobox.suse.cz>
References: <20210118211021.42308-1-broonie@kernel.org>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Mon, 18 Jan 2021, Mark Brown wrote:

> Currently arch_stack_wallk_reliable() is documented with an identical
> comment in both x86 and S/390 implementations which is a bit redundant.
> Move this to the header and convert to kerneldoc while we're at it.

Makes sense.
 
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: Heiko Carstens <hca@linux.ibm.com>
> Cc: Vasily Gorbik <gor@linux.ibm.com>
> Cc: Christian Borntraeger <borntraeger@de.ibm.com>
> Cc: Josh Poimboeuf <jpoimboe@redhat.com>
> Cc: Jiri Kosina <jikos@kernel.org>
> Cc: Miroslav Benes <mbenes@suse.cz>
> Cc: Petr Mladek <pmladek@suse.com>
> Cc: Joe Lawrence <joe.lawrence@redhat.com>
> Cc: x86@kernel.org
> Cc: linux-s390@vger.kernel.org
> Cc: live-patching@vger.kernel.org
> Signed-off-by: Mark Brown <broonie@kernel.org>

Reviewed-by: Miroslav Benes <mbenes@suse.cz>

> diff --git a/arch/s390/kernel/stacktrace.c b/arch/s390/kernel/stacktrace.c
> index 7f1266c24f6b..101477b3e263 100644
> --- a/arch/s390/kernel/stacktrace.c
> +++ b/arch/s390/kernel/stacktrace.c
> @@ -24,12 +24,6 @@ void arch_stack_walk(stack_trace_consume_fn consume_entry, void *cookie,
>  	}
>  }
>  
> -/*
> - * This function returns an error if it detects any unreliable features of the
> - * stack.  Otherwise it guarantees that the stack trace is reliable.
> - *
> - * If the task is not 'current', the caller *must* ensure the task is inactive.
> - */
>  int arch_stack_walk_reliable(stack_trace_consume_fn consume_entry,
>  			     void *cookie, struct task_struct *task)
>  {

Just a note. arch/powerpc/kernel/stacktrace.c has the same for 
__save_stack_trace_tsk_reliable(), but it would not be nice to pollute 
include/linux/stacktrace.h with that in my opinion. It is an old 
infrastructure after all.

Miroslav
