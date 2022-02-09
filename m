Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01F614AF414
	for <lists+live-patching@lfdr.de>; Wed,  9 Feb 2022 15:29:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234990AbiBIO2u (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 9 Feb 2022 09:28:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233010AbiBIO2s (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 9 Feb 2022 09:28:48 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72DFBC06157B;
        Wed,  9 Feb 2022 06:28:51 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 24D3A210DC;
        Wed,  9 Feb 2022 14:28:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1644416930; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=io62y92hn/uGoChit59qxAIh63DflnbWE34GvXvv5WY=;
        b=m5fq8AmYqQxnyQ62G7Dp1kUk7FtBRK69c8z6rNt9+uPZS2rBP6DX20dtihKPnvBQSLcNF/
        g1j4JPAAY9iR6VDbGiQwNODXMAgLfBTFPJ250ZX4oPUSGnBFvCRl4MJzVAONr8sfVkCWU0
        8NvP/aDKNFAWaYra6jtzeg1IdGrbcck=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1644416930;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=io62y92hn/uGoChit59qxAIh63DflnbWE34GvXvv5WY=;
        b=ECcpj/mg9vk6A2nU6+Lnt4PKQmtb4U1qjpc83XWVJpXbAYfBwiJMxU3WFeff9fmmwgMh8Y
        c6GNrA3cOXHTWLBw==
Received: from pobox.suse.cz (pobox.suse.cz [10.100.2.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id CB46EA3B8D;
        Wed,  9 Feb 2022 14:28:49 +0000 (UTC)
Date:   Wed, 9 Feb 2022 15:28:49 +0100 (CET)
From:   Miroslav Benes <mbenes@suse.cz>
To:     Aaron Tomlin <atomlin@redhat.com>
cc:     mcgrof@kernel.org, cl@linux.com, pmladek@suse.com,
        akpm@linux-foundation.org, jeyu@kernel.org,
        linux-kernel@vger.kernel.org, linux-modules@vger.kernel.org,
        live-patching@vger.kernel.org, atomlin@atomlin.com,
        ghalat@redhat.com, allen.lkml@gmail.com, void@manifault.com,
        joe@perches.com
Subject: Re: [RFC PATCH v4 07/13] module: Move extra signature support out
 of core code
In-Reply-To: <20220130213214.1042497-8-atomlin@redhat.com>
Message-ID: <alpine.LSU.2.21.2202091526260.32090@pobox.suse.cz>
References: <20220130213214.1042497-1-atomlin@redhat.com> <20220130213214.1042497-8-atomlin@redhat.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

> diff --git a/include/linux/module.h b/include/linux/module.h
> index 520c0f4bb968..15ba2ebbca3e 100644
> --- a/include/linux/module.h
> +++ b/include/linux/module.h
> @@ -720,8 +720,8 @@ static inline bool set_livepatch_module(struct module *mod)
>  	return false;
>  }
>  
> -bool is_module_sig_enforced(void);
> -void set_module_sig_enforced(void);
> +extern bool is_module_sig_enforced(void);
> +extern void set_module_sig_enforced(void);

Please, drop these extern modifiers in front of function declarations. 
They are unnecessary. It applies to different patches of the set as well.
  
>  #else /* !CONFIG_MODULES... */
>  
> @@ -911,6 +911,7 @@ static inline bool module_sig_ok(struct module *module)
>  {
>  	return true;
>  }
> +#define sig_enforce false
>  #endif	/* CONFIG_MODULE_SIG */
>  
>  int module_kallsyms_on_each_symbol(int (*fn)(void *, const char *,
> diff --git a/kernel/module/internal.h b/kernel/module/internal.h
> index de28d6bb7b5b..2ec2a1d9dd9f 100644
> --- a/kernel/module/internal.h
> +++ b/kernel/module/internal.h
> @@ -114,3 +114,12 @@ static struct module *mod_find(unsigned long addr)
>  	return NULL;
>  }
>  #endif /* CONFIG_MODULES_TREE_LOOKUP */
> +
> +#ifdef CONFIG_MODULE_SIG
> +extern int module_sig_check(struct load_info *info, int flags);
> +#else /* !CONFIG_MODULE_SIG */
> +static int module_sig_check(struct load_info *info, int flags)
> +{
> +	return 0;
> +}

I think it should be 

static inline int module_sig_check(struct load_info *info, int flags)

Thanks,
Miroslav
