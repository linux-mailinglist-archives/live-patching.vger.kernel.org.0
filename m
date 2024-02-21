Return-Path: <live-patching+bounces-183-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7AD9485E4C2
	for <lists+live-patching@lfdr.de>; Wed, 21 Feb 2024 18:40:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7B5311C2277B
	for <lists+live-patching@lfdr.de>; Wed, 21 Feb 2024 17:40:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C170783CC7;
	Wed, 21 Feb 2024 17:40:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="cTIffFjH"
X-Original-To: live-patching@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2E0B69313;
	Wed, 21 Feb 2024 17:40:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708537252; cv=none; b=IG4wcI/hP/kU40goemQgb2lAgquBSPL9RE/J6OSWN3KV7JfF4eK/ew/OieqTDLIOL59Axjgtn9hp3dhYmEl4Je4KokpNw0KRsGW4Ns7n8pKQfblcUnZrHTSF5/lXOTuvKHu7NGC0XZo380Wo6p/qcrpUw5MxuT6KqEpo6HlxW/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708537252; c=relaxed/simple;
	bh=yLnMOorwj6QR1Q8oj/Iy54vokcHJ0eqwtfTaOHATb1k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GDGxDZ6kWWJGpVVdD4qBtzt1UFXav8FXlaTr8PcKS2K+7siB2ppGMfaI8RfjUd4t365nFLzEsFjKOXQ9HrMsL9S4eHGWj5Da3HW8mjW2BOh7T7BEeyRBGGiviF5uLuwx62R5NCF5e8yuPCjdYZrOe34PqZATJPlm36l0f17tcwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=cTIffFjH; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=rIzuZ6FsR3sWeVB3z/k8YzwbvGS8Ck67EO49fqrTZqs=; b=cTIffFjHI+K2z/E9s7UbxErFsG
	7PzQ9ZKYkXud32O3aA0Frwag4BWV+ym6GvRCPPadMXG/qv7zUeSrtclIK6a6wVudMKztfoDbdPfEZ
	lwMi4hwd2y7F8LEJyv1fM8nvMKYzyv+CoH62NKQhFjubZGvPi156d7j04MjNPVOR5F34cDv4ejZ27
	V60Nkh8uZcMq73hqsqyAgfZjZOu4aIXWerzro65GdLuWhv1iNNCCnKdZ972UItt+5yrV+ooJPtvcJ
	OBLXaopJpgxjluOEtpEGkDqkD7Zf3Ui0RYCEARrt5opvnSzZEBEZEAzWLUm8KneKurfbxZAltmIcv
	1t6bYHAg==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rcqaO-00000001xe0-2o8H;
	Wed, 21 Feb 2024 17:40:48 +0000
Date: Wed, 21 Feb 2024 09:40:48 -0800
From: Luis Chamberlain <mcgrof@kernel.org>
To: Changbin Du <changbin.du@huawei.com>, live-patching@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-modules@vger.kernel.org, linux-kernel@vger.kernel.org,
	Xiaoyi Su <suxiaoyi@huawei.com>,
	Eric Chanudet <echanude@redhat.com>
Subject: Re: [PATCH v3] modules: wait do_free_init correctly
Message-ID: <ZdY1oHl8L8wDEvlW@bombadil.infradead.org>
References: <20240217081810.4155871-1-changbin.du@huawei.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240217081810.4155871-1-changbin.du@huawei.com>
Sender: Luis Chamberlain <mcgrof@infradead.org>

+ live-patching folks,

Finally, things are starting to be much clearer. Thanks for the time
for working on this, some more comments below and a question which
I think deserves some attention.

On Sat, Feb 17, 2024 at 04:18:10PM +0800, Changbin Du wrote:
> The synchronization here is just to ensure the module init's been freed
> before doing W+X checking. 

Some nits, this should read instead:

Fix the ordering of freeing of a module init so that it happens before
W+X checking.

> But the commit 1a7b7d922081 ("modules: Use
> vmalloc special flag") moves do_free_init() into a global workqueue
> instead of call_rcu(). So now rcu_barrier() can not ensure that do_free_init
> has completed. We should wait it via flush_work().

Remove "But" and adjust as:

Commit 1a7b7d922081 ("modules: Use vmalloc special flag") moved
calling do_free_init() into a global workqueue instead of relying on it
being called through call_rcu(..., do_free_init), which used to allowed us
call do_free_init() asynchronously after the end of a subsequent grace             
period. The move to a global workqueue broke the gaurantees for code
which needed to be sure the do_free_init() would complete with rcu_barrier().
To fix this callers which used to rely on rcu_barrier() must now instead
use flush_work(&init_free_wq).

> Without this fix, we still could encounter false positive reports in
> W+X checking,

This is good thanks for the clarification.

I think it would be useful for the commit log then to describe also that
it is not that the freeing was not happening, it is just that our sanity
checkers raced against the permission checkers which assume init memory
is already gone.

> and the rcu synchronization is unnecessary which can
> introduce significant delay.

While this can be true, I am not sure if we can remove it. See below.

> Eric Chanudet reports that the rcu_barrier introduces ~0.1s delay on a
> PREEMPT_RT kernel.

That's a separate issue.

>   [    0.291444] Freeing unused kernel memory: 5568K
>   [    0.402442] Run /sbin/init as init process
> 
> With this fix, the above delay can be eliminated.
> 
> Fixes: 1a7b7d922081 ("modules: Use vmalloc special flag")
> Signed-off-by: Changbin Du <changbin.du@huawei.com>
> Cc: Xiaoyi Su <suxiaoyi@huawei.com>
> Cc: Eric Chanudet <echanude@redhat.com>
> 
> ---
> v3:
>   - amend comment in do_init_module() and update commit msg.
> v2:
>   - fix compilation issue for no CONFIG_MODULES found by 0-DAY.
> ---
>  include/linux/moduleloader.h | 8 ++++++++
>  init/main.c                  | 5 +++--
>  kernel/module/main.c         | 9 +++++++--
>  3 files changed, 18 insertions(+), 4 deletions(-)
> 
> diff --git a/include/linux/moduleloader.h b/include/linux/moduleloader.h
> index 001b2ce83832..89b1e0ed9811 100644
> --- a/include/linux/moduleloader.h
> +++ b/include/linux/moduleloader.h
> @@ -115,6 +115,14 @@ int module_finalize(const Elf_Ehdr *hdr,
>  		    const Elf_Shdr *sechdrs,
>  		    struct module *mod);
>  
> +#ifdef CONFIG_MODULES
> +void flush_module_init_free_work(void);
> +#else
> +static inline void flush_module_init_free_work(void)
> +{
> +}
> +#endif
> +
>  /* Any cleanup needed when module leaves. */
>  void module_arch_cleanup(struct module *mod);
>  
> diff --git a/init/main.c b/init/main.c
> index e24b0780fdff..f0b7e21ac67f 100644
> --- a/init/main.c
> +++ b/init/main.c
> @@ -99,6 +99,7 @@
>  #include <linux/init_syscalls.h>
>  #include <linux/stackdepot.h>
>  #include <linux/randomize_kstack.h>
> +#include <linux/moduleloader.h>
>  #include <net/net_namespace.h>
>  
>  #include <asm/io.h>
> @@ -1402,11 +1403,11 @@ static void mark_readonly(void)
>  	if (rodata_enabled) {
>  		/*
>  		 * load_module() results in W+X mappings, which are cleaned
> -		 * up with call_rcu().  Let's make sure that queued work is
> +		 * up with init_free_wq. Let's make sure that queued work is
>  		 * flushed so that we don't hit false positives looking for
>  		 * insecure pages which are W+X.
>  		 */
> -		rcu_barrier();

Was this the only source of waiters that used rcu_barrier() to sync ?
What about kallsyms, live-patching ?

This original source to the addition of this rcu_barrier() (in a slight
older modified form with with rcu_barrier_sched()) was commit
ae646f0b9ca13 ("init: fix false positives in W+X checking") since
v4.17 in 2018, 6 years ago. So I'm hoping we don't have any other
side-by new users which have grown dependent on this rcu_barrier() for
other call_rcu()'s they may have used, but it is hard to tell.

So while I agree that flush work is the right solution, removing the
rcu_barrier() is technically another change which could potentially
regress for other reasons now. It is perhaps safe, but I'm used to
surprises for minor changes like these. So I think it makes sense to
lift it now, and test it in the wild to see what could possibly break,
I'd much prefer to split this as two separate commits. One which does
the fix, and another that lifts the rcu_barrier() with the stated
rationale and savings on time of ~0.1s on PREEMPT_RT kernels.

  Luis

