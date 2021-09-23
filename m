Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF99F415FFA
	for <lists+live-patching@lfdr.de>; Thu, 23 Sep 2021 15:32:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241408AbhIWNe3 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 23 Sep 2021 09:34:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241369AbhIWNe2 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 23 Sep 2021 09:34:28 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6306C061574;
        Thu, 23 Sep 2021 06:32:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=mRZoFF2Npvi34/71lpu+V+qZDQvPo0l+ydza7SqNuww=; b=RIbeQn55XpDN6/6y2Y/A0Q+cWk
        HM+UDeWnjFUv/yTm8H088DjFDoiDgl9GYI0hzd+hM7vXT1A5LnbGCNxnyZBNB9ernys47EOenpJby
        b8V9Xupkzj97rASZKA6g8Fued/tgKBJmGOoUc7D7G6LnjK8+KGfjVTVqjwkC6V2HLbW0aWV4lGbrx
        e8IvOYCBIDH0YurqeoSUNk/cO+bEtw+lfDxqA1QU55VT3rGGhK8kZqW+cIuMRtc0eh66zCr9+q5VX
        AjfSbEecDZS7VYxH/f06mBB4jqEphE7yDS+3sTxYhciQyRY6IbOUnb+DM/gDX42fKlR3zi5GDMZgI
        ITTaNi9Q==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mTOmX-005v1L-UB; Thu, 23 Sep 2021 13:29:33 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 26C0930031A;
        Thu, 23 Sep 2021 15:28:57 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 0E868201B1264; Thu, 23 Sep 2021 15:28:57 +0200 (CEST)
Date:   Thu, 23 Sep 2021 15:28:56 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Petr Mladek <pmladek@suse.com>
Cc:     gor@linux.ibm.com, jpoimboe@redhat.com, jikos@kernel.org,
        mbenes@suse.cz, mingo@kernel.org, linux-kernel@vger.kernel.org,
        joe.lawrence@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
        hca@linux.ibm.com, svens@linux.ibm.com, sumanthk@linux.ibm.com,
        live-patching@vger.kernel.org, paulmck@kernel.org
Subject: Re: [RFC][PATCH 7/7] livepatch,context_tracking: Avoid disturbing
 NOHZ_FULL tasks
Message-ID: <YUyBGJGCgrR56C7r@hirez.programming.kicks-ass.net>
References: <20210922110506.703075504@infradead.org>
 <20210922110836.304335737@infradead.org>
 <YUx9yNfgm4nnd23y@alley>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YUx9yNfgm4nnd23y@alley>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu, Sep 23, 2021 at 03:14:48PM +0200, Petr Mladek wrote:

> IMHO, this is not safe:
> 
> CPU0				CPU1
> 
> klp_check_task(A)
>   if (context_tracking_state_cpu(task_cpu(task)) == CONTEXT_USER)
>      goto complete;
> 
>   clear_tsk_thread_flag(task, TIF_PATCH_PENDING);
> 
> 				# task switching to kernel space
> 				klp_update_patch_state(A)
> 				       if (test_and_clear_tsk_thread_flag(task,	TIF_PATCH_PENDING))
> 				       //false
> 
> 				# calling kernel code with old task->patch_state
> 
> 	task->patch_state = klp_target_state;
> 
> BANG: CPU0 sets task->patch_state when task A is already running
> 	kernel code on CPU1.

Why is that a problem? That is, who actually cares about
task->patch_state ? I was under the impression that state was purely for
klp itself, to track which task has observed the new state.
