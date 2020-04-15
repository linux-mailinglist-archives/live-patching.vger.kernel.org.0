Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 357D41AA9DB
	for <lists+live-patching@lfdr.de>; Wed, 15 Apr 2020 16:26:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391887AbgDOOYj (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 15 Apr 2020 10:24:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2387746AbgDOOYg (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 15 Apr 2020 10:24:36 -0400
X-Greylist: delayed 74408 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 15 Apr 2020 07:24:36 PDT
Received: from merlin.infradead.org (unknown [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A021C061A0C;
        Wed, 15 Apr 2020 07:24:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=k70JX9dGb5HJevGuiLeyAfGQdNacrtEnoRjysTqq8Jc=; b=FDikE0Ggh/CSVMyB2amhONlMRw
        pj/k9Wpy0t5hXqbTH8Fk3U1RIh8AM3QVcmZevBbPeUy7Qq0YvY+Wx9Id2QdbwxS6vBcNtnAP6vtD2
        B85Y3yamN+NbhZ6Sa/Z6Wy1ILjyRn2i4cVsqJb1G10+Xa5+Sv604cMMxMdE0WMWSyQagUTheSl2xy
        0RhDHbYgCXUHHX6Ye34Uc8IVvRUr1veavNPhUc79lU9r/K9mlSuBRGHt0peSl5Xsxq51EoBioTM19
        hq6SWjBTNp+uBqsH91U7QklfQDGtevz7ymQoRpurVnzDawDpcs5wezfs8/jODWyrZ2fWzajkUgOLS
        lT+dIG5Q==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jOixe-0006JI-Df; Wed, 15 Apr 2020 14:24:18 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id B8016304D58;
        Wed, 15 Apr 2020 16:24:15 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id A45712BC703E8; Wed, 15 Apr 2020 16:24:15 +0200 (CEST)
Date:   Wed, 15 Apr 2020 16:24:15 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Josh Poimboeuf <jpoimboe@redhat.com>
Cc:     live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jessica Yu <jeyu@kernel.org>
Subject: Re: [PATCH 0/7] livepatch,module: Remove .klp.arch and
 module_disable_ro()
Message-ID: <20200415142415.GH20730@hirez.programming.kicks-ass.net>
References: <cover.1586881704.git.jpoimboe@redhat.com>
 <20200414182726.GF2483@worktop.programming.kicks-ass.net>
 <20200414190814.glra2gceqgy34iyx@treble>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200414190814.glra2gceqgy34iyx@treble>
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, Apr 14, 2020 at 02:08:14PM -0500, Josh Poimboeuf wrote:
> On Tue, Apr 14, 2020 at 08:27:26PM +0200, Peter Zijlstra wrote:
> > On Tue, Apr 14, 2020 at 11:28:36AM -0500, Josh Poimboeuf wrote:
> > > Better late than never, these patches add simplifications and
> > > improvements for some issues Peter found six months ago, as part of his
> > > non-writable text code (W^X) cleanups.
> > 
> > Excellent stuff, thanks!!
> >
> > I'll go brush up these two patches then:
> > 
> >   https://lkml.kernel.org/r/20191018074634.801435443@infradead.org
> >   https://lkml.kernel.org/r/20191018074634.858645375@infradead.org
> 
> Ah right, I meant to bring that up.  I actually played around with those
> patches.  While it would be nice to figure out a way to converge the
> ftrace module init, I didn't really like the first patch.

ftrace only needs it done after ftrace_module_enable(), which is before
the notifier chain happens, so we can simply do something like so
instead:

diff --git a/kernel/module.c b/kernel/module.c
index a3a8f6d0e144..89f8d02c3c3e 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -3700,6 +3700,10 @@ static int prepare_coming_module(struct module *mod)
 	if (err)
 		return err;
 
+	module_enable_ro(mod, false);
+	module_enable_nx(mod);
+	module_enable_x(mod);
+
 	err = blocking_notifier_call_chain_robust(&module_notify_list,
 			MODULE_STATE_COMING, MODULE_STATE_GOING, mod);
 	err = notifier_to_errno(err);
@@ -3845,10 +3849,6 @@ static int load_module(struct load_info *info, const char __user *uargs,
 	if (err)
 		goto bug_cleanup;
 
-	module_enable_ro(mod, false);
-	module_enable_nx(mod);
-	module_enable_x(mod);
-
 	/* Module is ready to execute: parsing args may do that. */
 	after_dashes = parse_args(mod->name, mod->args, mod->kp, mod->num_kp,
 				  -32768, 32767, mod,

> It bothers me that both the notifiers and the module init() both see the
> same MODULE_STATE_COMING state, but only in the former case is the text
> writable.
> 
> I think it's cognitively simpler if MODULE_STATE_COMING always means the
> same thing, like the comments imply, "fully formed" and thus
> not-writable:
> 
> enum module_state {
> 	MODULE_STATE_LIVE,	/* Normal state. */
> 	MODULE_STATE_COMING,	/* Full formed, running module_init. */
> 	MODULE_STATE_GOING,	/* Going away. */
> 	MODULE_STATE_UNFORMED,	/* Still setting it up. */
> };
> 
> And, it keeps tighter constraints on what a notifier can do, which is a
> good thing if we can get away with it.

Moo! -- but jump_label and static_call are on the notifier chain and I
was hoping to make it cheaper for them. Should we perhaps weane them off the
notifier and, like ftrace/klp put in explicit calls?

It'd make the error handling in prepare_coming_module() a bigger mess,
but it should work.
