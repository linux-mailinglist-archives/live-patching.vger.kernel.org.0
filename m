Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E5E42F7AEE
	for <lists+live-patching@lfdr.de>; Fri, 15 Jan 2021 13:58:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387505AbhAOMej (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 15 Jan 2021 07:34:39 -0500
Received: from foss.arm.com ([217.140.110.172]:38960 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387500AbhAOMei (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 15 Jan 2021 07:34:38 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 986DEED1;
        Fri, 15 Jan 2021 04:33:52 -0800 (PST)
Received: from C02TD0UTHF1T.local (unknown [10.57.41.13])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BD5D03F70D;
        Fri, 15 Jan 2021 04:33:50 -0800 (PST)
Date:   Fri, 15 Jan 2021 12:33:47 +0000
From:   Mark Rutland <mark.rutland@arm.com>
To:     "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Cc:     linux-arm-kernel@lists.infradead.org,
        Mark Brown <broonie@kernel.org>,
        Julien Thierry <jthierry@redhat.com>, jpoimboe@redhat.com,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Live patching on ARM64
Message-ID: <20210115123347.GB39776@C02TD0UTHF1T.local>
References: <f3fe6a60-9ac2-591d-1b83-9113c50dc492@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f3fe6a60-9ac2-591d-1b83-9113c50dc492@linux.microsoft.com>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu, Jan 14, 2021 at 04:07:55PM -0600, Madhavan T. Venkataraman wrote:
> Hi all,
> 
> My name is Madhavan Venkataraman.

Hi Madhavan,

> Microsoft is very interested in Live Patching support for ARM64.
> On behalf of Microsoft, I would like to contribute.
> 
> I would like to get in touch with the people who are currently working
> in this area, find out what exactly they are working on and see if they
> could use an extra pair of eyes/hands with what they are working on.
> 
> It looks like the most recent work in this area has been from the
> following folks:
> 
> Mark Brown and Mark Rutland:
> 	Kernel changes to providing reliable stack traces.
> 
> Julien Thierry:
> 	Providing ARM64 support in objtool.
> 
> Torsten Duwe:
> 	Ftrace with regs.

IIRC that's about right. I'm also trying to make arm64 patch-safe (more
on that below), and there's a long tail of work there for anyone
interested.

> I apologize if I have missed anyone else who is working on Live Patching
> for ARM64. Do let me know.
> 
> Is there any work I can help with? Any areas that need investigation, any code
> that needs to be written, any work that needs to be reviewed, any testing that
> needs to done? You folks are probably super busy and would not mind an extra
> hand.

One general thing that I believe we'll need to do is to rework code to
be patch-safe (which implies being noinstr-safe too). For example, we'll
need to rework the instruction patching code such that this cannot end
up patching itself (or anything that has instrumented it) in an unsafe
way.

Once we have objtool it should be possible to identify those cases
automatically. Currently I'm aware that we'll need to do something in at
least the following places:

* The entry code -- I'm currently chipping away at this.

* The insn framework (which is used by some patching code), since the
  bulk of it lives in arch/arm64/kernel/insn.c and isn't marked noinstr.
  
  We can probably shift the bulk of the aarch64_insn_gen_*() and
  aarch64_get_*() helpers into a header as __always_inline functions,
  which would allow them to be used in noinstr code. As those are
  typically invoked with a number of constant arguments that the
  compiler can fold, this /might/ work out as an optimization if the
  compiler can elide the error paths.

* The alternatives code, since we call instrumentable and patchable
  functions between updating instructions and performing all the
  necessary maintenance. There are a number of cases within
  __apply_alternatives(), e.g.

  - test_bit()
  - cpus_have_cap()
  - pr_info_once()
  - lm_alias()
  - alt_cb, if the callback is not marked as noinstr, or if it calls
    instrumentable code (e.g. from the insn framework).
  - clean_dcache_range_nopatch(), as read_sanitised_ftr_reg() and
    related code can be instrumented.

  This might need some underlying rework elsewhere (e.g. in the
  cpufeature code, or atomics framework).

So on the kernel side, maybe a first step would be to try to headerize
the insn generation code as __always_inline, and see whether that looks
ok? With that out of the way it'd be a bit easier to rework patching
code depending on the insn framework.

I'm not sure about the objtool side, so I'll leave that to Julien and co
to answer.

Thanks,
Mark.
