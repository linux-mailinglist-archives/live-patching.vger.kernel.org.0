Return-Path: <live-patching+bounces-679-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AE846984836
	for <lists+live-patching@lfdr.de>; Tue, 24 Sep 2024 17:05:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DCFBA1C21BF9
	for <lists+live-patching@lfdr.de>; Tue, 24 Sep 2024 15:05:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC03F1AAE2C;
	Tue, 24 Sep 2024 15:05:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="VNg54uxr"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F1A91AB52A
	for <live-patching@vger.kernel.org>; Tue, 24 Sep 2024 15:05:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727190352; cv=none; b=k0JdwNLlAwNHyi6NBKjO//Sf7sGQqXlCtuFr6BAxL6mApvwTycV4IKmWh16eFw/FaBhnNhWmrgF01z7wqTIxeNmtTxM1ceNVM9taIOf4aESzJwCYZoobI5ATwANg+ZglXQzkzi9mRqgrZNCsZEYN3XvB1mypYKB6UQ2WSacTUlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727190352; c=relaxed/simple;
	bh=PCfy5KVVKya/2o8NL7D7kX9ER1/XY+e91M/AiirAvBM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BcGBAI0u7vT1pQo6olvSjaGs6soHnCqUjsf4nfzq48QDIwVrGOd+uC3G3nxmTbEevoWk9kB+VuIDzSCzNi89wkFj9AuRjR5UitfbqYhb7pPxwR2uL0BeXQSvaAeYK5ZwYDvFYVGj9ff67pzJzlBiairiTnQQAJfoKoIIVYfZtx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=VNg54uxr; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-5c5b954c359so3749279a12.1
        for <live-patching@vger.kernel.org>; Tue, 24 Sep 2024 08:05:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1727190348; x=1727795148; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=D2iTwpQZftFZk5BO85zj81zyNaojiHPKdJA92bcWkxY=;
        b=VNg54uxr7bhImnv958TGDOnFvRW/nKAdJNgQXRETWs43xodC3DyQxY/k2CW4YVeI/w
         tXhetpojnm3IpK/lhMp0hDbQk5PYdc/VnQ7OWuqjGD7hNlBWdryZYZZt9CwbJR5CEY0z
         FOvdi15N0Ok9q2dH8fM9XzwkNbYAJlTGoaP8FeyCU4eLrM3EaRPG0JisEu8nk8JCPpSw
         3vrie7YpuZ0/yrsiTp3W5pmCMqxiXSz6FFwYUF8BdQQ8x6UBpyNot12rUBWwks/5Jz8W
         cyr+4ygtKZ/7K+z2XeVcRuY2WngNl8h681B0fjzoX1Z3HOrPKWGgMYEZJROXZplJV5vb
         qQWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727190348; x=1727795148;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D2iTwpQZftFZk5BO85zj81zyNaojiHPKdJA92bcWkxY=;
        b=tj7eQXoi6t3DsaW/wr95+++p2QkgI0E950DD3aXzxDRaHCi/QJvOXjwf2EsdfwNCgB
         d04a6ISNHGpU8bemjzoBpMKSEe6It160NIGy9BC/geP/sWJ5hnXNH4iU5z+vhB+tZO0j
         t64uINZQHrf7JM3eJ5vlO3/JvdagVCwwoZpYsfdwmQMUjd4rpXcTyVzzOceJRE8NOhyz
         jT5qhSOPJfmukBOhNCJNkcrvEATZePspf1NMdnjxfqKxwC8qA147Kba020GfrAYGEx7Z
         BwPVzw7oD27pZfNCa3Kw1xDExmRnn7+uV0ifQ6Pd/k+xqLIJvAZNVhHr34eqnFxexJqe
         E7ug==
X-Forwarded-Encrypted: i=1; AJvYcCX+XzqP/0RM8IcrGoTu4iw9URn1H+qRth1jhTnQd/CFsasQHcfRQ461fqVqyPAxo4uRfo3QPY3OsFYD64Im@vger.kernel.org
X-Gm-Message-State: AOJu0Yy9KLEGysDRCOIL7u1VW80/vri5Nnw7Mvs6Re0/VsxQbaf9mLTL
	fJLtAAbrTwdC2+Zl25eHDiptbp6Z5o9iDDJQVqIj10vzC9/WoYGubScByIfA9RgqpA0Gq3E84ho
	u
X-Google-Smtp-Source: AGHT+IGDj42uHYf5JdWGadh2EeUma95TCLAbhJROOWqmECYWhhARn8GvnOmClPslhJxH0GdhwfAvSw==
X-Received: by 2002:a05:6402:3219:b0:5c4:2fa2:93ed with SMTP id 4fb4d7f45d1cf-5c464a43a9fmr15392217a12.16.1727190348427;
        Tue, 24 Sep 2024 08:05:48 -0700 (PDT)
Received: from pathway.suse.cz ([176.114.240.50])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5c5cf4c5264sm822845a12.74.2024.09.24.08.05.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Sep 2024 08:05:48 -0700 (PDT)
Date: Tue, 24 Sep 2024 17:05:46 +0200
From: Petr Mladek <pmladek@suse.com>
To: Wardenjohn <zhangwarden@gmail.com>
Cc: jpoimboe@kernel.org, mbenes@suse.cz, jikos@kernel.org,
	joe.lawrence@redhat.com, live-patching@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] livepatch: introduce 'order' sysfs interface to
 klp_patch
Message-ID: <ZvLVSq7AQBFwVmsW@pathway.suse.cz>
References: <20240920090404.52153-1-zhangwarden@gmail.com>
 <20240920090404.52153-2-zhangwarden@gmail.com>
 <ZvKiPvID1K0dAHnq@pathway.suse.cz>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZvKiPvID1K0dAHnq@pathway.suse.cz>

On Tue 2024-09-24 13:27:58, Petr Mladek wrote:
> On Fri 2024-09-20 17:04:03, Wardenjohn wrote:
> > This feature can provide livepatch patch order information.
> > With the order of sysfs interface of one klp_patch, we can
> > use patch order to find out which function of the patch is
> > now activate.
> > 
> > After the discussion, we decided that patch-level sysfs
> > interface is the only accaptable way to introduce this
> > information.
> > 
> > This feature is like:
> > cat /sys/kernel/livepatch/livepatch_1/order -> 1
> > means this livepatch_1 module is the 1st klp patch applied.
> > 
> > cat /sys/kernel/livepatch/livepatch_module/order -> N
> > means this lviepatch_module is the Nth klp patch applied
> > to the system.
> >
> > --- a/kernel/livepatch/transition.c
> > +++ b/kernel/livepatch/transition.c
> > @@ -46,6 +46,15 @@ EXPORT_SYMBOL(klp_sched_try_switch_key);
> >  
> >  #endif /* CONFIG_PREEMPT_DYNAMIC && CONFIG_HAVE_PREEMPT_DYNAMIC_CALL */
> >  
> > +static inline int klp_get_patch_order(struct klp_patch *patch)
> > +{
> > +	int order = 0;
> > +
> > +	klp_for_each_patch(patch)
> > +		order = order + 1;
> > +	return order;
> > +}
> 
> This does not work well. It uses the order on the stack when
> the livepatch is being loaded. It is not updated when any livepatch gets
> removed. It might create wrong values.
> 
> I have even tried to reproduce this:
> 
> 	# modprobe livepatch-sample
> 	# modprobe livepatch-shadow-fix1
> 	# cat /sys/kernel/livepatch/livepatch_sample/order
> 	1
> 	# cat /sys/kernel/livepatch/livepatch_shadow_fix1/order
> 	2
> 
> 	# echo 0 >/sys/kernel/livepatch/livepatch_sample/enabled
> 	# rmmod livepatch_sample
> 	# cat /sys/kernel/livepatch/livepatch_shadow_fix1/order
> 	2
> 
> 	# modprobe livepatch-sample
> 	# cat /sys/kernel/livepatch/livepatch_shadow_fix1/order
> 	2
> 	# cat /sys/kernel/livepatch/livepatch_sample/order
> 	2
> 
> BANG: The livepatches have the same order.
> 
> I suggest to replace this with a global load counter. Something like:

Wait! Miroslav asked me on chat about a possibility to use klp_mutex
in the sysfs order_show() callback. It is a good point.

If I get it correctly then we actually could take klp_mutex in
the sysfs callbacks associated with struct klp_patch, similar
to enabled_store().

It should be safe because the "final" kobject_put(&patch->kobj) is
called without klp_mutex, see klp_free_patch_finish(). It was
explicitly done this way to allow taking klp_mutex in
enabled_store().

Note that it was not safe to take klp_mutex in the sysfs callback
associated with struct klp_func. The "final" kobject_put(&func->kobj)
is called under klp_mutex, see __klp_free_funcs().


Back to the order_show(). We could take klp_mutex there => we do not
need to store the order in struct klp_patch. Instead, we could do
something like:

static ssize_t order_show(struct kobject *kobj,
			struct kobj_attribute *attr, char *buf)
{
	struct klp_patch *this_patch, *patch;
	int order;

	this_patch = container_of(kobj, struct klp_patch, kobj);

	mutex_lock(&klp_mutex);

	order = 0;
	klp_for_each_patch(patch) {
		order++;
		if (patch == this_patch)
			break;
	}

	mutex_unlock(&klp_mutex);

	return sysfs_emit(buf, "%d\n", order);
}

BTW: I would prefer to rename the attribute from "order" to "stack_order".
     IMHO, it would make the meaning more clear.

Best Regards,
Petr

