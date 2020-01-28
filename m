Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 028E614BE3F
	for <lists+live-patching@lfdr.de>; Tue, 28 Jan 2020 18:03:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726671AbgA1RDN (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 28 Jan 2020 12:03:13 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:21758 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725881AbgA1RDN (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 28 Jan 2020 12:03:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580230992;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UEzamJ8ELA4VGrlkVRtVzx3OFq6AUZqHXicgISU+c/U=;
        b=FeMKUDyAjNlyzYZ9U3+ifjZtaVw86icT0G81W6RWIs6Yfrpa624MyZZI0lM240upKbHZQk
        V9nt8pefZhlNInn86O6r5YV2n2tJEwN+wcfWsp0JsG5rsbVarDejN+0tl9if1KIjyadxs/
        MC/9oNo+TpBN/1stG0v67L/ZuMgYAmE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-281-q9mkc36-PouBlOJvpY7NaQ-1; Tue, 28 Jan 2020 12:03:09 -0500
X-MC-Unique: q9mkc36-PouBlOJvpY7NaQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AF580100550E;
        Tue, 28 Jan 2020 17:03:04 +0000 (UTC)
Received: from treble (ovpn-124-151.rdu2.redhat.com [10.10.124.151])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 199CC84BC5;
        Tue, 28 Jan 2020 17:02:56 +0000 (UTC)
Date:   Tue, 28 Jan 2020 11:02:54 -0600
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
        Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH v3 5/6] x86/ftrace: Use text_poke()
Message-ID: <20200128170254.igb72ib5n7lvn3ds@treble>
References: <20191016074217.GL2328@hirez.programming.kicks-ass.net>
 <20191021150549.bitgqifqk2tbd3aj@treble>
 <20200120165039.6hohicj5o52gdghu@treble>
 <alpine.LSU.2.21.2001210922060.6036@pobox.suse.cz>
 <20200121161045.dhihqibnpyrk2lsu@treble>
 <alpine.LSU.2.21.2001221052331.15957@pobox.suse.cz>
 <20200122214239.ivnebi7hiabi5tbs@treble>
 <alpine.LSU.2.21.2001281014280.14030@pobox.suse.cz>
 <20200128150014.juaxfgivneiv6lje@treble>
 <20200128154046.trkpkdaz7qeovhii@pathway.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200128154046.trkpkdaz7qeovhii@pathway.suse.cz>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, Jan 28, 2020 at 04:40:46PM +0100, Petr Mladek wrote:
> On Tue 2020-01-28 09:00:14, Josh Poimboeuf wrote:
> > On Tue, Jan 28, 2020 at 10:28:07AM +0100, Miroslav Benes wrote:
> > > I don't think we have something special at SUSE not generally available...
> > > 
> > > ...and I don't think it is really important to discuss that and replying 
> > > to the above, because there is a legitimate use case which relies on the 
> > > flag. We decided to support different use cases right at the beginning.
> > > 
> > > I understand it currently complicates things for objtool, but objtool is 
> > > sensitive to GCC code generation by definition. "Issues" appear with every 
> > > new GCC version. I see no difference here and luckily it is not so 
> > > difficult to fix it.
> > > 
> > > I am happy to help with acting on those objtool warning reports you 
> > > mentioned in the other email. Just Cc me where appropriate. We will take a 
> > > look.
> > 
> > As I said, the objtool warnings aren't even the main issue.
> 
> Great.
> 
> Anyway, I think that we might make your life easier with using
> the proposed -Wsuggest-attribute=noreturn.

Maybe.  Though if I understand correctly, this doesn't help for any of
the new warnings because they're for static functions, and this only
warns about global functions.

> Also it might be possible to create the list of global
> noreturn functions using some gcc tool. Similar way that we get
> the list of functions that need to be livepatched explicitly
> because of the problematic optimizations.
> 
> It sounds like a win-win approach.

I don't quite get how that could be done in an automated way, but ideas
about how to implement it would certainly be welcome.

> > There are N users[*] of CONFIG_LIVEPATCH, where N is perhaps dozens.
> > For N-1 users, they have to suffer ALL the drawbacks, with NONE of the
> > benefits.
> 
> You wrote in the other mail:
> 
>   > The problems associated with it: performance, LTO incompatibility,
>   > clang incompatibility (I think?), the GCC dead code issue.
> 
> SUSE performance team did extensive testing and did not found
> any real performance issues. It was discussed when the option
> was enabled upstream.
> 
> Are the other problems affecting real life usage, please?
> Could you be more specific about them, please?

The original commit mentioned 1-3% scheduler degradation.  And I'd
expect things to worsen over time as interprocedural optimizations
improve.

Also, LTO is coming whether we like it or not.  As is Clang.  Those are
real-world things which will need to work with livepatching sooner or
later.

> > And, even if they wanted those benefits, they have no idea how to get
> > them because the patch creation process isn't documented.
> 
> I do not understand this. All the sample modules and selftests are
> using source based livepatches.

We're talking in circles.  Have you read the thread?

The samples are a (dangerous) joke.  With or without -flive-patching.

> It is actually the only somehow documented way. Sure, the
> documentation might get improved.  Patches are welcome.

Are you suggesting for *me* to send documentation for how *you* build
patches?

> The option is not currently needed by the selftests only because there
> is no selftest for this type of problems. But the problems are real.
> They would actually deserve selftests. Again, patches are welcome.
> 
> My understanding is that the source based livepatches is the future.

I think that still remains to be seen.

> N-1 users are just waiting until the 1 user develops more helper tools
> for this.

No.  N-1 users have no idea how to make (safe) source-based patches in
the first place.  And if *you* don't need the tools, why would anyone
else?  Why not document the process and encourage the existence of other
users so they can get involved and help with the tooling?

> I would really like to hear about some serious problems
> before we do this step back in upstream.

Sometimes you need to take 1 step back before you can take 2 steps
forward.  I regret ACKing the original patch.  It was too early.

-- 
Josh

