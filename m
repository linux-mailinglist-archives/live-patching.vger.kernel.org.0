Return-Path: <live-patching+bounces-1128-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 12F8EA2C125
	for <lists+live-patching@lfdr.de>; Fri,  7 Feb 2025 12:01:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4C39E3A72EE
	for <lists+live-patching@lfdr.de>; Fri,  7 Feb 2025 11:01:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7732E1A2645;
	Fri,  7 Feb 2025 11:01:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="PD45xRpi"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2BC91A8F95
	for <live-patching@vger.kernel.org>; Fri,  7 Feb 2025 11:01:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738926085; cv=none; b=bLjkcDWJl3qXFTF3iqxg3Gv7UMbbwuIgMPJUJwm5D9fy4E0uPUFhTbL7rf/5aANTvdLLeLV1tpkJS6oLkfLfLGbvmo9DVHoJIkbmw8V1xDhTHySynWn6n/wIRzCa6rjyA7siMvMC+mlwnwvY41CpIn3KawkqyicNA1nohOIOUCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738926085; c=relaxed/simple;
	bh=rmHBix0VMn7Pi7oBUbK00DY7eiej6iqdG6upOT1yMTE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VTtPZNbxAc9seKmLeRaumFl6v5u5Su1G4XWKEj9E1WbeuS8L5y5RWfPGhE0iQY3fgHIBNxCaaKeDcSzYlhU3eM+zr43k3EVSOX4f7YWARSFYTVuhfiQI9ru21HZyQlGaCaweSm/xRrUkzxOUGyiDQDd8r/5UEnlmHJVKNLog6hw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=PD45xRpi; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-aaecf50578eso388009166b.2
        for <live-patching@vger.kernel.org>; Fri, 07 Feb 2025 03:01:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1738926081; x=1739530881; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=6h/5PIlrI9ky7BgA4zlnqX7ix8sdevWa3Gp0y4FQMFk=;
        b=PD45xRpiPIN9emW0Og1Q+1PGVUmFoVaDcWHV8rpSHSVPZ/LgzYzyDYP1z7XGoAKnIq
         CoH7eC2wIlA0dB2IYQZCnA6ts/PtClovWQT8yNXugrctbnYpj0hL5xMtWG6xO7yUZW4O
         0SpN3PpBlBpjHl7FpmsZEByYj+YKOqvIN1wIYvkCdlm5GFVM77OBuk9cwrswTJf9V3nC
         uFSWwpjWG7fFwjrXn42iDFm2rgTsvLmvO87Nz2ryjpN0NExErb1+tfnUhyiipCt/HSLF
         7MEDKMurfyVHpAC+yknZN8+UNoFetGDNLaKiC5Q7qe63cceEhiHFRHNFGzoJ5iM9MDbF
         ZbKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738926081; x=1739530881;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6h/5PIlrI9ky7BgA4zlnqX7ix8sdevWa3Gp0y4FQMFk=;
        b=a22w5OEZjqAYtBm4Jh+ZTjCrJouUIjQpZ9GUkL5GsgIng1jGNpJGREuAySk1hOlFqc
         +Y8ZrytxreHPzpOhGMzmMDvC1S/d7D1+1GSobaI8QEB6PINYSOQR2O+lG5IILLfnzJNt
         PhN5sCNiR+0VfYxZ+HcMgMmiqFGO4PlDcRUUMZM9BaIcP0isCG7OueeetC/hTwJ7nKRw
         tNEgcIEAE/iq9rntiO/496ReNZLVfCalecd/ESITh6i8NSsQVMPRdwLagJqiRSL7++zP
         CeukG728+491TyQL2tEq39M85B+JZkgDg2MQkJmjfxDumumJe1ROLALLv5ECk9GmmP1q
         sE4Q==
X-Forwarded-Encrypted: i=1; AJvYcCXoUL3wFDY+hv8zlIofmmFTNQwUiTId795lQruMN+TC2i2ZHom9J5Pr2Z7BdqouPh5HHk64Hxgqny5Vo/N3@vger.kernel.org
X-Gm-Message-State: AOJu0Yxf7N0WDMbiwGvjfqq7a+19pw9cCPDcMCpon51N+Ec86q3IJ/ip
	Hvgf47sT/j7rjGg7tBhJivTEVQ6eSnhRLKhO4dMP0XZlnmjqi+X5o+YhYapGyVcEb2NXvSRH3ij
	W
X-Gm-Gg: ASbGncvns0Iw1vSKyf5JVYdzJUVNbO7WX0sMsEKBh72zyYpZw6HsrunEQyl2ePRoQfb
	XwgDBc9ToPTSdkjsaJG/cPB5q7FLgCTk8ACSuW6MJMrx3nXyymgdA392JdsMm/USj6DFDsw7e81
	reGEMAqP2z5nE1OjwUrl0BzrZkqTHAS+sWVeAjDppN0nNYffyjr3l2O9FFnvUVUW15FwURJclwq
	9TOixTWMBjbIMT+VGYrkfeUKTmPs8H3mI0XCnDOHIs1Q7ZqAiPe79F3GMZuNf3FPLwMfhZwUJY2
	XDko8WBJ3dnnyhbwMg==
X-Google-Smtp-Source: AGHT+IHfEY78ODJ1x4v4fN69gtSMwD8+ryIikpRKJykDCfTez8UZVPsmZ/tL7lZWaKh8ITIQXGrmzQ==
X-Received: by 2002:a17:907:3f90:b0:ab7:7c42:4381 with SMTP id a640c23a62f3a-ab789c3ae92mr259347066b.43.1738926080821;
        Fri, 07 Feb 2025 03:01:20 -0800 (PST)
Received: from pathway.suse.cz ([176.114.240.130])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab78da1f953sm78536866b.59.2025.02.07.03.01.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Feb 2025 03:01:20 -0800 (PST)
Date: Fri, 7 Feb 2025 12:00:59 +0100
From: Petr Mladek <pmladek@suse.com>
To: Yafang Shao <laoar.shao@gmail.com>
Cc: Miroslav Benes <mbenes@suse.cz>, jpoimboe@kernel.org, jikos@kernel.org,
	joe.lawrence@redhat.com, live-patching@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/2] livepatch: Add support for hybrid mode
Message-ID: <Z6Xn61Bjm8pMd8zX@pathway.suse.cz>
References: <20250127063526.76687-1-laoar.shao@gmail.com>
 <Z5eOIQ4tDJr8N4UR@pathway.suse.cz>
 <CALOAHbBZc6ORGzXwBRwe+rD2=YGf1jub5TEr989_GpK54P2o1A@mail.gmail.com>
 <alpine.LSU.2.21.2501311414281.10231@pobox.suse.cz>
 <CALOAHbDwsZqo9inSLNV1FQV3NYx2=eztd556rCZqbRvEu+DDFQ@mail.gmail.com>
 <Z6IQi4wpph0dnSD7@pathway.suse.cz>
 <CALOAHbBktE_jYd5zSzvmbo_K7PkFDXrykTqV1-ZDQju64EYPyg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALOAHbBktE_jYd5zSzvmbo_K7PkFDXrykTqV1-ZDQju64EYPyg@mail.gmail.com>

On Wed 2025-02-05 14:16:42, Yafang Shao wrote:
> On Tue, Feb 4, 2025 at 9:05 PM Petr Mladek <pmladek@suse.com> wrote:
> >
> > On Mon 2025-02-03 17:44:52, Yafang Shao wrote:
> > > On Fri, Jan 31, 2025 at 9:18 PM Miroslav Benes <mbenes@suse.cz> wrote:
> > > >
> > > > > >
> > > > > >   + What exactly is meant by frequent replacements (busy loop?, once a minute?)
> > > > >
> > > > > The script:
> > > > >
> > > > > #!/bin/bash
> > > > > while true; do
> > > > >         yum install -y ./kernel-livepatch-6.1.12-0.x86_64.rpm
> > > > >         ./apply_livepatch_61.sh # it will sleep 5s
> > > > >         yum erase -y kernel-livepatch-6.1.12-0.x86_64
> > > > >         yum install -y ./kernel-livepatch-6.1.6-0.x86_64.rpm
> > > > >         ./apply_livepatch_61.sh  # it will sleep 5s
> > > > > done
> > > >
> > > > A live patch application is a slowpath. It is expected not to run
> > > > frequently (in a relative sense).
> > >
> > > The frequency isn’t the main concern here; _scalability_ is the key issue.
> > > Running livepatches once per day (a relatively low frequency) across all of our
> > > production servers (hundreds of thousands) isn’t feasible. Instead, we need to
> > > periodically run tests on a subset of test servers.
> >
> > I am confused. The original problem was a system crash when
> > livepatching do_exit() function, see
> > https://lore.kernel.org/r/CALOAHbA9WHPjeZKUcUkwULagQjTMfqAdAg+akqPzbZ7Byc=qrw@mail.gmail.com
> 
> Why do you view this patchset as a solution to the original problem?

You discovered the hardlockup warnings when trying to reproduce the
original problem. At least, you mentioned this at
https://lore.kernel.org/r/20250122085146.41553-1-laoar.shao@gmail.com

And using the hybrid module would allow to livepatch do_exit() only
once and do not touch it any longer. It is not the right solution
but it would be a workaround.


> > The rcu watchdog warning was first mentioned in this patchset.
> > Do you see rcu watchdog warning in production or just
> > with this artificial test, please?
> 
> So, we shouldn’t run any artificial tests on the livepatch, correct?
> What exactly is the issue with these test cases?

Some tests might be too artificial. They might find problems which
do not exist in practice.

Disclaimer: I do not say that this is the case. You actually prove
	later in this mail that the hardlockup warning happen
	even in production.

Anyway, if an artificial test finds a potential problem and the fix is
complicated then we need to decide if it is worth it.

It does not make sense to complicate the code too much when
the fixed problem does not happen in practice.

  + Too complicated code might introduce regressions which are
    more serious than the original problem.

  + Too complicated code increases the maintenance cost. It is
    more complicated to add new features or fix bugs.


> > > > If you stress it like this, it is quite
> > > > expected that it will have an impact. Especially on a large busy system.
> > >
> > > It seems you agree that the current atomic-replace process lacks scalability.
> > > When deploying a livepatch across a large fleet of servers, it’s impossible to
> > > ensure that the servers are idle, as their workloads are constantly varying and
> > > are not deterministic.
> >
> > Do you see the scalability problem in production, please?
> 
> Yes, the livepatch transition was stalled.

Good to know.

> 
> > And could you prove that it was caused by livepatching, please?
> 
> When the livepatch transition is stalled, running `kpatch list` will
> display the stalled information.

OK.

> > > The challenges are very different when managing 1K servers versus 1M servers.
> > > Similarly, the issues differ significantly between patching a single
> > > function and
> > > patching 100 functions, especially when some of those functions are critical.
> > > That’s what scalability is all about.
> > >
> > > Since we transitioned from the old livepatch mode to the new
> > > atomic-replace mode,
> >
> > What do you mean with the old livepatch mode, please?
> 
> $ kpatch-build -R

I am not familiar with kpatch-build. OK, I see the following at
https://github.com/dynup/kpatch/blob/master/kpatch-build/kpatch-build

echo "		-R, --non-replace       Disable replace patch (replace is on by default)" >&2

> >
> > Did you allow to install more livepatches in parallel?
> 
> No.

I guess that there is a misunderstanding. I am sorry my wording was
not clear enough.

By "installing" more livepatches in parallel I meant to "have enabled"
more livepatches in parallel. It is possible only when you do not
use the atomic replace.

By other words, if you use "kpatch-build -R" then you could have
enabled more livepatches in parallel.


> > What was the motivation to switch to the atomic replace, please?
> 
> This is the default behavior of kpatch [1] after upgrading to a new version.
> 
> [1].  https://github.com/dynup/kpatch/tree/master

OK. I wonder if the atomic replace simplified some actions for you.

I ask because the proposed "hybrid" model is very similar to the "old"
model which did not use the atomic replace.

What are the advantages of the "hybrid" model over the "old" model, please?


> > > our SREs have consistently reported that one or more servers become
> > > stalled during
> > > the upgrade (replacement).
> >
> > What is SRE, please?
> 
> >From the wikipedia : https://en.wikipedia.org/wiki/Site_reliability_engineering

Good to know.

> > Could you please show some log from a production system?
> 
> When the SREs initially reported that the livepatch transition was
> stalled, I simply advised them to try again. However, after
> experiencing these crashes, I dug deeper into the livepatch code and
> realized that scalability is a concern. As a result, periodically
> replacing an old livepatch triggers RCU warnings on our production
> servers.
> 
> [Wed Feb  5 10:56:10 2025] livepatch: enabling patch 'livepatch_61_release6'
> [Wed Feb  5 10:56:10 2025] livepatch: 'livepatch_61_release6':
> starting patching transition
> [Wed Feb  5 10:56:24 2025] rcu_tasks_wait_gp: rcu_tasks grace period
> 1126113 is 10078 jiffies old.
> [Wed Feb  5 10:56:38 2025] rcu_tasks_wait_gp: rcu_tasks grace period
> 1126117 is 10199 jiffies old.
> [Wed Feb  5 10:56:52 2025] rcu_tasks_wait_gp: rcu_tasks grace period
> 1126121 is 10047 jiffies old.
> [Wed Feb  5 10:56:57 2025] livepatch: 'livepatch_61_release6': patching complete

I guess that this happens primary because there are many processes
running in kernel code:

       + many processes => long task list
       + in kernel code => need to check stack

I wondered how much it is caused by livepatching do_exit() which
takes tasklist_lock. The idea was:

	+ The processes calling do_exit() are blocked at
	  write_lock_irq(&tasklist_lock) when
	  klp_try_complete_transition() takes the tasklist_lock.

	+ These processes can't be transitioned because do_exit()
	  is on the stack => more klp_try_complete_transition()
	  rounds is needed.

	  => livepatching do_exit() reducess the chance of
	     klp_try_complete_transition() succcess.

	Well, it should not be that big problem because the next
	 klp_try_complete_transition() should be much faster.
	 It will skip already transitioned processes quickly.

       Resume: I think that livepatching of do_exit() should not be the main
	 	problem for the stall.


> PS: You might argue again about the frequency. If you believe this is
> just a frequency issue, please suggest a suitable frequency.

I do not know. The livepatch transition might block some processes.
It is a kind of stress for the system. Similar to another
housekeeping operations.

It depends on the load and the amount and type of livepatched
functions. It might take some time until the system recovers
from the stress and the system load drops back to normal.

If you create the stress (livepatch transition) too frequently
and the system does not get chance to recover in between the
stress situations then the bad effects might accumulate
and might be much worse.

I have no idea if it is the case here. The rule of thumb would be:

  + If you see the hardlockup warning _only_ when running the stress
    test "while true: do apply_livepatch ; done;" then
    the problem might be rather theoretical.

  + If you see the hardlockup warning on production systems where
    the you apply a livepatch only occasionally (one per day)
    then the problem is real and we should fix it.


> > > > > > > Other potential risks may also arise
> > > > > > >   due to inconsistencies or race conditions during transitions.
> > > > > >
> > > > > > What inconsistencies and race conditions you have in mind, please?
> > > > >
> > > > > I have explained it at
> > > > > https://lore.kernel.org/live-patching/Z5DHQG4geRsuIflc@pathway.suse.cz/T/#m5058583fa64d95ef7ac9525a6a8af8ca865bf354
> > > > >
> > > > >  klp_ftrace_handler
> > > > >       if (unlikely(func->transition)) {
> > > > >           WARN_ON_ONCE(patch_state == KLP_UNDEFINED);
> > > > >   }
> > > > >
> > > > > Why is WARN_ON_ONCE() placed here? What issues have we encountered in the past
> > > > > that led to the decision to add this warning?
> > > >
> > > > A safety measure for something which really should not happen.
> > >
> > > Unfortunately, this issue occurs during my stress tests.
> >
> > I am confused. Do you see the above WARN_ON_ONCE() during your
> > stress test? Could you please provide a log?
> 
> Could you pls read my replyment seriously ?

This is pretty hars and offending after so many details I have already
provided!

It is easy to miss a detail in a flood of long mails. Also I am
working on many other things in parallel.

> https://lore.kernel.org/live-patching/Z5DHQG4geRsuIflc@pathway.suse.cz/T/#m5058583fa64d95ef7ac9525a6a8af8ca865bf354

Ah, I have missed that you triggered this exact WARNING. It is great.
It confirms the theory about the race in do_exit(). I mean that
the transition finishes early because the processes in do_exit()
are not longer visible in the tasklist.


> > > > > > The main advantage of the atomic replace is simplify the maintenance
> > > > > > and debugging.
> >
> > If you have problems with the atomic replace then you might stop using
> > it completely and just install more livepatches in parallel.
> 
> Why do we need to install livepatches in parallel if atomic replace is disabled?
> We only need to install the additional new livepatch. Parallel
> installation is only necessary at boot time.

This is misunderstanding. By "installed" livepatches in parallel I
mean "enabled" livepatches in parallel, aka, without atomic replace.

If you have problems with atomic replace, you might stop using it.
Honestly, I do not see that big advantage in the hybrid model
over the non-atomic-replace model.

That said, I think that the hybrid mode will not prevent the
hardlockup warning. It seems that you have reproduced the hardlockup
even with a relatively simple livepatch, see
https://lore.kernel.org/all/CALOAHbBZc6ORGzXwBRwe+rD2=YGf1jub5TEr989_GpK54P2o1A@mail.gmail.com/

IMHO, we should rather detect and break the stall in
klp_try_complete_transition(). I mean to go the way explored in
the thread
https://lore.kernel.org/all/20250122085146.41553-1-laoar.shao@gmail.com/

Best Regards,
Petr

