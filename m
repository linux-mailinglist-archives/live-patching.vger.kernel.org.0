Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E7C0486EB1
	for <lists+live-patching@lfdr.de>; Fri,  7 Jan 2022 01:21:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343954AbiAGAVd (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 6 Jan 2022 19:21:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343961AbiAGAVd (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 6 Jan 2022 19:21:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75DDCC061245;
        Thu,  6 Jan 2022 16:21:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 46AF0B82492;
        Fri,  7 Jan 2022 00:21:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06963C36AF2;
        Fri,  7 Jan 2022 00:21:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641514890;
        bh=q2qMck5fOGv4y0jxtZgqjCAobqyuIwo9frnw8Ud7mxA=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=J4ZYJCvHRBauWGbjUzeywmS/bUleaEcbcoOcQY2UxYQBtqBfsGGwZ8H2rocOhrk4z
         ZkeB7DRHWe41pM3c2lAOv2Eo2wmqsHcaPH+pzvnLCJVS7BJ9th3pzALPrsIFfALlaf
         cxrHwXu72Jo0Dq0WxycTh74+mXobOm7E7xPq2U5cuGekRlxbEawZhGftKkHnvufWmV
         Vk+XQKI/6IMZHl1ggUFum1pZ0Sim/Vzt9+JfqUfFqP04Ya8I5kUIL/n2cO/Gv6x76F
         v4qXx6nj7I7KH1UYamzPNzEAdjbtU6QTJbJiCf9BEQjymZSJ96o3jih1mD9oFyNJEp
         fSsa34JOiJQrA==
Received: by mail-yb1-f172.google.com with SMTP id p15so12124835ybk.10;
        Thu, 06 Jan 2022 16:21:29 -0800 (PST)
X-Gm-Message-State: AOAM531oAgn5XWSoCq0mdQ5lv3kSnNfIJniKLl4TkisaxUinCpYMt90x
        8JFtP89/usq3917eKTOFyV4uNMMEq14y+qD6zXk=
X-Google-Smtp-Source: ABdhPJxgLvLXYZlXmHmikXGfVflPrHS0ENCRiG/npwgmyeoYAYOZ9vVJX5r+xW8325l7foPEjweplWKnwXcGPABDWxs=
X-Received: by 2002:a25:dc94:: with SMTP id y142mr485732ybe.282.1641514889137;
 Thu, 06 Jan 2022 16:21:29 -0800 (PST)
MIME-Version: 1.0
References: <20211229215646.830451-1-void@manifault.com>
In-Reply-To: <20211229215646.830451-1-void@manifault.com>
From:   Song Liu <song@kernel.org>
Date:   Thu, 6 Jan 2022 16:21:18 -0800
X-Gmail-Original-Message-ID: <CAPhsuW5PL1w_72Hrbsp2b3jA-SGyzv5oLfgybkq=s8J5KL6kmw@mail.gmail.com>
Message-ID: <CAPhsuW5PL1w_72Hrbsp2b3jA-SGyzv5oLfgybkq=s8J5KL6kmw@mail.gmail.com>
Subject: Re: [PATCH] livepatch: Avoid CPU hogging with cond_resched
To:     void@manifault.com
Cc:     live-patching@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>, jpoimboe@redhat.com,
        pmladek@suse.com, jikos@kernel.org, mbenes@suse.cz,
        joe.lawrence@redhat.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, Dec 29, 2021 at 1:57 PM David Vernet <void@manifault.com> wrote:
>
> When initializing a 'struct klp_object' in klp_init_object_loaded(), and
> performing relocations in klp_resolve_symbols(), klp_find_object_symbol()
> is invoked to look up the address of a symbol in an already-loaded module
> (or vmlinux). This, in turn, calls kallsyms_on_each_symbol() or
> module_kallsyms_on_each_symbol() to find the address of the symbol that is
> being patched.
>
> It turns out that symbol lookups often take up the most CPU time when
> enabling and disabling a patch, and may hog the CPU and cause other tasks
> on that CPU's runqueue to starve -- even in paths where interrupts are
> enabled.  For example, under certain workloads, enabling a KLP patch with
> many objects or functions may cause ksoftirqd to be starved, and thus for
> interrupts to be backlogged and delayed. This may end up causing TCP
> retransmits on the host where the KLP patch is being applied, and in
> general, may cause any interrupts serviced by softirqd to be delayed while
> the patch is being applied.
>
> So as to ensure that kallsyms_on_each_symbol() does not end up hogging the
> CPU, this patch adds a call to cond_resched() in kallsyms_on_each_symbol()
> and module_kallsyms_on_each_symbol(), which are invoked when doing a symbol
> lookup in vmlinux and a module respectively.  Without this patch, if a
> live-patch is applied on a 36-core Intel host with heavy TCP traffic, a
> ~10x spike is observed in TCP retransmits while the patch is being applied.
> Additionally, collecting sched events with perf indicates that ksoftirqd is
> awakened ~1.3 seconds before it's eventually scheduled.  With the patch, no
> increase in TCP retransmit events is observed, and ksoftirqd is scheduled
> shortly after it's awakened.
>
> Signed-off-by: David Vernet <void@manifault.com>

Acked-by: Song Liu <song@kernel.org>

PS: Do we observe livepatch takes a longer time to load after this change?
(I believe longer time shouldn't be a problem at all. Just curious.)
