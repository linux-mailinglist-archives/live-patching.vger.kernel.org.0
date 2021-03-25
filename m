Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF413348CBD
	for <lists+live-patching@lfdr.de>; Thu, 25 Mar 2021 10:26:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229676AbhCYJ0V (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 25 Mar 2021 05:26:21 -0400
Received: from mx2.suse.de ([195.135.220.15]:53482 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229576AbhCYJ0Q (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 25 Mar 2021 05:26:16 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 632A0AF65;
        Thu, 25 Mar 2021 09:26:14 +0000 (UTC)
Date:   Thu, 25 Mar 2021 10:26:13 +0100 (CET)
From:   Miroslav Benes <mbenes@suse.cz>
To:     Dong Kai <dongkai11@huawei.com>
cc:     jpoimboe@redhat.com, jikos@kernel.org, pmladek@suse.com,
        joe.lawrence@redhat.com, axboe@kernel.dk,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] livepatch: klp_send_signal should treat PF_IO_WORKER
 like PF_KTHREAD
In-Reply-To: <20210325014836.40649-1-dongkai11@huawei.com>
Message-ID: <alpine.LSU.2.21.2103251023320.30447@pobox.suse.cz>
References: <20210325014836.40649-1-dongkai11@huawei.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu, 25 Mar 2021, Dong Kai wrote:

> commit 15b2219facad ("kernel: freezer should treat PF_IO_WORKER like
> PF_KTHREAD for freezing") is to fix the freezeing issue of IO threads
> by making the freezer not send them fake signals.
> 
> Here live patching consistency model call klp_send_signals to wake up
> all tasks by send fake signal to all non-kthread which only check the
> PF_KTHREAD flag, so it still send signal to io threads which may lead to
> freezeing issue of io threads.

I suppose this could happen, but it will also affect the live patching 
transition if the io threads do not react to signals.

Are you able to reproduce it easily? I mean, is there a testcase I could 
use to take a closer look?
 
> Here we take the same fix action by treating PF_IO_WORKERS as PF_KTHREAD
> within klp_send_signal function.

Yes, this sounds reasonable.

Miroslav

> Signed-off-by: Dong Kai <dongkai11@huawei.com>
> ---
> note:
> the io threads freeze issue links:
> [1] https://lore.kernel.org/io-uring/YEgnIp43%2F6kFn8GL@kevinlocke.name/
> [2] https://lore.kernel.org/io-uring/d7350ce7-17dc-75d7-611b-27ebf2cb539b@kernel.dk/
> 
>  kernel/livepatch/transition.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/livepatch/transition.c b/kernel/livepatch/transition.c
> index f6310f848f34..0e1c35c8f4b4 100644
> --- a/kernel/livepatch/transition.c
> +++ b/kernel/livepatch/transition.c
> @@ -358,7 +358,7 @@ static void klp_send_signals(void)
>  		 * Meanwhile the task could migrate itself and the action
>  		 * would be meaningless. It is not serious though.
>  		 */
> -		if (task->flags & PF_KTHREAD) {
> +		if (task->flags & (PF_KTHREAD | PF_IO_WORKER)) {
>  			/*
>  			 * Wake up a kthread which sleeps interruptedly and
>  			 * still has not been migrated.

