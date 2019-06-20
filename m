Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B79554D068
	for <lists+live-patching@lfdr.de>; Thu, 20 Jun 2019 16:30:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726491AbfFTOac (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 20 Jun 2019 10:30:32 -0400
Received: from mx2.suse.de ([195.135.220.15]:55776 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726428AbfFTOab (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 20 Jun 2019 10:30:31 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 9B8AEAE07;
        Thu, 20 Jun 2019 14:30:30 +0000 (UTC)
Date:   Thu, 20 Jun 2019 16:30:29 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     Josh Poimboeuf <jpoimboe@redhat.com>
Cc:     Miroslav Benes <mbenes@suse.cz>, jikos@kernel.org,
        joe.lawrence@redhat.com, kamalesh@linux.vnet.ibm.com,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v4 0/3] livepatch: Cleanup of reliable stacktrace warnings
Message-ID: <20190620143029.gf2ic6yxshactxbd@pathway.suse.cz>
References: <20190611141320.25359-1-mbenes@suse.cz>
 <20190615204320.i4qxbk2m3ee73vyg@treble>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190615204320.i4qxbk2m3ee73vyg@treble>
User-Agent: NeoMutt/20170912 (1.9.0)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Sat 2019-06-15 15:43:20, Josh Poimboeuf wrote:
> On Tue, Jun 11, 2019 at 04:13:17PM +0200, Miroslav Benes wrote:
> > This is the fourth attempt to improve the situation of reliable stack
> > trace warnings in livepatch. Based on discussion in
> > 20190531074147.27616-1-pmladek@suse.com (v3).
> > 
> > Changes against v3:
> > + weak save_stack_trace_tsk_reliable() removed, because it is not needed
> >   anymore thanks to Thomas' recent improvements
> > + klp_have_reliable_stack() check reintroduced in klp_try_switch_task()
> > 
> > Changes against v2:
> > 
> > + Put back the patch removing WARN_ONCE in the weak
> >   save_stack_trace_tsk_reliable(). It is related.
> > + Simplified patch removing the duplicate warning from klp_check_stack()
> > + Update commit message for 3rd patch [Josh]
> > 
> > Miroslav Benes (2):
> >   stacktrace: Remove weak version of save_stack_trace_tsk_reliable()
> >   Revert "livepatch: Remove reliable stacktrace check in
> >     klp_try_switch_task()"
> > 
> > Petr Mladek (1):
> >   livepatch: Remove duplicate warning about missing reliable stacktrace
> >     support
> > 
> >  kernel/livepatch/transition.c | 8 +++++++-
> >  kernel/stacktrace.c           | 8 --------
> >  2 files changed, 7 insertions(+), 9 deletions(-)
> 
> Thanks Miroslav for wrapping this up, and thanks to Petr for his
> previous work on this.
> 
> Acked-by: Josh Poimboeuf <jpoimboe@redhat.com>

All three patches have been commited into for-5.3/core branch.

Best Regards,
Petr
