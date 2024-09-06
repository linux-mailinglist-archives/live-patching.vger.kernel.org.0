Return-Path: <live-patching+bounces-621-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EE4B496F90F
	for <lists+live-patching@lfdr.de>; Fri,  6 Sep 2024 18:13:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6A2701F215EA
	for <lists+live-patching@lfdr.de>; Fri,  6 Sep 2024 16:13:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 078361D31B4;
	Fri,  6 Sep 2024 16:13:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="SG5VoLbq"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCF601C9ECF
	for <live-patching@vger.kernel.org>; Fri,  6 Sep 2024 16:13:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725639220; cv=none; b=hGFMVVEQmNOYz3MUof3gD25QhgxGfdVcEpxReNKlRf+qNVm4Wb0/JKsb0k1DjUC7chTCflXu+a6mRDPkNvB1VaF0IQ5DRo2fH+SMNSlBYS2NCqejdwAYsLxFJlSMEqsEXxXCb3/fbTNSBJoSAb8lf9QiWr6VGXtT96f6yFxkzF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725639220; c=relaxed/simple;
	bh=6qtHiDnxElIvPDVEWmhk2vdl1c+NLPGnxFLLq5CjDLs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RZwh4yA7ukrQsfuoemqSxK9IDblF+KFL7oKm727MchyZv67lBkjbAEnX8FKsrYQsfk2NYNsGytdPf4TjcuyKQMIYRwqIMF39JnjIy2+H1zKIfNuvGRMgcOVch6wvpYPsY+042RQl0P4ztmFZBWz5QkEudK6krbpYuGrASKGJ71I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=SG5VoLbq; arc=none smtp.client-ip=209.85.167.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-5365b71a6bdso692952e87.2
        for <live-patching@vger.kernel.org>; Fri, 06 Sep 2024 09:13:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1725639217; x=1726244017; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=adpXTAZO60azUV0Ob6AZV0dcnKEkcroMCFDVSYJYFSw=;
        b=SG5VoLbqRYDJQD07r1Hwfp4+dy13rpG1sO2FnbynJL1FAquihFOxFdXhViCxcAiHGO
         HPx9EB1Wjsy4UemusYDf+hsUl0cqNUo/nKQIwej8WDXRqpgrUITV750HvrlTT3yDkHLl
         Y0iWuSVBc4UJYD+DWYajpekl2GHLtLBAYqaPMQCZ5Jd7J1oMXUxxixGoHNb8IieBAAQm
         zwZ3NhR43bZsN0ueSsJJMJ517eyRnAgO+BN+Xw7Mo+znccAYwNhMg0jztylvWRanjiqT
         Bt7q/TkPLL+4Ep5wIpuZqFTHVtPKLOtBVTAyxtj4vXoKo1pEP2ffbFH0MFA822AmAWII
         YW5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725639217; x=1726244017;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=adpXTAZO60azUV0Ob6AZV0dcnKEkcroMCFDVSYJYFSw=;
        b=q9HFVeBspzZhzuuyP7nvBrRconvV8QAG+guLzcBxgzEW6j3zMAG2NLSxUIRyxdSpse
         6Nso+UNcxqcePdkjoqe2CYr5K6TrtNbeVgIcb7DOSqX5ybOYceJlaK9dfns76+4CCm2E
         Q+c2QHpm653zuJ/WvE3XvyBwIrSqjGVBtvk78aPrfSdvcI6RlCo97U3iyu4txWNQ5gjp
         1V02N0D+e3d55zl6P/SoVGNTz7at9P6e/kxC9bHJPitAAFQG7ulfgDaWZer+G/EHrYoB
         P0oCFqw9dxsE26bvqj74lHzIcocUXJh3ICfNY4+i1mMEldNyNxoPLbaBAbAFkcbuS4YW
         VW1A==
X-Forwarded-Encrypted: i=1; AJvYcCUCSe7HM6UNcpALumomsgnd8b0vdTAG8zssBd7Rzw6HMV8ByoMdYO8SJaxKniri7ecvqu/hvUg++YqFfS0q@vger.kernel.org
X-Gm-Message-State: AOJu0YywczUw3AIh2xtFSPGNNEibRfUcc8vKK8LX6Hn5PL78b+WzF1oQ
	QlGGRejFnWb5F9SkU1YIllUPMMJ7lg85twrcIenxZ9OYxd+sn0DMd5BpYKYxYMI=
X-Google-Smtp-Source: AGHT+IFajb+bsrzIRWA8ZFjiVGyZ+YpHk8riHh9kcXtlmaeSyrq2uJsF6Lk4kJ+PapFck/x8hOT71Q==
X-Received: by 2002:a05:6512:1392:b0:533:809:a94d with SMTP id 2adb3069b0e04-536587ad9c5mr2317114e87.17.1725639216687;
        Fri, 06 Sep 2024 09:13:36 -0700 (PDT)
Received: from pathway.suse.cz ([176.114.240.50])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a8a61fbaf9esm294528466b.9.2024.09.06.09.13.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Sep 2024 09:13:36 -0700 (PDT)
Date: Fri, 6 Sep 2024 18:13:34 +0200
From: Petr Mladek <pmladek@suse.com>
To: Miroslav Benes <mbenes@suse.cz>
Cc: Wardenjohn <zhangwarden@gmail.com>, jpoimboe@kernel.org,
	jikos@kernel.org, joe.lawrence@redhat.com,
	live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 2/2] livepatch: Add using attribute to klp_func for
 using function show
Message-ID: <ZtsqLiJPy5e70Ows@pathway.suse.cz>
References: <20240828022350.71456-1-zhangwarden@gmail.com>
 <20240828022350.71456-3-zhangwarden@gmail.com>
 <alpine.LSU.2.21.2409051215140.8559@pobox.suse.cz>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.21.2409051215140.8559@pobox.suse.cz>

On Thu 2024-09-05 12:23:20, Miroslav Benes wrote:
> Hi,
> 
> On Wed, 28 Aug 2024, Wardenjohn wrote:
> 
> > One system may contains more than one livepatch module. We can see
> > which patch is enabled. If some patches applied to one system
> > modifing the same function, livepatch will use the function enabled
> > on top of the function stack. However, we can not excatly know
> > which function of which patch is now enabling.
> > 
> > This patch introduce one sysfs attribute of "using" to klp_func.
> > For example, if there are serval patches  make changes to function
> > "meminfo_proc_show", the attribute "enabled" of all the patch is 1.
> > With this attribute, we can easily know the version enabling belongs
> > to which patch.
> > 
> > The "using" is set as three state. 0 is disabled, it means that this
> > version of function is not used. 1 is running, it means that this
> > version of function is now running. -1 is unknown, it means that
> > this version of function is under transition, some task is still
> > chaning their running version of this function.
> > 
> > cat /sys/kernel/livepatch/<patch1>/<object1>/<function1,sympos>/using -> 0
> > means that the function1 of patch1 is disabled.
> > 
> > cat /sys/kernel/livepatch/<patchN>/<object1>/<function1,sympos>/using -> 1
> > means that the function1 of patchN is enabled.
> > 
> > cat /sys/kernel/livepatch/<patchN>/<object1>/<function1,sympos>/using -> -1
> > means that the function1 of patchN is under transition and unknown.
> > 
> > Signed-off-by: Wardenjohn <zhangwarden@gmail.com>
> 
> I am not a fan. Josh wrote most of my objections already so I will not 
> repeat them. I understand that the attribute might be useful but the 
> amount of code it adds to sensitive functions like 
> klp_complete_transition() is no fun.
> 
> Would it be possible to just use klp_transition_patch and implement the 
> logic just in using_show()? I have not thought through it completely but 
> klp_transition_patch is also an indicator that there is a transition going 
> on. It is set to NULL only after all func->transition are false. So if you 
> check that, you can assign -1 in using_show() immediately and then just 
> look at the top of func_stack.

The 1st patch adds the pointer to struct klp_ops into struct
klp_func. We might check the state a similar way as klp_ftrace_handler().

I had something like this in mind when I suggested to move the pointer:

static ssize_t using_show(struct kobject *kobj,
				struct kobj_attribute *attr, char *buf)
{
	struct klp_func *func, *using_func;
	struct klp_ops *ops;
	int using;

	func = container_of(kobj, struct klp_func, kobj);

	rcu_read_lock();

	if (func->transition) {
		using = -1;
		goto out;
	}

	# FIXME: This requires releasing struct klp_ops via call_rcu()
	ops = func->ops;
	if (!ops) {
		using = 0;
		goto out;
	}

	using_func = list_first_or_null_rcu(&ops->func_stack,
					struct klp_func, stack_node);
	if (func == using_func)
		using = 1;
	else
		using = 0;

out:
	rcu_read_unlock();

	return sysfs_emit(buf, "%d\n", func->using);
}

It is racy and tricky. We probably should add some memory barriers.
And maybe even the ordering of reads should be different.

We could not take klp_mutex because it might cause a deadlock when
the sysfs file gets removed. kobject_put(&func->kobj) is called
by __klp_free_funcs() under klp_mutex.

It would be easier if we could take klp_mutex. But it would require
decrementing the kobject refcout without of klp_mutex. It might
be complicated.

I am afraid that this approach is not worth the effort and
is is not the way to go.

Best Regards,
Petr

