Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9AE214CDDD
	for <lists+live-patching@lfdr.de>; Wed, 29 Jan 2020 17:00:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726672AbgA2QAX (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 29 Jan 2020 11:00:23 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:57520 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726498AbgA2QAW (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 29 Jan 2020 11:00:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580313621;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JHdR/wydiMatasy7II8oolAvR27JhCac6KTR2yMwbvk=;
        b=E7Vq3wNxMw5PVSkX2TEmZqp/kidslfTxiJKkvn77YpcuANYf91iGWtmtyRV/sgkZn8Dqra
        mJtnnpyRtwX+WDBG/Gw5dYh0eSfl/Bgh9g9CEmNrTl9Yj1CkhObbrCPW1zTFZgub+NnW1g
        amBpjsBiKBxk//LRN1okw1c+g7Ly7Pk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-303-uh5QMEoqNxmrSpexFiUoNA-1; Wed, 29 Jan 2020 11:00:04 -0500
X-MC-Unique: uh5QMEoqNxmrSpexFiUoNA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 090B98017CC;
        Wed, 29 Jan 2020 16:00:01 +0000 (UTC)
Received: from treble (ovpn-120-83.rdu2.redhat.com [10.10.120.83])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6760660BF3;
        Wed, 29 Jan 2020 15:59:53 +0000 (UTC)
Date:   Wed, 29 Jan 2020 09:59:51 -0600
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Miroslav Benes <mbenes@suse.cz>
Cc:     Petr Mladek <pmladek@suse.com>,
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
Message-ID: <20200129155951.qvf3tjsv2qvswciw@treble>
References: <20200120165039.6hohicj5o52gdghu@treble>
 <alpine.LSU.2.21.2001210922060.6036@pobox.suse.cz>
 <20200121161045.dhihqibnpyrk2lsu@treble>
 <alpine.LSU.2.21.2001221052331.15957@pobox.suse.cz>
 <20200122214239.ivnebi7hiabi5tbs@treble>
 <alpine.LSU.2.21.2001281014280.14030@pobox.suse.cz>
 <20200128150014.juaxfgivneiv6lje@treble>
 <20200128154046.trkpkdaz7qeovhii@pathway.suse.cz>
 <20200128170254.igb72ib5n7lvn3ds@treble>
 <alpine.LSU.2.21.2001291249430.28615@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.21.2001291249430.28615@pobox.suse.cz>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, Jan 29, 2020 at 01:28:30PM +0100, Miroslav Benes wrote:
> The fact is that -fno-ipa-pure-const caused the objtool issue. One could 
> argue that it should be fixed anyway, because it relies on GCC internal 
> implementation which could easily change, and we luckily found it out 
> thanks to -flive-patching. But you pointed out that was not even the main 
> problem here, so I'd leave it for the separate subthread which Jiri 
> started. 

It's not an objtool "issue".  The warnings were correct.  And objtool
*has* to rely on GCC internals.

And why would this particular internal implementation ever change
(detecting static noreturns)?  I don't see why optimizing the call
interface to a pure/const static function would break GCC's implicit
noreturn detection anyway.  It smells like a GCC bug.

> Regarding the scheduler degradation. hackbench performance degradation to 
> make it clear. It might be interesting to find out what really changed 
> there. Which disabled optimization caused it and how. Maybe it could be 
> gained back if proven again (because it may have changed, right?).

Fixing the scheduler performance regression would be a good thing to
have done *before* merging the patch.

> It all sound artificial to me though. I am not saying the degradation is 
> not there, but many people also lived with frame pointers enabled for 
> quite a long time and no one seemed to be bothered. And that was even more 
> serious because the decline was bigger and it was measurable in many 
> workflows. Not just a schedule microbenchmark. That is why Petr asked 
> about real life reports, I guess.

Many people were happy to get rid of frame pointers.

> > The samples are a (dangerous) joke.  With or without -flive-patching.
> 
> How come?
> 
> In my opinion, the samples and selftests try to show the way to prepare a 
> (simple, yes) live patch. We try to ensure it always works (selftests 
> should).
> 
> After all, there is not much more we do at SUSE to prepare a live patch.
> 
> 1. take a patch and put all touched functions in a live patch
> 2. if the functions cannot be patched, patch their callers
> 3. do the function closure and/or add references (relocations or 
>    kallsyms trick) so it can all be compiled.
> 4. done
> 
> See? Samples and selftests are not different.

How much ABI optimization analysis was done before creating the samples?
(hint: none)

And how would somebody using the samples as a guide know to do all that?

> Do we lack the documentation of our approach? Definitely. We are moving to 
> klp-ccp automation now (https://github.com/SUSE/klp-ccp) and once done 
> completely, we will hopefully have some documention. CCing Nicolai if he 
> wants to add something.
> 
> Should it be upstream? I don't know. I don't think so. For the same reason 
> kpatch-build documentation is not upstream either. Use cases of the 
> infrastructure differ. Maybe there are users who use it in a completely 
> different way. I don't know. In fact, it does not matter to me. I think we 
> should support it all if they make sense.

Of course the documentation should be in-tree.  Otherwise the samples
are *very* misleading.

> And that is my message which (in my opinion) makes more sense. Definitely 
> more sense than your "kpatch-build is the only safe way to prepare a live 
> patch" mantra you are trying to sell here for whatever reason. I don't 
> agree with it.

Of course I didn't say that.

The only thing I'm trying to "sell" is that this flag has several
drawbacks and no benefits for the upstream community.  Why do you keep
dancing around that unavoidable fact?

> > > It is actually the only somehow documented way. Sure, the
> > > documentation might get improved.  Patches are welcome.
> > 
> > Are you suggesting for *me* to send documentation for how *you* build
> > patches?
> 
> I don't think that is what Petr meant (he will definitely correct me). If 
> you think there is a space for improvement in our upstream documentation 
> of the infrastructure, you are welcome to send patches. The space is 
> definitely there.

If you want to use the -flive-patching flag for CONFIG_LIVEPATCH, then
yes, there's a huge gap in the documentation.  I don't understand why
you seem to be suggesting that I'm the one whose qualified to write that
documentation.

> > > N-1 users are just waiting until the 1 user develops more helper tools
> > > for this.
> > 
> > No.  N-1 users have no idea how to make (safe) source-based patches in
> > the first place.  And if *you* don't need the tools, why would anyone
> > else?  Why not document the process and encourage the existence of other
> > users so they can get involved and help with the tooling?
> 
> I replied to this one above. You are right we should document our approach 
> better. I think it is off topic of the thread and problem here.

It's actually very much on-topic.  It's one of the main reasons why I
wanted to revert the patch.  Surely that's clear by now?

In retrospect, the prerequisites for merging it should have been:


1) Document how source-based patches can be safely generated;

2) Fix the scheduler performance regression;

3) Figure out if there are any other regressions by detecting which
   function interfaces are affected by the flag and seeing if they're
   hot path;

4) Provide a way for the N-1 users to opt-out

5) Fix the objtool warnings (or is it a GCC bug)

6) Make -flive-patching compatible with LTO (or at least acknowledge
   that it should and will be done soon)

7) At least make it build- or runtime-incompatible with Clang-built
   kernels to prevent people from assuming it's safe.


If you don't want to revert the patch, then address my concerns instead
of minimizing and deflecting at every opportunity.

-- 
Josh

