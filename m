Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6058B4AD7EE
	for <lists+live-patching@lfdr.de>; Tue,  8 Feb 2022 12:52:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236934AbiBHLvR (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 8 Feb 2022 06:51:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357980AbiBHLuQ (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 8 Feb 2022 06:50:16 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3364C02549C;
        Tue,  8 Feb 2022 03:42:15 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 71654210F5;
        Tue,  8 Feb 2022 11:42:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1644320534; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=txkE5XzzyFXzIuOv7AWLb7NWIjo0bQa6foIWhGJ1WH8=;
        b=NTxXEVyuDBlX93//ziag9/u/YKfr/o63OWd+BvhP4eq4trTMgcsXcL04QBfS8sP33AlWOc
        I0oenl/j5W9toXdR1zZcvNgtta5Paomkkeup5R75HYtjIuECDKnOLGFA4SekBLA3+YOw5c
        2JQG8NRQe9nuigXqWua6laRNVH5zQq8=
Received: from suse.cz (unknown [10.100.216.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 28308A3B83;
        Tue,  8 Feb 2022 11:42:14 +0000 (UTC)
Date:   Tue, 8 Feb 2022 12:42:10 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     Aaron Tomlin <atomlin@redhat.com>
Cc:     mcgrof@kernel.org, cl@linux.com, mbenes@suse.cz,
        akpm@linux-foundation.org, jeyu@kernel.org,
        linux-kernel@vger.kernel.org, linux-modules@vger.kernel.org,
        live-patching@vger.kernel.org, atomlin@atomlin.com,
        ghalat@redhat.com, allen.lkml@gmail.com, void@manifault.com,
        joe@perches.com
Subject: Re: [RFC PATCH v4 03/13] module: Move livepatch support to a
 separate file
Message-ID: <YgJXEhiwn5B4Psxa@alley>
References: <20220130213214.1042497-1-atomlin@redhat.com>
 <20220130213214.1042497-4-atomlin@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220130213214.1042497-4-atomlin@redhat.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Sun 2022-01-30 21:32:04, Aaron Tomlin wrote:
> No functional change.
> 
> This patch migrates livepatch support (i.e. used during module
> add/or load and remove/or deletion) from core module code into
> kernel/module/livepatch.c. At the moment it contains code to
> persist Elf information about a given livepatch module, only.
> 
> diff --git a/include/linux/module.h b/include/linux/module.h
> index f4338235ed2c..c7daac4d16ee 100644
> --- a/include/linux/module.h
> +++ b/include/linux/module.h
> @@ -663,17 +663,23 @@ static inline bool module_requested_async_probing(struct module *module)
>  	return module && module->async_probe_requested;
>  }
>  
> -#ifdef CONFIG_LIVEPATCH
>  static inline bool is_livepatch_module(struct module *mod)
>  {
> -	return mod->klp;
> +	if (IS_ENABLED(CONFIG_LIVEPATCH)) {
> +		if (mod->klp)
> +			return true;
> +	}
> +	return false;

The following is easier to follow for me. But it is a matter of taste.
Feel free to use whatever you prefer.

	return IS_ENABLED(CONFIG_LIVEPATCH) && mod->klp;

>  }
> -#else /* !CONFIG_LIVEPATCH */
> -static inline bool is_livepatch_module(struct module *mod)
> +
> +static inline bool set_livepatch_module(struct module *mod)
>  {
> +	if (IS_ENABLED(CONFIG_LIVEPATCH)) {
> +		mod->klp = true;
> +		return true;
> +	}
>  	return false;

This should go to internal.h.

Alternative is to move both is_livepatch_module() and
set_livepatch_module() into include/linux/livepatch.h.

I do not have strong opinion.

>  }
> -#endif /* CONFIG_LIVEPATCH */
>  
>  bool is_module_sig_enforced(void);
>  void set_module_sig_enforced(void);

Otherwise, it looks good to me.

Best Regards,
Petr
