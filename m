Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44321423A52
	for <lists+live-patching@lfdr.de>; Wed,  6 Oct 2021 11:16:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237846AbhJFJSS (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 6 Oct 2021 05:18:18 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:50660 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230120AbhJFJSO (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 6 Oct 2021 05:18:14 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id B95FC2034E;
        Wed,  6 Oct 2021 09:16:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1633511781; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vi8wBtlo5jemshbJR/DfVnHgxnspXcznbzVfs867agc=;
        b=OvxWvXN2RaEGsEDaAG86QI7FAOG3TzdsxDn2wqTQq+g4WEL+vrJZzwEJPz1Tl6hCRQdCMA
        7H5c5j90pqXe0VbJSEqjwjiudZfNGxifvk6F29FST0VEP23OK3xFhrcFI3b2dw7gsJ+R4/
        P3PZPEYJOO48vx/dUOrB5JHvmDdzWOM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1633511781;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vi8wBtlo5jemshbJR/DfVnHgxnspXcznbzVfs867agc=;
        b=jVYp0yN8jSF+6aun/e/t+8hqXANPZ2MHoSb4vbfjL8Q8RzZyJOfnSxNNhk/8qpGm2p9bd/
        /Ry4+iqLq0xr3+Ag==
Received: from pobox.suse.cz (pobox.suse.cz [10.100.2.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 67C27A3B87;
        Wed,  6 Oct 2021 09:16:21 +0000 (UTC)
Date:   Wed, 6 Oct 2021 11:16:21 +0200 (CEST)
From:   Miroslav Benes <mbenes@suse.cz>
To:     Peter Zijlstra <peterz@infradead.org>
cc:     gor@linux.ibm.com, jpoimboe@redhat.com, jikos@kernel.org,
        pmladek@suse.com, mingo@kernel.org, linux-kernel@vger.kernel.org,
        joe.lawrence@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
        hca@linux.ibm.com, svens@linux.ibm.com, sumanthk@linux.ibm.com,
        live-patching@vger.kernel.org, paulmck@kernel.org,
        rostedt@goodmis.org, x86@kernel.org
Subject: Re: [PATCH v2 05/11] sched,livepatch: Use wake_up_if_idle()
In-Reply-To: <20210929152428.828064133@infradead.org>
Message-ID: <alpine.LSU.2.21.2110061115270.2311@pobox.suse.cz>
References: <20210929151723.162004989@infradead.org> <20210929152428.828064133@infradead.org>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, 29 Sep 2021, Peter Zijlstra wrote:

> Make sure to prod idle CPUs so they call klp_update_patch_state().
> 
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> ---
>  kernel/livepatch/transition.c |    5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> --- a/kernel/livepatch/transition.c
> +++ b/kernel/livepatch/transition.c
> @@ -413,8 +413,11 @@ void klp_try_complete_transition(void)
>  	for_each_possible_cpu(cpu) {
>  		task = idle_task(cpu);
>  		if (cpu_online(cpu)) {
> -			if (!klp_try_switch_task(task))
> +			if (!klp_try_switch_task(task)) {
>  				complete = false;
> +				/* Make idle task go through the main loop. */
> +				wake_up_if_idle(cpu);
> +			}

Right, it should be enough.

Acked-by: Miroslav Benes <mbenes@suse.cz>

It would be nice to get Vasily's Tested-by tag on this one.

M
