Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A38334A34C
	for <lists+live-patching@lfdr.de>; Fri, 26 Mar 2021 09:40:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229744AbhCZIjc (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 26 Mar 2021 04:39:32 -0400
Received: from mx2.suse.de ([195.135.220.15]:52876 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229871AbhCZIjN (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 26 Mar 2021 04:39:13 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 5F4E1AA55;
        Fri, 26 Mar 2021 08:39:12 +0000 (UTC)
Date:   Fri, 26 Mar 2021 09:39:12 +0100 (CET)
From:   Miroslav Benes <mbenes@suse.cz>
To:     Jens Axboe <axboe@kernel.dk>
cc:     Joe Lawrence <joe.lawrence@redhat.com>,
        Dong Kai <dongkai11@huawei.com>, jpoimboe@redhat.com,
        jikos@kernel.org, pmladek@suse.com, live-patching@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] livepatch: klp_send_signal should treat PF_IO_WORKER
 like PF_KTHREAD
In-Reply-To: <f4969563-23fa-cb49-8243-d600f1bf0b23@kernel.dk>
Message-ID: <alpine.LSU.2.21.2103260934470.9965@pobox.suse.cz>
References: <20210325014836.40649-1-dongkai11@huawei.com> <cd701421-f2c6-56f6-5798-106bc9de0084@redhat.com> <alpine.LSU.2.21.2103251026180.30447@pobox.suse.cz> <f4969563-23fa-cb49-8243-d600f1bf0b23@kernel.dk>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu, 25 Mar 2021, Jens Axboe wrote:

> On 3/25/21 3:30 AM, Miroslav Benes wrote:
> >> (PF_KTHREAD | PF_IO_WORKER) is open coded in soo many places maybe this is a
> >> silly question, but...
> >>
> >> If the livepatch code could use fake_signal_wake_up(), we could consolidate
> >> the pattern in klp_send_signals() with the one in freeze_task().  Then there
> >> would only one place for wake up / fake signal logic.
> >>
> >> I don't fully understand the differences in the freeze_task() version, so I
> >> only pose this as a question and not v2 request.
> > 
> > The plan was to remove our live patching fake signal completely and use 
> > the new infrastructure Jens proposed in the past.
> 
> That would be great, I've actually been waiting for that to show up!

Sorry about that. I failed to notice that the infrastructure was merged 
already. I'll send it soonish.

> I would greatly prefer this approach if you deem it suitable for 5.12,
> if not we'll still need the temporary work-around for live patching.

I noticed there is 20210326003928.978750-1-axboe@kernel.dk now, so I 
suppose we should wait for that to land in mainline and simply do nothing 
about PF_IO_WORKER for live patching. 

Miroslav
