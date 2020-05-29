Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E1C81E857D
	for <lists+live-patching@lfdr.de>; Fri, 29 May 2020 19:44:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726999AbgE2Ros (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 29 May 2020 13:44:48 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:48014 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726829AbgE2Ror (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 29 May 2020 13:44:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590774286;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dTz4t9XSMrolUyKg6CsMoUPC7f/9JweFm6zuCIDCXNg=;
        b=jGCrhbdH2tf6fgYvG6tZJuvffy1eRR4xxdq5dKrrtBr4uSlwiImExkCV0rK+xpQDNZMNH8
        PSEnswm2LXObPd2ZcCg3txYPsPj39YFqGFp6dWyDX1naR4+qdJPEfrJK+3fg6iJAYdn1n3
        +xnBF5vrcQECPYKSghpB8A2SBkXiO1g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-287-TaVu2yjfOy2MO9txOqUAXw-1; Fri, 29 May 2020 13:44:42 -0400
X-MC-Unique: TaVu2yjfOy2MO9txOqUAXw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DAFE0107ACCA;
        Fri, 29 May 2020 17:44:40 +0000 (UTC)
Received: from treble (ovpn-116-170.rdu2.redhat.com [10.10.116.170])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B75765C1B5;
        Fri, 29 May 2020 17:44:35 +0000 (UTC)
Date:   Fri, 29 May 2020 12:44:33 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Wang ShaoBo <bobo.shaobowang@huawei.com>
Cc:     huawei.libin@huawei.com, xiexiuqi@huawei.com,
        cj.chengjian@huawei.com, mingo@redhat.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        mbenes@suse.cz, devel@etsukata.com, viro@zeniv.linux.org.uk,
        esyr@redhat.com
Subject: Re: Question: livepatch failed for new fork() task stack unreliable
Message-ID: <20200529174433.wpkknhypx2bmjika@treble>
References: <20200529101059.39885-1-bobo.shaobowang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200529101059.39885-1-bobo.shaobowang@huawei.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri, May 29, 2020 at 06:10:59PM +0800, Wang ShaoBo wrote:
> Stack unreliable error is reported by stack_trace_save_tsk_reliable() when trying
> to insmod a hot patch for module modification, this results in frequent failures
> sometimes. We found this 'unreliable' stack is from task just fork.

For livepatch, this shouldn't actually be a failure.  The patch will
just stay in the transition state until after the fork has completed.
Which should happen in a reasonable amount of time, right?

> 1) The task was not actually scheduled to excute, at this time UNWIND_HINT_EMPTY in
> ret_from_fork() has not reset unwind_hint, it's sp_reg and end field remain default value
> and end up throwing an error in unwind_next_frame() when called by arch_stack_walk_reliable();

Yes, this seems to be true for forked-but-not-yet-scheduled tasks.

I can look at fixing that.  I have some ORC cleanups in progress which
are related to UNWIND_HINT_EMPTY and the end of the stack.  I can add
this issue to the list of improvements.

> 2) The task has been scheduled but UNWIND_HINT_REGS not finished, at this time
> arch_stack_walk_reliable() terminates it's backtracing loop for pt_regs unknown
> and return -EINVAL because it's a user task.

Hm, do you see this problem with upstream?  It seems like it should
work.  arch_stack_walk_reliable() has this:

			/* Success path for user tasks */
			if (user_mode(regs))
				return 0;

Where exactly is the error coming from?

-- 
Josh

