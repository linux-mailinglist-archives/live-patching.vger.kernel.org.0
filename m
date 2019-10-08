Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F55BD0143
	for <lists+live-patching@lfdr.de>; Tue,  8 Oct 2019 21:35:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729854AbfJHTfh (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 8 Oct 2019 15:35:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41000 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729602AbfJHTfh (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Tue, 8 Oct 2019 15:35:37 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 130508553D;
        Tue,  8 Oct 2019 19:35:37 +0000 (UTC)
Received: from redhat.com (dhcp-17-119.bos.redhat.com [10.18.17.119])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 221D810013A1;
        Tue,  8 Oct 2019 19:35:36 +0000 (UTC)
Date:   Tue, 8 Oct 2019 15:35:34 -0400
From:   Joe Lawrence <joe.lawrence@redhat.com>
To:     Miroslav Benes <mbenes@suse.cz>
Cc:     rostedt@goodmis.org, mingo@redhat.com, jpoimboe@redhat.com,
        jikos@kernel.org, pmladek@suse.com, linux-kernel@vger.kernel.org,
        live-patching@vger.kernel.org
Subject: Re: [PATCH 0/3] ftrace: Introduce PERMANENT ftrace_ops flag
Message-ID: <20191008193534.GA16675@redhat.com>
References: <20191007081714.20259-1-mbenes@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191007081714.20259-1-mbenes@suse.cz>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.28]); Tue, 08 Oct 2019 19:35:37 +0000 (UTC)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Mon, Oct 07, 2019 at 10:17:11AM +0200, Miroslav Benes wrote:
> Livepatch uses ftrace for redirection to new patched functions. It is
> thus directly affected by ftrace sysctl knobs such as ftrace_enabled.
> Setting ftrace_enabled to 0 also disables all live patched functions. It
> is not a problem per se, because only administrator can set sysctl
> values, but it still may be surprising.
> 
> Introduce PERMANENT ftrace_ops flag to amend this. If the
> FTRACE_OPS_FL_PERMANENT is set, the tracing of the function is not
> disabled. Such ftrace_ops can still be unregistered in a standard way.
> 
> The patch set passes ftrace and livepatch kselftests.
> 
> Miroslav Benes (3):
>   ftrace: Make test_rec_ops_needs_regs() generic
>   ftrace: Introduce PERMANENT ftrace_ops flag
>   livepatch: Use FTRACE_OPS_FL_PERMANENT
> 
>  Documentation/trace/ftrace-uses.rst |  6 ++++
>  Documentation/trace/ftrace.rst      |  2 ++
>  include/linux/ftrace.h              |  8 +++--
>  kernel/livepatch/patch.c            |  3 +-
>  kernel/trace/ftrace.c               | 47 ++++++++++++++++++++++++-----
>  5 files changed, 55 insertions(+), 11 deletions(-)
> 
> -- 
> 2.23.0
> 

Hi Miroslav,

I wonder if the opposite would be more intuitive: when ftrace_enabled is
not set, don't allow livepatches to register ftrace filters and
likewise, don't allow ftrace_enabled to be unset if any livepatches are
already registered.  I guess you could make an argument either way, but
just offering another option.  Perhaps livepatches should follow similar
behavior of other ftrace clients (like perf probes?)

As for the approach in this patchset, is it consistent that livepatches
loaded after setting ftrace_enabled to 0 will successfully load, but not
execute their new code...  but then when ftrace_enabled is toggled, the
new livepatch code remains on?

For example:

1 - Turn ftrace_enabled off and load the /proc/cmdline livepatch test
    case, note that it reports a success patching transition, but
    doesn't run new its code:

  % dmesg -C
  % sysctl kernel.ftrace_enabled=0
  kernel.ftrace_enabled = 0
  % insmod lib/livepatch/test_klp_livepatch.ko 
  % echo $?
  0
  % dmesg
  [  450.579980] livepatch: enabling patch 'test_klp_livepatch'
  [  450.581243] livepatch: 'test_klp_livepatch': starting patching transition
  [  451.942971] livepatch: 'test_klp_livepatch': patching complete
  % cat /proc/cmdline 
  BOOT_IMAGE=(hd0,msdos1)/boot/vmlinuz-5.4.0-rc2+ root=UUID=c42bb089-b5c1-4e17-82bd-132f55bee54c ro console=ttyS0 console=ttyS0,115200n8 no_timer_check net.ifnames=0 crashkernel=auto

2 - Turn ftrace_enabled on and see that the livepatch now works:

  % sysctl kernel.ftrace_enabled=1
  kernel.ftrace_enabled = 1
  % cat /proc/cmdline 
  test_klp_livepatch: this has been live patched

3 - Turn ftrace_enabled off and see that it's still enabled:

  % sysctl kernel.ftrace_enabled=0
  kernel.ftrace_enabled = 0
  % cat /proc/cmdline 
  test_klp_livepatch: this has been live patched

Steps 2 and 3 match the behavior described by the patchset, but I was
particularly wondering what you thought about step 1.

IMHO, I would expect step 1 to fully enable the livepatch, or at the
very least, not report a patch transition (though that may confuse
userspace tools waiting for that report).

Thanks,

-- Joe
