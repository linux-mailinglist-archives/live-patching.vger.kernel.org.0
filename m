Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82F901441C1
	for <lists+live-patching@lfdr.de>; Tue, 21 Jan 2020 17:11:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729275AbgAUQLK (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 21 Jan 2020 11:11:10 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:23923 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729256AbgAUQLJ (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 21 Jan 2020 11:11:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579623069;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=heVKG+KSMzawq2hC2KgTNTV1AZM6QZ5629QiClM/r1A=;
        b=DvWqyFeXCIVWIQfTa6O7EDCPLTdyr2SpUsYk90z6zYMD8GekQWRK7ypH10El6l+/4Z0A7+
        F2G+klwk1qN3woOZ5U6X5sAm1eDB/G+ONAjg7w2RR+gnjOVpOP6zhJqgmOQc9jkmshQUdS
        fQ/DH7wgt+zRO1gaKVtntuZo9Mr3aiQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-298-2Vtp-qc_OfeKGDhAjMVAfQ-1; Tue, 21 Jan 2020 11:11:02 -0500
X-MC-Unique: 2Vtp-qc_OfeKGDhAjMVAfQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5A4B4113784C;
        Tue, 21 Jan 2020 16:11:00 +0000 (UTC)
Received: from treble (ovpn-122-154.rdu2.redhat.com [10.10.122.154])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9C81E2898C;
        Tue, 21 Jan 2020 16:10:47 +0000 (UTC)
Date:   Tue, 21 Jan 2020 10:10:45 -0600
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Miroslav Benes <mbenes@suse.cz>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Jessica Yu <jeyu@kernel.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, mhiramat@kernel.org,
        bristot@redhat.com, jbaron@akamai.com,
        torvalds@linux-foundation.org, tglx@linutronix.de,
        mingo@kernel.org, namit@vmware.com, hpa@zytor.com, luto@kernel.org,
        ard.biesheuvel@linaro.org, live-patching@vger.kernel.org,
        Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH v3 5/6] x86/ftrace: Use text_poke()
Message-ID: <20200121161045.dhihqibnpyrk2lsu@treble>
References: <20191015135634.GK2328@hirez.programming.kicks-ass.net>
 <alpine.LSU.2.21.1910151611000.13169@pobox.suse.cz>
 <88bab814-ea24-ece9-2bc0-7a1e10a62f12@redhat.com>
 <20191015153120.GA21580@linux-8ccs>
 <7e9c7dd1-809e-f130-26a3-3d3328477437@redhat.com>
 <20191015182705.1aeec284@gandalf.local.home>
 <20191016074217.GL2328@hirez.programming.kicks-ass.net>
 <20191021150549.bitgqifqk2tbd3aj@treble>
 <20200120165039.6hohicj5o52gdghu@treble>
 <alpine.LSU.2.21.2001210922060.6036@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.21.2001210922060.6036@pobox.suse.cz>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, Jan 21, 2020 at 09:35:28AM +0100, Miroslav Benes wrote:
> On Mon, 20 Jan 2020, Josh Poimboeuf wrote:
> 
> > On Mon, Oct 21, 2019 at 10:05:49AM -0500, Josh Poimboeuf wrote:
> > > On Wed, Oct 16, 2019 at 09:42:17AM +0200, Peter Zijlstra wrote:
> > > > > which are not compatible with livepatching. GCC upstream now has
> > > > > -flive-patching option, which disables all those interfering optimizations.
> > > > 
> > > > Which, IIRC, has a significant performance impact and should thus really
> > > > not be used...
> > > > 
> > > > If distros ship that crap, I'm going to laugh at them the next time they
> > > > want a single digit performance improvement because *important*.
> > > 
> > > I have a crazy plan to try to use objtool to detect function changes at
> > > a binary level, which would hopefully allow us to drop this flag.
> > > 
> > > But regardless, I wonder if we enabled this flag prematurely.  We still
> > > don't have a reasonable way to use it for creating source-based live
> > > patches upstream, and it should really be optional for CONFIG_LIVEPATCH,
> > > since kpatch-build doesn't need it.
> > 
> > I also just discovered that -flive-patching is responsible for all those
> > "unreachable instruction" objtool warnings which Randy has been
> > dutifully bugging me about over the last several months.  For some
> > reason it subtly breaks GCC implicit noreturn detection for local
> > functions.
> 
> Ugh, that is unfortunate. Have you reported it?

Not yet (but I plan to).

> > At this point, I only see downsides of -flive-patching, at least until
> > we actually have real upstream code which needs it.
> 
> Can you explain this? The option makes GCC to avoid optimizations which 
> are difficult to detect and would make live patching unsafe. I consider it 
> useful as it is, so if you shared the other downsides and what you meant 
> by real upstream code, we could discuss it.

Only SLES needs it right?  Why inflict it on other livepatch users?  By
"real upstream code" I mean there's no (documented) way to create live
patches using the method which relies on this flag.  So I don't see any
upstream benefits for having it enabled.

-- 
Josh

