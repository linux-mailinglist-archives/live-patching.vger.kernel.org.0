Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B8BD14C491
	for <lists+live-patching@lfdr.de>; Wed, 29 Jan 2020 03:17:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726401AbgA2CR0 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 28 Jan 2020 21:17:26 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:50682 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726402AbgA2CRZ (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 28 Jan 2020 21:17:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580264244;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=m+nJONZZoTQaSQ5XpfMtUdufvZ+z5SCiJsRhF9C0wds=;
        b=Vx5C78b7ZlJ0TXS3cP0gOp0dkTGqPwXGsFOR+GeUA4+vD/v3FEMAFV4dIqd8Glp3/yNoN9
        KYnemaMWPgptzG5adTxe4Ep6tb41gY0F/r2mzlpl++5raKpWRZ3EpO/I3WiWFLT3rDFCs5
        ygHEzL+Q//4o7ZeT6PJ3YELhm57wG6I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-282-SUZ9hjDgOgiZxJRTzgB8tg-1; Tue, 28 Jan 2020 21:17:20 -0500
X-MC-Unique: SUZ9hjDgOgiZxJRTzgB8tg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9C3A610054E3;
        Wed, 29 Jan 2020 02:17:17 +0000 (UTC)
Received: from treble (ovpn-120-83.rdu2.redhat.com [10.10.120.83])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id BEC5984BB8;
        Wed, 29 Jan 2020 02:17:08 +0000 (UTC)
Date:   Tue, 28 Jan 2020 20:17:06 -0600
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Jiri Kosina <jikos@kernel.org>
Cc:     Petr Mladek <pmladek@suse.com>, Miroslav Benes <mbenes@suse.cz>,
        Peter Zijlstra <peterz@infradead.org>,
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
Message-ID: <20200129021619.cvbsvmag2v4tyjek@treble>
References: <20200120165039.6hohicj5o52gdghu@treble>
 <alpine.LSU.2.21.2001210922060.6036@pobox.suse.cz>
 <20200121161045.dhihqibnpyrk2lsu@treble>
 <alpine.LSU.2.21.2001221052331.15957@pobox.suse.cz>
 <20200122214239.ivnebi7hiabi5tbs@treble>
 <alpine.LSU.2.21.2001281014280.14030@pobox.suse.cz>
 <20200128150014.juaxfgivneiv6lje@treble>
 <20200128154046.trkpkdaz7qeovhii@pathway.suse.cz>
 <20200128170254.igb72ib5n7lvn3ds@treble>
 <nycvar.YFH.7.76.2001290141140.31058@cbobk.fhfr.pm>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <nycvar.YFH.7.76.2001290141140.31058@cbobk.fhfr.pm>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, Jan 29, 2020 at 01:46:55AM +0100, Jiri Kosina wrote:
> On Tue, 28 Jan 2020, Josh Poimboeuf wrote:
> 
> > > Anyway, I think that we might make your life easier with using the 
> > > proposed -Wsuggest-attribute=noreturn.
> > 
> > Maybe.  Though if I understand correctly, this doesn't help for any of 
> > the new warnings because they're for static functions, and this only 
> > warns about global functions.
> 
> Could you please provide a pointer where those have been 
> reported/analyzed?
> 
> For the cases I've seen so far, it has always been gcc deciding under 
> certain circumstances not to propagate __attribute__((__noreturn__)) from 
> callee to caller even in the cases when caller unconditionally called 
> callee.
> 
> AFAIU, the behavior is (and always will) be dependent on the state of gcc 
> optimizations, and therefore I don't see any other way than adding 
> __noreturn anotation transitively everywhere in order to silence objtool.
> 
> So those cases have to be fixed anyway.
> 
> What are the other cases please? Either I have completely missed those, or 
> they haven't been mentioned in this thread.

For example, see:

  https://git.kernel.org/pub/scm/linux/kernel/git/jpoimboe/linux.git/commit/?h=objtool-fixes&id=6265238af90b395a1e5e5032a41f012a552d8a9e

Many of those callees are static noreturns, for which we've *never*
needed annotations.  Disabling -fipa-pure-const has apparently changed
that.

-Wsuggest-attribute=noreturn doesn't seem to suggest annotations for
static functions, probably because most reasonable setups use -O2 which
allows GCC to detect them.

-- 
Josh

