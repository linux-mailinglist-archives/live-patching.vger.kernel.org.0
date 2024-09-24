Return-Path: <live-patching+bounces-678-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5052498447B
	for <lists+live-patching@lfdr.de>; Tue, 24 Sep 2024 13:28:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D08751F23FE2
	for <lists+live-patching@lfdr.de>; Tue, 24 Sep 2024 11:28:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 653531A7055;
	Tue, 24 Sep 2024 11:28:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="QcI40u8C"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33D9B1A704B
	for <live-patching@vger.kernel.org>; Tue, 24 Sep 2024 11:28:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727177284; cv=none; b=FgPkJcIESZkF2jNED7EDI1JHupt6HttiAALnOQuQHOQhcqErD+h075Xbndb1SSZDKh/uTzG9HvVJyMV/6GNkFpd2tETOEqKeVcSYx9hOTzysTBWHoBlKC4GJEMrGGJDLBGLLywic3nwyzYBbFwjUZj4I/TZfWyr/jdAebPPB8Xg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727177284; c=relaxed/simple;
	bh=Vj/+h4clW39HO9NfY4+281e9vNVIw+9TDYWQv30La4U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iOMgIHdr47IgFrB7Zu7p4Wb6sh95dZwCiI85N/qnS9STCwVpdH+R34tiaL6T0fjD8vmDpg3tf/hxWbjzFInNLBP4PQuSdoJJAwE5X2BEeJc+tEjjR1C7ltjYV5zXoTTwJQGhKkJk960ft+on9NHZE161DTLY1f9LKzcvCI3ua2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=QcI40u8C; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-a7aa086b077so707021766b.0
        for <live-patching@vger.kernel.org>; Tue, 24 Sep 2024 04:28:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1727177280; x=1727782080; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4XoewAAgRhjyjtS5SRLJsJLIBsaq3XcQDP2Zckj9flo=;
        b=QcI40u8CJogk78EbCWL+mBQL/RbWnhCQH2yXPEglwTUVEeVmRAgMT+Nmo3sUs4y271
         CHdJAEXaNBJTsvYNz1m3c4jtZRbDKB8vN6iCXBaVAli4BMnk/eM8RycvA19zy4YMxKVp
         gtdu3GggnqwOCnFe9tKll+PXkMbqLqR2GIMLVhu/mqr4LVSfD8GdJRvsK/3K3OKxRsSG
         8YcvjtBhjhUj6Oa7cBEI7ia+4RqrXg1iC0OnS7k2tz0qOzc6P5bVvQV3KSNjBQEmeb/7
         2hymPrfR6pCq2Lcf9I3w7QkvEA3xtzV/bcdZ8CJEeZdSR/BXe5E93Wxl7UVnBUMtoFQ5
         yKEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727177280; x=1727782080;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4XoewAAgRhjyjtS5SRLJsJLIBsaq3XcQDP2Zckj9flo=;
        b=tB+E1wKQdipMT8uuZ8CZQWiOdjY6vgLKcyvT00gdxH6d9InBivpMDH78bzWXa6+Zdh
         iIhVuDMgwpVopsVGwAsQdnQofbZ8mPfGYjc10s4uuHNe9BwicTqrHMuiTmATUSAZy51i
         6bAr86xqip3mR3YrJFZdnqVDX8pK2TAW/tDvGHPousXtLAk0AEgjRQhtudyiJAvZYCXC
         /czrwL2Qwnu0X+8bnQfomZLJE0iGK/ACwnPssbreYIzoD85Z1Fku2xXRlrBg4sBYuOUD
         iH35aQ1ZMYdfo19mas8l6yQYhHAGDHXSqaQ6/iWYIY6W028bQO9LsQVYdkE7Yf6OWqiv
         AnsQ==
X-Forwarded-Encrypted: i=1; AJvYcCWun/Fg2wda7rmSpqz764S1cvodGAC0pu1zkJ/Cl8B3MIH/y3m6wmBKGnIJDdfnuH+XzVdl40ddgVFmkRdx@vger.kernel.org
X-Gm-Message-State: AOJu0YznBJSIxhCEBgS1o41jMZSre2fWlkQVbk0dyGH8Ym1fKYNtMCMM
	rpqiuNF1i673/18dl2nx3vjiHe63sWNwcxb6VBvEYhL1glREmWz1oUtOJfp5C8I=
X-Google-Smtp-Source: AGHT+IHT85zGFTdU3hUBRoI5YQMowHkk2n04uYM4pFq5OpuNGRvYWq9HAfjJCQZ3r8HL3+OJaiZIhQ==
X-Received: by 2002:a17:907:d3dc:b0:a7d:e956:ad51 with SMTP id a640c23a62f3a-a90d4ffe2a3mr1325730466b.21.1727177280584;
        Tue, 24 Sep 2024 04:28:00 -0700 (PDT)
Received: from pathway.suse.cz ([176.114.240.50])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9392f541b8sm73018066b.84.2024.09.24.04.28.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Sep 2024 04:28:00 -0700 (PDT)
Date: Tue, 24 Sep 2024 13:27:58 +0200
From: Petr Mladek <pmladek@suse.com>
To: Wardenjohn <zhangwarden@gmail.com>
Cc: jpoimboe@kernel.org, mbenes@suse.cz, jikos@kernel.org,
	joe.lawrence@redhat.com, live-patching@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] livepatch: introduce 'order' sysfs interface to
 klp_patch
Message-ID: <ZvKiPvID1K0dAHnq@pathway.suse.cz>
References: <20240920090404.52153-1-zhangwarden@gmail.com>
 <20240920090404.52153-2-zhangwarden@gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240920090404.52153-2-zhangwarden@gmail.com>

On Fri 2024-09-20 17:04:03, Wardenjohn wrote:
> This feature can provide livepatch patch order information.
> With the order of sysfs interface of one klp_patch, we can
> use patch order to find out which function of the patch is
> now activate.
> 
> After the discussion, we decided that patch-level sysfs
> interface is the only accaptable way to introduce this
> information.
> 
> This feature is like:
> cat /sys/kernel/livepatch/livepatch_1/order -> 1
> means this livepatch_1 module is the 1st klp patch applied.
> 
> cat /sys/kernel/livepatch/livepatch_module/order -> N
> means this lviepatch_module is the Nth klp patch applied
> to the system.
>
> --- a/kernel/livepatch/transition.c
> +++ b/kernel/livepatch/transition.c
> @@ -46,6 +46,15 @@ EXPORT_SYMBOL(klp_sched_try_switch_key);
>  
>  #endif /* CONFIG_PREEMPT_DYNAMIC && CONFIG_HAVE_PREEMPT_DYNAMIC_CALL */
>  
> +static inline int klp_get_patch_order(struct klp_patch *patch)
> +{
> +	int order = 0;
> +
> +	klp_for_each_patch(patch)
> +		order = order + 1;
> +	return order;
> +}

This does not work well. It uses the order on the stack when
the livepatch is being loaded. It is not updated when any livepatch gets
removed. It might create wrong values.

I have even tried to reproduce this:

	# modprobe livepatch-sample
	# modprobe livepatch-shadow-fix1
	# cat /sys/kernel/livepatch/livepatch_sample/order
	1
	# cat /sys/kernel/livepatch/livepatch_shadow_fix1/order
	2

	# echo 0 >/sys/kernel/livepatch/livepatch_sample/enabled
	# rmmod livepatch_sample
	# cat /sys/kernel/livepatch/livepatch_shadow_fix1/order
	2

	# modprobe livepatch-sample
	# cat /sys/kernel/livepatch/livepatch_shadow_fix1/order
	2
	# cat /sys/kernel/livepatch/livepatch_sample/order
	2

BANG: The livepatches have the same order.

I suggest to replace this with a global load counter. Something like:

diff --git a/include/linux/livepatch.h b/include/linux/livepatch.h
index 51a258c24ff5..44a8887573bb 100644
--- a/include/linux/livepatch.h
+++ b/include/linux/livepatch.h
@@ -150,10 +150,12 @@ struct klp_state {
  * @list:	list node for global list of actively used patches
  * @kobj:	kobject for sysfs resources
  * @obj_list:	dynamic list of the object entries
+ * @load_counter sequence counter in which the patch is loaded
  * @enabled:	the patch is enabled (but operation may be incomplete)
  * @forced:	was involved in a forced transition
  * @free_work:	patch cleanup from workqueue-context
  * @finish:	for waiting till it is safe to remove the patch module
+ * @order:	the order of this patch applied to the system
  */
 struct klp_patch {
 	/* external */
@@ -166,6 +168,7 @@ struct klp_patch {
 	struct list_head list;
 	struct kobject kobj;
 	struct list_head obj_list;
+	int load_counter;
 	bool enabled;
 	bool forced;
 	struct work_struct free_work;
diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index 3c21c31796db..3a858477ae02 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -44,6 +44,9 @@ DEFINE_MUTEX(klp_mutex);
  */
 LIST_HEAD(klp_patches);
 
+/* The counter is incremented everytime a new livepatch is being loaded. */
+static int klp_load_counter;
+
 static struct kobject *klp_root_kobj;
 
 static bool klp_is_module(struct klp_object *obj)
@@ -347,6 +350,7 @@ int klp_apply_section_relocs(struct module *pmod, Elf_Shdr *sechdrs,
  * /sys/kernel/livepatch/<patch>/transition
  * /sys/kernel/livepatch/<patch>/force
  * /sys/kernel/livepatch/<patch>/replace
+ * /sys/kernel/livepatch/<patch>/load_counter
  * /sys/kernel/livepatch/<patch>/<object>
  * /sys/kernel/livepatch/<patch>/<object>/patched
  * /sys/kernel/livepatch/<patch>/<object>/<function,sympos>
@@ -452,15 +456,26 @@ static ssize_t replace_show(struct kobject *kobj,
 	return sysfs_emit(buf, "%d\n", patch->replace);
 }
 
+static ssize_t load_counter_show(struct kobject *kobj,
+			struct kobj_attribute *attr, char *buf)
+{
+	struct klp_patch *patch;
+
+	patch = container_of(kobj, struct klp_patch, kobj);
+	return sysfs_emit(buf, "%d\n", patch->load_counter);
+}
+
 static struct kobj_attribute enabled_kobj_attr = __ATTR_RW(enabled);
 static struct kobj_attribute transition_kobj_attr = __ATTR_RO(transition);
 static struct kobj_attribute force_kobj_attr = __ATTR_WO(force);
 static struct kobj_attribute replace_kobj_attr = __ATTR_RO(replace);
+static struct kobj_attribute load_counter_kobj_attr = __ATTR_RO(load_counter);
 static struct attribute *klp_patch_attrs[] = {
 	&enabled_kobj_attr.attr,
 	&transition_kobj_attr.attr,
 	&force_kobj_attr.attr,
 	&replace_kobj_attr.attr,
+	&load_counter_kobj_attr.attr,
 	NULL
 };
 ATTRIBUTE_GROUPS(klp_patch);
@@ -934,6 +949,7 @@ static void klp_init_patch_early(struct klp_patch *patch)
 	INIT_LIST_HEAD(&patch->list);
 	INIT_LIST_HEAD(&patch->obj_list);
 	kobject_init(&patch->kobj, &klp_ktype_patch);
+	patch->load_counter = klp_load_counter + 1;
 	patch->enabled = false;
 	patch->forced = false;
 	INIT_WORK(&patch->free_work, klp_free_patch_work_fn);
@@ -1050,6 +1066,7 @@ static int __klp_enable_patch(struct klp_patch *patch)
 	}
 
 	klp_start_transition();
+	klp_load_counter++;
 	patch->enabled = true;
 	klp_try_complete_transition();
 
-- 
2.46.1

Any better (shorter) name would be appreciated ;-)

Best Regards,
Petr

