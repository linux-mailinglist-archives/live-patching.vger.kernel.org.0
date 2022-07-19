Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C93257A686
	for <lists+live-patching@lfdr.de>; Tue, 19 Jul 2022 20:32:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237135AbiGSScP (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 19 Jul 2022 14:32:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233242AbiGSScP (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 19 Jul 2022 14:32:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AE7657214;
        Tue, 19 Jul 2022 11:32:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C564561787;
        Tue, 19 Jul 2022 18:32:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D16C0C341C6;
        Tue, 19 Jul 2022 18:32:11 +0000 (UTC)
Date:   Tue, 19 Jul 2022 14:32:10 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Song Liu <songliubraving@fb.com>
Cc:     Petr Mladek <pmladek@suse.com>, kernel test robot <lkp@intel.com>,
        Song Liu <song@kernel.org>, bpf <bpf@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>,
        "kbuild-all@lists.01.org" <kbuild-all@lists.01.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        "jolsa@kernel.org" <jolsa@kernel.org>
Subject: Re: [PATCH v4 bpf-next 2/4] ftrace: allow IPMODIFY and DIRECT ops
 on the same function
Message-ID: <20220719143210.08f9922b@gandalf.local.home>
In-Reply-To: <9DAB0710-7D60-46AC-8A2F-ED4B8A1A4BC0@fb.com>
References: <20220718055449.3960512-3-song@kernel.org>
        <202207181552.VuKfz9zg-lkp@intel.com>
        <YtVd4FKOcEmGfubm@alley>
        <9DAB0710-7D60-46AC-8A2F-ED4B8A1A4BC0@fb.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Mon, 18 Jul 2022 16:59:51 +0000
Song Liu <songliubraving@fb.com> wrote:

> >> vim +/direct_mutex_locked +8197 kernel/trace/ftrace.c
> >> 
> >>  8182	
> >>  8183	/**
> >>  8184	 * register_ftrace_function - register a function for profiling
> >>  8185	 * @ops:	ops structure that holds the function for profiling.
> >>  8186	 *
> >>  8187	 * Register a function to be called by all functions in the
> >>  8188	 * kernel.
> >>  8189	 *
> >>  8190	 * Note: @ops->func and all the functions it calls must be labeled
> >>  8191	 *       with "notrace", otherwise it will go into a
> >>  8192	 *       recursive loop.
> >>  8193	 */
> >>  8194	int register_ftrace_function(struct ftrace_ops *ops)
> >>  8195		__releases(&direct_mutex)
> >>  8196	{  
> >>> 8197		bool direct_mutex_locked = false;  
> >>  8198		int ret;
> >>  8199	
> >>  8200		ftrace_ops_init(ops);
> >>  8201	
> >>  8202		ret = prepare_direct_functions_for_ipmodify(ops);
> >>  8203		if (ret < 0)
> >>  8204			return ret;
> >>  8205		else if (ret == 1)
> >>  8206			direct_mutex_locked = true;  
> > 
> > Honestly, this is another horrible trick. Would it be possible to
> > call prepare_direct_functions_for_ipmodify() with direct_mutex
> > already taken?

Agreed. I'm not sure why I didn't notice this in the other versions.
Probably was looking too much at the other logic. :-/

> > 
> > I mean something like:
> > 
> > 	mutex_lock(&direct_mutex);
> > 
> > 	ret = prepare_direct_functions_for_ipmodify(ops);
> > 	if (ret)
> > 		goto out:
> > 
> > 	mutex_lock(&ftrace_lock);
> > 	ret = ftrace_startup(ops, 0);
> > 	mutex_unlock(&ftrace_lock);
> > 
> > out:
> > 	mutex_unlock(&direct_mutex);
> > 	return ret;  
> 
> Yeah, we can actually do something like this. We can also move the
> ops->flags & FTRACE_OPS_FL_IPMODIFY check to 
> register_ftrace_function(), so we only lock direct_mutex when when
> it is necessary. 

No need. Just take the direct_mutex, and perhaps add a:

	lockdep_assert_held(&direct_mutex);

in the prepare_direct_functions_for_ipmodify().

This is far from a fast path to do any tricks in trying to optimize it.

-- Steve
