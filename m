Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D48D1EAE0B
	for <lists+live-patching@lfdr.de>; Mon,  1 Jun 2020 20:50:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729687AbgFASuk (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 1 Jun 2020 14:50:40 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:51608 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730376AbgFASFx (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 1 Jun 2020 14:05:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591034751;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=osjdztueMuaAwG61qi79PUuaa4pVp/qOeP56bfj88L4=;
        b=L/G1ZV/xWvd2hrDrY0cZTqbOrZl6yNPP84aZquM22KwwOXYll9NRC/CG+a6Cvzp5ef9dEN
        4Y7SyReYBIGvCcdOpnjiN8KuiTE+HXdxPgxO5tKNVTILVhvCD/Oa6gn4tw+sfxeeP2EKyx
        cE4cNSy1daO9HfhVXzpkyjD7d+BiA30=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-1-ayfnyAN1PO6nfg34SZesjA-1; Mon, 01 Jun 2020 14:05:47 -0400
X-MC-Unique: ayfnyAN1PO6nfg34SZesjA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8DF86107B266;
        Mon,  1 Jun 2020 18:05:45 +0000 (UTC)
Received: from treble (ovpn-116-170.rdu2.redhat.com [10.10.116.170])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D44F11002394;
        Mon,  1 Jun 2020 18:05:40 +0000 (UTC)
Date:   Mon, 1 Jun 2020 13:05:38 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     "Wangshaobo (bobo)" <bobo.shaobowang@huawei.com>
Cc:     huawei.libin@huawei.com, xiexiuqi@huawei.com,
        cj.chengjian@huawei.com, mingo@redhat.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        mbenes@suse.cz, devel@etsukata.com, viro@zeniv.linux.org.uk,
        esyr@redhat.com
Subject: Re: Question: livepatch failed for new fork() task stack unreliable
Message-ID: <20200601180538.o5agg5trbdssqken@treble>
References: <20200529101059.39885-1-bobo.shaobowang@huawei.com>
 <20200529174433.wpkknhypx2bmjika@treble>
 <a9ed9157-f3cf-7d2c-7a8e-56150a2a114e@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a9ed9157-f3cf-7d2c-7a8e-56150a2a114e@huawei.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Sat, May 30, 2020 at 10:21:19AM +0800, Wangshaobo (bobo) wrote:
> 1) when a user mode task just fork start excuting ret_from_fork() till
> schedule_tail, unwind_next_frame found
> 
> orc->sp_reg is ORC_REG_UNDEFINED but orc->end not equals zero, this time
> arch_stack_walk_reliable()
> 
> terminates it's backtracing loop for unwind_done() return true. then 'if
> (!(task->flags & (PF_KTHREAD | PF_IDLE)))'
> 
> in arch_stack_walk_reliable() true and return -EINVAL after.
> 
> * The stack trace looks like that:
> 
> ret_from_fork
> 
>       -=> UNWIND_HINT_EMPTY
> 
>       -=> schedule_tail             /* schedule out */
> 
>       ...
> 
>       -=> UNWIND_HINT_REGS      /*  UNDO */

Yes, makes sense.

> 2) when using call_usermodehelper_exec_async() to create a user mode task,
> ret_from_fork() still not exec whereas
> 
> the task has been scheduled in __schedule(), at this time, orc->sp_reg is
> ORC_REG_UNDEFINED but orc->end equals zero,
> 
> unwind_error() return true and also terminates arch_stack_walk_reliable()'s
> backtracing loop, end up return from
> 
> 'if (unwind_error())' branch.
> 
> * The stack trace looks like that:
> 
> -=> call_usermodehelper_exec
> 
>                  -=> do_exec
> 
>                            -=> search_binary_handler
> 
>                                       -=> load_elf_binary
> 
>                                                 -=> elf_map
> 
>                                                          -=> vm_mmap_pgoff
> 
> -=> down_write_killable
> 
> -=> _cond_resched
> 
>              -=> __schedule           /* scheduled to work */
> 
> -=> ret_from_fork       /* UNDO */

I don't quite follow the stacktrace, but it sounds like the issue is the
same as the first one you originally reported:

> 1) The task was not actually scheduled to excute, at this time
> UNWIND_HINT_EMPTY in ret_from_fork() has not reset unwind_hint, it's
> sp_reg and end field remain default value and end up throwing an error
> in unwind_next_frame() when called by arch_stack_walk_reliable();

Or am I misunderstanding?

And to reiterate, these are not "livepatch failures", right?  Livepatch
doesn't fail when stack_trace_save_tsk_reliable() returns an error.  It
recovers gracefully and tries again later.

-- 
Josh

