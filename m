Return-Path: <live-patching+bounces-1136-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D35A6A2D34D
	for <lists+live-patching@lfdr.de>; Sat,  8 Feb 2025 03:51:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 64BDB16D3C7
	for <lists+live-patching@lfdr.de>; Sat,  8 Feb 2025 02:51:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4554153BD7;
	Sat,  8 Feb 2025 02:49:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CNKFpzSl"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBD50154423;
	Sat,  8 Feb 2025 02:49:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738982986; cv=none; b=qynIhfWv7yAgkK+7SDvj2QTdjcaFcABOejATJ1s1gpvxuvGSXS2kFumXOeYoHGYYrc2xv9ns6CFrI9NL9eAixXYM9GhrZvBWdxgrgNsrse9fVfBqgls3CIQlTfy480m+daPJC9uGayAB7/b+ySZjklf2wTJjeQJyO1+QtiO+VJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738982986; c=relaxed/simple;
	bh=1Ewy0oyo8Os8gAQ6yHesmS0dY/JOVAyB5piU4zsf0Vs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DMsQ1W/8ZMXr3ahJeQUGjKaub0a6DRgcpftijHduPUiiIe/SH8GvswqzF5b7MY5DupuMQSyUqLJwF6I+B/NZyhxJxHlTvwgpLBVF+gh9PdCgY2KEIZRi54dKrxylg8MALBpDaZsAyE6Nnp02uhF/09jMOLIl0WVTWdFRC5cCruY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CNKFpzSl; arc=none smtp.client-ip=209.85.219.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-6dd43b08674so23709266d6.3;
        Fri, 07 Feb 2025 18:49:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738982983; x=1739587783; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z/pxjG3mBleCK4XJFbeVp6idHR4qOnE5XR4YxD+Us8Y=;
        b=CNKFpzSlOABoVA0VxCjVIAuQCtijrFTrrIJBqD1SP1AgC+pAgZTdBy0LWGcCMMWfCt
         KDCbhXe1SFwIvbKhbKrEQnYgNkZHFsamGAjyel7Gznb6jJJYl5AcxkSDAnNdDPB+ZEGZ
         5Y1WXbu/G/GX0tmEPP4hKGc/9kyX3I0eIA52uzzaraycj8GWGq9lwJa/oVKuP2xeq+vQ
         9QHvRNX0wbLLADLcnPKuH70VokQwXehkoCDTmNYJqw7nNkpROYuRty7688eQsz9wuXSV
         F/YWSJJUk8nOXp+ZytVcz1eJ79m/Ph3yMRz+UywWpf/J/OF3vnqUFD1F+cTzf7Mit8ma
         1pKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738982983; x=1739587783;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=z/pxjG3mBleCK4XJFbeVp6idHR4qOnE5XR4YxD+Us8Y=;
        b=ZAYprxt0RApucdT5Dj6Lsmd+xesBT+bKXtmtIJ2/cYQCrRw4kKpNjFafP1Dof7lrA6
         D4LyL97JOlD/cIWX+vkNFmpFi65ecjVlJO91Tivz6sOIuk80M+NFRIlidcgr5BP45Lvt
         5aAhpdyX8+mRt1YWxDFOq842+XGzF1LUJ7fsVRtC6Bjl0irIFs/eQEW5zrm08lWYU2FC
         KxbETgwyT+3qifse2sT6Db/tT1KZ3DrdC0VnMisbXg+66d1k4QCsf2tfJBF0fm9Ey2OO
         +NStddx348DvcgpFYVgmO0RYHXiZTXgfdUhSD01B3KOGTNA3oa1JeIIpOiQodORlebBr
         lzZw==
X-Forwarded-Encrypted: i=1; AJvYcCVFCFUFWJzTv1MZYqmrFvo/Ma51teRzurHlOptLgUoCCC0DnXq1SrKtCYIvzLdwKUwIppY0RUCvtqeWfZY=@vger.kernel.org, AJvYcCXYxEPsuQ5chbT9ngW4rDIZgEenC0MMsDBoOYjxVqgWbMuf+6yNYyrsqTZNz7GW+gQ1PIXf2JJdy+PBfl4nng==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy+6XqkzY1jyB/i2gqh4W/7kvsksojCKUpOGBcC28uLvMQqfSaW
	7w1TjvMsheh96/emg02PYSTTdWMGA2yKcT2WP6cw+XYmNaKwBylAQHnNrqT1bHFtXDOnCL5AxEl
	EkM+H38MGdYWlLAWOTDzzEgYb9Ck=
X-Gm-Gg: ASbGnctK010798yus1bD8vdJFfeYWeA9xhrzZv7JY86Mlpc3GrvRv8pEhjYISxCennr
	1tp+O7Zc0vgsuuKDmz4ze7tqRp9cGSe4j+5fCKr35XFyWvSJ9zE5gp1gQKpgMDHmMHP1/DQAzA5
	A=
X-Google-Smtp-Source: AGHT+IH4gbyIlnPPY/XjW52M62RPeNvOSsfI4eQ4I+o5BejLBnIpORlZnN1OVTTiEKH/EkeZrapW4e69XbheE0JsYNY=
X-Received: by 2002:a05:6214:5016:b0:6e4:2e00:dda9 with SMTP id
 6a1803df08f44-6e4456feb26mr95069906d6.31.1738982983397; Fri, 07 Feb 2025
 18:49:43 -0800 (PST)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250127063526.76687-1-laoar.shao@gmail.com> <Z5eOIQ4tDJr8N4UR@pathway.suse.cz>
 <CALOAHbBZc6ORGzXwBRwe+rD2=YGf1jub5TEr989_GpK54P2o1A@mail.gmail.com>
 <alpine.LSU.2.21.2501311414281.10231@pobox.suse.cz> <CALOAHbDwsZqo9inSLNV1FQV3NYx2=eztd556rCZqbRvEu+DDFQ@mail.gmail.com>
 <Z6IQi4wpph0dnSD7@pathway.suse.cz> <CALOAHbBktE_jYd5zSzvmbo_K7PkFDXrykTqV1-ZDQju64EYPyg@mail.gmail.com>
 <Z6Xn61Bjm8pMd8zX@pathway.suse.cz>
In-Reply-To: <Z6Xn61Bjm8pMd8zX@pathway.suse.cz>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Sat, 8 Feb 2025 10:49:07 +0800
X-Gm-Features: AWEUYZkRB5X0rWYPBV2nWr2IFJm2KGkQ91VpxFso1yWHTQ3prDMkm7z-M1x3c8I
Message-ID: <CALOAHbBs5sfAxSw4HA6KwjWbH3GmhkHJqcni0d4iB7oVZ_3vjw@mail.gmail.com>
Subject: Re: [RFC PATCH 0/2] livepatch: Add support for hybrid mode
To: Petr Mladek <pmladek@suse.com>
Cc: Miroslav Benes <mbenes@suse.cz>, jpoimboe@kernel.org, jikos@kernel.org, 
	joe.lawrence@redhat.com, live-patching@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 7, 2025 at 7:01=E2=80=AFPM Petr Mladek <pmladek@suse.com> wrote=
:
>
> On Wed 2025-02-05 14:16:42, Yafang Shao wrote:
> > On Tue, Feb 4, 2025 at 9:05=E2=80=AFPM Petr Mladek <pmladek@suse.com> w=
rote:
> > >
> > > On Mon 2025-02-03 17:44:52, Yafang Shao wrote:
> > > > On Fri, Jan 31, 2025 at 9:18=E2=80=AFPM Miroslav Benes <mbenes@suse=
.cz> wrote:
> > > > >
> > > > > > >
> > > > > > >   + What exactly is meant by frequent replacements (busy loop=
?, once a minute?)
> > > > > >
> > > > > > The script:
> > > > > >
> > > > > > #!/bin/bash
> > > > > > while true; do
> > > > > >         yum install -y ./kernel-livepatch-6.1.12-0.x86_64.rpm
> > > > > >         ./apply_livepatch_61.sh # it will sleep 5s
> > > > > >         yum erase -y kernel-livepatch-6.1.12-0.x86_64
> > > > > >         yum install -y ./kernel-livepatch-6.1.6-0.x86_64.rpm
> > > > > >         ./apply_livepatch_61.sh  # it will sleep 5s
> > > > > > done
> > > > >
> > > > > A live patch application is a slowpath. It is expected not to run
> > > > > frequently (in a relative sense).
> > > >
> > > > The frequency isn=E2=80=99t the main concern here; _scalability_ is=
 the key issue.
> > > > Running livepatches once per day (a relatively low frequency) acros=
s all of our
> > > > production servers (hundreds of thousands) isn=E2=80=99t feasible. =
Instead, we need to
> > > > periodically run tests on a subset of test servers.
> > >
> > > I am confused. The original problem was a system crash when
> > > livepatching do_exit() function, see
> > > https://lore.kernel.org/r/CALOAHbA9WHPjeZKUcUkwULagQjTMfqAdAg+akqPzbZ=
7Byc=3Dqrw@mail.gmail.com
> >
> > Why do you view this patchset as a solution to the original problem?
>
> You discovered the hardlockup warnings when trying to reproduce the
> original problem. At least, you mentioned this at
> https://lore.kernel.org/r/20250122085146.41553-1-laoar.shao@gmail.com
>
> And using the hybrid module would allow to livepatch do_exit() only
> once and do not touch it any longer. It is not the right solution
> but it would be a workaround.
>
>
> > > The rcu watchdog warning was first mentioned in this patchset.
> > > Do you see rcu watchdog warning in production or just
> > > with this artificial test, please?
> >
> > So, we shouldn=E2=80=99t run any artificial tests on the livepatch, cor=
rect?
> > What exactly is the issue with these test cases?
>
> Some tests might be too artificial. They might find problems which
> do not exist in practice.
>
> Disclaimer: I do not say that this is the case. You actually prove
>         later in this mail that the hardlockup warning happen
>         even in production.
>
> Anyway, if an artificial test finds a potential problem and the fix is
> complicated then we need to decide if it is worth it.
>
> It does not make sense to complicate the code too much when
> the fixed problem does not happen in practice.
>
>   + Too complicated code might introduce regressions which are
>     more serious than the original problem.
>
>   + Too complicated code increases the maintenance cost. It is
>     more complicated to add new features or fix bugs.
>
>
> > > > > If you stress it like this, it is quite
> > > > > expected that it will have an impact. Especially on a large busy =
system.
> > > >
> > > > It seems you agree that the current atomic-replace process lacks sc=
alability.
> > > > When deploying a livepatch across a large fleet of servers, it=E2=
=80=99s impossible to
> > > > ensure that the servers are idle, as their workloads are constantly=
 varying and
> > > > are not deterministic.
> > >
> > > Do you see the scalability problem in production, please?
> >
> > Yes, the livepatch transition was stalled.
>
> Good to know.
>
> >
> > > And could you prove that it was caused by livepatching, please?
> >
> > When the livepatch transition is stalled, running `kpatch list` will
> > display the stalled information.
>
> OK.
>
> > > > The challenges are very different when managing 1K servers versus 1=
M servers.
> > > > Similarly, the issues differ significantly between patching a singl=
e
> > > > function and
> > > > patching 100 functions, especially when some of those functions are=
 critical.
> > > > That=E2=80=99s what scalability is all about.
> > > >
> > > > Since we transitioned from the old livepatch mode to the new
> > > > atomic-replace mode,
> > >
> > > What do you mean with the old livepatch mode, please?
> >
> > $ kpatch-build -R
>
> I am not familiar with kpatch-build. OK, I see the following at
> https://github.com/dynup/kpatch/blob/master/kpatch-build/kpatch-build
>
> echo "          -R, --non-replace       Disable replace patch (replace is=
 on by default)" >&2
>
> > >
> > > Did you allow to install more livepatches in parallel?
> >
> > No.
>
> I guess that there is a misunderstanding. I am sorry my wording was
> not clear enough.
>
> By "installing" more livepatches in parallel I meant to "have enabled"
> more livepatches in parallel. It is possible only when you do not
> use the atomic replace.
>
> By other words, if you use "kpatch-build -R" then you could have
> enabled more livepatches in parallel.
>
>
> > > What was the motivation to switch to the atomic replace, please?
> >
> > This is the default behavior of kpatch [1] after upgrading to a new ver=
sion.
> >
> > [1].  https://github.com/dynup/kpatch/tree/master
>
> OK. I wonder if the atomic replace simplified some actions for you.

Actually, it simplifies the livepatch deployment since it only
involves a single livepatch.

>
> I ask because the proposed "hybrid" model is very similar to the "old"
> model which did not use the atomic replace.

It=E2=80=99s essentially a hybrid of the old model and the atomic replace m=
odel.

>
> What are the advantages of the "hybrid" model over the "old" model, pleas=
e?

- Advantages compared to the old model
  In the old model, it=E2=80=99s not possible to replace a specific livepat=
ch
with a new one. In the hybrid model, however, you can replace specific
livepatches as needed.

- Advantages and disadvantages compared to the atomic replace model
   - Advantage
     In the atomic replace model, you must replace all old
livepatches, regardless of whether they are relevant to the new
livepatch. In the hybrid model, you only need to replace the relevant
livepatches.

   - Disadvantage
     In the atomic replace model, you only need to maintain a single
livepatch. However, in the hybrid model, you need to manage multiple
livepatches.

>
>
> > > > our SREs have consistently reported that one or more servers become
> > > > stalled during
> > > > the upgrade (replacement).
> > >
> > > What is SRE, please?
> >
> > >From the wikipedia : https://en.wikipedia.org/wiki/Site_reliability_en=
gineering
>
> Good to know.
>
> > > Could you please show some log from a production system?
> >
> > When the SREs initially reported that the livepatch transition was
> > stalled, I simply advised them to try again. However, after
> > experiencing these crashes, I dug deeper into the livepatch code and
> > realized that scalability is a concern. As a result, periodically
> > replacing an old livepatch triggers RCU warnings on our production
> > servers.
> >
> > [Wed Feb  5 10:56:10 2025] livepatch: enabling patch 'livepatch_61_rele=
ase6'
> > [Wed Feb  5 10:56:10 2025] livepatch: 'livepatch_61_release6':
> > starting patching transition
> > [Wed Feb  5 10:56:24 2025] rcu_tasks_wait_gp: rcu_tasks grace period
> > 1126113 is 10078 jiffies old.
> > [Wed Feb  5 10:56:38 2025] rcu_tasks_wait_gp: rcu_tasks grace period
> > 1126117 is 10199 jiffies old.
> > [Wed Feb  5 10:56:52 2025] rcu_tasks_wait_gp: rcu_tasks grace period
> > 1126121 is 10047 jiffies old.
> > [Wed Feb  5 10:56:57 2025] livepatch: 'livepatch_61_release6': patching=
 complete
>
> I guess that this happens primary because there are many processes
> running in kernel code:
>
>        + many processes =3D> long task list
>        + in kernel code =3D> need to check stack
>
> I wondered how much it is caused by livepatching do_exit() which
> takes tasklist_lock. The idea was:

I=E2=80=99ll drop the changes in do_exit() and run the test again.

>
>         + The processes calling do_exit() are blocked at
>           write_lock_irq(&tasklist_lock) when
>           klp_try_complete_transition() takes the tasklist_lock.
>
>         + These processes can't be transitioned because do_exit()
>           is on the stack =3D> more klp_try_complete_transition()
>           rounds is needed.
>
>           =3D> livepatching do_exit() reducess the chance of
>              klp_try_complete_transition() succcess.
>
>         Well, it should not be that big problem because the next
>          klp_try_complete_transition() should be much faster.
>          It will skip already transitioned processes quickly.
>
>        Resume: I think that livepatching of do_exit() should not be the m=
ain
>                 problem for the stall.
>
>
> > PS: You might argue again about the frequency. If you believe this is
> > just a frequency issue, please suggest a suitable frequency.
>
> I do not know. The livepatch transition might block some processes.
> It is a kind of stress for the system. Similar to another
> housekeeping operations.
>
> It depends on the load and the amount and type of livepatched
> functions. It might take some time until the system recovers
> from the stress and the system load drops back to normal.
>
> If you create the stress (livepatch transition) too frequently
> and the system does not get chance to recover in between the
> stress situations then the bad effects might accumulate
> and might be much worse.
>
> I have no idea if it is the case here. The rule of thumb would be:

Note that I=E2=80=99ve just deployed the test to a few of our production
servers. The test runs at a relatively low frequency, so it doesn=E2=80=99t
introduce significant side effects to the original workload, aside
from some latency spikes during deployment. These spikes are
short-lived and disappear quickly.

>
>   + If you see the hardlockup warning _only_ when running the stress
>     test "while true: do apply_livepatch ; done;" then
>     the problem might be rather theoretical.
>
>   + If you see the hardlockup warning on production systems where
>     the you apply a livepatch only occasionally (one per day)
>     then the problem is real and we should fix it.

I can't run it once per day, as it might take too long to reproduce
the issue. If I want to reproduce it quickly, I=E2=80=99d need to deploy th=
e
test to more production servers, which would likely be complained
about by our sys admins. Notably, the RCU warning even occurs when I
run the test once every 4 hours. The reason I run the test
periodically is that the workloads change throughout the day, so
periodically testing them helps monitor the system's behavior across
different workloads.

>
>
> > > > > > > > Other potential risks may also arise
> > > > > > > >   due to inconsistencies or race conditions during transiti=
ons.
> > > > > > >
> > > > > > > What inconsistencies and race conditions you have in mind, pl=
ease?
> > > > > >
> > > > > > I have explained it at
> > > > > > https://lore.kernel.org/live-patching/Z5DHQG4geRsuIflc@pathway.=
suse.cz/T/#m5058583fa64d95ef7ac9525a6a8af8ca865bf354
> > > > > >
> > > > > >  klp_ftrace_handler
> > > > > >       if (unlikely(func->transition)) {
> > > > > >           WARN_ON_ONCE(patch_state =3D=3D KLP_UNDEFINED);
> > > > > >   }
> > > > > >
> > > > > > Why is WARN_ON_ONCE() placed here? What issues have we encounte=
red in the past
> > > > > > that led to the decision to add this warning?
> > > > >
> > > > > A safety measure for something which really should not happen.
> > > >
> > > > Unfortunately, this issue occurs during my stress tests.
> > >
> > > I am confused. Do you see the above WARN_ON_ONCE() during your
> > > stress test? Could you please provide a log?
> >
> > Could you pls read my replyment seriously ?
>
> This is pretty hars and offending after so many details I have already
> provided!

Sorry about that. You really help me so much.

>
> It is easy to miss a detail in a flood of long mails. Also I am
> working on many other things in parallel.
>
> > https://lore.kernel.org/live-patching/Z5DHQG4geRsuIflc@pathway.suse.cz/=
T/#m5058583fa64d95ef7ac9525a6a8af8ca865bf354
>
> Ah, I have missed that you triggered this exact WARNING. It is great.
> It confirms the theory about the race in do_exit(). I mean that
> the transition finishes early because the processes in do_exit()
> are not longer visible in the tasklist.

It seems like that.

>
>
> > > > > > > The main advantage of the atomic replace is simplify the main=
tenance
> > > > > > > and debugging.
> > >
> > > If you have problems with the atomic replace then you might stop usin=
g
> > > it completely and just install more livepatches in parallel.
> >
> > Why do we need to install livepatches in parallel if atomic replace is =
disabled?
> > We only need to install the additional new livepatch. Parallel
> > installation is only necessary at boot time.
>
> This is misunderstanding. By "installed" livepatches in parallel I
> mean "enabled" livepatches in parallel, aka, without atomic replace.
>
> If you have problems with atomic replace, you might stop using it.
> Honestly, I do not see that big advantage in the hybrid model
> over the non-atomic-replace model.

I believe the ability to selectively replace a specific livepatch is a
significant advantage over both the non-atomic-replace and
atomic-replace models.

>
> That said, I think that the hybrid mode will not prevent the
> hardlockup warning. It seems that you have reproduced the hardlockup
> even with a relatively simple livepatch, see
> https://lore.kernel.org/all/CALOAHbBZc6ORGzXwBRwe+rD2=3DYGf1jub5TEr989_Gp=
K54P2o1A@mail.gmail.com/
>
> IMHO, we should rather detect and break the stall in
> klp_try_complete_transition(). I mean to go the way explored in
> the thread
> https://lore.kernel.org/all/20250122085146.41553-1-laoar.shao@gmail.com/

That=E2=80=99s a separate issue, which we can discuss it seperately.

--
Regards
Yafang

