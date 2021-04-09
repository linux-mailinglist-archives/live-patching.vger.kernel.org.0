Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A439035A867
	for <lists+live-patching@lfdr.de>; Fri,  9 Apr 2021 23:37:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234701AbhDIViH (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 9 Apr 2021 17:38:07 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:35413 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234513AbhDIViG (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 9 Apr 2021 17:38:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618004272;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZBMZnRMpIOd6IP+V5RmmTzdsPpj63VPABE8k3ixq6qQ=;
        b=JV5tDwqliRHYEFNEIbhJUiI33dtn1pK6FUkGTfGZGYCJyuzW/iqacGV5YIv8IakBUK5hRv
        jv6EtGvofY1N/lQdMYZf1e3VFAPdsYkDQntNhcBBNIXuBtiCVVbDxrwOA7aoEhh7QeBjrc
        2i5vNzIX5r1mgPwFHmpm7MBoOh5ZR1U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-425-IUn5evBIM5aXOyaLMGNl2w-1; Fri, 09 Apr 2021 17:37:49 -0400
X-MC-Unique: IUn5evBIM5aXOyaLMGNl2w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5DED06D4F3;
        Fri,  9 Apr 2021 21:37:47 +0000 (UTC)
Received: from treble (ovpn-112-2.rdu2.redhat.com [10.10.112.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 39AFB18A50;
        Fri,  9 Apr 2021 21:37:43 +0000 (UTC)
Date:   Fri, 9 Apr 2021 16:37:41 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Mark Rutland <mark.rutland@arm.com>
Cc:     madvenka@linux.microsoft.com, broonie@kernel.org,
        jthierry@redhat.com, catalin.marinas@arm.com, will@kernel.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC PATCH v2 0/4] arm64: Implement stack trace reliability
 checks
Message-ID: <20210409213741.kqmwyajoppuqrkge@treble>
References: <705993ccb34a611c75cdae0a8cb1b40f9b218ebd>
 <20210405204313.21346-1-madvenka@linux.microsoft.com>
 <20210409120859.GA51636@C02TD0UTHF1T.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210409120859.GA51636@C02TD0UTHF1T.local>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri, Apr 09, 2021 at 01:09:09PM +0100, Mark Rutland wrote:
> On Mon, Apr 05, 2021 at 03:43:09PM -0500, madvenka@linux.microsoft.com wrote:
> > From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
> > 
> > There are a number of places in kernel code where the stack trace is not
> > reliable. Enhance the unwinder to check for those cases and mark the
> > stack trace as unreliable. Once all of the checks are in place, the unwinder
> > can provide a reliable stack trace. But before this can be used for livepatch,
> > some other entity needs to guarantee that the frame pointers are all set up
> > correctly in kernel functions. objtool is currently being worked on to
> > fill that gap.
> > 
> > Except for the return address check, all the other checks involve checking
> > the return PC of every frame against certain kernel functions. To do this,
> > implement some infrastructure code:
> > 
> > 	- Define a special_functions[] array and populate the array with
> > 	  the special functions
> 
> I'm not too keen on having to manually collate this within the unwinder,
> as it's very painful from a maintenance perspective.

Agreed.

> I'd much rather we could associate this information with the
> implementations of these functions, so that they're more likely to
> stay in sync.
> 
> Further, I believe all the special cases are assembly functions, and
> most of those are already in special sections to begin with. I reckon
> it'd be simpler and more robust to reject unwinding based on the
> section. If we need to unwind across specific functions in those
> sections, we could opt-in with some metadata. So e.g. we could reject
> all functions in ".entry.text", special casing the EL0 entry functions
> if necessary.

Couldn't this also end up being somewhat fragile?  Saying "certain
sections are deemed unreliable" isn't necessarily obvious to somebody
who doesn't already know about it, and it could be overlooked or
forgotten over time.  And there's no way to enforce it stays that way.

FWIW, over the years we've had zero issues with encoding the frame
pointer on x86.  After you save pt_regs, you encode the frame pointer to
point to it.  Ideally in the same macro so it's hard to overlook.

If you're concerned about debuggers getting confused by the encoding -
which debuggers specifically?  In my experience, if vmlinux has
debuginfo, gdb and most other debuggers will use DWARF (which is already
broken in asm code) and completely ignore frame pointers.

> I think there's a lot more code that we cannot unwind, e.g. KVM
> exception code, or almost anything marked with SYM_CODE_END().

Just a reminder that livepatch only unwinds blocked tasks (plus the
'current' task which calls into livepatch).  So practically speaking, it
doesn't matter whether the 'unreliable' detection has full coverage.
The only exceptions which really matter are those which end up calling
schedule(), e.g. preemption or page faults.

Being able to consistently detect *all* possible unreliable paths would
be nice in theory, but it's unnecessary and may not be worth the extra
complexity.

-- 
Josh

