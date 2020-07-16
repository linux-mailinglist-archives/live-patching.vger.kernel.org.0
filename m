Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2593222A0A
	for <lists+live-patching@lfdr.de>; Thu, 16 Jul 2020 19:37:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728402AbgGPRho (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 16 Jul 2020 13:37:44 -0400
Received: from mga17.intel.com ([192.55.52.151]:8831 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727844AbgGPRhn (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 16 Jul 2020 13:37:43 -0400
IronPort-SDR: tW7gg4/KGkl+DzODuKNzzPTwnvp75POsfYZYNAsUIcMYlH3ND1qiuiiJYz9dI8kWECCdZoEKUS
 0wEM3mzxqPCg==
X-IronPort-AV: E=McAfee;i="6000,8403,9684"; a="129531979"
X-IronPort-AV: E=Sophos;i="5.75,360,1589266800"; 
   d="scan'208";a="129531979"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jul 2020 10:37:42 -0700
IronPort-SDR: Yht4DgPOikZmYOd5giPSDZealJ80taRpkvvN+/vv7pCF3nVML6W661HGp0qnX0rlQpJuE/YTYO
 0Y5jTTZUuQeg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,360,1589266800"; 
   d="scan'208";a="325207690"
Received: from unknown (HELO localhost) ([10.249.34.156])
  by FMSMGA003.fm.intel.com with ESMTP; 16 Jul 2020 10:37:35 -0700
Date:   Thu, 16 Jul 2020 20:37:34 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Masami Hiramatsu <mhiramat@kernel.org>
Cc:     linux-kernel@vger.kernel.org, x86@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>, Jessica Yu <jeyu@kernel.org>,
        "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        "open list:LIVE PATCHING" <live-patching@vger.kernel.org>
Subject: Re: [PATCH v3 2/3] module: Add lock_modules() and unlock_modules()
Message-ID: <20200716173734.GF14135@linux.intel.com>
References: <20200714223239.1543716-1-jarkko.sakkinen@linux.intel.com>
 <20200714223239.1543716-3-jarkko.sakkinen@linux.intel.com>
 <20200715173939.40e235a5035ea698e38b7ee7@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200715173939.40e235a5035ea698e38b7ee7@kernel.org>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, Jul 15, 2020 at 05:39:39PM +0900, Masami Hiramatsu wrote:
> On Wed, 15 Jul 2020 01:32:28 +0300
> Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com> wrote:
> 
> > Add wrappers to take the modules "big lock" in order to encapsulate
> > conditional compilation (CONFIG_MODULES) inside the wrapper.
> > 
> > Cc: Andi Kleen <ak@linux.intel.com>
> > Suggested-by: Masami Hiramatsu <mhiramat@kernel.org>
> > Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> > ---
> >  include/linux/module.h      | 15 ++++++++++
> >  kernel/kprobes.c            |  4 +--
> >  kernel/livepatch/core.c     |  8 ++---
> >  kernel/module.c             | 60 ++++++++++++++++++-------------------
> >  kernel/trace/trace_kprobe.c |  4 +--
> >  5 files changed, 53 insertions(+), 38 deletions(-)
> > 
> > diff --git a/include/linux/module.h b/include/linux/module.h
> > index 2e6670860d27..857b84bf9e90 100644
> > --- a/include/linux/module.h
> > +++ b/include/linux/module.h
> > @@ -902,4 +902,19 @@ static inline bool module_sig_ok(struct module *module)
> >  }
> >  #endif	/* CONFIG_MODULE_SIG */
> >  
> > +#ifdef CONFIG_MODULES
> > +static inline void lock_modules(void)
> > +{
> > +	mutex_lock(&module_mutex);
> > +}
> > +
> > +static inline void unlock_modules(void)
> > +{
> > +	mutex_unlock(&module_mutex);
> > +}
> > +#else
> > +static inline void lock_modules(void) { }
> > +static inline void unlock_modules(void) { }
> > +#endif
> 
> You don't need to add new #ifdefs. There is a room for dummy prototypes
> for !CONFIG_MODULES already in modules.h.
> 
> -----
> struct notifier_block;
> 
> #ifdef CONFIG_MODULES
> 
> extern int modules_disabled; /* for sysctl */
> 
> ...
> #else /* !CONFIG_MODULES... */
> 
> static inline struct module *__module_address(unsigned long addr)
> {
> -----
> 
> So you can just put those inlines in the appropriate places ;)
> 
> Thank you,

Rrright.

/Jarkko
