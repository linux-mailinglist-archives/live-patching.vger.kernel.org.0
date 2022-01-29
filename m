Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CFC24A2C83
	for <lists+live-patching@lfdr.de>; Sat, 29 Jan 2022 08:35:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350739AbiA2HfS (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Sat, 29 Jan 2022 02:35:18 -0500
Received: from relay037.a.hostedemail.com ([64.99.140.37]:59277 "EHLO
        relay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S236113AbiA2HfR (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Sat, 29 Jan 2022 02:35:17 -0500
X-Greylist: delayed 462 seconds by postgrey-1.27 at vger.kernel.org; Sat, 29 Jan 2022 02:35:17 EST
Received: from omf06.hostedemail.com (a10.router.float.18 [10.200.18.1])
        by unirelay10.hostedemail.com (Postfix) with ESMTP id B770EF7A;
        Sat, 29 Jan 2022 07:27:32 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf06.hostedemail.com (Postfix) with ESMTPA id 5FAD320021;
        Sat, 29 Jan 2022 07:27:30 +0000 (UTC)
Message-ID: <c94bd56f8be79670542af53eaaf4bd749505b78b.camel@perches.com>
Subject: Re: [RFC PATCH v3 03/13] module: Move livepatch support to a
 separate file
From:   Joe Perches <joe@perches.com>
To:     Aaron Tomlin <atomlin@redhat.com>, mcgrof@kernel.org
Cc:     cl@linux.com, pmladek@suse.com, mbenes@suse.cz,
        akpm@linux-foundation.org, jeyu@kernel.org,
        linux-kernel@vger.kernel.org, linux-modules@vger.kernel.org,
        live-patching@vger.kernel.org, atomlin@atomlin.com,
        ghalat@redhat.com, allen.lkml@gmail.com
Date:   Fri, 28 Jan 2022 23:27:29 -0800
In-Reply-To: <20220128203934.600247-4-atomlin@redhat.com>
References: <20220128203934.600247-1-atomlin@redhat.com>
         <20220128203934.600247-4-atomlin@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.40.4-1ubuntu2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 77agk1thbwafnubyr77zj8armqi3zqr5
X-Spam-Status: No, score=-3.03
X-Rspamd-Server: rspamout08
X-Rspamd-Queue-Id: 5FAD320021
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX18tnKphhZrxs8SAkUupQjJbwtcTABK26Jg=
X-HE-Tag: 1643441250-995245
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri, 2022-01-28 at 20:39 +0000, Aaron Tomlin wrote:
> No functional change.
> 
> This patch migrates livepatch support (i.e. used during module
> add/or load and remove/or deletion) from core module code into
> kernel/module/livepatch.c. At the moment it contains code to
> persist Elf information about a given livepatch module, only.
[]
> diff --git a/include/linux/module.h b/include/linux/module.h
[]
> @@ -668,11 +668,22 @@ static inline bool is_livepatch_module(struct module *mod)
>  {
>  	return mod->klp;
>  }
> +
> +static inline bool set_livepatch_module(struct module *mod)
> +{
> +	mod->klp = true;
> +	return true;
> +}
>  #else /* !CONFIG_LIVEPATCH */
>  static inline bool is_livepatch_module(struct module *mod)
>  {
>  	return false;
>  }
> +
> +static inline bool set_livepatch_module(struct module *mod)
> +{
> +	return false;
> +}
>  #endif /* CONFIG_LIVEPATCH */

style trivia:

Generally, these static inlines can be written deduplicating
the function declaration and using IS_ENABLED or #if inside
the definition.

Something like:

static inline bool is_livepatch_module(struct module *mod)
{
	if (IS_ENABLED(CONFIG_LIVEPATCH)) {
		mod->klp = true;
		return true;
	}
	return false;
}

or

static inline bool is_livepatch_module(struct module *mod)
{
#ifdef CONFIG_LIVEPATCH
	mod->klp = true;
	return true;
#else
	return false;
#endif
}


