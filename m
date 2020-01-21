Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9964143BC5
	for <lists+live-patching@lfdr.de>; Tue, 21 Jan 2020 12:11:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729242AbgAULLv (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 21 Jan 2020 06:11:51 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:34258 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726473AbgAULLv (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 21 Jan 2020 06:11:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579605110;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QKqg0qIuNTWeOPp5PQFP1u+dmbGkLpoIFnrni/uLk+I=;
        b=dJ1niJp+TNGJd7wJD1/JV5irmwYRGNwYNQTyvrNZFgRNo93X6pQ1AZtBzwNaezqanqgNW3
        qS4aH23ENo9Ujj7BQ+NKkfqfv397GcXK6evBkVVgn6ojSUhBFqaFza168Z9FfpPR3SXDHA
        xRt5Mb8NqyFt4gi026i0pfNtej/k2Zw=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-297--ISVJ4vjNmqzRd3Trd3xkw-1; Tue, 21 Jan 2020 06:11:49 -0500
X-MC-Unique: -ISVJ4vjNmqzRd3Trd3xkw-1
Received: by mail-wm1-f71.google.com with SMTP id y125so664422wmg.1
        for <live-patching@vger.kernel.org>; Tue, 21 Jan 2020 03:11:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QKqg0qIuNTWeOPp5PQFP1u+dmbGkLpoIFnrni/uLk+I=;
        b=l3LqUY+F6aV1r7zSrRgbwGzNx4bNSPzuw0TnKuOCPEmgQodvR6lkK7TEhCLrh+wkYR
         da0mOIi3fG5dl8qPODPsPjEMq/wUUZIvInRP+w/zEZ6tWT/E40Gks4FgUbtr/VjEWCuw
         8PWo/hTb3wni23guMdMCtAXRIXC/jD6aKpUvxvJyUps7en8yAR0zqosTKZAW6tWasj3D
         feCVoqmKetvP/wt4VRE25kPwxeyl5P13H6dsnIOdxnjkoMLXvYbhJhAH/fVN8BRRos7A
         g75W48NWsOVS+nuBpP+4x/9MbQ9tKzr1hXCx9Vg6Bjf0HuGEwzlJbnmGJbLiY0tmeElo
         aEvQ==
X-Gm-Message-State: APjAAAXVF98DZtK9M7Mdo6ndE9muNKEZXW5Ni13kIilx9xE6RGpNvCYH
        7LX7nKwndB1zAMXdPwiE5iMFdyCLmB1dqm8WZELEJ9sLH8fY+/BMEeVJhyAzqGc+V/W30Hz2Zzc
        uwwLqRouYSFavJEqs/Rb1lfMoVw==
X-Received: by 2002:a5d:608e:: with SMTP id w14mr4604243wrt.256.1579605107742;
        Tue, 21 Jan 2020 03:11:47 -0800 (PST)
X-Google-Smtp-Source: APXvYqz6wv6glJfLdvRz2/MrzIMcWR6iiQ2XVXsN7rhTv5buGbe6Ah+4Zx7xVSaVcVV6Aohg7Au65w==
X-Received: by 2002:a5d:608e:: with SMTP id w14mr4604203wrt.256.1579605107280;
        Tue, 21 Jan 2020 03:11:47 -0800 (PST)
Received: from [192.168.1.81] (host81-140-166-164.range81-140.btcentralplus.com. [81.140.166.164])
        by smtp.gmail.com with ESMTPSA id v22sm3380325wml.11.2020.01.21.03.11.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jan 2020 03:11:46 -0800 (PST)
From:   Julien Thierry <jthierry@redhat.com>
Subject: Re: [POC 02/23] livepatch: Split livepatch modules per livepatched
 object
To:     Petr Mladek <pmladek@suse.com>, Jiri Kosina <jikos@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>
Cc:     Joe Lawrence <joe.lawrence@redhat.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Nicolai Stange <nstange@suse.de>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200117150323.21801-1-pmladek@suse.com>
 <20200117150323.21801-3-pmladek@suse.com>
Message-ID: <af90531e-219c-3515-1dc8-d86191902ea4@redhat.com>
Date:   Tue, 21 Jan 2020 11:11:45 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20200117150323.21801-3-pmladek@suse.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hi Petr,

On 1/17/20 3:03 PM, Petr Mladek wrote:
> One livepatch module allows to fix vmlinux and any number of modules
> while providing some guarantees defined by the consistency model.
> 
> The patched modules can be loaded at any time: before, during,
> or after the livepatch module gets loaded. They can even get
> removed and loaded again. This variety of scenarios bring some
> troubles. For example, some livepatch symbols could be relocated
> only after the related module gets loaded. These changes need
> to get cleared when the module gets unloaded so that it can
> get eventually loaded again.
> 
> As a result some functionality needs to be duplicated by
> the livepatching code. Some elf sections need to be preserved
> even when they normally can be removed during the module load.
> Architecture specific code is involved which makes harder
> adding support for new architectures and the maintainace.
> 
> The solution is to split the livepatch module per livepatched
> object (vmlinux or module). Then both livepatch module and
> the livepatched modules could get loaded and removed at the
> same time.
> 
> This require many changes in the livepatch subsystem, module
> loader, sample livepatches and livepatches needed for selftests.
> 
> The bad news is that bisection will not work by definition.
> The good news is that it allows to do the changes in smaller
> steps.
> 
> The first step allows to split the existing sample and testing
> modules so that they can be later user. It is done by
> the following changes:
> 
> 1. struct klp_patch:
> 
>    + Add "patch_name" and "obj_names" to match all the related
>      livepatch modules.
> 
>    + Replace "objs" array with a pointer to a single struct object.
> 
>    + move "mod" to struct object.
> 
> 2. struct klp_object:
> 
>    + Add "patch_name" to match all the related livepatch modules.
> 
>    + "mod" points to the livepatch module instead of the livepatched
>      one. The pointer to the livepatched module was used only to
>      detect whether it was loaded. It will be always loaded
>      with related livepatch module now.
> 
> 3. klp_find_object_module() and klp_is_object_loaded() are no longer
>     needed. Livepatch module is loaded only when the related livepatched
>     module is loaded.
> 
> 4. Add klp_add_object() function that will need to initialize
>     struct object, link it into the related struct klp_patch,
>     and patch the functions. It will get implemented later.
> 
> The livepatches for modules are put into separate source files
> that define only struct klp_object() and call the new klp_add_object()
> in the init() callback. The name of the module follows the pattern:
> 
>    <patch_name>__<object_name>
> 

Is that a requirement? Or is it just the convention followed for the 
current tests?

> Signed-off-by: Petr Mladek <pmladek@suse.com>
> ---
>   arch/x86/kernel/livepatch.c                        |   5 +-
>   include/linux/livepatch.h                          |  20 +--
>   kernel/livepatch/core.c                            | 139 +++++++-----------
>   kernel/livepatch/core.h                            |   5 -
>   kernel/livepatch/transition.c                      |  14 +-
>   lib/livepatch/Makefile                             |   2 +
>   lib/livepatch/test_klp_atomic_replace.c            |  18 ++-
>   lib/livepatch/test_klp_callbacks_demo.c            |  90 ++++++------
>   lib/livepatch/test_klp_callbacks_demo.h            |  11 ++
>   lib/livepatch/test_klp_callbacks_demo2.c           |  62 ++++++---
>   lib/livepatch/test_klp_callbacks_demo2.h           |  11 ++
>   ...t_klp_callbacks_demo__test_klp_callbacks_busy.c |  50 +++++++
>   ...st_klp_callbacks_demo__test_klp_callbacks_mod.c |  42 ++++++
>   lib/livepatch/test_klp_livepatch.c                 |  18 ++-
>   lib/livepatch/test_klp_state.c                     |  53 ++++---
>   lib/livepatch/test_klp_state2.c                    |  53 ++++---
>   samples/livepatch/Makefile                         |   4 +
>   samples/livepatch/livepatch-callbacks-demo.c       |  90 ++++++------
>   samples/livepatch/livepatch-callbacks-demo.h       |  11 ++
>   ...h-callbacks-demo__livepatch-callbacks-busymod.c |  54 +++++++
>   ...patch-callbacks-demo__livepatch-callbacks-mod.c |  46 ++++++
>   samples/livepatch/livepatch-sample.c               |  18 ++-
>   samples/livepatch/livepatch-shadow-fix1.c          | 120 ++--------------
>   .../livepatch-shadow-fix1__livepatch-shadow-mod.c  | 155 +++++++++++++++++++++
>   samples/livepatch/livepatch-shadow-fix2.c          |  92 ++----------
>   .../livepatch-shadow-fix2__livepatch-shadow-mod.c  | 127 +++++++++++++++++
>   .../testing/selftests/livepatch/test-callbacks.sh  |  16 +--
>   27 files changed, 841 insertions(+), 485 deletions(-)
>   create mode 100644 lib/livepatch/test_klp_callbacks_demo.h
>   create mode 100644 lib/livepatch/test_klp_callbacks_demo2.h
>   create mode 100644 lib/livepatch/test_klp_callbacks_demo__test_klp_callbacks_busy.c
>   create mode 100644 lib/livepatch/test_klp_callbacks_demo__test_klp_callbacks_mod.c
>   create mode 100644 samples/livepatch/livepatch-callbacks-demo.h
>   create mode 100644 samples/livepatch/livepatch-callbacks-demo__livepatch-callbacks-busymod.c
>   create mode 100644 samples/livepatch/livepatch-callbacks-demo__livepatch-callbacks-mod.c
>   create mode 100644 samples/livepatch/livepatch-shadow-fix1__livepatch-shadow-mod.c
>   create mode 100644 samples/livepatch/livepatch-shadow-fix2__livepatch-shadow-mod.c
> 
> diff --git a/arch/x86/kernel/livepatch.c b/arch/x86/kernel/livepatch.c
> index 6a68e41206e7..728b44eaa168 100644
> --- a/arch/x86/kernel/livepatch.c
> +++ b/arch/x86/kernel/livepatch.c
> @@ -9,8 +9,7 @@
>   #include <asm/text-patching.h>
>   
>   /* Apply per-object alternatives. Based on x86 module_finalize() */
> -void arch_klp_init_object_loaded(struct klp_patch *patch,
> -				 struct klp_object *obj)
> +void arch_klp_init_object_loaded(struct klp_object *obj)
>   {
>   	int cnt;
>   	struct klp_modinfo *info;
> @@ -20,7 +19,7 @@ void arch_klp_init_object_loaded(struct klp_patch *patch,
>   	char sec_objname[MODULE_NAME_LEN];
>   	char secname[KSYM_NAME_LEN];
>   
> -	info = patch->mod->klp_info;
> +	info = obj->mod->klp_info;
>   	objname = obj->name ? obj->name : "vmlinux";
>   
>   	/* See livepatch core code for BUILD_BUG_ON() explanation */
> diff --git a/include/linux/livepatch.h b/include/linux/livepatch.h
> index e894e74905f3..a4567c17a9f2 100644
> --- a/include/linux/livepatch.h
> +++ b/include/linux/livepatch.h
> @@ -105,19 +105,21 @@ struct klp_callbacks {
>   /**
>    * struct klp_object - kernel object structure for live patching
>    * @name:	module name (or NULL for vmlinux)
> + * @patch_name:	module name for  vmlinux
> + * @mod:	reference to the live patch module for this object
>    * @funcs:	function entries for functions to be patched in the object
>    * @callbacks:	functions to be executed pre/post (un)patching
>    * @kobj:	kobject for sysfs resources
>    * @func_list:	dynamic list of the function entries
>    * @node:	list node for klp_patch obj_list
> - * @mod:	kernel module associated with the patched object
> - *		(NULL for vmlinux)
>    * @dynamic:    temporary object for nop functions; dynamically allocated
>    * @patched:	the object's funcs have been added to the klp_ops list
>    */
>   struct klp_object {
>   	/* external */
>   	const char *name;
> +	const char *patch_name;
> +	struct module *mod;
>   	struct klp_func *funcs;
>   	struct klp_callbacks callbacks;
>   
> @@ -125,7 +127,6 @@ struct klp_object {
>   	struct kobject kobj;
>   	struct list_head func_list;
>   	struct list_head node;
> -	struct module *mod;
>   	bool dynamic;
>   	bool patched;
>   };
> @@ -144,8 +145,9 @@ struct klp_state {
>   
>   /**
>    * struct klp_patch - patch structure for live patching
> - * @mod:	reference to the live patch module
> - * @objs:	object entries for kernel objects to be patched
> + * @patch_name: livepatch name; same for related livepatch against other objects

You forgot to add that to the structure.

> + * @objs:	object entry for vmlinux object

Nit: s/objs/obj/

> + * @obj_names:	names of modules synchronously livepatched with this patch

Not sure I understand the purpose of this. Is it to check that the 
klp_object that will get linked to this patch are part of a 
pre-established set?

>    * @states:	system states that can get modified
>    * @replace:	replace all actively used patches
>    * @list:	list node for global list of actively used patches
> @@ -158,9 +160,9 @@ struct klp_state {
>    */
>   struct klp_patch {
>   	/* external */
> -	struct module *mod;
> -	struct klp_object *objs;
>   	struct klp_state *states;
> +	struct klp_object *obj;
> +	char **obj_names;
>   	bool replace;
>   
>   	/* internal */
> @@ -194,9 +196,9 @@ struct klp_patch {
>   	list_for_each_entry(func, &obj->func_list, node)
>   
>   int klp_enable_patch(struct klp_patch *);
> +int klp_add_object(struct klp_object *);
>   
> -void arch_klp_init_object_loaded(struct klp_patch *patch,
> -				 struct klp_object *obj);
> +void arch_klp_init_object_loaded(struct klp_object *obj);
>   
>   /* Called from the module loader during module coming/going states */
>   int klp_module_coming(struct module *mod);
> diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
> index c3512e7e0801..bb62c5407b75 100644
> --- a/kernel/livepatch/core.c
> +++ b/kernel/livepatch/core.c
> @@ -49,34 +49,6 @@ static bool klp_is_module(struct klp_object *obj)
>   	return obj->name;
>   }
>   
> -/* sets obj->mod if object is not vmlinux and module is found */
> -static void klp_find_object_module(struct klp_object *obj)
> -{
> -	struct module *mod;
> -
> -	if (!klp_is_module(obj))
> -		return;
> -
> -	mutex_lock(&module_mutex);
> -	/*
> -	 * We do not want to block removal of patched modules and therefore
> -	 * we do not take a reference here. The patches are removed by
> -	 * klp_module_going() instead.
> -	 */
> -	mod = find_module(obj->name);
> -	/*
> -	 * Do not mess work of klp_module_coming() and klp_module_going().
> -	 * Note that the patch might still be needed before klp_module_going()
> -	 * is called. Module functions can be called even in the GOING state
> -	 * until mod->exit() finishes. This is especially important for
> -	 * patches that modify semantic of the functions.
> -	 */
> -	if (mod && mod->klp_alive)
> -		obj->mod = mod;
> -
> -	mutex_unlock(&module_mutex);
> -}
> -
>   static bool klp_initialized(void)
>   {
>   	return !!klp_root_kobj;
> @@ -246,18 +218,16 @@ static int klp_resolve_symbols(Elf_Shdr *relasec, struct module *pmod)
>   	return 0;
>   }
>   
> -static int klp_write_object_relocations(struct module *pmod,
> -					struct klp_object *obj)
> +static int klp_write_object_relocations(struct klp_object *obj)
>   {
>   	int i, cnt, ret = 0;
>   	const char *objname, *secname;
>   	char sec_objname[MODULE_NAME_LEN];
> +	struct module *pmod;
>   	Elf_Shdr *sec;
>   
> -	if (WARN_ON(!klp_is_object_loaded(obj)))
> -		return -EINVAL;
> -
>   	objname = klp_is_module(obj) ? obj->name : "vmlinux";
> +	pmod = obj->mod;
>   
>   	/* For each klp relocation section */
>   	for (i = 1; i < pmod->klp_info->hdr.e_shnum; i++) {
> @@ -419,8 +389,8 @@ static void klp_free_object_dynamic(struct klp_object *obj)
>   
>   static void klp_init_func_early(struct klp_object *obj,
>   				struct klp_func *func);
> -static void klp_init_object_early(struct klp_patch *patch,
> -				  struct klp_object *obj);
> +static int klp_init_object_early(struct klp_patch *patch,
> +				 struct klp_object *obj);
>   
>   static struct klp_object *klp_alloc_object_dynamic(const char *name,
>   						   struct klp_patch *patch)
> @@ -662,7 +632,7 @@ static void klp_free_patch_finish(struct klp_patch *patch)
>   
>   	/* Put the module after the last access to struct klp_patch. */
>   	if (!patch->forced)
> -		module_put(patch->mod);
> +		module_put(patch->obj->mod);
>   }
>   
>   /*
> @@ -725,30 +695,28 @@ static int klp_init_func(struct klp_object *obj, struct klp_func *func)
>   }
>   
>   /* Arches may override this to finish any remaining arch-specific tasks */
> -void __weak arch_klp_init_object_loaded(struct klp_patch *patch,
> -					struct klp_object *obj)
> +void __weak arch_klp_init_object_loaded(struct klp_object *obj)
>   {
>   }
>   
>   /* parts of the initialization that is done only when the object is loaded */
> -static int klp_init_object_loaded(struct klp_patch *patch,
> -				  struct klp_object *obj)
> +static int klp_init_object_loaded(struct klp_object *obj)
>   {
>   	struct klp_func *func;
>   	int ret;
>   
>   	mutex_lock(&text_mutex);
>   
> -	module_disable_ro(patch->mod);
> -	ret = klp_write_object_relocations(patch->mod, obj);
> +	module_disable_ro(obj->mod);
> +	ret = klp_write_object_relocations(obj);
>   	if (ret) {
> -		module_enable_ro(patch->mod, true);
> +		module_enable_ro(obj->mod, true);
>   		mutex_unlock(&text_mutex);
>   		return ret;
>   	}
>   
> -	arch_klp_init_object_loaded(patch, obj);
> -	module_enable_ro(patch->mod, true);
> +	arch_klp_init_object_loaded(obj);
> +	module_enable_ro(obj->mod, true);
>   
>   	mutex_unlock(&text_mutex);
>   
> @@ -792,11 +760,8 @@ static int klp_init_object(struct klp_patch *patch, struct klp_object *obj)
>   		return -EINVAL;
>   
>   	obj->patched = false;
> -	obj->mod = NULL;
>   
> -	klp_find_object_module(obj);
> -
> -	name = klp_is_module(obj) ? obj->name : "vmlinux";
> +	name = obj->name ? obj->name : "vmlinux";
>   	ret = kobject_add(&obj->kobj, &patch->kobj, "%s", name);
>   	if (ret)
>   		return ret;
> @@ -807,8 +772,7 @@ static int klp_init_object(struct klp_patch *patch, struct klp_object *obj)
>   			return ret;
>   	}
>   
> -	if (klp_is_object_loaded(obj))
> -		ret = klp_init_object_loaded(patch, obj);
> +	ret = klp_init_object_loaded(obj);
>   
>   	return ret;
>   }
> @@ -820,20 +784,34 @@ static void klp_init_func_early(struct klp_object *obj,
>   	list_add_tail(&func->node, &obj->func_list);
>   }
>   
> -static void klp_init_object_early(struct klp_patch *patch,
> +static int klp_init_object_early(struct klp_patch *patch,
>   				  struct klp_object *obj)
>   {
> +	struct klp_func *func;
> +
> +	if (!obj->funcs)
> +		return -EINVAL;
> +
>   	INIT_LIST_HEAD(&obj->func_list);
>   	kobject_init(&obj->kobj, &klp_ktype_object);
>   	list_add_tail(&obj->node, &patch->obj_list);
> +
> +	klp_for_each_func_static(obj, func) {
> +		klp_init_func_early(obj, func);
> +	}
> +
> +	if (obj->dynamic || try_module_get(obj->mod))
> +		return 0;
> +
> +	return -ENODEV;
>   }
>   
>   static int klp_init_patch_early(struct klp_patch *patch)
>   {
> -	struct klp_object *obj;
> -	struct klp_func *func;
> +	struct klp_object *obj = patch->obj;
>   
> -	if (!patch->objs)
> +	/* Main patch module is always for vmlinux */
> +	if (obj->name)
>   		return -EINVAL;
>   
>   	INIT_LIST_HEAD(&patch->list);
> @@ -844,21 +822,7 @@ static int klp_init_patch_early(struct klp_patch *patch)
>   	INIT_WORK(&patch->free_work, klp_free_patch_work_fn);
>   	init_completion(&patch->finish);
>   
> -	klp_for_each_object_static(patch, obj) {

I think we can get rid of klp_for_each_object_static(), no? Now the 
klp_patch is only associated to a single klp_object, so everything will 
be dynamic. Is this correct?

> -		if (!obj->funcs)
> -			return -EINVAL;
> -
> -		klp_init_object_early(patch, obj);
> -
> -		klp_for_each_func_static(obj, func) {
> -			klp_init_func_early(obj, func);
> -		}
> -	}
> -
> -	if (!try_module_get(patch->mod))
> -		return -ENODEV;
> -
> -	return 0;
> +	return klp_init_object_early(patch, obj);
>   }
>   
>   static int klp_init_patch(struct klp_patch *patch)
> @@ -866,7 +830,7 @@ static int klp_init_patch(struct klp_patch *patch)
>   	struct klp_object *obj;
>   	int ret;
>   
> -	ret = kobject_add(&patch->kobj, klp_root_kobj, "%s", patch->mod->name);
> +	ret = kobject_add(&patch->kobj, klp_root_kobj, "%s", patch->obj->mod->name);
>   	if (ret)
>   		return ret;
>   
> @@ -887,6 +851,12 @@ static int klp_init_patch(struct klp_patch *patch)
>   	return 0;
>   }
>   
> +int klp_add_object(struct klp_object *obj)
> +{
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(klp_add_object);
> +
>   static int __klp_disable_patch(struct klp_patch *patch)
>   {
>   	struct klp_object *obj;
> @@ -930,7 +900,7 @@ static int __klp_enable_patch(struct klp_patch *patch)
>   	if (WARN_ON(patch->enabled))
>   		return -EINVAL;
>   
> -	pr_notice("enabling patch '%s'\n", patch->mod->name);
> +	pr_notice("enabling patch '%s'\n", patch->obj->patch_name);
>   
>   	klp_init_transition(patch, KLP_PATCHED);
>   
> @@ -944,9 +914,6 @@ static int __klp_enable_patch(struct klp_patch *patch)
>   	smp_wmb();
>   
>   	klp_for_each_object(patch, obj) {
> -		if (!klp_is_object_loaded(obj))
> -			continue;
> -
>   		ret = klp_pre_patch_callback(obj);
>   		if (ret) {
>   			pr_warn("pre-patch callback failed for object '%s'\n",
> @@ -968,7 +935,7 @@ static int __klp_enable_patch(struct klp_patch *patch)
>   
>   	return 0;
>   err:
> -	pr_warn("failed to enable patch '%s'\n", patch->mod->name);
> +	pr_warn("failed to enable patch '%s'\n", patch->obj->patch_name);
>   
>   	klp_cancel_transition();
>   	return ret;
> @@ -991,12 +958,12 @@ int klp_enable_patch(struct klp_patch *patch)
>   {
>   	int ret;
>   
> -	if (!patch || !patch->mod)
> +	if (!patch || !patch->obj || !patch->obj->mod)
>   		return -EINVAL;
>   
> -	if (!is_livepatch_module(patch->mod)) {
> +	if (!is_livepatch_module(patch->obj->mod)) {
>   		pr_err("module %s is not marked as a livepatch module\n",
> -		       patch->mod->name);
> +		       patch->obj->patch_name);

Shouldn't that be "patch->obj->mod->name" ?

>   		return -EINVAL;
>   	}
>   
> @@ -1012,7 +979,7 @@ int klp_enable_patch(struct klp_patch *patch)
>   
>   	if (!klp_is_patch_compatible(patch)) {
>   		pr_err("Livepatch patch (%s) is not compatible with the already installed livepatches.\n",
> -			patch->mod->name);
> +			patch->obj->mod->name);
>   		mutex_unlock(&klp_mutex);
>   		return -EINVAL;
>   	}
> @@ -1119,7 +1086,7 @@ static void klp_cleanup_module_patches_limited(struct module *mod,
>   				klp_pre_unpatch_callback(obj);
>   
>   			pr_notice("reverting patch '%s' on unloading module '%s'\n",
> -				  patch->mod->name, obj->mod->name);
> +				  patch->obj->patch_name, obj->name);
>   			klp_unpatch_object(obj);
>   
>   			klp_post_unpatch_callback(obj);
> @@ -1154,15 +1121,15 @@ int klp_module_coming(struct module *mod)
>   
>   			obj->mod = mod;
>   
> -			ret = klp_init_object_loaded(patch, obj);
> +			ret = klp_init_object_loaded(obj);
>   			if (ret) {
>   				pr_warn("failed to initialize patch '%s' for module '%s' (%d)\n",
> -					patch->mod->name, obj->mod->name, ret);
> +					patch->obj->patch_name, obj->name, ret);
>   				goto err;
>   			}
>   
>   			pr_notice("applying patch '%s' to loading module '%s'\n",
> -				  patch->mod->name, obj->mod->name);
> +				  patch->obj->patch_name, obj->name);
>   
>   			ret = klp_pre_patch_callback(obj);
>   			if (ret) {
> @@ -1174,7 +1141,7 @@ int klp_module_coming(struct module *mod)
>   			ret = klp_patch_object(obj);
>   			if (ret) {
>   				pr_warn("failed to apply patch '%s' to module '%s' (%d)\n",
> -					patch->mod->name, obj->mod->name, ret);
> +					patch->obj->patch_name, obj->name, ret);
>   
>   				klp_post_unpatch_callback(obj);
>   				goto err;
> @@ -1197,7 +1164,7 @@ int klp_module_coming(struct module *mod)
>   	 * error to the module loader.
>   	 */
>   	pr_warn("patch '%s' failed for module '%s', refusing to load module '%s'\n",
> -		patch->mod->name, obj->mod->name, obj->mod->name);
> +		patch->obj->patch_name, obj->name, obj->name);
>   	mod->klp_alive = false;
>   	obj->mod = NULL;
>   	klp_cleanup_module_patches_limited(mod, patch);
> diff --git a/kernel/livepatch/core.h b/kernel/livepatch/core.h
> index 38209c7361b6..01980cc0509b 100644
> --- a/kernel/livepatch/core.h
> +++ b/kernel/livepatch/core.h
> @@ -18,11 +18,6 @@ void klp_free_replaced_patches_async(struct klp_patch *new_patch);
>   void klp_unpatch_replaced_patches(struct klp_patch *new_patch);
>   void klp_discard_nops(struct klp_patch *new_patch);
>   
> -static inline bool klp_is_object_loaded(struct klp_object *obj)
> -{
> -	return !obj->name || obj->mod;
> -}
> -
>   static inline int klp_pre_patch_callback(struct klp_object *obj)
>   {
>   	int ret = 0;
> diff --git a/kernel/livepatch/transition.c b/kernel/livepatch/transition.c
> index f6310f848f34..78e3280560cd 100644
> --- a/kernel/livepatch/transition.c
> +++ b/kernel/livepatch/transition.c
> @@ -74,7 +74,7 @@ static void klp_complete_transition(void)
>   	unsigned int cpu;
>   
>   	pr_debug("'%s': completing %s transition\n",
> -		 klp_transition_patch->mod->name,
> +		 klp_transition_patch->obj->patch_name,
>   		 klp_target_state == KLP_PATCHED ? "patching" : "unpatching");
>   
>   	if (klp_transition_patch->replace && klp_target_state == KLP_PATCHED) {
> @@ -120,15 +120,13 @@ static void klp_complete_transition(void)
>   	}
>   
>   	klp_for_each_object(klp_transition_patch, obj) {
> -		if (!klp_is_object_loaded(obj))
> -			continue;
>   		if (klp_target_state == KLP_PATCHED)
>   			klp_post_patch_callback(obj);
>   		else if (klp_target_state == KLP_UNPATCHED)
>   			klp_post_unpatch_callback(obj);
>   	}
>   
> -	pr_notice("'%s': %s complete\n", klp_transition_patch->mod->name,
> +	pr_notice("'%s': %s complete\n", klp_transition_patch->obj->patch_name,
>   		  klp_target_state == KLP_PATCHED ? "patching" : "unpatching");
>   
>   	klp_target_state = KLP_UNDEFINED;
> @@ -147,7 +145,7 @@ void klp_cancel_transition(void)
>   		return;
>   
>   	pr_debug("'%s': canceling patching transition, going to unpatch\n",
> -		 klp_transition_patch->mod->name);
> +		 klp_transition_patch->obj->patch_name);
>   
>   	klp_target_state = KLP_UNPATCHED;
>   	klp_complete_transition();
> @@ -468,7 +466,7 @@ void klp_start_transition(void)
>   	WARN_ON_ONCE(klp_target_state == KLP_UNDEFINED);
>   
>   	pr_notice("'%s': starting %s transition\n",
> -		  klp_transition_patch->mod->name,
> +		  klp_transition_patch->obj->patch_name,

Isn't the transition per livepatched module rather than per-patch now?
If so, would it make more sense to display also the name of the module 
being patched/unpatched?

>   		  klp_target_state == KLP_PATCHED ? "patching" : "unpatching");
>   
>   	/*
> @@ -519,7 +517,7 @@ void klp_init_transition(struct klp_patch *patch, int state)
>   	 */
>   	klp_target_state = state;
>   
> -	pr_debug("'%s': initializing %s transition\n", patch->mod->name,
> +	pr_debug("'%s': initializing %s transition\n", patch->obj->patch_name,

Ditto.

>   		 klp_target_state == KLP_PATCHED ? "patching" : "unpatching");
>   
>   	/*
> @@ -581,7 +579,7 @@ void klp_reverse_transition(void)
>   	struct task_struct *g, *task;
>   
>   	pr_debug("'%s': reversing transition from %s\n",
> -		 klp_transition_patch->mod->name,
> +		 klp_transition_patch->obj->patch_name,

Ditto.

>   		 klp_target_state == KLP_PATCHED ? "patching to unpatching" :
>   						   "unpatching to patching");
>   

[...]

Cheers,

-- 
Julien Thierry

