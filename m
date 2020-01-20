Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BB6A143041
	for <lists+live-patching@lfdr.de>; Mon, 20 Jan 2020 17:50:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728842AbgATQuu (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 20 Jan 2020 11:50:50 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:31385 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726642AbgATQuu (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 20 Jan 2020 11:50:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579539049;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jLPz2Zth+2ZStIwZ+5ljQmnZerYZCaQViHX5ArD0Uso=;
        b=EwcOXp5jNtAhkQiwO94Hap0MS44E4hDFiLOfzuTu3qMkTY/F3B6QOFJe6j7KOz4yTRc53K
        VDrbNwAluxmjXzXAQmz2gsjWF5D8fFFuoQEbQgvRhR5OD/oDSr5LEj8QeZO59QB3LyYqgN
        Q2eEYeh4peo37ALkrrbBse0TkMkCLsA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-423-jvNGqmbPODqUa4-fwhBrLA-1; Mon, 20 Jan 2020 11:50:47 -0500
X-MC-Unique: jvNGqmbPODqUa4-fwhBrLA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7A15D8018CC;
        Mon, 20 Jan 2020 16:50:44 +0000 (UTC)
Received: from treble (ovpn-125-19.rdu2.redhat.com [10.10.125.19])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C9F308643A;
        Mon, 20 Jan 2020 16:50:41 +0000 (UTC)
Date:   Mon, 20 Jan 2020 10:50:39 -0600
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Jessica Yu <jeyu@kernel.org>, Miroslav Benes <mbenes@suse.cz>,
        x86@kernel.org, linux-kernel@vger.kernel.org, mhiramat@kernel.org,
        bristot@redhat.com, jbaron@akamai.com,
        torvalds@linux-foundation.org, tglx@linutronix.de,
        mingo@kernel.org, namit@vmware.com, hpa@zytor.com, luto@kernel.org,
        ard.biesheuvel@linaro.org, live-patching@vger.kernel.org,
        Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH v3 5/6] x86/ftrace: Use text_poke()
Message-ID: <20200120165039.6hohicj5o52gdghu@treble>
References: <20191011125903.GN2359@hirez.programming.kicks-ass.net>
 <20191015130739.GA23565@linux-8ccs>
 <20191015135634.GK2328@hirez.programming.kicks-ass.net>
 <alpine.LSU.2.21.1910151611000.13169@pobox.suse.cz>
 <88bab814-ea24-ece9-2bc0-7a1e10a62f12@redhat.com>
 <20191015153120.GA21580@linux-8ccs>
 <7e9c7dd1-809e-f130-26a3-3d3328477437@redhat.com>
 <20191015182705.1aeec284@gandalf.local.home>
 <20191016074217.GL2328@hirez.programming.kicks-ass.net>
 <20191021150549.bitgqifqk2tbd3aj@treble>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20191021150549.bitgqifqk2tbd3aj@treble>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Mon, Oct 21, 2019 at 10:05:49AM -0500, Josh Poimboeuf wrote:
> On Wed, Oct 16, 2019 at 09:42:17AM +0200, Peter Zijlstra wrote:
> > > which are not compatible with livepatching. GCC upstream now has
> > > -flive-patching option, which disables all those interfering optimizations.
> > 
> > Which, IIRC, has a significant performance impact and should thus really
> > not be used...
> > 
> > If distros ship that crap, I'm going to laugh at them the next time they
> > want a single digit performance improvement because *important*.
> 
> I have a crazy plan to try to use objtool to detect function changes at
> a binary level, which would hopefully allow us to drop this flag.
> 
> But regardless, I wonder if we enabled this flag prematurely.  We still
> don't have a reasonable way to use it for creating source-based live
> patches upstream, and it should really be optional for CONFIG_LIVEPATCH,
> since kpatch-build doesn't need it.

I also just discovered that -flive-patching is responsible for all those
"unreachable instruction" objtool warnings which Randy has been
dutifully bugging me about over the last several months.  For some
reason it subtly breaks GCC implicit noreturn detection for local
functions.

At this point, I only see downsides of -flive-patching, at least until
we actually have real upstream code which needs it.

If there aren't any objections I'll be posting a patch soon to revert.

-- 
Josh

