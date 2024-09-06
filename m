Return-Path: <live-patching+bounces-626-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0DFAF96FE17
	for <lists+live-patching@lfdr.de>; Sat,  7 Sep 2024 00:46:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BBCD22870D8
	for <lists+live-patching@lfdr.de>; Fri,  6 Sep 2024 22:46:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F23FE157A72;
	Fri,  6 Sep 2024 22:46:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cpBZwAx7"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8CE113D248;
	Fri,  6 Sep 2024 22:46:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725662761; cv=none; b=B5Oq0e1zsnscHFPJD3avBp/gzJiKNwLYc6FwoXz3mhWjidCsARF7l7qbQOFJRt2FFI2BLLT71BzTAzXslDRTvyo7psUbN2JAk+0uMJe/VtYVtWndPy08wzV+K97DPOVupuwr6O3sspnUJSEG6wfnWn53cnDAZxq2aodO81AnVro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725662761; c=relaxed/simple;
	bh=pgy10sINnl3wg5V5uZT+kLYtn7sjQNqFtgevoyHcgl8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dSFxNwJxmANm2N/RoCQOcdoWg3ZwXT197fF0tcQuzl2A9Wzn+9Fya1RDaLrCJZCQAD/CgmVjd/Q4dgGUw55vw8FqcJapZovc1LwDA391f5qh2Zpr6+LPqBrG+UNS9BUzPMms7M9uxv3tJgMd9MP3TB5wjMlo2qF3xLKOfusT+Wo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cpBZwAx7; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBBEDC4CEC4;
	Fri,  6 Sep 2024 22:45:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725662761;
	bh=pgy10sINnl3wg5V5uZT+kLYtn7sjQNqFtgevoyHcgl8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cpBZwAx7yliuYL/V7IhiXW0QcYq/c9F8TkHWZCljXLKwLPLDP07pr9y2YFAfjCzlX
	 hJkgbtmIIYg/m9jyZc6dp3BmSZe7jVt0YCXybivc4lcJ8i2vC9l0N3RFxVg2l1Yeul
	 Q6lnYcFaHMwWHPQeQju5CfzdPZpJYbDrjTWDWNXZDEIkNMsUgASMV3aCQfI69JkYab
	 ZPSMx9HYNkzckHRt1CJaBsK5VD7xVbL3roBcYGDnuT5eDYru2tGF0lGQ/56MQi6oGH
	 J8ssxWASA98rE4iY2hHvQWHmNKLGXHFq+5AvPMH8cYpvHegmQCvtYubZajq1xtMFRJ
	 Og7Aq5D0SW9qg==
Date: Fri, 6 Sep 2024 15:45:49 -0700
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Joe Lawrence <joe.lawrence@redhat.com>
Cc: live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
	x86@kernel.org, Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>, Jiri Kosina <jikos@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Marcos Paulo de Souza <mpdesouza@suse.com>,
	Song Liu <song@kernel.org>
Subject: Re: [RFC 00/31] objtool, livepatch: Livepatch module generation
Message-ID: <20240906224549.3et6ikhqi6vr2d3m@treble>
References: <cover.1725334260.git.jpoimboe@kernel.org>
 <ZtsJ9qIPcADVce2i@redhat.com>
 <20240906170008.fc7h3vqdpwnkok3b@treble>
 <Ztttv0Eo/FHyxo78@redhat.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Ztttv0Eo/FHyxo78@redhat.com>

On Fri, Sep 06, 2024 at 05:01:51PM -0400, Joe Lawrence wrote:
> On Fri, Sep 06, 2024 at 10:00:08AM -0700, Josh Poimboeuf wrote:
> > On Fri, Sep 06, 2024 at 09:56:06AM -0400, Joe Lawrence wrote:
> > > In the case of klp-diff.c, adding #include <string.h> will provide the
> > > memmem prototype.  For both files, I needed to #define _GNU_SOURCE for
> > > that prototype though.
> > > 
> > > For the other complaint, I just set struct instruction *dest_insn = NULL
> > > at the top of the for loop, but perhaps the code could be refactored to
> > > clarify the situation to the compiler if you prefer not to do that.
> > 
> > Thanks!  I'll get these fixed up.
> > 
> 
> Also, with the workarounds mentioned above, the two you sent to Song,
> and the same .config I attached in the first email, I get the following
> error when trying to build the canonical /proc/cmdline example:
> 
>   $ cat cmdline-string.patch 
>   diff --git a/fs/proc/cmdline.c b/fs/proc/cmdline.c
>   index a6f76121955f..2bcaf9ec6f78 100644
>   --- a/fs/proc/cmdline.c
>   +++ b/fs/proc/cmdline.c
>   @@ -7,8 +7,7 @@
>    
>    static int cmdline_proc_show(struct seq_file *m, void *v)
>    {
>   -       seq_puts(m, saved_command_line);
>   -       seq_putc(m, '\n');
>   +       seq_printf(m, "%s kpatch=1", saved_command_line);
>           return 0;
>    }
> 
> 
>   $ ./scripts/livepatch/klp-build ./cmdline-string.patch 2>&1 | tee build2.out
>   - klp-build: building original kernel
>   vmlinux.o: warning: objtool: init_espfix_bsp+0xab: unreachable instruction
>   vmlinux.o: warning: objtool: init_espfix_ap+0x50: unreachable instruction
>   vmlinux.o: warning: objtool: syscall_init+0xca: unreachable instruction
>   vmlinux.o: warning: objtool: sync_core_before_usermode+0xf: unreachable instruction
>   vmlinux.o: warning: objtool: sync_core_before_usermode+0xf: unreachable instruction
>   vmlinux.o: warning: objtool: tc_wrapper_init+0x16: unreachable instruction
>   vmlinux.o: warning: objtool: pvh_start_xen+0x50: relocation to !ENDBR: pvh_start_xen+0x57
>   - klp-build: building patched kernel
>   vmlinux.o: warning: objtool: init_espfix_bsp+0xab: unreachable instruction
>   vmlinux.o: warning: objtool: init_espfix_ap+0x50: unreachable instruction
>   vmlinux.o: warning: objtool: syscall_init+0xca: unreachable instruction
>   vmlinux.o: warning: objtool: sync_core_before_usermode+0xf: unreachable instruction
>   vmlinux.o: warning: objtool: sync_core_before_usermode+0xf: unreachable instruction
>   vmlinux.o: warning: objtool: tc_wrapper_init+0x16: unreachable instruction
>   vmlinux.o: warning: objtool: pvh_start_xen+0x50: relocation to !ENDBR: pvh_start_xen+0x57
>   - klp-build: diffing objects
>   kvm.o: added: __UNIQUE_ID_nop_644
>   kvm.o: added: __UNIQUE_ID_nop_645
>   kvm.o: added: __UNIQUE_ID_nop_646
>   kvm.o: added: __UNIQUE_ID_nop_647
>   kvm.o: added: __UNIQUE_ID_nop_648
>   kvm.o: added: __UNIQUE_ID_nop_649
>   kvm.o: added: __UNIQUE_ID_nop_650
>   kvm.o: added: __UNIQUE_ID_nop_651
>   kvm.o: added: __UNIQUE_ID_nop_652
>   vmlinux.o: changed: cmdline_proc_show
>   - klp-build: building patch module
>   make[2]: /bin/sh: Argument list too long
>   make[2]: *** [scripts/Makefile.build:253: /home/jolawren/src/linux/klp-tmp/out/livepatch.mod] Error 127
>   make[1]: *** [/home/jolawren/src/linux/Makefile:1943: /home/jolawren/src/linux/klp-tmp/out] Error 2
>   make: *** [Makefile:240: __sub-make] Error 2
>   klp-build: error: module build failed
> 
> I'm guessing that this happens because of the huge dependency line in
> klp-tmp/out/Kbuild for livepatch-y, it includes over 2000 object files
> (that I'm pretty sure didn't change :)

Hm, did you get this fix?

https://lkml.kernel.org/lkml/20240904070952.kkafz2w5m7wnhblh@treble

-- 
Josh

