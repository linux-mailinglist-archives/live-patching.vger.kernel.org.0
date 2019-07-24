Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B611973297
	for <lists+live-patching@lfdr.de>; Wed, 24 Jul 2019 17:19:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387581AbfGXPTp (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 24 Jul 2019 11:19:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47626 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387503AbfGXPTp (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Wed, 24 Jul 2019 11:19:45 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A76E6C024AF3;
        Wed, 24 Jul 2019 15:19:44 +0000 (UTC)
Received: from redhat.com (ovpn-123-65.rdu2.redhat.com [10.10.123.65])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1A5D95D9DE;
        Wed, 24 Jul 2019 15:19:43 +0000 (UTC)
Date:   Wed, 24 Jul 2019 11:19:42 -0400
From:   Joe Lawrence <joe.lawrence@redhat.com>
To:     Masami Hiramatsu <mhiramat@kernel.org>
Cc:     live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: kprobes, livepatch and FTRACE_OPS_FL_IPMODIFY
Message-ID: <20190724151942.GA7205@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.12.0 (2019-05-25)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Wed, 24 Jul 2019 15:19:44 +0000 (UTC)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hi Masami,

I wanted to revisit FTRACE_OPS_FL_IPMODIFY blocking of kprobes and
livepatch, at least in cases where kprobe pre_handlers don't modify
regs->ip.

(We've discussed this previously at part of a kpatch github issue #47:
https://github.com/dynup/kpatch/issues/47)

The particular use case I was wondering about was perf probing a
particular function, then attempting to livepatch that same function:

  % uname -r
  5.3.0-rc1+

  % dmesg -C
  % perf probe --add cmdline_proc_show
  Added new event:
    probe:cmdline_proc_show (on cmdline_proc_show)

  You can now use it in all perf tools, such as:

          perf record -e probe:cmdline_proc_show -aR sleep 1

  % perf record -e probe:cmdline_proc_show -aR sleep 30 &
  [1] 1007
  % insmod samples/livepatch/livepatch-sample.ko
  insmod: ERROR: could not insert module samples/livepatch/livepatch-sample.ko: Device or resource busy
  % dmesg
  [  440.913962] livepatch_sample: tainting kernel with TAINT_LIVEPATCH
  [  440.917123] livepatch_sample: module verification failed: signature and/or required key missing - tainting kernel
  [  440.942493] livepatch: enabling patch 'livepatch_sample'
  [  440.943445] livepatch: failed to register ftrace handler for function 'cmdline_proc_show' (-16)
  [  440.944576] livepatch: failed to patch object 'vmlinux'
  [  440.945270] livepatch: failed to enable patch 'livepatch_sample'
  [  440.946085] livepatch: 'livepatch_sample': unpatching complete

This same behavior holds in reverse, if we want to probe a livepatched
function:

  % insmod samples/livepatch/livepatch-sample.ko
  % perf probe --add cmdline_proc_show
  Added new event:
    probe:cmdline_proc_show (on cmdline_proc_show)

  You can now use it in all perf tools, such as:

          perf record -e probe:cmdline_proc_show -aR sleep 1

  % perf record -e probe:cmdline_proc_show -aR sleep 30
  Error:
  The sys_perf_event_open() syscall returned with 16 (Device or resource busy) for event (probe:cmdline_proc_show).
  /bin/dmesg | grep -i perf may provide additional information.


Now, if I read kernel/trace/trace_kprobe.c :: kprobe_dispatcher()
correctly, it's only going to return !0 (indicating a modified regs->ip)
when kprobe_perf_func() returns !0, i.e. regs->ip changes over a call to
trace_call_bpf().

Aside: should kprobe_ftrace_handler() check that FTRACE_OPS_FL_IPMODIFY
is set when a pre_handler returns !0?

In kpatch #47, Josh suggested:

- If a kprobe handler needs to modify IP, user sets KPROBE_FLAG_IPMODIFY
  flag to register_kprobe, and then kprobes sets FTRACE_OPS_FL_IPMODIFY
  when registering with ftrace for that probe.

- If KPROBE_FLAG_IPMODIFY is not used, kprobe_ftrace_handler() can
  detect when a kprobe handler changes regs->ip and restore it to its
  original value (regs->ip = ip).

Is this something that could still be supported?  In cases like perf
probe, could we get away with not setting FTRACE_OPS_FL_IPMODIFY?  The
current way that we're applying that flag, kprobes and livepatch are
mutually exclusive (for the same function).

Regards,

-- Joe
