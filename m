Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C905487AA7
	for <lists+live-patching@lfdr.de>; Fri,  7 Jan 2022 17:46:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240085AbiAGQq5 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 7 Jan 2022 11:46:57 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:35374 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240038AbiAGQq5 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 7 Jan 2022 11:46:57 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9F93161F63;
        Fri,  7 Jan 2022 16:46:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B804C36AEF;
        Fri,  7 Jan 2022 16:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641574016;
        bh=uY8qyK5QY52TdDm0IBri989Ttzdm1zbibvJDDniXh4U=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=bpu/vrNhak7b95ZBgmQlriTRt7oaTeTtLK3MqWS3u0PIJ+gwLYn66cl5Ty8rQgJKg
         9Jwezafy84yqyYTWUuXQ3KSJntANN/HkRsQdb7ENNaXmzdBiKAlp0rSwTPAPkvfF7L
         Y33zr5gH1+AxB0UvHQyY/sYNkq3T4pN7MFjawZRz3CBMY6Q6so65iZaZ0ce+2Q35C9
         INgINOdsNqXYXc/gr8M+UAArxOvJHmfdsz9zXkx8Rb4i1vL5RYbNNh3GmRHR3y/IDO
         6ymHLl6r47EvDRhF2/p7AAP2/vz1kX+DFojRuBA7L15t1hHXjHAxlx6zXzvDEJSQ2k
         8BqL492OFwUVw==
Received: by mail-yb1-f175.google.com with SMTP id d201so18310206ybc.7;
        Fri, 07 Jan 2022 08:46:55 -0800 (PST)
X-Gm-Message-State: AOAM533Vwze6CJuc0D5AFe5+rnuyw6MMr9DTzOgOGFWkmb3CiO4CfSw4
        8Eth6HPWRLIbLdKO8N0dgoU+U3/zmiKV2EMJVDU=
X-Google-Smtp-Source: ABdhPJxPBE7HCwAiCj6POan6TNgTerrP9DAYS4LQmDmyoY4KD1kUjFNihbISjMKwJL06bWBbmkh5TO4TFUeO1A6blX0=
X-Received: by 2002:a5b:c01:: with SMTP id f1mr84256178ybq.47.1641574015121;
 Fri, 07 Jan 2022 08:46:55 -0800 (PST)
MIME-Version: 1.0
References: <20211229215646.830451-1-void@manifault.com> <1f1b9b01-cfab-8a84-f35f-c21172e5d64d@redhat.com>
In-Reply-To: <1f1b9b01-cfab-8a84-f35f-c21172e5d64d@redhat.com>
From:   Song Liu <song@kernel.org>
Date:   Fri, 7 Jan 2022 08:46:44 -0800
X-Gmail-Original-Message-ID: <CAPhsuW4Ua2hDs5WMtF0s_CQki-ZdYMvkU2s+Nc7Rvs=-D6WL=Q@mail.gmail.com>
Message-ID: <CAPhsuW4Ua2hDs5WMtF0s_CQki-ZdYMvkU2s+Nc7Rvs=-D6WL=Q@mail.gmail.com>
Subject: Re: [PATCH] livepatch: Avoid CPU hogging with cond_resched
To:     Joe Lawrence <joe.lawrence@redhat.com>
Cc:     David Vernet <void@manifault.com>, live-patching@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>, jpoimboe@redhat.com,
        pmladek@suse.com, jikos@kernel.org, mbenes@suse.cz
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri, Jan 7, 2022 at 6:13 AM Joe Lawrence <joe.lawrence@redhat.com> wrote:
>
> On 12/29/21 4:56 PM, David Vernet wrote:
> > For example, under certain workloads, enabling a KLP patch with
> > many objects or functions may cause ksoftirqd to be starved, and thus for
> > interrupts to be backlogged and delayed.
>
> Just curious, approximately how many objects/functions does it take to
> hit this condition?  While the livepatching kselftests are more about
> API and kernel correctness, this sounds like an interesting test case
> for some of the other (out of tree) test suites.

Not many patched functions. We only do small fixes at the moment. In the recent
example, we hit the issue with ~10 patched functions. Another version
with 2 to 3
patched function seems fine.

Yes, I think this is an important test case.

Song
