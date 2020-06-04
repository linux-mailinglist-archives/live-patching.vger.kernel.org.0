Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CEBE1EDB48
	for <lists+live-patching@lfdr.de>; Thu,  4 Jun 2020 04:41:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726877AbgFDClK (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 3 Jun 2020 22:41:10 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:42610 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726874AbgFDClJ (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 3 Jun 2020 22:41:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591238466;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yd4542Fh+4FYtypVVwxlbTi97DfvciD+WPtx97gNYhs=;
        b=OaAdvv8ovBLiSL6NgG2Hsi//d/uqKaDOdA4BFmCJdjyflX+eOGjVeXc7LmWNrIu+z0sT7p
        fKErTkz9pvYNojLfzK8x8aNt9pvfWSscoiK23HTvKYxsMQzla6A5HQDT0AmeG2aCXjAr54
        adlBLmBrshv6UuW12gz093WPIPtuBks=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-64-H713mFUsOtiEv0pmf7nX3g-1; Wed, 03 Jun 2020 22:41:02 -0400
X-MC-Unique: H713mFUsOtiEv0pmf7nX3g-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9D3291883600;
        Thu,  4 Jun 2020 02:41:00 +0000 (UTC)
Received: from treble (ovpn-116-170.rdu2.redhat.com [10.10.116.170])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7E5C62DE71;
        Thu,  4 Jun 2020 02:40:53 +0000 (UTC)
Date:   Wed, 3 Jun 2020 21:40:51 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     "Wangshaobo (bobo)" <bobo.shaobowang@huawei.com>
Cc:     huawei.libin@huawei.com, xiexiuqi@huawei.com,
        cj.chengjian@huawei.com, mingo@redhat.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        mbenes@suse.cz, devel@etsukata.com, viro@zeniv.linux.org.uk,
        esyr@redhat.com
Subject: Re: Question: livepatch failed for new fork() task stack unreliable
Message-ID: <20200604024051.6ovbr6tbrowwg6jr@treble>
References: <20200529101059.39885-1-bobo.shaobowang@huawei.com>
 <20200529174433.wpkknhypx2bmjika@treble>
 <a9ed9157-f3cf-7d2c-7a8e-56150a2a114e@huawei.com>
 <20200601180538.o5agg5trbdssqken@treble>
 <a5e0f476-02b5-cc44-8d4e-d33ff2138143@huawei.com>
 <20200602131450.oydrydelpdaval4h@treble>
 <1353648b-f3f7-5b8d-f0bb-28bdb1a66f0f@huawei.com>
 <20200603153358.2ezz2pgxxxld7mj7@treble>
 <2225bc83-95f2-bf3d-7651-fdd10a3ddd00@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2225bc83-95f2-bf3d-7651-fdd10a3ddd00@huawei.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu, Jun 04, 2020 at 09:24:55AM +0800, Wangshaobo (bobo) wrote:
> 
> 在 2020/6/3 23:33, Josh Poimboeuf 写道:
> > On Wed, Jun 03, 2020 at 10:06:07PM +0800, Wangshaobo (bobo) wrote:
> > To be honest, I don't remember what I meant by sibling calls.  They
> > don't even leave anything on the stack.
> > 
> > For noreturns, the code might be laid out like this:
> > 
> > func1:
> > 	...
> > 	call noreturn_foo
> > func2:
> > 
> > func2 is immediately after the call to noreturn_foo.  So the return
> > address on the stack will actually be 'func2'.  We want to retrieve the
> > ORC data for the call instruction (inside func1), instead of the
> > instruction at the beginning of func2.
> > 
> > I should probably update that comment.
> 
> So, I want to ask is there any side effects if i modify like this ? this
> modification is based on
> 
> your fix. It looks like ok with proper test.
> 
> diff --git a/arch/x86/kernel/unwind_orc.c b/arch/x86/kernel/unwind_orc.c
> index e9cc182aa97e..ecce5051e8fd 100644
> --- a/arch/x86/kernel/unwind_orc.c
> +++ b/arch/x86/kernel/unwind_orc.c
> @@ -620,6 +620,7 @@ void __unwind_start(struct unwind_state *state, struct
> task_struct *task,
>                 state->sp = task->thread.sp;
>                 state->bp = READ_ONCE_NOCHECK(frame->bp);
>                 state->ip = READ_ONCE_NOCHECK(frame->ret_addr);
> +              state->signal = ((void *)state->ip == ret_from_fork);
>         }
> 
> diff --git a/arch/x86/kernel/unwind_orc.c b/arch/x86/kernel/unwind_orc.c
> index 7f969b2d240f..d7396431261a 100644
> --- a/arch/x86/kernel/unwind_orc.c
> +++ b/arch/x86/kernel/unwind_orc.c
> @@ -540,7 +540,7 @@ bool unwind_next_frame(struct unwind_state *state)
>          state->sp = sp;
>          state->regs = NULL;
>          state->prev_regs = NULL;
> -        state->signal = ((void *)state->ip == ret_from_fork);
> +        state->signal = false;
>          break;

Yes that's correct.

-- 
Josh

