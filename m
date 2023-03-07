Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E41CD6ADDDA
	for <lists+live-patching@lfdr.de>; Tue,  7 Mar 2023 12:45:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231151AbjCGLph (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 7 Mar 2023 06:45:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231567AbjCGLpP (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 7 Mar 2023 06:45:15 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 305F57D0B8;
        Tue,  7 Mar 2023 03:42:51 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id CFE7721A20;
        Tue,  7 Mar 2023 11:41:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1678189281; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+pemajQb8YP6fjdoGUmljNw7gqtlykEg8Ge5hYifXP4=;
        b=2HzZLajkhO1VacYOeLd8PTuEQVTKSpWUM6VZuKovXS45ISnOFHN/9IXXZwn1IFJAznI7Ed
        QgdVirHlYC+Lt2nv+vPwUU6nQsLSW6IB1qHtkweJJHsXC3eW4j0j31V6u7AEChDWUkzXDp
        sike6KP0KmRZ0JaJs2tw8uzEgqObn1s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1678189281;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+pemajQb8YP6fjdoGUmljNw7gqtlykEg8Ge5hYifXP4=;
        b=8jFRF4nMk3jcjEjaS3YZJIGciSp2TFitvO2sY4rakybV2XPaICJZUbzUTdQz/7Lhz8u0Fz
        GZnPWR7kIYbAzjCg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 3012313440;
        Tue,  7 Mar 2023 11:41:20 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 7D9hN+AiB2R7EgAAMHmgww
        (envelope-from <mpdesouza@suse.com>); Tue, 07 Mar 2023 11:41:20 +0000
Date:   Tue, 7 Mar 2023 08:41:18 -0300
From:   Marcos Paulo de Souza <mpdesouza@suse.de>
To:     Joe Lawrence <joe.lawrence@redhat.com>
Cc:     live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org, Josh Poimboeuf <jpoimboe@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Marcos Paulo de Souza <mpdesouza@suse.com>
Subject: Re: [PATCH v7 01/10] livepatch: Create and include UAPI headers
Message-ID: <20230307114118.igckixgcc5gmgyyy@daedalus>
References: <20230306140824.3858543-1-joe.lawrence@redhat.com>
 <20230306140824.3858543-2-joe.lawrence@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230306140824.3858543-2-joe.lawrence@redhat.com>
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Mon, Mar 06, 2023 at 09:08:15AM -0500, Joe Lawrence wrote:
> Define klp prefixes in include/uapi/linux/livepatch.h, and use them for
> replacing hard-coded values in kernel/livepatch/core.c.
> 
> Update MAINTAINERS.
> 
> Note: Add defines to uapi as these are also to be used by a newly
> introduced klp-convert script.
> 
> Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
> Signed-off-by: Joao Moreira <jmoreira@suse.de>
> Signed-off-by: Joe Lawrence <joe.lawrence@redhat.com>

LGTM:

Reviewed-by: Marcos Paulo de Souza <mpdesouza@suse.com>

> ---
>  MAINTAINERS                    |  1 +
>  include/linux/livepatch.h      |  1 +
>  include/uapi/linux/livepatch.h | 15 +++++++++++++++
>  kernel/livepatch/core.c        |  4 ++--
>  4 files changed, 19 insertions(+), 2 deletions(-)
>  create mode 100644 include/uapi/linux/livepatch.h
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 135d93368d36..5bdf333fb1f3 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -12069,6 +12069,7 @@ F:	Documentation/ABI/testing/sysfs-kernel-livepatch
>  F:	Documentation/livepatch/
>  F:	arch/powerpc/include/asm/livepatch.h
>  F:	include/linux/livepatch.h
> +F:	include/uapi/linux/livepatch.h
>  F:	kernel/livepatch/
>  F:	kernel/module/livepatch.c
>  F:	lib/livepatch/
> diff --git a/include/linux/livepatch.h b/include/linux/livepatch.h
> index 293e29960c6e..46da4c0df6c1 100644
> --- a/include/linux/livepatch.h
> +++ b/include/linux/livepatch.h
> @@ -13,6 +13,7 @@
>  #include <linux/ftrace.h>
>  #include <linux/completion.h>
>  #include <linux/list.h>
> +#include <uapi/linux/livepatch.h>
>  
>  #if IS_ENABLED(CONFIG_LIVEPATCH)
>  
> diff --git a/include/uapi/linux/livepatch.h b/include/uapi/linux/livepatch.h
> new file mode 100644
> index 000000000000..e19430918a07
> --- /dev/null
> +++ b/include/uapi/linux/livepatch.h
> @@ -0,0 +1,15 @@
> +/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
> +
> +/*
> + * livepatch.h - Kernel Live Patching Core
> + *
> + * Copyright (C) 2016 Josh Poimboeuf <jpoimboe@redhat.com>
> + */
> +
> +#ifndef _UAPI_LIVEPATCH_H
> +#define _UAPI_LIVEPATCH_H
> +
> +#define KLP_RELA_PREFIX		".klp.rela."
> +#define KLP_SYM_PREFIX		".klp.sym."
> +
> +#endif /* _UAPI_LIVEPATCH_H */
> diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
> index 201f0c0482fb..c565d33db582 100644
> --- a/kernel/livepatch/core.c
> +++ b/kernel/livepatch/core.c
> @@ -234,7 +234,7 @@ static int klp_resolve_symbols(Elf_Shdr *sechdrs, const char *strtab,
>  
>  		/* Format: .klp.sym.sym_objname.sym_name,sympos */
>  		cnt = sscanf(strtab + sym->st_name,
> -			     ".klp.sym.%55[^.].%511[^,],%lu",
> +			     KLP_SYM_PREFIX "%55[^.].%511[^,],%lu",
>  			     sym_objname, sym_name, &sympos);
>  		if (cnt != 3) {
>  			pr_err("symbol %s has an incorrectly formatted name\n",
> @@ -305,7 +305,7 @@ int klp_apply_section_relocs(struct module *pmod, Elf_Shdr *sechdrs,
>  	 * See comment in klp_resolve_symbols() for an explanation
>  	 * of the selected field width value.
>  	 */
> -	cnt = sscanf(shstrtab + sec->sh_name, ".klp.rela.%55[^.]",
> +	cnt = sscanf(shstrtab + sec->sh_name, KLP_RELA_PREFIX "%55[^.]",
>  		     sec_objname);
>  	if (cnt != 1) {
>  		pr_err("section %s has an incorrectly formatted name\n",
> -- 
> 2.39.2
> 
