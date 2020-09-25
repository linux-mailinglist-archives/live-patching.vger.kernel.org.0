Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 025EE278972
	for <lists+live-patching@lfdr.de>; Fri, 25 Sep 2020 15:23:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728919AbgIYNXp (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 25 Sep 2020 09:23:45 -0400
Received: from mx2.suse.de ([195.135.220.15]:44704 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728643AbgIYNXo (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 25 Sep 2020 09:23:44 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 6B7F9B509;
        Fri, 25 Sep 2020 13:07:01 +0000 (UTC)
Date:   Fri, 25 Sep 2020 15:06:55 +0200 (CEST)
From:   Miroslav Benes <mbenes@suse.cz>
To:     Kristen Carlson Accardi <kristen@linux.intel.com>
cc:     keescook@chromium.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, arjan@linux.intel.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com,
        rick.p.edgecombe@intel.com, live-patching@vger.kernel.org
Subject: Re: [PATCH v5 00/10] Function Granular KASLR
In-Reply-To: <20200923173905.11219-1-kristen@linux.intel.com>
Message-ID: <alpine.LSU.2.21.2009251450260.13615@pobox.suse.cz>
References: <20200923173905.11219-1-kristen@linux.intel.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hi Kristen,

On Wed, 23 Sep 2020, Kristen Carlson Accardi wrote:

> Function Granular Kernel Address Space Layout Randomization (fgkaslr)
> ---------------------------------------------------------------------
> 
> This patch set is an implementation of finer grained kernel address space
> randomization. It rearranges your kernel code at load time 
> on a per-function level granularity, with only around a second added to
> boot time.

I ran live patching kernel selftests on the patch set and everything 
passed fine.

However, we also use not-yet-upstream set of tests at SUSE for testing 
live patching [1] and one of them, klp_tc_12.sh, is failing. You should be 
able to run the set on upstream as is.

The test uninterruptedly sleeps in a kretprobed function called by a 
patched one. The current master without fgkaslr patch set reports the 
stack of the sleeping task as unreliable and live patching fails. The 
situation is different with fgkaslr (even with nofgkaslr on the command 
line). The stack is returned as reliable. It looks something like 

[<0>] __schedule+0x465/0xa40
[<0>] schedule+0x55/0xd0
[<0>] orig_do_sleep+0xb1/0x110 [klp_test_support_mod]
[<0>] swap_pages+0x7f/0x7f

where the last entry is not reliable. I've seen 
kretprobe_trampoline+0x0/0x4a and some other symbols there too. Since the 
patched function (orig_sleep_uninterruptible_set) is not on the stack, 
live patching succeeds, which is not intended.

With kprobe setting removed, all works as expected.

So I wonder if there is still some issue with ORC somewhere as you 
mentioned in v4 thread. I'll investigate more next week, but wanted to 
report early.

Regards
Miroslav

[1] https://github.com/lpechacek/qa_test_klp
