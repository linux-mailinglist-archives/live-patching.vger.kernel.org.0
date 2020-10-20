Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A082294012
	for <lists+live-patching@lfdr.de>; Tue, 20 Oct 2020 17:58:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437013AbgJTP6P (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 20 Oct 2020 11:58:15 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:55353 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2437011AbgJTP6P (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 20 Oct 2020 11:58:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603209493;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6rKJUp/hFuoSptP9CoWz5upgdM+KXQTN0SbAhamuu80=;
        b=Q4RW9u6B4R39gZMYKgHQZTbCdZbEC7q3J4oP8d1AWPRsHBcTLtnBIzNXVizFwkr5bkeWcf
        6p61bmS1/0PUiKqyiam8ku4FJsPHNBHs9oiwfkDdKz9NYmqUNLogWLXcnlTvlGM2QeWmg5
        d6IMMXTS9YR6iYNzjTuAbQOOkT/HmeE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-296-sCqQLHNnMSOZBz2EoKvXNg-1; Tue, 20 Oct 2020 11:58:09 -0400
X-MC-Unique: sCqQLHNnMSOZBz2EoKvXNg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 99B7E186842E;
        Tue, 20 Oct 2020 15:58:07 +0000 (UTC)
Received: from treble (ovpn-114-84.rdu2.redhat.com [10.10.114.84])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 59C4F60C0F;
        Tue, 20 Oct 2020 15:58:05 +0000 (UTC)
Date:   Tue, 20 Oct 2020 10:58:02 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Mark Rutland <mark.rutland@arm.com>
Cc:     Mark Brown <broonie@kernel.org>, Miroslav Benes <mbenes@suse.cz>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        live-patching@vger.kernel.org
Subject: Re: [RFC PATCH 0/3] arm64: Implement reliable stack trace
Message-ID: <20201020155802.da6ca652hramdlnb@treble>
References: <20201012172605.10715-1-broonie@kernel.org>
 <alpine.LSU.2.21.2010151533490.14094@pobox.suse.cz>
 <20201015141612.GC50416@C02TD0UTHF1T.local>
 <20201015154951.GD4390@sirena.org.uk>
 <20201015212931.mh4a5jt7pxqlzxsg@treble>
 <20201016111431.GB84361@C02TD0UTHF1T.local>
 <20201020100352.GA48360@C02TD0UTHF1T.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201020100352.GA48360@C02TD0UTHF1T.local>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, Oct 20, 2020 at 11:03:52AM +0100, Mark Rutland wrote:
> On Fri, Oct 16, 2020 at 12:14:31PM +0100, Mark Rutland wrote:
> > Mark B's reply dropped this, but the next paragraph covered that:
> > 
> > | I was planning to send a mail once I've finished writing a test, but
> > | IIUC there are some windows where ftrace/kretprobes
> > | detection/repainting may not work, e.g. if preempted after
> > | ftrace_return_to_handler() decrements curr_ret_stack, but before the
> > | arch trampoline asm restores the original return addr. So we might
> > | need something like an in_return_trampoline() to detect and report
> > | that reliably.
> > 
> > ... so e.g. for a callchain A->B->C, where C is instrumented there are
> > windows where B might be missing from the trace, but the trace is
> > reported as reliable.
> 
> I'd missed a couple of details, and I think I see how each existing
> architecture prevents this case now.
> 
> Josh, just to confirm the x86 case, am I right in thinking that the ORC
> unwinder will refuse to unwind from the return_to_handler and
> kretprobe_trampoline asm? IIRC objtool shouldn't build unwind info for
> those as return_to_handler is marked with SYM_CODE_{START,END}() and
> kretprobe_trampoline is marked with STACK_FRAME_NON_STANDARD().

Hm, return_to_handler() actually looks like a bug.  UNWIND_HINT_EMPTY
sets end=1, which causes the ORC unwinder to treat it like entry code
(end of the stack).  So while it does stop the unwind, it fails to
report an error.

This would be fixed by the idea I previously mentioned, changing
UNWIND_HINT_EMPTY -> UNWIND_HINT_UNDEFINED (end=0) for the non-entry
cases.  I'll need to work up some patches.

> Both powerpc and s390 refuse to reliably unwind through exceptions, so
> they can rely on function call boundaries to keep the callchain in a
> sane state.

Yes, and also true for x86 frame pointers.

-- 
Josh

