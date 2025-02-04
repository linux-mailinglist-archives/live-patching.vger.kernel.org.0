Return-Path: <live-patching+bounces-1107-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CA940A272C2
	for <lists+live-patching@lfdr.de>; Tue,  4 Feb 2025 14:28:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 529A216059A
	for <lists+live-patching@lfdr.de>; Tue,  4 Feb 2025 13:28:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A672213E9F;
	Tue,  4 Feb 2025 13:05:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="P4ElE6Np"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A42E213239
	for <live-patching@vger.kernel.org>; Tue,  4 Feb 2025 13:05:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738674321; cv=none; b=V6J9Nnpqrznog3BeApSx6HYUU77PHUSft97ZHH9QAq9dG+3L8bc8i2OvjvbJi9w+KxpdXmyvMxCQe0uUlaEjAFyBeekR+Wqm6/aUU/2OR+RgNCt/kAXYFd4Up/p2n4L8DtNhUSHzrfIgGH6bkxcug4lnQ0dxoG/YoYMMbB3q0v0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738674321; c=relaxed/simple;
	bh=i+1q8Zzgvh2Mh3R1+FitBJPqR1dPHazu3ddiTGqitQ0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=htMEEYCVTRO2LDtNUxTsR2/2bHUCeb5kymvXP1iSt2d4UxbtiUCwV7Ly8Lk0xLt4lr1KVA2n5qIKq9m95+DctjMgqn+1TvUc6b6ZIStxw000ROUM0sIPZp9j8brlgoRegwwC350MJ2AfC+5vIF0r54hb2qobK7fuy3mWVBKhi7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=P4ElE6Np; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-ab737e5674bso312499266b.1
        for <live-patching@vger.kernel.org>; Tue, 04 Feb 2025 05:05:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1738674317; x=1739279117; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=3oOyfmyvxD2JRjb/GBBLy3vJNh6/Dw/oGTe4zC+nKbk=;
        b=P4ElE6Np9zbljPbka/Z0X9bUA/VL9va5WQZt4+NqxyhO4U5D7f7MXQ2jy5sDvE82el
         ym3EbSibw8A1jSj/QC3Ejxfew8A/7t7oDJIdcaQPqlw0YfrllrjadvpqvSfO+9TuO97H
         obPsVwhcQg31L/YlG+vYr7aLBlMJzn7vQJzNdHu3PnIPDrNJmQzF7XdhKaiB6mHUpUup
         KdZKyo/vN9/QDKh+jhQzBT9gABgMQ8JuZRh8CqnHXov+d8xWlgiBMJn1lOZL8lOFRJgv
         xQ/KSY3LLmjJaIQ2HRSlbUteO15uB7U6zIhLnHwuHp4ZK7uAyfbw3zyTDmhHpoHtFQq+
         SZ9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738674317; x=1739279117;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3oOyfmyvxD2JRjb/GBBLy3vJNh6/Dw/oGTe4zC+nKbk=;
        b=TWnZ5Dynl+DUN52HIbQ3th43XcMJXBjTVs54wyh3W7YINAbzYZ1Sy1/8fCoDLLzQ4N
         cea+oe+OGvQP9VsH/DWWAd+zW8mige1wO6Z33Z5xGh99Vmif91noY36L7BgckTaN4ZMM
         sHaIl8iDmYNICzdNIWWVHk311QgLTjwxcV5IRHaQJhdjDhN8P9CVuGsPldxdKevCUEjI
         MAeHexnZoIhVqiiIQ7YL1xhybS69DUo5cDbgxP5Cm+YsT1lTqKMHUlQRhHMqif/VnHiw
         ClErZMRbbHrOay4pOS+HyG5+KWQxzohKyXnIAeEdT5HUM7muOqCPHPjBnBU4UY3Ubunb
         R0Ng==
X-Forwarded-Encrypted: i=1; AJvYcCWL7Nc4rCDniixPPQnn3wprnxHWuL7TDvSksKAqbv9zLRBJdnw6mQWBr+L0PM3GZyGvqEzFJVwMPMufOJKj@vger.kernel.org
X-Gm-Message-State: AOJu0Yw5OfJV8+ky5BnBxNC96Qef6198w/kEYaLbvLBf3mSTm5IxOK+2
	cq7yZWDYxeVlTM8swZR1kFNvTo4KE/RZeu/b1p17l5H5TZzcAFzDJOvX8PHNaGo=
X-Gm-Gg: ASbGncsYRCLXxMFPqpeBtq7GgPZC56dJjiPs0euFpv5gPyMEcUZhoGTi3M78TIcw/7M
	ZEuCn2rN3YaDHK5oSAORM0fkPCbC+1ikOzdXYXlD6A2IPpCHibgMtQkEkgEEa3/ONcdFV7A4sOK
	6fFU+4wqznKbVD0sVcz6TGk9Xo21zYRntZDSD6dF8WGChCVTMydR4ub9VXlzFiCB3htBvYPqF1e
	iET1BSKi3BkEMNYbf958nVUB/83TPhQ0LpvBrs558XO1H7DzWbK0X4G5h8CZjGyCXn7iJbxpNQN
	C6ZBllojkjuDRfhztg==
X-Google-Smtp-Source: AGHT+IGBl7i7nXlso9tbhlV1G/QjiiNegMs2sz3oHixQqd+gL/Zatt/iwtDjc84jpzxmYuC601DOjA==
X-Received: by 2002:a17:906:6a24:b0:aa6:aa8e:c89c with SMTP id a640c23a62f3a-ab6cfda42fbmr3356237366b.39.1738674317098;
        Tue, 04 Feb 2025 05:05:17 -0800 (PST)
Received: from pathway.suse.cz ([176.114.240.130])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab6e49ff269sm914164166b.118.2025.02.04.05.05.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Feb 2025 05:05:16 -0800 (PST)
Date: Tue, 4 Feb 2025 14:05:15 +0100
From: Petr Mladek <pmladek@suse.com>
To: Yafang Shao <laoar.shao@gmail.com>
Cc: Miroslav Benes <mbenes@suse.cz>, jpoimboe@kernel.org, jikos@kernel.org,
	joe.lawrence@redhat.com, live-patching@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/2] livepatch: Add support for hybrid mode
Message-ID: <Z6IQi4wpph0dnSD7@pathway.suse.cz>
References: <20250127063526.76687-1-laoar.shao@gmail.com>
 <Z5eOIQ4tDJr8N4UR@pathway.suse.cz>
 <CALOAHbBZc6ORGzXwBRwe+rD2=YGf1jub5TEr989_GpK54P2o1A@mail.gmail.com>
 <alpine.LSU.2.21.2501311414281.10231@pobox.suse.cz>
 <CALOAHbDwsZqo9inSLNV1FQV3NYx2=eztd556rCZqbRvEu+DDFQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALOAHbDwsZqo9inSLNV1FQV3NYx2=eztd556rCZqbRvEu+DDFQ@mail.gmail.com>

On Mon 2025-02-03 17:44:52, Yafang Shao wrote:
> On Fri, Jan 31, 2025 at 9:18 PM Miroslav Benes <mbenes@suse.cz> wrote:
> >
> > > >
> > > >   + What exactly is meant by frequent replacements (busy loop?, once a minute?)
> > >
> > > The script:
> > >
> > > #!/bin/bash
> > > while true; do
> > >         yum install -y ./kernel-livepatch-6.1.12-0.x86_64.rpm
> > >         ./apply_livepatch_61.sh # it will sleep 5s
> > >         yum erase -y kernel-livepatch-6.1.12-0.x86_64
> > >         yum install -y ./kernel-livepatch-6.1.6-0.x86_64.rpm
> > >         ./apply_livepatch_61.sh  # it will sleep 5s
> > > done
> >
> > A live patch application is a slowpath. It is expected not to run
> > frequently (in a relative sense).
> 
> The frequency isn’t the main concern here; _scalability_ is the key issue.
> Running livepatches once per day (a relatively low frequency) across all of our
> production servers (hundreds of thousands) isn’t feasible. Instead, we need to
> periodically run tests on a subset of test servers.

I am confused. The original problem was a system crash when
livepatching do_exit() function, see
https://lore.kernel.org/r/CALOAHbA9WHPjeZKUcUkwULagQjTMfqAdAg+akqPzbZ7Byc=qrw@mail.gmail.com

The rcu watchdog warning was first mentioned in this patchset.
Do you see rcu watchdog warning in production or just
with this artificial test, please?


> > If you stress it like this, it is quite
> > expected that it will have an impact. Especially on a large busy system.
> 
> It seems you agree that the current atomic-replace process lacks scalability.
> When deploying a livepatch across a large fleet of servers, it’s impossible to
> ensure that the servers are idle, as their workloads are constantly varying and
> are not deterministic.

Do you see the scalability problem in production, please?
And could you prove that it was caused by livepatching, please?


> The challenges are very different when managing 1K servers versus 1M servers.
> Similarly, the issues differ significantly between patching a single
> function and
> patching 100 functions, especially when some of those functions are critical.
> That’s what scalability is all about.
> 
> Since we transitioned from the old livepatch mode to the new
> atomic-replace mode,

What do you mean with the old livepatch mode, please?

Did you allow to install more livepatches in parallel?
What was the motivation to switch to the atomic replace, please?

> our SREs have consistently reported that one or more servers become
> stalled during
> the upgrade (replacement).

What is SRE, please?
Could you please show some log from a production system?


> > > > > Other potential risks may also arise
> > > > >   due to inconsistencies or race conditions during transitions.
> > > >
> > > > What inconsistencies and race conditions you have in mind, please?
> > >
> > > I have explained it at
> > > https://lore.kernel.org/live-patching/Z5DHQG4geRsuIflc@pathway.suse.cz/T/#m5058583fa64d95ef7ac9525a6a8af8ca865bf354
> > >
> > >  klp_ftrace_handler
> > >       if (unlikely(func->transition)) {
> > >           WARN_ON_ONCE(patch_state == KLP_UNDEFINED);
> > >   }
> > >
> > > Why is WARN_ON_ONCE() placed here? What issues have we encountered in the past
> > > that led to the decision to add this warning?
> >
> > A safety measure for something which really should not happen.
> 
> Unfortunately, this issue occurs during my stress tests.

I am confused. Do you see the above WARN_ON_ONCE() during your
stress test? Could you please provide a log?

> > > > The main advantage of the atomic replace is simplify the maintenance
> > > > and debugging.
> > >
> > > Is it worth the high overhead on production servers?
> >
> > Yes, because the overhead once a live patch is applied is negligible.
> 
> If you’re managing a large fleet of servers, this issue is far from negligible.
> 
> >
> > > Can you provide examples of companies that use atomic replacement at
> > > scale in their production environments?
> >
> > At least SUSE uses it as a solution for its customers. No many problems
> > have been reported since we started ~10 years ago.
> 
> Perhaps we’re running different workloads.
> Going back to the original purpose of livepatching: is it designed to address
> security vulnerabilities, or to deploy new features?

We (SUSE) use livepatches only for fixing CVEs and serious bugs.


> If it’s the latter, then there’s definitely a lot of room for improvement.

You might be right. I am just not sure whether the hybrid mode would
be the right solution.

If you have problems with the atomic replace then you might stop using
it completely and just install more livepatches in parallel.


My view:

More livepatches installed in parallel are more prone to
inconsistencies. A good example is the thread about introducing
stack order sysfs interface, see
https://lore.kernel.org/all/AAD198C9-210E-4E31-8FD7-270C39A974A8@gmail.com/

The atomic replace helps to keep the livepatched functions consistent.

The hybrid model would allow to install more livepatches in parallel except
that one livepatch could be replaced atomically. It would create even
more scenarios than allowing all livepatches in parallel.

What would be the rules, please?

Which functionality will be livepatched by the atomic replace, please?

Which functionality will be handled by the extra non-replaceable
livepatches, please?

How would you keep the livepatches consistent, please?

How would you manage dependencies between livepatches, please?

What is the advantage of the hybrid model over allowing
all livepatches in parallel, please?

Best Regards,
Petr

