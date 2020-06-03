Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 156781ED378
	for <lists+live-patching@lfdr.de>; Wed,  3 Jun 2020 17:34:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725937AbgFCPeQ (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 3 Jun 2020 11:34:16 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:44538 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725904AbgFCPeQ (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 3 Jun 2020 11:34:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591198454;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qaCbCFVzSvAuhoMZaBKDEMbKv2nC6/i8181cqEt1QZM=;
        b=c0Y7c6R+M3BXluy/3bJpXDA86geVOPQN4T14jqV+o9jgbtVHj0ahTfnuuvjLypNN+3iOiO
        waIBYdPD9WiqIiS7jTpT2W8a6r88PRa+AxROHr4Rsj5Aii4e2FckqIuk4N3J8NR3d2E4yt
        6zpxMPU5XxHaQuHU4pM0JDW773+/q9I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-250-P5dUG9HHPu6e5UN1z0hIDA-1; Wed, 03 Jun 2020 11:34:12 -0400
X-MC-Unique: P5dUG9HHPu6e5UN1z0hIDA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 866843640A;
        Wed,  3 Jun 2020 15:34:10 +0000 (UTC)
Received: from treble (ovpn-116-170.rdu2.redhat.com [10.10.116.170])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id EBADD78EFD;
        Wed,  3 Jun 2020 15:34:05 +0000 (UTC)
Date:   Wed, 3 Jun 2020 10:33:58 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     "Wangshaobo (bobo)" <bobo.shaobowang@huawei.com>
Cc:     huawei.libin@huawei.com, xiexiuqi@huawei.com,
        cj.chengjian@huawei.com, mingo@redhat.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        mbenes@suse.cz, devel@etsukata.com, viro@zeniv.linux.org.uk,
        esyr@redhat.com
Subject: Re: Question: livepatch failed for new fork() task stack unreliable
Message-ID: <20200603153358.2ezz2pgxxxld7mj7@treble>
References: <20200529101059.39885-1-bobo.shaobowang@huawei.com>
 <20200529174433.wpkknhypx2bmjika@treble>
 <a9ed9157-f3cf-7d2c-7a8e-56150a2a114e@huawei.com>
 <20200601180538.o5agg5trbdssqken@treble>
 <a5e0f476-02b5-cc44-8d4e-d33ff2138143@huawei.com>
 <20200602131450.oydrydelpdaval4h@treble>
 <1353648b-f3f7-5b8d-f0bb-28bdb1a66f0f@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1353648b-f3f7-5b8d-f0bb-28bdb1a66f0f@huawei.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, Jun 03, 2020 at 10:06:07PM +0800, Wangshaobo (bobo) wrote:
> Today I test your fix, but arch_stack_walk_reliable() still return failed
> sometimes, I
> 
> found one of three scenarios mentioned failed:
> 
> 
> 1. user task (just fork) but not been scheduled
> 
>     test FAILED
> 
>     it is because unwind_next_frame() get the first frame, this time
> state->signal is false, and then return
> 
>     failed in the same place for ret_from_fork has not executed at all.

Oops - I meant to do it in __unwind_start (as you discovered).

> 2. user task (just fork) start excuting ret_from_fork() till schedule_tail
> but not UNWIND_HINT_REGS
> 
>     test condition :loop fork() in current  system
> 
>     result : SUCCESS,
> 
>     it looks like this modification works for my perspective :
> 
> 	-	/* Success path for non-user tasks, i.e. kthreads and idle tasks */
> 	-	if (!(task->flags & (PF_KTHREAD | PF_IDLE)))
> 	-		return -EINVAL;
>   but is this possible to miss one invalid judgement condition ? (1)

I'm not sure I understand your question, but I think this change
shouldn't break anything else because the ORC unwinder is careful to
always set an error if it doesn't reach the end of the stack, especially
with my recent ORC fixes which went into 5.7.

> 3. call_usermodehelper_exec_async
> 
>     test condition :loop call call_usermodehelper() in a module selfmade.
> 
>     result : SUCCESS,
> 
>    it looks state->signal==true works when unwind_next_frame() gets the end
> ret_from_fork() frame,
> 
>    but i don't know how does it work, i am confused by this sentences, how
> does the comment means sibling calls and
> 
>     calls to noreturn functions? (2)
> 
>             /*
>              * Find the orc_entry associated with the text address.
>              *
>              * Decrement call return addresses by one so they work for sibling
>              * calls and calls to noreturn functions.
>              */
>             orc = orc_find(state->signal ? state->ip : state->ip - 1);
>             if (!orc) {

To be honest, I don't remember what I meant by sibling calls.  They
don't even leave anything on the stack.

For noreturns, the code might be laid out like this:

func1:
	...
	call noreturn_foo
func2:

func2 is immediately after the call to noreturn_foo.  So the return
address on the stack will actually be 'func2'.  We want to retrieve the
ORC data for the call instruction (inside func1), instead of the
instruction at the beginning of func2.

I should probably update that comment.

-- 
Josh

