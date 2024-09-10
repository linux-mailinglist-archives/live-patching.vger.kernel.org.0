Return-Path: <live-patching+bounces-641-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 43227972B68
	for <lists+live-patching@lfdr.de>; Tue, 10 Sep 2024 10:03:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F2C97285841
	for <lists+live-patching@lfdr.de>; Tue, 10 Sep 2024 08:03:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2B19187357;
	Tue, 10 Sep 2024 08:01:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="BhhXNrKZ"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D62BD186E4B
	for <live-patching@vger.kernel.org>; Tue, 10 Sep 2024 08:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725955312; cv=none; b=N9yATbQS7947H3uis3pjO9wJYUNNl12qha4YyZQ/d4rLOkYCpcsSQiB7hEI4nZkIe/IfiMFrEMSkKBElQ3J8G9nJRWmrjSyw0Dcp+kuaDX2KMm2XyDBybNvVqZI329kMdeBuvL8YKOzq+Pbn876nqYNG64Z1Ncn1KEo5R20jnGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725955312; c=relaxed/simple;
	bh=fliTI4ku+2nc6L0W4Ad5abYeryIU2dtOv5FKC4kJkK8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TJWEFNyWYLoTSBmcsjJiqUEC1Q6mji86XRxD/gG6PM3hk2IutDGra/KuOSBWrvOeoiJ81NqhfvrFxrq8wDXSERlNZ58saJHfSm3/GJj3KFm1P0y7Gnj0zAKkRwRG0Wgmaq2AndR7f3Js1P8CZJIe1WjTOksKVyXfo5641LRRKYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=BhhXNrKZ; arc=none smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-5c251ba0d1cso532535a12.3
        for <live-patching@vger.kernel.org>; Tue, 10 Sep 2024 01:01:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1725955309; x=1726560109; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=u2HXx27vJakYic9aWVU4rnACS7qhR7kcJ+b+F6ySTEw=;
        b=BhhXNrKZKMyH5EYGWHxI7GcKp70lPmaUhfb6a9GN1k4FTbgK8Gbbj1fhXr/Y56oLh6
         au7L1tiVofZBQdVbA2EViHZig7w8DdFdwkvo/P8P9rZRHAGAyr9RKbd5k6tEFK+1uarI
         bUaTyBndq5SLuetqE3MD56Iy+jpF+JHLRYKXadc1DA0oJLl8b5RGVjRPkcxuDB7+5hq+
         txCn6huZpxJGoa48Og0y6IqN+DHrAQQ4uiJue8H/k2a6r81jdSyDHfk3OIvuHOForliB
         mcxKZBM3vr6JEsoH+kIzODeqg5FOW3ix3Cb0aYmtWgUK3IVt8PDwOY/nUMgcwwl104wY
         SlSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725955309; x=1726560109;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u2HXx27vJakYic9aWVU4rnACS7qhR7kcJ+b+F6ySTEw=;
        b=tmCENkUFIdD/Zv6sP7RMoc35v+dzfnBiHP61DcZvEVUT94nxYsk4JYvWuxVtQE81Jk
         ehWH9QXWyNrcOcznc+zhjjy9tkDCoLjs6pyJGU8xqofpFjIpBjWv7RNP9nJHpiRoizcN
         +ZdNXvnkt20AosNycoB2PEMx4D8oY3KXWTRA4ujSucZcdK4+aQAJiZUUvvz7byV0BV24
         T8htZtOcNcS6XmdngcUCJsAb4mrVzrA0HUoYU6NfYxqMFBOnQSXv4PtZr4L2V5gDmHU8
         wmaAs4oLBBrSviVCs6pTkgFii7YpuEOpZ5Fnr81aLlG42SmqnYm7w4mhQZpwobPHP7fW
         aMdA==
X-Forwarded-Encrypted: i=1; AJvYcCXAqtaLqcJRrNV+WQpvchxFyC6A2QMTbz5Yan514Yae2UynrJWojtFrUJK/qdad2UXA8npCStQfXHBYEP09@vger.kernel.org
X-Gm-Message-State: AOJu0Yy5bgBLqtYwj1uY+xI+fTaLDIp2p9wFC63Tbs68QKMM6hBgpdTe
	t8uEeQ6X9Ol0rWk330kcLwHLFzSgFMMu8vg1qcdgK1NmyAuQkLk3zm1xLVomIgI=
X-Google-Smtp-Source: AGHT+IHr3avMGlJNYFmUlmiQLM7eBFWFezrmyKcnEv8CK4mGzrZPx/NLsrObWoaM30sj+QoeSNwPww==
X-Received: by 2002:a05:6402:42cb:b0:5a3:a4d7:caf5 with SMTP id 4fb4d7f45d1cf-5c3dc7c9cc1mr7089291a12.36.1725955308754;
        Tue, 10 Sep 2024 01:01:48 -0700 (PDT)
Received: from pathway.suse.cz ([176.114.240.50])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5c3ebd523b4sm3962515a12.51.2024.09.10.01.01.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Sep 2024 01:01:48 -0700 (PDT)
Date: Tue, 10 Sep 2024 10:01:46 +0200
From: Petr Mladek <pmladek@suse.com>
To: zhang warden <zhangwarden@gmail.com>
Cc: Miroslav Benes <mbenes@suse.cz>, Josh Poimboeuf <jpoimboe@kernel.org>,
	Jiri Kosina <jikos@kernel.org>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 2/2] livepatch: Add using attribute to klp_func for
 using function show
Message-ID: <Zt_86rOMJN4UFEk-@pathway.suse.cz>
References: <20240828022350.71456-1-zhangwarden@gmail.com>
 <20240828022350.71456-3-zhangwarden@gmail.com>
 <alpine.LSU.2.21.2409051215140.8559@pobox.suse.cz>
 <ZtsqLiJPy5e70Ows@pathway.suse.cz>
 <B250EB77-AFB0-4D32-BA4E-3B96976F8A82@gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <B250EB77-AFB0-4D32-BA4E-3B96976F8A82@gmail.com>

On Sun 2024-09-08 10:51:14, zhang warden wrote:
> 
> Hi, Petr
> > 
> > The 1st patch adds the pointer to struct klp_ops into struct
> > klp_func. We might check the state a similar way as klp_ftrace_handler().
> > 
> > I had something like this in mind when I suggested to move the pointer:
> > 
> > static ssize_t using_show(struct kobject *kobj,
> > struct kobj_attribute *attr, char *buf)
> > {
> > struct klp_func *func, *using_func;
> > struct klp_ops *ops;
> > int using;
> > 
> > func = container_of(kobj, struct klp_func, kobj);
> > 
> > rcu_read_lock();
> > 
> > if (func->transition) {
> > using = -1;
> > goto out;
> > }
> > 
> > # FIXME: This requires releasing struct klp_ops via call_rcu()

This would require adding "struct rcu_head" into "struct klp_ops",
like:

struct klp_ops {
	struct list_head func_stack;
	struct ftrace_ops fops;
	struct rcu_head rcu;
};

and then freeing the structure using kfree_rcu():

diff --git a/kernel/livepatch/patch.c b/kernel/livepatch/patch.c
index 90408500e5a3..f096dd9390d2 100644
--- a/kernel/livepatch/patch.c
+++ b/kernel/livepatch/patch.c
@@ -149,7 +149,7 @@ static void klp_unpatch_func(struct klp_func *func)
 
 		list_del_rcu(&func->stack_node);
 		list_del(&ops->node);
-		kfree(ops);
+		kfree_rcu(ops, rcu);
 	} else {
 		list_del_rcu(&func->stack_node);
 	}
@@ -223,7 +223,7 @@ static int klp_patch_func(struct klp_func *func)
 err:
 	list_del_rcu(&func->stack_node);
 	list_del(&ops->node);
-	kfree(ops);
+	kfree_rcu(ops, rcu);
 	return ret;
 }

With this the function should be safe against accessing an invalid
pointer.

> > ops = func->ops;
> > if (!ops) {
> > using = 0;
> > goto out;
> > }
> > 
> > using_func = list_first_or_null_rcu(&ops->func_stack,
> > struct klp_func, stack_node);
> > if (func == using_func)
> > using = 1;
> > else
> > using = 0;
> > 
> > out:
> > rcu_read_unlock();
> > 
> > return sysfs_emit(buf, "%d\n", func->using);
> > }

But the function is still not correct according the order of reading.
A more correct solution would be something like:

static ssize_t using_show(struct kobject *kobj,
				struct kobj_attribute *attr, char *buf)
{
	struct klp_func *func, *using_func;
	struct klp_ops *ops;
	int using;

	func = container_of(kobj, struct klp_func, kobj);

	rcu_read_lock();

	/* This livepatch is used when the function is on top of the stack. */
	ops = func->ops;
	if (ops) {
		using_func = list_first_or_null_rcu(&ops->func_stack,
						struct klp_func, stack_node);
		if (func == using_func)
			using = 1;
		else
			using = 0;
	}

	/*
	 * The function stack gives the right information only when there
	 * is no transition in progress.
	 *
	 * Make sure that we see the updated ops->func_stack when
	 * func->transition is cleared. This matches with:
	 *
	 * The write barrier in  __klp_enable_patch() between
	 * klp_init_transition() and klp_patch_object().
	 *
	 * The write barrier in  __klp_disable_patch() between
	 * klp_init_transition() and klp_start_transition().
	 *
	 * The write barrier in klp_complete_transition()
	 * between klp_unpatch_objects() and func->transition = false.
	 */
	smp_rmb();

	if (func->transition)
		using = -1;

	rcu_read_unlock();

	return sysfs_emit(buf, "%d\n", func->using);
}

Now, the question is whether we want to maintain such a barrier. Any
lockless access and barrier adds a maintenance burden.

You might try to put the above into a patch see what others tell
about it.

Best Regards,
Petr

