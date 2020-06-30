Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7ABF20FF53
	for <lists+live-patching@lfdr.de>; Tue, 30 Jun 2020 23:36:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727876AbgF3Vgy (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 30 Jun 2020 17:36:54 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:31276 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726117AbgF3Vgy (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 30 Jun 2020 17:36:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593553012;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=T8HFffOX994sg1wvTHx+e4a2JbF0zYztyobMfFyAbl0=;
        b=IzlEwTGo/rSmT6jmTbObC5ixJldR5AUBmwtSrXmuZP8PrONW4nvXE4BWKgwB+AVpkhF+VF
        5kOlCQwfZD6MiCEWtoiAdOp8JNXwkELYSdSQJR1CYOhOxmQ0M4vPSW4E2+KfdQXoNf1Szj
        47fGjeeQW/KZgmPLBwz7J6RmHW0gzHA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-501-PTqCLy6WNKOZnRq2wUANSQ-1; Tue, 30 Jun 2020 17:36:47 -0400
X-MC-Unique: PTqCLy6WNKOZnRq2wUANSQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 177E780183C;
        Tue, 30 Jun 2020 21:36:46 +0000 (UTC)
Received: from treble (ovpn-114-241.rdu2.redhat.com [10.10.114.241])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9653E78137;
        Tue, 30 Jun 2020 21:36:41 +0000 (UTC)
Date:   Tue, 30 Jun 2020 16:36:39 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     "Wangshaobo (bobo)" <bobo.shaobowang@huawei.com>
Cc:     huawei.libin@huawei.com, xiexiuqi@huawei.com,
        cj.chengjian@huawei.com, mingo@redhat.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        mbenes@suse.cz, devel@etsukata.com, viro@zeniv.linux.org.uk,
        esyr@redhat.com
Subject: Re: Question: livepatch failed for new fork() task stack unreliable
Message-ID: <20200630213639.kijctnz4y3zjbkhx@treble>
References: <20200601180538.o5agg5trbdssqken@treble>
 <a5e0f476-02b5-cc44-8d4e-d33ff2138143@huawei.com>
 <20200602131450.oydrydelpdaval4h@treble>
 <1353648b-f3f7-5b8d-f0bb-28bdb1a66f0f@huawei.com>
 <20200603153358.2ezz2pgxxxld7mj7@treble>
 <2225bc83-95f2-bf3d-7651-fdd10a3ddd00@huawei.com>
 <20200604024051.6ovbr6tbrowwg6jr@treble>
 <c3a81224-bea1-116b-7528-f03f90be5264@huawei.com>
 <20200605015142.w65uu5wxfmrun2ro@treble>
 <e914bcd6-009c-0a89-bc59-b9a87a9c552d@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e914bcd6-009c-0a89-bc59-b9a87a9c552d@huawei.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, Jun 30, 2020 at 09:04:12PM +0800, Wangshaobo (bobo) wrote:
> 
> 在 2020/6/5 9:51, Josh Poimboeuf 写道:
> > On Fri, Jun 05, 2020 at 09:26:42AM +0800, Wangshaobo (bobo) wrote:
> > > > > So, I want to ask is there any side effects if i modify like this ? this
> > > > > modification is based on
> > > > > 
> > > > > your fix. It looks like ok with proper test.
> > > > > 
> > > > > diff --git a/arch/x86/kernel/unwind_orc.c b/arch/x86/kernel/unwind_orc.c
> > > > > index e9cc182aa97e..ecce5051e8fd 100644
> > > > > --- a/arch/x86/kernel/unwind_orc.c
> > > > > +++ b/arch/x86/kernel/unwind_orc.c
> > > > > @@ -620,6 +620,7 @@ void __unwind_start(struct unwind_state *state, struct
> > > > > task_struct *task,
> > > > >                   state->sp = task->thread.sp;
> > > > >                   state->bp = READ_ONCE_NOCHECK(frame->bp);
> > > > >                   state->ip = READ_ONCE_NOCHECK(frame->ret_addr);
> > > > > +              state->signal = ((void *)state->ip == ret_from_fork);
> > > > >           }
> > > > > 
> > > > > diff --git a/arch/x86/kernel/unwind_orc.c b/arch/x86/kernel/unwind_orc.c
> > > > > index 7f969b2d240f..d7396431261a 100644
> > > > > --- a/arch/x86/kernel/unwind_orc.c
> > > > > +++ b/arch/x86/kernel/unwind_orc.c
> > > > > @@ -540,7 +540,7 @@ bool unwind_next_frame(struct unwind_state *state)
> > > > >            state->sp = sp;
> > > > >            state->regs = NULL;
> > > > >            state->prev_regs = NULL;
> > > > > -        state->signal = ((void *)state->ip == ret_from_fork);
> > > > > +        state->signal = false;
> > > > >            break;
> > > > Yes that's correct.
> > > Hi, josh
> > > 
> > > Could i ask when are you free to send the patch, all the tests are passed
> > > by.
> > I want to run some regression tests, so it will probably be next week.

Sorry, I was away for a bit and I didn't get a chance to send the patch.
I should hopefully have it ready soon.

-- 
Josh

