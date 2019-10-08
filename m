Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4EF0DD0173
	for <lists+live-patching@lfdr.de>; Tue,  8 Oct 2019 21:50:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729602AbfJHTuZ (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 8 Oct 2019 15:50:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:42322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729385AbfJHTuZ (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Tue, 8 Oct 2019 15:50:25 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7BEC321835;
        Tue,  8 Oct 2019 19:50:24 +0000 (UTC)
Date:   Tue, 8 Oct 2019 15:50:22 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Joe Lawrence <joe.lawrence@redhat.com>
Cc:     Miroslav Benes <mbenes@suse.cz>, mingo@redhat.com,
        jpoimboe@redhat.com, jikos@kernel.org, pmladek@suse.com,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org
Subject: Re: [PATCH 0/3] ftrace: Introduce PERMANENT ftrace_ops flag
Message-ID: <20191008155022.61db3108@gandalf.local.home>
In-Reply-To: <20191008193534.GA16675@redhat.com>
References: <20191007081714.20259-1-mbenes@suse.cz>
        <20191008193534.GA16675@redhat.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, 8 Oct 2019 15:35:34 -0400
Joe Lawrence <joe.lawrence@redhat.com> wrote:

> 
> I wonder if the opposite would be more intuitive: when ftrace_enabled is
> not set, don't allow livepatches to register ftrace filters and
> likewise, don't allow ftrace_enabled to be unset if any livepatches are
> already registered.  I guess you could make an argument either way, but
> just offering another option.  Perhaps livepatches should follow similar
> behavior of other ftrace clients (like perf probes?)

I believe I suggested the "PERMANENT" flag, but disabling ftrace_enable
may be another approach. Might be much easier to maintain.

> 
> As for the approach in this patchset, is it consistent that livepatches
> loaded after setting ftrace_enabled to 0 will successfully load, but not
> execute their new code...  but then when ftrace_enabled is toggled, the
> new livepatch code remains on?
> 
> For example:
> 
> 1 - Turn ftrace_enabled off and load the /proc/cmdline livepatch test
>     case, note that it reports a success patching transition, but
>     doesn't run new its code:
> 
>   % dmesg -C
>   % sysctl kernel.ftrace_enabled=0
>   kernel.ftrace_enabled = 0
>   % insmod lib/livepatch/test_klp_livepatch.ko 
>   % echo $?
>   0
>   % dmesg
>   [  450.579980] livepatch: enabling patch 'test_klp_livepatch'
>   [  450.581243] livepatch: 'test_klp_livepatch': starting patching transition
>   [  451.942971] livepatch: 'test_klp_livepatch': patching complete
>   % cat /proc/cmdline 
>   BOOT_IMAGE=(hd0,msdos1)/boot/vmlinuz-5.4.0-rc2+ root=UUID=c42bb089-b5c1-4e17-82bd-132f55bee54c ro console=ttyS0 console=ttyS0,115200n8 no_timer_check net.ifnames=0 crashkernel=auto
> 
> 2 - Turn ftrace_enabled on and see that the livepatch now works:
> 
>   % sysctl kernel.ftrace_enabled=1
>   kernel.ftrace_enabled = 1
>   % cat /proc/cmdline 
>   test_klp_livepatch: this has been live patched
> 
> 3 - Turn ftrace_enabled off and see that it's still enabled:
> 
>   % sysctl kernel.ftrace_enabled=0
>   kernel.ftrace_enabled = 0
>   % cat /proc/cmdline 
>   test_klp_livepatch: this has been live patched
> 
> Steps 2 and 3 match the behavior described by the patchset, but I was
> particularly wondering what you thought about step 1.
> 
> IMHO, I would expect step 1 to fully enable the livepatch, or at the
> very least, not report a patch transition (though that may confuse
> userspace tools waiting for that report).
> 

I think I like your idea better. To prevent ftrace_enable from being
disabled if a "permanent" option is set. Then we only need to have a
permanent flag for the ftrace_ops, that will disable the ftrace_enable
from being cleared. We can also prevent the ftrace_ops from being
loaded if ftrace_enable is not set and the ftrace_ops has the PERMANENT
flag set.

-- Steve
