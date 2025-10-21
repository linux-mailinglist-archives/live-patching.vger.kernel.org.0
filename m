Return-Path: <live-patching+bounces-1781-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 59B0EBF4ADE
	for <lists+live-patching@lfdr.de>; Tue, 21 Oct 2025 08:07:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 132484E3009
	for <lists+live-patching@lfdr.de>; Tue, 21 Oct 2025 06:07:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B118E221D96;
	Tue, 21 Oct 2025 06:07:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BCbqvoj4"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B9381BFE00
	for <live-patching@vger.kernel.org>; Tue, 21 Oct 2025 06:07:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761026858; cv=none; b=Ool08wOKvRYjjou05lqBk25jUwBgTNEhY1OmPknq9aT2gTHCtMnd4u7WjMltxXWdVfo4fqjUsuiZXfltoItA6VQ+FSo4bDlIajrOl9CUScRnjZestQBC4Ym7FcfFkZ4HeiHdXxWnTXFRKfWJP0AfuvkRakXg9j19edCtb/oAc28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761026858; c=relaxed/simple;
	bh=17NtzcxTvAdEUyY3ycFZtavJkTbsy0ol92xqlb8z7Ac=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gO7+PWSuMp2rhuelmzXyEXi2zFmWPpHVSrn3i3MxfrwbgYj1WMe9bQQ2YanR0ToEELrQ0Hx8Ag0nQG6bW6JaKzbZaldjOH8vgejoDu5A2RwyVH9ocbAT/G7jf3rZIKbCkyLCSndUWtK77RmUUhzUO4SPd9SkZu9HqlRqSePASEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BCbqvoj4; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E439C4CEFF
	for <live-patching@vger.kernel.org>; Tue, 21 Oct 2025 06:07:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761026858;
	bh=17NtzcxTvAdEUyY3ycFZtavJkTbsy0ol92xqlb8z7Ac=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=BCbqvoj44vlV9Bn+QnI6WYv0cChkN0ag9zvxiLqjr6kFA2N2So4JYCss/QnMbc0UA
	 O3tVIzEMU1nuLlTss4PXz22k4RBRBQJx9ntUEm9j4MjFaEYd/HD2LUdBXWMCTqAvli
	 ZGJHcGzpU38P3wfspkg4gJIcxWmiZS+tmx/jVynJSZ6FqbTl16kARxdHdc5trC7j6I
	 hJAJWXbr46Lx+9Ooqd74YlK2PxnfWbdqjKPw9+3jbvTHufnob/s2CHiJYe7Jfl7+bt
	 8kegKG7/5UenZVTI3z+nTurJdFEVAK82lL79U/b7l7J9KOMXVmwESoybJw1uXFaNX8
	 WxILXtHRRidbg==
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-81efcad9c90so95020786d6.0
        for <live-patching@vger.kernel.org>; Mon, 20 Oct 2025 23:07:38 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWn4Nl8BIOYdh2VQ51bwC54xCgLIXPdWNJRvdiNHaj3hvzmCvulwUJ6B7/QmS6FO7ju3BB1tqZtM91hQT3v@vger.kernel.org
X-Gm-Message-State: AOJu0Yzy+MryeRgpTYtnbTGKIY1LLY1ywrmpfXb1v4OA35z5IwmHpgv0
	vu44eW84poQhGljGqIPiQ0x2dpR1EmY5sdELL6cE0t9JPepbsIDPTRW3De6D8yV3iKDiTt5MPZN
	NAjMg44Bn1v5rlLOFuDmsISs8jkxEhZ8=
X-Google-Smtp-Source: AGHT+IEMeD978JuC2HWau9xWtSxSlbp35i4X0dyXUNCrU7Kes86hagCiNRLQ+78/LRDrGENJWMa4QuMlJDAX2OWyJmc=
X-Received: by 2002:ad4:5e8e:0:b0:87d:c778:655a with SMTP id
 6a1803df08f44-87dc7786c78mr118709036d6.64.1761026857256; Mon, 20 Oct 2025
 23:07:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <c5058315a39d4615b333e485893345be@crowdstrike.com>
 <aO-LMaY-os44cEJP@pathway.suse.cz> <eb176565-6e13-4f98-8c9a-cacf7fc42f3a@crowdstrike.com>
 <aPDPYIA4_mpo-OZS@pathway.suse.cz> <CAHzjS_v2HfpH1Oof3BWawN51WVM_1V1uXro4MSC=0YmMiqVWcg@mail.gmail.com>
 <82eaaada-f3fc-44f7-826d-8de47ce9fd39@crowdstrike.com> <CAHzjS_s2RhM3_H9CCedud3zkGUWW2xkmvxvPLR1qujLZRhgL1A@mail.gmail.com>
 <CAHzjS_sQQaTZpxC2drGx8=7zCMAKQN_CNjYFcNzxZEGhd+yXPA@mail.gmail.com>
 <69339fb8-04a6-4c28-bb71-d9522ebd7282@crowdstrike.com> <CAHzjS_tf0KeBnzA6psjHSCuiXn--hK=owDPhCPUB0=jnLDBk=A@mail.gmail.com>
 <4cc825e6-fdf8-4fc1-8ccd-9bad456c2131@crowdstrike.com> <CAHzjS_soRQwKKP24DObNKBnOtiNsVZHOM-NnY_34w5GwGhC9rw@mail.gmail.com>
 <5477a73a-1dce-4b9e-b389-e757ef5536c4@crowdstrike.com> <CAHzjS_tuotYQQ0HmncVp=oFOfcyxmYqCds0MDBMOr5FC5KzhSA@mail.gmail.com>
 <7e6886ab-b168-422e-9adf-8297b88643d1@crowdstrike.com> <f3f3e753-1014-4fb2-9d6e-328b33c7356f@crowdstrike.com>
 <07ab2111-0f41-40cb-aeb1-d9d3463b1a6a@crowdstrike.com>
In-Reply-To: <07ab2111-0f41-40cb-aeb1-d9d3463b1a6a@crowdstrike.com>
From: Song Liu <song@kernel.org>
Date: Mon, 20 Oct 2025 23:07:26 -0700
X-Gmail-Original-Message-ID: <CAHzjS_vD1TJkVxN+bf+2srKhH9ajn=BHyvEn7oeu664R481R+g@mail.gmail.com>
X-Gm-Features: AS18NWAmCCPOtasQIERtSmWBN7sBqOmzd402QXLxkOf5SbCT53y3v4dgZDxs-cc
Message-ID: <CAHzjS_vD1TJkVxN+bf+2srKhH9ajn=BHyvEn7oeu664R481R+g@mail.gmail.com>
Subject: Re: [External] Re: Question - Livepatch/Kprobe Coexistence on
 Ftrace-enabled Functions (Ubuntu kernel based on Linux stable 5.15.30)
To: Andrey Grodzovsky <andrey.grodzovsky@crowdstrike.com>
Cc: Song Liu <song@kernel.org>, Petr Mladek <pmladek@suse.com>, 
	"kernel-team@lists.ubuntu.com" <kernel-team@lists.ubuntu.com>, 
	"live-patching@vger.kernel.org" <live-patching@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 20, 2025 at 2:31=E2=80=AFPM Andrey Grodzovsky
<andrey.grodzovsky@crowdstrike.com> wrote:
[...]
> Song, I identified another issue in pre 6.6 kernel, building
> ~/linux-6.5/samples/livepatch/livepatch-sample.c as ko,
> before insmoding it, bpftrace fentry/fexit fires as expected, after
> insmod, while no errors reported on attachments,
> the hooks stop firing, both if attaching before insmod and if attaching
> after insmod. If i rrmod the ko, existing hooks
> resume working.
>
> ubuntu@ip-10-10-115-238:~$ cat /proc/version_signature
> Ubuntu 6.5.0-1008.8-aws 6.5.3
> Source obtained to build the test module for the AWS kernel from the
> related stable branch -
> https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-6.5.tar.xz
>
> Let me know what you think.

I tested various stable kernels. I got:

With livepatch, fentry and fexit work on 6.3 kernels.

On 6.4 and 6.5 kernels, the combination stops working since this commit:

commit 60c8971899f3b34ad24857913c0784dab08962f0
Author: Florent Revest <revest@chromium.org>
Date:   2 years, 7 months ago

    ftrace: Make DIRECT_CALLS work WITH_ARGS and !WITH_REGS


On 6.5 kernels, it got fixed by the following two commits:

commit a8b9cf62ade1bf17261a979fc97e40c2d7842353
Author: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Date: 1 year, 9 months ago
ftrace: Fix DIRECT_CALLS to use SAVE_REGS by default

commit bdbddb109c75365d22ec4826f480c5e75869e1cb
Author: Petr Pavlu <petr.pavlu@suse.com>
Date:   1 year, 8 months ago

    tracing: Fix HAVE_DYNAMIC_FTRACE_WITH_REGS ifdef

I tried to cherry-pick 60c8971899f3b34ad24857913c0784dab08962f0
and a8b9cf62ade1bf17261a979fc97e40c2d7842353, on top of 6.5.13
kernel. Then, fentry and fexit both work with livepatch.

Thanks,
Song

