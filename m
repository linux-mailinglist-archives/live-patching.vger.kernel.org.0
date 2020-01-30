Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DD8814DCB1
	for <lists+live-patching@lfdr.de>; Thu, 30 Jan 2020 15:17:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727241AbgA3ORu (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 30 Jan 2020 09:17:50 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:50248 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727219AbgA3ORu (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 30 Jan 2020 09:17:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580393869;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SQLCEiwjxFUhrMsORDFo4u4SoI+4SqDuOptNlKVezG8=;
        b=D0pSnybUNZCn/Wdr7JZ4AO4Mh4h/4Ci7TNgbh/HvCsC0zShQw8Q/Q+NYbHl7ws8pz8pG/j
        L4UOXPpRbHeMFCUkqE6vm7Efoa4ZA04ZLS7PoZhr1KwaDa251dzWo+9ULzDNn5gN05Wsuh
        JGFYksLPCYMZYI5Y5fuY6DD2d3Lws7k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-170-MywjOwE5PnGrr_6RyZCF3Q-1; Thu, 30 Jan 2020 09:17:47 -0500
X-MC-Unique: MywjOwE5PnGrr_6RyZCF3Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 806A31005F73;
        Thu, 30 Jan 2020 14:17:44 +0000 (UTC)
Received: from treble (ovpn-120-83.rdu2.redhat.com [10.10.120.83])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 98BDD60BE1;
        Thu, 30 Jan 2020 14:17:36 +0000 (UTC)
Date:   Thu, 30 Jan 2020 08:17:33 -0600
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Petr Mladek <pmladek@suse.com>
Cc:     Miroslav Benes <mbenes@suse.cz>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Jessica Yu <jeyu@kernel.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, mhiramat@kernel.org,
        bristot@redhat.com, jbaron@akamai.com,
        torvalds@linux-foundation.org, tglx@linutronix.de,
        mingo@kernel.org, namit@vmware.com, hpa@zytor.com, luto@kernel.org,
        ard.biesheuvel@linaro.org, live-patching@vger.kernel.org,
        Randy Dunlap <rdunlap@infradead.org>, nstange@suse.de
Subject: Re: [PATCH v3 5/6] x86/ftrace: Use text_poke()
Message-ID: <20200130141733.krfdmirathscgkkp@treble>
References: <20200121161045.dhihqibnpyrk2lsu@treble>
 <alpine.LSU.2.21.2001221052331.15957@pobox.suse.cz>
 <20200122214239.ivnebi7hiabi5tbs@treble>
 <alpine.LSU.2.21.2001281014280.14030@pobox.suse.cz>
 <20200128150014.juaxfgivneiv6lje@treble>
 <20200128154046.trkpkdaz7qeovhii@pathway.suse.cz>
 <20200128170254.igb72ib5n7lvn3ds@treble>
 <alpine.LSU.2.21.2001291249430.28615@pobox.suse.cz>
 <20200129155951.qvf3tjsv2qvswciw@treble>
 <20200130095346.6buhb3reehijbamz@pathway.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200130095346.6buhb3reehijbamz@pathway.suse.cz>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu, Jan 30, 2020 at 10:53:46AM +0100, Petr Mladek wrote:
> On Wed 2020-01-29 09:59:51, Josh Poimboeuf wrote:
> > In retrospect, the prerequisites for merging it should have been:
> 
> OK, let me do one more move in this game.
> 
> 
> > 1) Document how source-based patches can be safely generated;
> 
> I agree that the information are really scattered over many files
> in Documentation/livepatch/.

Once again you're blithely ignoring my point and pretending I'm saying
something else.  And you did that again further down in the email, but
what's the point of arguing if you're not going to listen.

This has nothing to do with the organization of the existing
documentation.  When did I say that?

Adding the -flive-patching flag doesn't remove *all*
function-ABI-breaking optimizations.  It's only a partial solution.  The
rest of the solution involves tooling and processes which need to be
documented.  But you already know that.

If we weren't co-maintainers I would have reverted the patch days ago.
I've tried to give you all the benefit of the doubt.  But you seem to be
playing company politics.

I would ask that you please put on your upstream hats and stop playing
politics.  If the patch creation process is a secret, then by all means,
keep it secret.  But then keep your GCC flag to yourself.

-- 
Josh

