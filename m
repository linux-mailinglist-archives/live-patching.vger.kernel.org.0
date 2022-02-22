Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BDCD4BF59A
	for <lists+live-patching@lfdr.de>; Tue, 22 Feb 2022 11:19:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230428AbiBVKTq (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 22 Feb 2022 05:19:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229772AbiBVKTq (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 22 Feb 2022 05:19:46 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8206913EF8D;
        Tue, 22 Feb 2022 02:19:20 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 3D4DF1F39A;
        Tue, 22 Feb 2022 10:19:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1645525159; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Nd6Y06WPdUzGLt9uFP0+QcSRgSpsN30ENtdTm/2OQIw=;
        b=LNDjK6NrofKlw36GmECzp8PiOVKAzoePJ0x6/QosEUnBxBpoVoW0ZxklczKgnlkP/KKtDz
        gYGUBLMmr5eHMxbPj0ThWOTwx/0SQ73QajYPGXnocCq+MMaGhhaYYylZ8Ybf2Lz4QlUVNc
        wDf0rz+hKoD9yc0Rq4oScb6uh4xPLOo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1645525159;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Nd6Y06WPdUzGLt9uFP0+QcSRgSpsN30ENtdTm/2OQIw=;
        b=SHwU5F/z5IEJSmkyw4ybJwcRr76y5UKKBod6Om9yawkEXXiFqdID+ThEw/axQGDCjJLtTH
        hkAs/P5UxXleekBw==
Received: from pobox.suse.cz (pobox.suse.cz [10.100.2.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id CF122A3B8A;
        Tue, 22 Feb 2022 10:19:18 +0000 (UTC)
Date:   Tue, 22 Feb 2022 11:19:18 +0100 (CET)
From:   Miroslav Benes <mbenes@suse.cz>
To:     Aaron Tomlin <atomlin@redhat.com>
cc:     mcgrof@kernel.org, cl@linux.com, pmladek@suse.com,
        akpm@linux-foundation.org, jeyu@kernel.org,
        linux-kernel@vger.kernel.org, linux-modules@vger.kernel.org,
        live-patching@vger.kernel.org, atomlin@atomlin.com,
        ghalat@redhat.com, allen.lkml@gmail.com, joe@perches.com,
        christophe.leroy@csgroup.eu, msuchanek@suse.de,
        oleksandr@natalenko.name
Subject: Re: [PATCH v6 11/13] module: Move sysfs support into a separate
 file
In-Reply-To: <20220218212757.888751-1-atomlin@redhat.com>
Message-ID: <alpine.LSU.2.21.2202221115471.15071@pobox.suse.cz>
References: <20220218212757.888751-1-atomlin@redhat.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri, 18 Feb 2022, Aaron Tomlin wrote:

> No functional change.
> 
> This patch migrates module sysfs support out of core code into
> kernel/module/sysfs.c. In addition simple code refactoring to
> make this possible.
> 
> Signed-off-by: Aaron Tomlin <atomlin@redhat.com>

There was apparently a problem on your side when sending the series. There 
is Reply-To field which probably should have been In-Reply-To. It also 
applied to the following two patches.

>  kernel/module/Makefile   |   1 +
>  kernel/module/internal.h |  21 ++
>  kernel/module/main.c     | 469 +--------------------------------------
>  kernel/module/sysfs.c    | 436 ++++++++++++++++++++++++++++++++++++
>  4 files changed, 461 insertions(+), 466 deletions(-)
>  create mode 100644 kernel/module/sysfs.c
> 
> diff --git a/kernel/module/Makefile b/kernel/module/Makefile
> index f66fda0b41cc..a3cbe09ce2b2 100644
> --- a/kernel/module/Makefile
> +++ b/kernel/module/Makefile
> @@ -14,4 +14,5 @@ obj-$(CONFIG_STRICT_MODULE_RWX) += strict_rwx.o
>  obj-$(CONFIG_DEBUG_KMEMLEAK) += debug_kmemleak.o
>  obj-$(CONFIG_KALLSYMS) += kallsyms.o
>  obj-$(CONFIG_PROC_FS) += procfs.o
> +obj-$(CONFIG_SYSFS) += sysfs.o
>  endif
> diff --git a/kernel/module/internal.h b/kernel/module/internal.h
> index ddb37024a0d6..74096cca742c 100644
> --- a/kernel/module/internal.h
> +++ b/kernel/module/internal.h
> @@ -34,6 +34,9 @@
>  extern struct mutex module_mutex;
>  extern struct list_head modules;
>  
> +extern struct module_attribute *modinfo_attrs[];
> +extern size_t modinfo_attrs_count;
> +
>  /* Provided by the linker */
>  extern const struct kernel_symbol __start___ksymtab[];
>  extern const struct kernel_symbol __stop___ksymtab[];
> @@ -213,3 +216,21 @@ static inline bool sect_empty(const Elf_Shdr *sect)
>  static inline void layout_symtab(struct module *mod, struct load_info *info) { }
>  static inline void add_kallsyms(struct module *mod, const struct load_info *info) { }
>  #endif /* CONFIG_KALLSYMS */
> +
> +#ifdef CONFIG_SYSFS
> +int mod_sysfs_setup(struct module *mod, const struct load_info *info,
> +		    struct kernel_param *kparam, unsigned int num_params);
> +void mod_sysfs_teardown(struct module *mod);
> +void init_param_lock(struct module *mod);
> +#else /* !CONFIG_SYSFS */
> +static inline int mod_sysfs_setup(struct module *mod,
> +			   	  const struct load_info *info,
> +			   	  struct kernel_param *kparam,
> +			   	  unsigned int num_params)

Whitespace is broken here.

Miroslav
