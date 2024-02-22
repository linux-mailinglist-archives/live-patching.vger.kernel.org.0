Return-Path: <live-patching+bounces-191-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 98B3C85F42E
	for <lists+live-patching@lfdr.de>; Thu, 22 Feb 2024 10:22:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 49CC32856F0
	for <lists+live-patching@lfdr.de>; Thu, 22 Feb 2024 09:22:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BAEA6376F2;
	Thu, 22 Feb 2024 09:22:09 +0000 (UTC)
X-Original-To: live-patching@vger.kernel.org
Received: from szxga07-in.huawei.com (szxga07-in.huawei.com [45.249.212.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDD8636B04;
	Thu, 22 Feb 2024 09:22:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708593729; cv=none; b=cXtJxxr9G/WFc9n3VOd9YI5zUOSRYz5N4RARjyqJlQeBdQ4cL6KZHrlf0gFtiQLluxt739KIOwFxlmmqdlKxLx07o+MTK6Xdv2lBOiawFRHgv+3XgoirdkT2zsp6mnZ88ir4twRgBHvctrd9EmB4+FDE6EHuaChxH/z63JEo2Ls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708593729; c=relaxed/simple;
	bh=5v9yH/V+iT/XBq13O4b1uFWQSJMXaxAV6nRnWvjhvLg=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fX0RkHX4kytmvB1aAs2WLCKVERpIaYiNwv4fgdFckUimcbSq1sifo+W4hAEMurndRK32jt7rZep8AgOsxsr+qwXsEng+tgvYbkrQjhs/6VeKYV6dvpA1sZBcAvohjbDC+OLQthDNgPUQbKFz0ohjuLwqqKEoKzkiLunfk7u/0PY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4TgSK54Lf4z1X3Cc;
	Thu, 22 Feb 2024 17:19:53 +0800 (CST)
Received: from kwepemd500009.china.huawei.com (unknown [7.221.188.237])
	by mail.maildlp.com (Postfix) with ESMTPS id 9CD171400D9;
	Thu, 22 Feb 2024 17:22:03 +0800 (CST)
Received: from kwepemd100011.china.huawei.com (7.221.188.204) by
 kwepemd500009.china.huawei.com (7.221.188.237) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.28; Thu, 22 Feb 2024 17:22:03 +0800
Received: from M910t (10.110.54.157) by kwepemd100011.china.huawei.com
 (7.221.188.204) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.1258.28; Thu, 22 Feb
 2024 17:22:02 +0800
Date: Thu, 22 Feb 2024 17:21:19 +0800
From: Changbin Du <changbin.du@huawei.com>
To: Luis Chamberlain <mcgrof@kernel.org>
CC: Changbin Du <changbin.du@huawei.com>, <live-patching@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>, <linux-modules@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Xiaoyi Su <suxiaoyi@huawei.com>, "Eric
 Chanudet" <echanude@redhat.com>
Subject: Re: [PATCH v3] modules: wait do_free_init correctly
Message-ID: <20240222092119.tp6kls4ycnsflcgm@M910t>
References: <20240217081810.4155871-1-changbin.du@huawei.com>
 <ZdY1oHl8L8wDEvlW@bombadil.infradead.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZdY1oHl8L8wDEvlW@bombadil.infradead.org>
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemd100011.china.huawei.com (7.221.188.204)

On Wed, Feb 21, 2024 at 09:40:48AM -0800, Luis Chamberlain wrote:
> + live-patching folks,
> 
> Finally, things are starting to be much clearer. Thanks for the time
> for working on this, some more comments below and a question which
> I think deserves some attention.
> 
> On Sat, Feb 17, 2024 at 04:18:10PM +0800, Changbin Du wrote:
> > The synchronization here is just to ensure the module init's been freed
> > before doing W+X checking. 
> 
> Some nits, this should read instead:
> 
> Fix the ordering of freeing of a module init so that it happens before
> W+X checking.
> 
> > But the commit 1a7b7d922081 ("modules: Use
> > vmalloc special flag") moves do_free_init() into a global workqueue
> > instead of call_rcu(). So now rcu_barrier() can not ensure that do_free_init
> > has completed. We should wait it via flush_work().
> 
> Remove "But" and adjust as:
> 
> Commit 1a7b7d922081 ("modules: Use vmalloc special flag") moved
> calling do_free_init() into a global workqueue instead of relying on it
> being called through call_rcu(..., do_free_init), which used to allowed us
> call do_free_init() asynchronously after the end of a subsequent grace             
> period. The move to a global workqueue broke the gaurantees for code
> which needed to be sure the do_free_init() would complete with rcu_barrier().
> To fix this callers which used to rely on rcu_barrier() must now instead
> use flush_work(&init_free_wq).
>
Sure, thanks!

> > Without this fix, we still could encounter false positive reports in
> > W+X checking,
> 
> This is good thanks for the clarification.
> 
> I think it would be useful for the commit log then to describe also that
> it is not that the freeing was not happening, it is just that our sanity
> checkers raced against the permission checkers which assume init memory
> is already gone.
> 
okay, I'll apend this detailed explanation.

> > and the rcu synchronization is unnecessary which can
> > introduce significant delay.
> 
> While this can be true, I am not sure if we can remove it. See below.
> 
> > Eric Chanudet reports that the rcu_barrier introduces ~0.1s delay on a
> > PREEMPT_RT kernel.
> 
> That's a separate issue.
> 
> >   [    0.291444] Freeing unused kernel memory: 5568K
> >   [    0.402442] Run /sbin/init as init process
> > 
> > With this fix, the above delay can be eliminated.
> > 
> > Fixes: 1a7b7d922081 ("modules: Use vmalloc special flag")
> > Signed-off-by: Changbin Du <changbin.du@huawei.com>
> > Cc: Xiaoyi Su <suxiaoyi@huawei.com>
> > Cc: Eric Chanudet <echanude@redhat.com>
> > 
> > ---
> > v3:
> >   - amend comment in do_init_module() and update commit msg.
> > v2:
> >   - fix compilation issue for no CONFIG_MODULES found by 0-DAY.
> > ---
> >  include/linux/moduleloader.h | 8 ++++++++
> >  init/main.c                  | 5 +++--
> >  kernel/module/main.c         | 9 +++++++--
> >  3 files changed, 18 insertions(+), 4 deletions(-)
> > 
> > diff --git a/include/linux/moduleloader.h b/include/linux/moduleloader.h
> > index 001b2ce83832..89b1e0ed9811 100644
> > --- a/include/linux/moduleloader.h
> > +++ b/include/linux/moduleloader.h
> > @@ -115,6 +115,14 @@ int module_finalize(const Elf_Ehdr *hdr,
> >  		    const Elf_Shdr *sechdrs,
> >  		    struct module *mod);
> >  
> > +#ifdef CONFIG_MODULES
> > +void flush_module_init_free_work(void);
> > +#else
> > +static inline void flush_module_init_free_work(void)
> > +{
> > +}
> > +#endif
> > +
> >  /* Any cleanup needed when module leaves. */
> >  void module_arch_cleanup(struct module *mod);
> >  
> > diff --git a/init/main.c b/init/main.c
> > index e24b0780fdff..f0b7e21ac67f 100644
> > --- a/init/main.c
> > +++ b/init/main.c
> > @@ -99,6 +99,7 @@
> >  #include <linux/init_syscalls.h>
> >  #include <linux/stackdepot.h>
> >  #include <linux/randomize_kstack.h>
> > +#include <linux/moduleloader.h>
> >  #include <net/net_namespace.h>
> >  
> >  #include <asm/io.h>
> > @@ -1402,11 +1403,11 @@ static void mark_readonly(void)
> >  	if (rodata_enabled) {
> >  		/*
> >  		 * load_module() results in W+X mappings, which are cleaned
> > -		 * up with call_rcu().  Let's make sure that queued work is
> > +		 * up with init_free_wq. Let's make sure that queued work is
> >  		 * flushed so that we don't hit false positives looking for
> >  		 * insecure pages which are W+X.
> >  		 */
> > -		rcu_barrier();
> 
> Was this the only source of waiters that used rcu_barrier() to sync ?
> What about kallsyms, live-patching ?
> 
> This original source to the addition of this rcu_barrier() (in a slight
> older modified form with with rcu_barrier_sched()) was commit
> ae646f0b9ca13 ("init: fix false positives in W+X checking") since
> v4.17 in 2018, 6 years ago. So I'm hoping we don't have any other
> side-by new users which have grown dependent on this rcu_barrier() for
> other call_rcu()'s they may have used, but it is hard to tell.
> 
Per the condtion 'rodata_enabled' and comments, I think the rcu_barrier() is
only used to synchronize with freeing module init memory.

> So while I agree that flush work is the right solution, removing the
> rcu_barrier() is technically another change which could potentially
> regress for other reasons now. It is perhaps safe, but I'm used to
> surprises for minor changes like these. So I think it makes sense to
> lift it now, and test it in the wild to see what could possibly break,
> I'd much prefer to split this as two separate commits. One which does
> the fix, and another that lifts the rcu_barrier() with the stated
> rationale and savings on time of ~0.1s on PREEMPT_RT kernels.
>
But the only change in patch is to replace rcu_barrier() with flush_module_init_free_work().

Do you mean that keep both flush_module_init_free_work() and rcu_barrier() here?
It sounds a little bit weird IMHO.

>   Luis

-- 
Cheers,
Changbin Du

