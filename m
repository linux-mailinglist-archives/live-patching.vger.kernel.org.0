Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D55263602F
	for <lists+live-patching@lfdr.de>; Wed, 23 Nov 2022 14:41:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238385AbiKWNlE (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 23 Nov 2022 08:41:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238421AbiKWNki (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 23 Nov 2022 08:40:38 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 683E231350;
        Wed, 23 Nov 2022 05:28:26 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 2564B21D6D;
        Wed, 23 Nov 2022 13:28:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1669210105; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lftKQS0Jx+lLFwwtA+DmuDztJ+B9DLUPYk915WjeBA4=;
        b=B97cnp1olHh4IxfqkO4dLSxqBoHic9dqoTxF2c3pKfHMrpiwjrGLLLArmu+b1JNqiQeKQi
        BfSKAsomMoixcyHjxfvBHC0/f6zMTb+XdBJjxyYoIAMVqeX/TmOFPYUaZr2hkLfyDT35/5
        n7+0xEsm76a01RB2ojwkped74N2mrPw=
Received: from suse.cz (unknown [10.100.201.202])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id C6A402C141;
        Wed, 23 Nov 2022 13:28:24 +0000 (UTC)
Date:   Wed, 23 Nov 2022 14:28:24 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     Zhen Lei <thunder.leizhen@huawei.com>
Cc:     Josh Poimboeuf <jpoimboe@kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        Masahiro Yamada <masahiroy@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        linux-modules@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        David Laight <David.Laight@aculab.com>
Subject: Re: [PATCH v8 6/9] livepatch: Use kallsyms_on_each_match_symbol() to
 improve performance
Message-ID: <Y34f+IqqSGbtC82V@alley>
References: <20221102084921.1615-1-thunder.leizhen@huawei.com>
 <20221102084921.1615-7-thunder.leizhen@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221102084921.1615-7-thunder.leizhen@huawei.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hi,

I am sorry for the late review. I have been snowed under another
tasks.

On Wed 2022-11-02 16:49:18, Zhen Lei wrote:
> Based on the test results of kallsyms_on_each_match_symbol() and
> kallsyms_on_each_symbol(), the average performance can be improved by
> more than 1500 times.

Sounds great.

> --- a/kernel/livepatch/core.c
> +++ b/kernel/livepatch/core.c
> @@ -153,6 +153,24 @@ static int klp_find_callback(void *data, const char *name,
>  	return 0;
>  }
>  
> +static int klp_match_callback(void *data, unsigned long addr)
> +{
> +	struct klp_find_arg *args = data;
> +
> +	args->addr = addr;
> +	args->count++;
> +
> +	/*
> +	 * Finish the search when the symbol is found for the desired position
> +	 * or the position is not defined for a non-unique symbol.
> +	 */
> +	if ((args->pos && (args->count == args->pos)) ||
> +	    (!args->pos && (args->count > 1)))
> +		return 1;
> +
> +	return 0;

This duplicates most of the klp_find_callback(). Please, call this
new function in klp_find_callback() instead of the duplicated code.
I mean to do:

static int klp_find_callback(void *data, const char *name, unsigned long addr)
{
	struct klp_find_arg *args = data;

	if (strcmp(args->name, name))
		return 0;

	return klp_match_callback(data, addr);
}

Otherwise, it looks good.

Best Regards,
Petr
