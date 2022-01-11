Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89D9848A551
	for <lists+live-patching@lfdr.de>; Tue, 11 Jan 2022 02:49:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346391AbiAKBtv (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 10 Jan 2022 20:49:51 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:52542 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346331AbiAKBtv (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 10 Jan 2022 20:49:51 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F3773614A2;
        Tue, 11 Jan 2022 01:49:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60721C36AF6;
        Tue, 11 Jan 2022 01:49:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641865790;
        bh=3UQexFSZqQnTQR1vM+ym9IdZtYO7x9+eEj9hHwpof2g=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=BQozbTlnPgrukL7vnpLVJ9H/DstgWWDWnwD31DV8ia92WG5ubukIjYYznYVo2JSrK
         C3wpyZa7rhs37US3++TC9eGrr4IRhXhGSGejXjL3gnxRtGNcvSSv0OHreAWz444GAr
         7NuJ7Jkyjf9R4VcYrFd7ghB0/IxhIpcA6VIqoWB+562e215kFvZcZ2VZ/ur7aNw59Z
         0FlG7UHVf1CF7oKe2PxM+LAwRUCcMe9Am8bmk4IxoomucqAx5ccbqTsW5e2vLWs3zs
         na2vS/6Nv8PCA25bs8mIlZucyBQ7FUTQjl9A12YfgtHoTm5pTHa9V6YxnSQmVLd9/Z
         45fXMG+nynI6Q==
Received: by mail-yb1-f181.google.com with SMTP id c6so41153240ybk.3;
        Mon, 10 Jan 2022 17:49:50 -0800 (PST)
X-Gm-Message-State: AOAM530R5JeEyhr2wk2JegMWYbWhAtFX/en/CUDqpLDkUahKGDhY1+WG
        lnnBqwGauaON0GL27o9Z6DCsXaM8cX71LkN8Uqw=
X-Google-Smtp-Source: ABdhPJwsDC9bqbFvVxq3Il8K1t5nZFwWkMVwSr4dlbvI9paqqXq2IMgtspS0YGQqbFvUu7baVkUxbRik6cN2qY1kd6s=
X-Received: by 2002:a25:c42:: with SMTP id 63mr3275054ybm.219.1641865789528;
 Mon, 10 Jan 2022 17:49:49 -0800 (PST)
MIME-Version: 1.0
References: <20211229215646.830451-1-void@manifault.com> <1f1b9b01-cfab-8a84-f35f-c21172e5d64d@redhat.com>
 <CAPhsuW4Ua2hDs5WMtF0s_CQki-ZdYMvkU2s+Nc7Rvs=-D6WL=Q@mail.gmail.com> <4df1f9a0-3b26-903b-fe63-af5e75ed98d4@redhat.com>
In-Reply-To: <4df1f9a0-3b26-903b-fe63-af5e75ed98d4@redhat.com>
From:   Song Liu <song@kernel.org>
Date:   Mon, 10 Jan 2022 17:49:38 -0800
X-Gmail-Original-Message-ID: <CAPhsuW7O6br8BtAb0Tnx2aMJODfp5Rvxn-YABPUCuL1ofNPcyw@mail.gmail.com>
Message-ID: <CAPhsuW7O6br8BtAb0Tnx2aMJODfp5Rvxn-YABPUCuL1ofNPcyw@mail.gmail.com>
Subject: Re: [PATCH] livepatch: Avoid CPU hogging with cond_resched
To:     Joe Lawrence <joe.lawrence@redhat.com>
Cc:     David Vernet <void@manifault.com>, live-patching@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>, jpoimboe@redhat.com,
        pmladek@suse.com, jikos@kernel.org, mbenes@suse.cz
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Mon, Jan 10, 2022 at 8:17 AM Joe Lawrence <joe.lawrence@redhat.com> wrote:
>
> On 1/7/22 11:46 AM, Song Liu wrote:
> > On Fri, Jan 7, 2022 at 6:13 AM Joe Lawrence <joe.lawrence@redhat.com> wrote:
> >>
> >> On 12/29/21 4:56 PM, David Vernet wrote:
> >>> For example, under certain workloads, enabling a KLP patch with
> >>> many objects or functions may cause ksoftirqd to be starved, and thus for
> >>> interrupts to be backlogged and delayed.
> >>
> >> Just curious, approximately how many objects/functions does it take to
> >> hit this condition?  While the livepatching kselftests are more about
> >> API and kernel correctness, this sounds like an interesting test case
> >> for some of the other (out of tree) test suites.
> >
> > Not many patched functions. We only do small fixes at the moment. In the recent
> > example, we hit the issue with ~10 patched functions. Another version
> > with 2 to 3
> > patched function seems fine.
> >
> > Yes, I think this is an important test case.
> >
>
> Thanks, Song.  If you can share any test setup details, I'll pass those
> along to our internal QE group.  And once merged, we'll be adding this
> one to the list of backports for our distro.

We get this on shadow production traffic of our web service, which we cannot
recreate out of our data centers.
I tried to use iperf to generate traffic (among a few hosts), but it
doesn't work.
At the moment, I am not sure what's the easiest way to repro this.

Thanks,
Song
