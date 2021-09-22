Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BFA6414A1A
	for <lists+live-patching@lfdr.de>; Wed, 22 Sep 2021 15:05:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230200AbhIVNGf (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 22 Sep 2021 09:06:35 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:37510 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230180AbhIVNGf (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 22 Sep 2021 09:06:35 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 209F0222B1;
        Wed, 22 Sep 2021 13:05:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1632315904; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=iteCz5RdAnYGOBGKoprBfbkeyuB3CB4m0Pf4yg6ab4s=;
        b=Ua46vGTGgLwJhqwEpWv/jfECXBPzT7a3BDUAmU/a14/B5QucSb2KvQdJQIz3D6g3/sl8Rq
        NQfC++VEWCnw5CZ8taO/7AgULGVx3QxcMx8fYSrmgk/aKAycXI0nrDiMUn4vLGA9Od93yE
        V+W3fDnrdMtE4byedPaW8XGUJaDoOgk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1632315904;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=iteCz5RdAnYGOBGKoprBfbkeyuB3CB4m0Pf4yg6ab4s=;
        b=ElsFrnE9itQzJDjBkqpfRGGO48TwHcd5nyrgW112u2pzHiOuiDmtfYHRZhq+bS8YFJUaBc
        83afqOEapHpWoOBA==
Received: from pobox.suse.cz (pobox.suse.cz [10.100.2.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id EA422A3B8D;
        Wed, 22 Sep 2021 13:05:03 +0000 (UTC)
Date:   Wed, 22 Sep 2021 15:05:03 +0200 (CEST)
From:   Miroslav Benes <mbenes@suse.cz>
To:     Peter Zijlstra <peterz@infradead.org>
cc:     gor@linux.ibm.com, jpoimboe@redhat.com, jikos@kernel.org,
        pmladek@suse.com, mingo@kernel.org, linux-kernel@vger.kernel.org,
        joe.lawrence@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
        hca@linux.ibm.com, svens@linux.ibm.com, sumanthk@linux.ibm.com,
        live-patching@vger.kernel.org, paulmck@kernel.org
Subject: Re: [RFC][PATCH 5/7] sched,livepatch: Use wake_up_if_idle()
In-Reply-To: <20210922110836.185239814@infradead.org>
Message-ID: <alpine.LSU.2.21.2109221458230.442@pobox.suse.cz>
References: <20210922110506.703075504@infradead.org> <20210922110836.185239814@infradead.org>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

> @@ -405,8 +405,10 @@ void klp_try_complete_transition(void)
>  	for_each_possible_cpu(cpu) {
>  		task = idle_task(cpu);
>  		if (cpu_online(cpu)) {
> -			if (!klp_try_switch_task(task))
> -				complete = false;
> +			int ret = klp_try_switch_task(task);
> +			if (ret == -EBUSY)
> +				wake_up_if_idle(cpu);
> +			complete = !ret;

This is broken. You can basically change "complete" only to false (when it 
applies). This could leave some tasks in the old patching state.

Anyway, I like the patch set a lot. It moves our infrastructure to a 
proper (I hope so) API and it removes few quirks we have along the way. 
I'll play with it some more.

Thanks

Miroslav
