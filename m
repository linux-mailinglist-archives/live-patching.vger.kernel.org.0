Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB91F3732F3
	for <lists+live-patching@lfdr.de>; Wed,  5 May 2021 02:07:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231204AbhEEAIf (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 4 May 2021 20:08:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:32773 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231189AbhEEAIe (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 4 May 2021 20:08:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620173258;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WLuhQI1mHvbvNctH59ASrVI5S/Q5ccQ6XIJwhLh2EGQ=;
        b=VH7E7LAx/RQq1j2bLsaC38QEY0H2k26mstVGPVlZQRfCtB7iFgtyFcMhU86r0SizQP3opo
        lIwfBkNGmDaelFBAy0a6IYW8NohbzwR39wSicvUDcHpzuKPAEUWI9j8VgO9wt3KueW1lfa
        JlbfDqzNwXhNj93VKVv399QMS+PWQ00=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-442-axtACvBCMI65Emy9o77H0g-1; Tue, 04 May 2021 20:07:35 -0400
X-MC-Unique: axtACvBCMI65Emy9o77H0g-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EF2E5801817;
        Wed,  5 May 2021 00:07:33 +0000 (UTC)
Received: from treble (ovpn-115-93.rdu2.redhat.com [10.10.115.93])
        by smtp.corp.redhat.com (Postfix) with SMTP id DF02560C4A;
        Wed,  5 May 2021 00:07:28 +0000 (UTC)
Date:   Tue, 4 May 2021 19:07:28 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Cc:     broonie@kernel.org, mark.rutland@arm.com, jthierry@redhat.com,
        catalin.marinas@arm.com, will@kernel.org, jmorris@namei.org,
        pasha.tatashin@soleen.com, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v3 1/4] arm64: Introduce stack trace reliability
 checks in the unwinder
Message-ID: <20210505000728.yxg3xbwa3emcu2wi@treble>
References: <65cf4dfbc439b010b50a0c46ec500432acde86d6>
 <20210503173615.21576-1-madvenka@linux.microsoft.com>
 <20210503173615.21576-2-madvenka@linux.microsoft.com>
 <20210504215248.oi3zay3memgqri33@treble>
 <b000767b-26ca-01a9-a109-c9fc3357f832@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <b000767b-26ca-01a9-a109-c9fc3357f832@linux.microsoft.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, May 04, 2021 at 06:13:39PM -0500, Madhavan T. Venkataraman wrote:
> 
> 
> On 5/4/21 4:52 PM, Josh Poimboeuf wrote:
> > On Mon, May 03, 2021 at 12:36:12PM -0500, madvenka@linux.microsoft.com wrote:
> >> @@ -44,6 +44,8 @@ int notrace unwind_frame(struct task_struct *tsk, struct stackframe *frame)
> >>  	unsigned long fp = frame->fp;
> >>  	struct stack_info info;
> >>  
> >> +	frame->reliable = true;
> >> +
> > 
> > Why set 'reliable' to true on every invocation of unwind_frame()?
> > Shouldn't it be remembered across frames?
> > 
> 
> This is mainly for debug purposes in case a caller wants to print the whole stack and also
> print which functions are unreliable. For livepatch, it does not make any difference. It will
> quit as soon as it encounters an unreliable frame.

Hm, ok.  So 'frame->reliable' refers to the current frame, not the
entire stack.

> > Also, it looks like there are several error scenarios where it returns
> > -EINVAL but doesn't set 'reliable' to false.
> > 
> 
> I wanted to make a distinction between an error situation (like stack corruption where unwinding
> has to stop) and an unreliable situation (where unwinding can still proceed). E.g., when a
> stack trace is taken for informational purposes or debug purposes, the unwinding will try to
> proceed until either the stack trace ends or an error happens.

Ok, but I don't understand how that relates to my comment.

Why wouldn't a stack corruption like !on_accessible_stack() set
'frame->reliable' to false?

In other words: for livepatch purposes, how does the caller tell the
difference between hitting the final stack record -- which returns an
error with reliable 'true' -- and a stack corruption like
!on_accessible_stack(), which also returns an error with reliable
'true'?  Surely the latter should be considered unreliable?

-- 
Josh

