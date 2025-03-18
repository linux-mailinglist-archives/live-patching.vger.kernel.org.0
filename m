Return-Path: <live-patching+bounces-1288-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A951A67977
	for <lists+live-patching@lfdr.de>; Tue, 18 Mar 2025 17:31:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4DD0019C2B5A
	for <lists+live-patching@lfdr.de>; Tue, 18 Mar 2025 16:26:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8064D20DD59;
	Tue, 18 Mar 2025 16:26:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c9Hn43Sj"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AE077464
	for <live-patching@vger.kernel.org>; Tue, 18 Mar 2025 16:26:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742315169; cv=none; b=DVox1vpyp/dHfl9zipVMxZTSCwe693OyXeaoEBhLkZNxLCYxP9pTUOkN8dQp3SsJCyrnRu5TouidFKARVrWn6fN3EdEv0jWzSeqpfbqSkbKtGaF5MrwUtkou/B2Zoc7wlPnAYWg9nS07qWX1HrlcmUXJzA2RQ7cpNCVqG14kma4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742315169; c=relaxed/simple;
	bh=DYYPxMLGcH1cynKQCgcBkJo6iqt5zgZvpARCXHTncD4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HswkX92SQLqCgBquRheYr8ExdxKr2OF7eReG2vf3QYXQU+sCJ4ZjcRAfZRq5EQvs5vdtpMYgq6B7PLOLF3C/0w0xFJhmgACnuEFq2giU199mz0TdRBa1MqMhL1Lltba8yPJTnHTS252j4/9bNsH+31XZiDyPUISkrss5s7+mJ9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c9Hn43Sj; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CED3EC4CEF0
	for <live-patching@vger.kernel.org>; Tue, 18 Mar 2025 16:26:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742315168;
	bh=DYYPxMLGcH1cynKQCgcBkJo6iqt5zgZvpARCXHTncD4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=c9Hn43Sj8dRQFU4Eykjkl/Tgnc3/45Dnl+5Hspi0j8J4uZ1H9/9FYfxFiSw1gn12Z
	 l9cp8mQKtPNSr++YlLDAadmENn4vJ2fXtL5qQjBcqutF1N2VWjbowGYkLDntiX8fiq
	 LKJ3hVXVBSSfTTVKRf1JTcpoMacxK1qXwmnJRr7NZr/GwGBTG9RTLnU7yt9NpHk4eS
	 8SNuyW4KVJ39h36B5Ek4JQz4Zf/bhJm2bsjZe7Dp9Apj+TzYkgwQzv/5InCC9FLFuk
	 Ff637C6SRV8eyaZ8e7XEFqemiMGiCJv1yuMyYCA9BFp+/7mFA7/Qexc9j5oOg5zvmS
	 AbI08rBFbYtHA==
Received: by mail-il1-f181.google.com with SMTP id e9e14a558f8ab-3ce886a2d5bso58736825ab.1
        for <live-patching@vger.kernel.org>; Tue, 18 Mar 2025 09:26:08 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVxoVHhUyvF3gMRd31ZkWvVxCY2PU2CFqhIECa3Gd0olCQVEItGw/bCr948zCFoZFQJRH1IhRO+W6KkcoeB@vger.kernel.org
X-Gm-Message-State: AOJu0Yxxd1MVZ4AURjvM0zUFGvOZzBdWyfMKyhEQx0NuczjBIvrBaocT
	qkvVs7Iq2dE5GJer37tmrq8VZGFti8Cn6x9c5i5yd4qbiIDCnoUEquvRWPnE2LIxeJ7wP/VhZ7Y
	5q39byDrDANMfEbzGhwG5rba4yuY=
X-Google-Smtp-Source: AGHT+IERBd1mzBZy+eOtZ48NG4st2dfNTw1AlU2sb8lEFjoNFf2yZtxTReW97zyAXLVxN40QDW50qljw3lXYvGxQTrg=
X-Received: by 2002:a92:ca48:0:b0:3d3:dfc6:bc26 with SMTP id
 e9e14a558f8ab-3d483a82983mr196674595ab.22.1742315168087; Tue, 18 Mar 2025
 09:26:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250317165128.2356385-1-song@kernel.org> <2862567f-e380-a580-c3be-08bd768384f9@redhat.com>
 <CAPhsuW6UdBHHZA+h=hCctkL05YU7xpQ3uZ3=36ub5vrFYRNd5A@mail.gmail.com>
 <alpine.LSU.2.21.2503181112380.16243@pobox.suse.cz> <Z9l4zJKzXHc51OMO@redhat.com>
In-Reply-To: <Z9l4zJKzXHc51OMO@redhat.com>
From: Song Liu <song@kernel.org>
Date: Tue, 18 Mar 2025 09:25:57 -0700
X-Gmail-Original-Message-ID: <CAPhsuW63DceUb6Gfv8QaxwZFO+eKCNotdcppLhe=FJ0Ujoh=CA@mail.gmail.com>
X-Gm-Features: AQ5f1JqqepGkEiEFCCy5s852bB0JT7eGqJ_P_Q4DEzzlXoB9h52L1v72Doxk6us
Message-ID: <CAPhsuW63DceUb6Gfv8QaxwZFO+eKCNotdcppLhe=FJ0Ujoh=CA@mail.gmail.com>
Subject: Re: [PATCH] selftest/livepatch: Only run test-kprobe with CONFIG_KPROBES_ON_FTRACE
To: Joe Lawrence <joe.lawrence@redhat.com>
Cc: Miroslav Benes <mbenes@suse.cz>, live-patching@vger.kernel.org, jpoimboe@kernel.org, 
	kernel-team@meta.com, jikos@kernel.org, pmladek@suse.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 18, 2025 at 6:45=E2=80=AFAM Joe Lawrence <joe.lawrence@redhat.c=
om> wrote:
>
> On Tue, Mar 18, 2025 at 11:14:55AM +0100, Miroslav Benes wrote:
> > Hi,
> >
> > On Mon, 17 Mar 2025, Song Liu wrote:
> >
> > > On Mon, Mar 17, 2025 at 11:59=E2=80=AFAM Joe Lawrence <joe.lawrence@r=
edhat.com> wrote:
> > > >
> > > > On 3/17/25 12:51, Song Liu wrote:
> > > > > CONFIG_KPROBES_ON_FTRACE is required for test-kprobe. Skip test-k=
probe
> > > > > when CONFIG_KPROBES_ON_FTRACE is not set.
> > > > >
> > > > > Signed-off-by: Song Liu <song@kernel.org>
> > > > > ---
> > > > >  tools/testing/selftests/livepatch/test-kprobe.sh | 2 ++
> > > > >  1 file changed, 2 insertions(+)
> > > > >
> > > > > diff --git a/tools/testing/selftests/livepatch/test-kprobe.sh b/t=
ools/testing/selftests/livepatch/test-kprobe.sh
> > > > > index 115065156016..fd823dd5dd7f 100755
> > > > > --- a/tools/testing/selftests/livepatch/test-kprobe.sh
> > > > > +++ b/tools/testing/selftests/livepatch/test-kprobe.sh
> > > > > @@ -5,6 +5,8 @@
> > > > >
> > > > >  . $(dirname $0)/functions.sh
> > > > >
> > > > > +zgrep KPROBES_ON_FTRACE /proc/config.gz || skip "test-kprobe req=
uires CONFIG_KPROBES_ON_FTRACE"
> > > > > +
> > > >
> > > > Hi Song,
> > > >
> > > > This in turn depends on CONFIG_IKCONFIG_PROC for /proc/config.gz (n=
ot
> > > > set for RHEL distro kernels).
> > >
> > > I was actually worrying about this when testing it.
> > >
> > > > Is there a dynamic way to figure out CONFIG_KPROBES_ON_FTRACE suppo=
rt?
> > >
> > > How about we grep kprobe_ftrace_ops from /proc/kallsyms?
> >
> > which relies on having KALLSYMS_ALL enabled but since CONFIG_LIVEPATCH
> > depends on it, we are good. So I would say yes, it is a better option.
> > Please, add a comment around.
> >
>
> Kallsyms is a good workaround as kprobe_ftrace_ops should be stable (I
> hope :)
>
> Since Song probably noticed this when upgrading and the new kprobes test
> unexpectedly failed, I'd add a Fixes tag to help out backporters:
>
>   Fixes: 62597edf6340 ("selftests: livepatch: test livepatching a kprobed=
 function")
>
> but IMHO not worth rushing as important through the merge window.
>
>
> Also, while poking at this today with virtme-ng, my initial attempt had
> build a fairly minimal kernel without CONFIG_DYNAMIC_DEBUG.  We can also
> check for that via the sysfs interface to avoid confusing path-not-found
> msgs, like the following ...

We already have CONFIG_DYNAMIC_DEBUG=3Dy in
tools/testing/selftests/livepatch, so I think we don't need to check that a=
gain.

We cannot do the same for CONFIG_KPROBES_ON_FTRACE, because
we still want to run other tests on systems that do not support
CONFIG_KPROBES_ON_FTRACE.

Thanks,
Song

