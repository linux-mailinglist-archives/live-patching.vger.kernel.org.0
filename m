Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4062A145E3A
	for <lists+live-patching@lfdr.de>; Wed, 22 Jan 2020 22:43:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726103AbgAVVm6 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 22 Jan 2020 16:42:58 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:59135 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725943AbgAVVm5 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 22 Jan 2020 16:42:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579729376;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1gFcEZJIvMTM55lub5PAcGjASB5nWcvJKHPzUNKZDoA=;
        b=Gtm4ADD7TcgCJPtzido722+WuA0NUdAPAV8Cc1WriXQuxN+nUWgP6woHBwe5wOuAPrVjEJ
        WSql1WLxvMQh9etbGMW5FxdV2ADRBJ+evK4rIoBmzaX77/9/xVkuMi3HoK8itkHz89+7Qd
        nGvJyRXf3Kce9irGCozhKf34FvSEAVA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-46-vfrKVyS_PUyEIk0FIgm2lg-1; Wed, 22 Jan 2020 16:42:51 -0500
X-MC-Unique: vfrKVyS_PUyEIk0FIgm2lg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C11F9107ACC4;
        Wed, 22 Jan 2020 21:42:48 +0000 (UTC)
Received: from treble (ovpn-122-154.rdu2.redhat.com [10.10.122.154])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6DE9A88893;
        Wed, 22 Jan 2020 21:42:41 +0000 (UTC)
Date:   Wed, 22 Jan 2020 15:42:39 -0600
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
Message-ID: <20200122214239.ivnebi7hiabi5tbs@treble>
References: <88bab814-ea24-ece9-2bc0-7a1e10a62f12@redhat.com>
 <20191015153120.GA21580@linux-8ccs>
 <7e9c7dd1-809e-f130-26a3-3d3328477437@redhat.com>
 <20191015182705.1aeec284@gandalf.local.home>
 <20191016074217.GL2328@hirez.programming.kicks-ass.net>
 <20191021150549.bitgqifqk2tbd3aj@treble>
 <20200120165039.6hohicj5o52gdghu@treble>
 <alpine.LSU.2.21.2001210922060.6036@pobox.suse.cz>
 <20200121161045.dhihqibnpyrk2lsu@treble>
 <alpine.LSU.2.21.2001221052331.15957@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.21.2001221052331.15957@pobox.suse.cz>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, Jan 22, 2020 at 11:09:56AM +0100, Miroslav Benes wrote:
> 
> > > > At this point, I only see downsides of -flive-patching, at least until
> > > > we actually have real upstream code which needs it.
> > > 
> > > Can you explain this? The option makes GCC to avoid optimizations which 
> > > are difficult to detect and would make live patching unsafe. I consider it 
> > > useful as it is, so if you shared the other downsides and what you meant 
> > > by real upstream code, we could discuss it.
> > 
> > Only SLES needs it right?  Why inflict it on other livepatch users?  By
> > "real upstream code" I mean there's no (documented) way to create live
> > patches using the method which relies on this flag.  So I don't see any
> > upstream benefits for having it enabled.
> 
> I'd put it differently. SLES and upstream need it, RHEL does not need it. 
> Or anyone using kpatch-build.

I'm confused about why you think upstream needs it.

Is all the tooling available somewhere?  Is there documentation
available which describes how to build patches using that method from
start to finish?  Are there actual users other than SUSE?

BTW, kpatch-build has a *lot* of users other than RHEL.  All its tooling
and documentation are available on Github.

> It is perfectly fine to prepare live patches just from the source code
> using upstream live patching infrastructure. 

Do you mean the dangerous method used by the livepatch sample code which
completely ignores interprocedural optimizations?  I wouldn't call that
perfectly fine.

> After all, SLES is nothing else than upstream here. We were creating live 
> patches manually for quite a long time and only recently we have been 
> using Nicolai's klp-ccp automation (https://github.com/SUSE/klp-ccp).
> 
> So, everyone using upstream directly relies on the flag, which seems to be 
> a clear benefit to me. Reverting the patch would be a step back.

Who exactly is "everyone using upstream"?

From what I can tell, kpatch-build is the only known way (to those
outside of SUSE) to make safe patches for an upstream kernel.  And it
doesn't need this flag and the problems associated with it: performance,
LTO incompatibility, clang incompatibility (I think?), the GCC dead code
issue.

-- 
Josh

