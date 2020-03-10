Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD6EA180840
	for <lists+live-patching@lfdr.de>; Tue, 10 Mar 2020 20:38:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727531AbgCJTiW (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 10 Mar 2020 15:38:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:35214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726729AbgCJTiW (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Tue, 10 Mar 2020 15:38:22 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EA3C3208E4;
        Tue, 10 Mar 2020 19:38:21 +0000 (UTC)
Date:   Tue, 10 Mar 2020 15:38:20 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Artem Savkov <asavkov@redhat.com>
Cc:     linux-kernel@vger.kernel.org, live-patching@vger.kernel.org
Subject: Re: [PATCH v2] ftrace: return first found result in lookup_rec()
Message-ID: <20200310153820.436a8583@gandalf.local.home>
In-Reply-To: <20200306174317.21699-1-asavkov@redhat.com>
References: <20200306121246.5dac2573@gandalf.local.home>
        <20200306174317.21699-1-asavkov@redhat.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri,  6 Mar 2020 18:43:17 +0100
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
> v2: break instead of two returns

Thanks Artem, I applied your patch. But just an FYI, it's best to place the
"v2" statement below the three dashes "---" so that it doesn't get pulled
into the git commit when this patch is applied via a script.

-- Steve

> 
> Fixes: 7e16f581a817 ("ftrace: Separate out functionality from ftrace_location_range()")
> Signed-off-by: Artem Savkov <asavkov@redhat.com>
> ---
>  kernel/trace/ftrace.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> index 3f7ee102868a..fd81c7de77a7 100644
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -1547,6 +1547,8 @@ static struct dyn_ftrace *lookup_rec(unsigned long start, unsigned long end)
>  		rec = bsearch(&key, pg->records, pg->index,
>  			      sizeof(struct dyn_ftrace),
>  			      ftrace_cmp_recs);
> +		if (rec)
> +			break;
>  	}
>  	return rec;
>  }

