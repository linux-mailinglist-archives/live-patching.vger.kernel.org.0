Return-Path: <live-patching+bounces-1910-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0241FD3BABD
	for <lists+live-patching@lfdr.de>; Mon, 19 Jan 2026 23:20:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id A0D97300B37D
	for <lists+live-patching@lfdr.de>; Mon, 19 Jan 2026 22:20:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9DCAC2FDC4D;
	Mon, 19 Jan 2026 22:20:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="L+lW50v6"
X-Original-To: live-patching@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEE492F7440
	for <live-patching@vger.kernel.org>; Mon, 19 Jan 2026 22:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768861209; cv=none; b=hj0LstLMJKVzoH05gJ56JD1s0EpWqdjkwMNVG2zdpU+TacoRjXKZDwym/1X0MOStCdpJq983FFSS2+rFNxuvDs/AbJPNhJ0hpQuNSWpvgbGNFHn3yY72e4aISHHC+uuwJuA9fEShZfMjnk2UQ9zLF2pVGxhRDstS10HpS9+tSNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768861209; c=relaxed/simple;
	bh=i7Vka5cBOmMCzqwXf8vHQ+0qPJSKjtgHQwwxyEfUnDI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QzlCBS5m8+1uQUaHWyM2r2lZvpEszL/Q/AJckG0GcGL5FHfxR7GbDgzjmX2XynaXVWt5PQGU/tHVI7AWarQENCLC2wCFbWqTuuPg9PjdhjIZNG5uWfIsIthaq193OzamHkT0HLAgVu1yjbhIazQ64C3KghzEMVqzniiecgLhwNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=L+lW50v6; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768861207;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xS4KN3jR3NZDNE6uFYrItJViNkTJBI9nlgCpQMd0lng=;
	b=L+lW50v6P1+Q1UDQ95k+maFZt4djowh+2n9NKkHdOI4f3/qU1B26cDiBkF+4xiBwBuntoe
	303NMdB1q75HZVPLD/a/dFW87bgDdtvGWnuDKzyUlPTyUwcT3KedhZPJCNiatW15kKhSAd
	7bsDuHj0upyF9nnQ66HoNqxRGgtDZ1A=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-84-PyhNjVFiN8K4mgy0QwPIwQ-1; Mon,
 19 Jan 2026 17:20:02 -0500
X-MC-Unique: PyhNjVFiN8K4mgy0QwPIwQ-1
X-Mimecast-MFC-AGG-ID: PyhNjVFiN8K4mgy0QwPIwQ_1768861200
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D8A6F195609D;
	Mon, 19 Jan 2026 22:19:59 +0000 (UTC)
Received: from redhat.com (unknown [10.22.64.98])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 58DF519560A2;
	Mon, 19 Jan 2026 22:19:56 +0000 (UTC)
Date: Mon, 19 Jan 2026 17:19:53 -0500
From: Joe Lawrence <joe.lawrence@redhat.com>
To: Petr Pavlu <petr.pavlu@suse.com>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>, Jiri Kosina <jikos@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Daniel Gomez <da.gomez@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	Aaron Tomlin <atomlin@atomlin.com>,
	Peter Zijlstra <peterz@infradead.org>,
	live-patching@vger.kernel.org, linux-modules@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] livepatch: Fix having __klp_objects relics in
 non-livepatch modules
Message-ID: <aW6uCQNXj0Y7IGnz@redhat.com>
References: <20260114123056.2045816-1-petr.pavlu@suse.com>
 <20260114123056.2045816-2-petr.pavlu@suse.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260114123056.2045816-2-petr.pavlu@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

On Wed, Jan 14, 2026 at 01:29:53PM +0100, Petr Pavlu wrote:
> The linker script scripts/module.lds.S specifies that all input
> __klp_objects sections should be consolidated into an output section of
> the same name, and start/stop symbols should be created to enable
> scripts/livepatch/init.c to locate this data.
> 
> This start/stop pattern is not ideal for modules because the symbols are
> created even if no __klp_objects input sections are present.
> Consequently, a dummy __klp_objects section also appears in the
> resulting module. This unnecessarily pollutes non-livepatch modules.
> 
> Instead, since modules are relocatable files, the usual method for
> locating consolidated data in a module is to read its section table.
> This approach avoids the aforementioned problem.
> 
> The klp_modinfo already stores a copy of the entire section table with
> the final addresses. Introduce a helper function that
> scripts/livepatch/init.c can call to obtain the location of the
> __klp_objects section from this data.
> 
> Signed-off-by: Petr Pavlu <petr.pavlu@suse.com>
> ---
>  include/linux/livepatch.h |  3 +++
>  kernel/livepatch/core.c   | 20 ++++++++++++++++++++
>  scripts/livepatch/init.c  | 17 ++++++-----------
>  scripts/module.lds.S      |  7 +------
>  4 files changed, 30 insertions(+), 17 deletions(-)
> 
> diff --git a/include/linux/livepatch.h b/include/linux/livepatch.h
> index 772919e8096a..ca90adbe89ed 100644
> --- a/include/linux/livepatch.h
> +++ b/include/linux/livepatch.h
> @@ -175,6 +175,9 @@ int klp_enable_patch(struct klp_patch *);
>  int klp_module_coming(struct module *mod);
>  void klp_module_going(struct module *mod);
>  
> +struct klp_object_ext *klp_build_locate_init_objects(const struct module *mod,
> +						     unsigned int *nr_objs);
> +
>  void klp_copy_process(struct task_struct *child);
>  void klp_update_patch_state(struct task_struct *task);
>  
> diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
> index 9917756dae46..4e0ac47b3623 100644
> --- a/kernel/livepatch/core.c
> +++ b/kernel/livepatch/core.c
> @@ -1356,6 +1356,26 @@ void klp_module_going(struct module *mod)
>  	mutex_unlock(&klp_mutex);
>  }
>  
> +struct klp_object_ext *klp_build_locate_init_objects(const struct module *mod,
> +						     unsigned int *nr_objs)
> +{
> +	struct klp_modinfo *info = mod->klp_info;
> +
> +	for (int i = 1; i < info->hdr.e_shnum; i++) {
> +		Elf_Shdr *shdr = &info->sechdrs[i];
> +
> +		if (strcmp(info->secstrings + shdr->sh_name, "__klp_objects"))
> +			continue;
> +

Since this function is doing a string comparision to find the ELF
section, would it make sense to open up the API by allowing to caller to
specify the sh_name?  That would give scripts/livepatch/init.c future
flexibility in finding similarly crafted data structures.  Disregard if
there is already a pattern of doing it this way :)

> +		*nr_objs = shdr->sh_size / sizeof(struct klp_object_ext);
> +		return (struct klp_object_ext *)shdr->sh_addr;
> +	}
> +
> +	*nr_objs = 0;
> +	return NULL;
> +}
> +EXPORT_SYMBOL_GPL(klp_build_locate_init_objects);
> +
>  static int __init klp_init(void)
>  {
>  	klp_root_kobj = kobject_create_and_add("livepatch", kernel_kobj);
> diff --git a/scripts/livepatch/init.c b/scripts/livepatch/init.c
> index 2274d8f5a482..23e037d6de19 100644
> --- a/scripts/livepatch/init.c
> +++ b/scripts/livepatch/init.c
> @@ -9,19 +9,16 @@
>  #include <linux/slab.h>
>  #include <linux/livepatch.h>
>  
> -extern struct klp_object_ext __start_klp_objects[];
> -extern struct klp_object_ext __stop_klp_objects[];
> -
>  static struct klp_patch *patch;
>  
>  static int __init livepatch_mod_init(void)
>  {
> +	struct klp_object_ext *obj_exts;
>  	struct klp_object *objs;
>  	unsigned int nr_objs;
>  	int ret;
>  
> -	nr_objs = __stop_klp_objects - __start_klp_objects;
> -
> +	obj_exts = klp_build_locate_init_objects(THIS_MODULE, &nr_objs);
>  	if (!nr_objs) {
>  		pr_err("nothing to patch!\n");
>  		ret = -EINVAL;
> @@ -41,7 +38,7 @@ static int __init livepatch_mod_init(void)
>  	}
>  
>  	for (int i = 0; i < nr_objs; i++) {
> -		struct klp_object_ext *obj_ext = __start_klp_objects + i;
> +		struct klp_object_ext *obj_ext = obj_exts + i;
>  		struct klp_func_ext *funcs_ext = obj_ext->funcs;
>  		unsigned int nr_funcs = obj_ext->nr_funcs;
>  		struct klp_func *funcs = objs[i].funcs;
> @@ -90,12 +87,10 @@ static int __init livepatch_mod_init(void)
>  
>  static void __exit livepatch_mod_exit(void)
>  {
> -	unsigned int nr_objs;
> -
> -	nr_objs = __stop_klp_objects - __start_klp_objects;
> +	struct klp_object *obj;
>  
> -	for (int i = 0; i < nr_objs; i++)
> -		kfree(patch->objs[i].funcs);
> +	klp_for_each_object_static(patch, obj)
> +		kfree(obj->funcs);
>  
>  	kfree(patch->objs);
>  	kfree(patch);
> diff --git a/scripts/module.lds.S b/scripts/module.lds.S
> index 3037d5e5527c..383d19beffb4 100644
> --- a/scripts/module.lds.S
> +++ b/scripts/module.lds.S
> @@ -35,12 +35,7 @@ SECTIONS {
>  	__patchable_function_entries : { *(__patchable_function_entries) }
>  
>  	__klp_funcs		0: ALIGN(8) { KEEP(*(__klp_funcs)) }
> -
> -	__klp_objects		0: ALIGN(8) {
> -		__start_klp_objects = .;
> -		KEEP(*(__klp_objects))
> -		__stop_klp_objects = .;
> -	}
> +	__klp_objects		0: ALIGN(8) { KEEP(*(__klp_objects)) }
>  
>  #ifdef CONFIG_ARCH_USES_CFI_TRAPS
>  	__kcfi_traps		: { KEEP(*(.kcfi_traps)) }
> -- 
> 2.52.0
> 

Acked-by: Joe Lawrence <joe.lawrence@redhat.com>

--
Joe


