Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBB3035A8BA
	for <lists+live-patching@lfdr.de>; Sat, 10 Apr 2021 00:34:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235069AbhDIWcz (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 9 Apr 2021 18:32:55 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:53990 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235067AbhDIWcy (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 9 Apr 2021 18:32:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618007560;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yyr/6Ag1Vbeg1psngxfhYGjr6J2CEL/d4aEho0RnXho=;
        b=iY+X7/kmeEfNcuDuMLn7VsH2hGplppTe6eacnc4kt7tlBdjaCZkVviIt5WpurDVMtnOtCe
        mFdIZJL2FKQA0kjfhSLRgKdk1Vaywc08760Em+byxvcTYD3besSdctl8kMlGbd4HDuFz7I
        DYw/Lx4AZe2Ao9iFjfEFy/QTSWw8X9A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-241-0AUWjXB6OJWe5318dHN-_w-1; Fri, 09 Apr 2021 18:32:36 -0400
X-MC-Unique: 0AUWjXB6OJWe5318dHN-_w-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E0F5F10053E7;
        Fri,  9 Apr 2021 22:32:34 +0000 (UTC)
Received: from treble (ovpn-112-2.rdu2.redhat.com [10.10.112.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A29605C1D5;
        Fri,  9 Apr 2021 22:32:29 +0000 (UTC)
Date:   Fri, 9 Apr 2021 17:32:27 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Cc:     Mark Rutland <mark.rutland@arm.com>, broonie@kernel.org,
        jthierry@redhat.com, catalin.marinas@arm.com, will@kernel.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC PATCH v2 0/4] arm64: Implement stack trace reliability
 checks
Message-ID: <20210409223227.rvf6tfhvgnpzmabn@treble>
References: <705993ccb34a611c75cdae0a8cb1b40f9b218ebd>
 <20210405204313.21346-1-madvenka@linux.microsoft.com>
 <20210409120859.GA51636@C02TD0UTHF1T.local>
 <20210409213741.kqmwyajoppuqrkge@treble>
 <8c30ec5f-b51e-494f-5f6c-d2f012135f69@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <8c30ec5f-b51e-494f-5f6c-d2f012135f69@linux.microsoft.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri, Apr 09, 2021 at 05:05:58PM -0500, Madhavan T. Venkataraman wrote:
> > FWIW, over the years we've had zero issues with encoding the frame
> > pointer on x86.  After you save pt_regs, you encode the frame pointer to
> > point to it.  Ideally in the same macro so it's hard to overlook.
> > 
> 
> I had the same opinion. In fact, in my encoding scheme, I have additional
> checks to make absolutely sure that it is a true encoding and not stack
> corruption. The chances of all of those values accidentally matching are,
> well, null.

Right, stack corruption -- which is already exceedingly rare -- would
have to be combined with a miracle or two in order to come out of the
whole thing marked as 'reliable' :-)

And really, we already take a similar risk today by "trusting" the frame
pointer value on the stack to a certain extent.

> >> I think there's a lot more code that we cannot unwind, e.g. KVM
> >> exception code, or almost anything marked with SYM_CODE_END().
> > 
> > Just a reminder that livepatch only unwinds blocked tasks (plus the
> > 'current' task which calls into livepatch).  So practically speaking, it
> > doesn't matter whether the 'unreliable' detection has full coverage.
> > The only exceptions which really matter are those which end up calling
> > schedule(), e.g. preemption or page faults.
> > 
> > Being able to consistently detect *all* possible unreliable paths would
> > be nice in theory, but it's unnecessary and may not be worth the extra
> > complexity.
> > 
> 
> You do have a point. I tried to think of arch_stack_walk_reliable() as
> something that should be implemented independent of livepatching. But
> I could not really come up with a single example of where else it would
> really be useful.
> 
> So, if we assume that the reliable stack trace is solely for the purpose
> of livepatching, I agree with your earlier comments as well.

One thought: if folks really view this as a problem, it might help to
just rename things to reduce confusion.

For example, instead of calling it 'reliable', we could call it
something more precise, like 'klp_reliable', to indicate that its
reliable enough for live patching.

Then have a comment above 'klp_reliable' and/or
stack_trace_save_tsk_klp_reliable() which describes what that means.

Hm, for that matter, even without renaming things, a comment above
stack_trace_save_tsk_reliable() describing the meaning of "reliable"
would be a good idea.

-- 
Josh

