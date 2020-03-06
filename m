Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A687417C3F3
	for <lists+live-patching@lfdr.de>; Fri,  6 Mar 2020 18:12:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726368AbgCFRMs (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 6 Mar 2020 12:12:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:59080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726231AbgCFRMs (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 6 Mar 2020 12:12:48 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8379320658;
        Fri,  6 Mar 2020 17:12:47 +0000 (UTC)
Date:   Fri, 6 Mar 2020 12:12:46 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Artem Savkov <asavkov@redhat.com>
Cc:     linux-kernel@vger.kernel.org, live-patching@vger.kernel.org
Subject: Re: [PATCH] ftrace: return first found result in lookup_rec()
Message-ID: <20200306121246.5dac2573@gandalf.local.home>
In-Reply-To: <20200306081035.21213-1-asavkov@redhat.com>
References: <20200306081035.21213-1-asavkov@redhat.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri,  6 Mar 2020 09:10:35 +0100
Artem Savkov <asavkov@redhat.com> wrote:

> It appears that ip ranges can overlap so. In that case lookup_rec()
> returns whatever results it got last even if it found nothing in last
> searched page.
> 
> This breaks an obscure livepatch late module patching usecase:
>   - load livepatch
>   - load the patched module
>   - unload livepatch
>   - try to load livepatch again
> 
> To fix this return from lookup_rec() as soon as it found the record
> containing searched-for ip. This used to be this way prior lookup_rec()
> introduction.
> 
> Fixes: 7e16f581a817 ("ftrace: Separate out functionality from ftrace_location_range()")
> Signed-off-by: Artem Savkov <asavkov@redhat.com>
> ---
>  kernel/trace/ftrace.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> index 3f7ee102868a..b0f5ee1fd6e4 100644
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -1547,8 +1547,10 @@ static struct dyn_ftrace *lookup_rec(unsigned long start, unsigned long end)
>  		rec = bsearch(&key, pg->records, pg->index,
>  			      sizeof(struct dyn_ftrace),
>  			      ftrace_cmp_recs);

how about just adding:

		if (rec)
			break;

as that will do the same thing without adding two returns.

-- Steve

> +		if (rec)
> +			return rec;
>  	}
> -	return rec;
> +	return NULL;
>  }
>  
>  /**

