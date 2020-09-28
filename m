Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2354927B342
	for <lists+live-patching@lfdr.de>; Mon, 28 Sep 2020 19:31:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726634AbgI1Rbj (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 28 Sep 2020 13:31:39 -0400
Received: from mga06.intel.com ([134.134.136.31]:45297 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726566AbgI1Rbj (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Mon, 28 Sep 2020 13:31:39 -0400
IronPort-SDR: oDskYaklAm6OZ0KeaQSvCxdob4IUfx40KJGKWBn2Hay8Otpe5bpv74qlTjYoiEHXNtsVhtXyaA
 VgEwBdF4sNeQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9758"; a="223626486"
X-IronPort-AV: E=Sophos;i="5.77,313,1596524400"; 
   d="scan'208";a="223626486"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2020 10:31:23 -0700
IronPort-SDR: nnegwXXoi7LbHlIk1Pd+tsGxn9JbuR27+0akBxZ4pcYrJQ9v0nROBkslvXlIyZUjL5r4NJhmqe
 AOm2fw7NMmfw==
X-IronPort-AV: E=Sophos;i="5.77,313,1596524400"; 
   d="scan'208";a="324365155"
Received: from kcaccard-mobl.amr.corp.intel.com (HELO kcaccard-mobl1.jf.intel.com) ([10.212.204.13])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2020 10:31:19 -0700
Message-ID: <5d9b4b306b9cc9109286e2d8f7213be3296d6aa8.camel@linux.intel.com>
Subject: Re: [PATCH v5 00/10] Function Granular KASLR
From:   Kristen Carlson Accardi <kristen@linux.intel.com>
To:     Miroslav Benes <mbenes@suse.cz>
Cc:     keescook@chromium.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, arjan@linux.intel.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com,
        rick.p.edgecombe@intel.com, live-patching@vger.kernel.org
Date:   Mon, 28 Sep 2020 10:31:12 -0700
In-Reply-To: <alpine.LSU.2.21.2009251450260.13615@pobox.suse.cz>
References: <20200923173905.11219-1-kristen@linux.intel.com>
         <alpine.LSU.2.21.2009251450260.13615@pobox.suse.cz>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hi,

On Fri, 2020-09-25 at 15:06 +0200, Miroslav Benes wrote:
> Hi Kristen,
> 
> On Wed, 23 Sep 2020, Kristen Carlson Accardi wrote:
> 
> > Function Granular Kernel Address Space Layout Randomization
> > (fgkaslr)
> > -----------------------------------------------------------------
> > ----
> > 
> > This patch set is an implementation of finer grained kernel address
> > space
> > randomization. It rearranges your kernel code at load time 
> > on a per-function level granularity, with only around a second
> > added to
> > boot time.
> 
> I ran live patching kernel selftests on the patch set and everything 
> passed fine.
> 
> However, we also use not-yet-upstream set of tests at SUSE for
> testing 
> live patching [1] and one of them, klp_tc_12.sh, is failing. You
> should be 
> able to run the set on upstream as is.
> 
> The test uninterruptedly sleeps in a kretprobed function called by a 
> patched one. The current master without fgkaslr patch set reports
> the 
> stack of the sleeping task as unreliable and live patching fails.
> The 
> situation is different with fgkaslr (even with nofgkaslr on the
> command 
> line). The stack is returned as reliable. It looks something like 
> 
> [<0>] __schedule+0x465/0xa40
> [<0>] schedule+0x55/0xd0
> [<0>] orig_do_sleep+0xb1/0x110 [klp_test_support_mod]
> [<0>] swap_pages+0x7f/0x7f
> 
> where the last entry is not reliable. I've seen 
> kretprobe_trampoline+0x0/0x4a and some other symbols there too. Since
> the 
> patched function (orig_sleep_uninterruptible_set) is not on the
> stack, 
> live patching succeeds, which is not intended.
> 
> With kprobe setting removed, all works as expected.
> 
> So I wonder if there is still some issue with ORC somewhere as you 
> mentioned in v4 thread. I'll investigate more next week, but wanted
> to 
> report early.
> 
> Regards
> Miroslav
> 
> [1] https://github.com/lpechacek/qa_test_klp

Thanks for testing and reporting. I will grab your test and see what I
can find.


