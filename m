Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33F0372908F
	for <lists+live-patching@lfdr.de>; Fri,  9 Jun 2023 09:09:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229808AbjFIHJQ (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 9 Jun 2023 03:09:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbjFIHJP (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 9 Jun 2023 03:09:15 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A5552717
        for <live-patching@vger.kernel.org>; Fri,  9 Jun 2023 00:09:11 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id E04211FDF7;
        Fri,  9 Jun 2023 07:09:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1686294549; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1lUAK1TpVmZ4JApYwYPhUp4p87uvE3qoqwLhhmAqDEg=;
        b=q1ecXKV93qapf5PEITKneEX8fFccbeKeSN1bCVVtuBxEM2bWJnhnICgFmiND1Lwet3m8Lo
        ROr4IFv28YIbFO7H4rEUsc9Y2XZHMbLfBeB4QFAPzuJQqaVaAbg7P1qa8qN0TxVD4MStCq
        fujIxv1gBjU+oFtkZg+4XSSfMeqnuFw=
Received: from suse.cz (pmladek.tcp.ovpn2.prg.suse.de [10.100.208.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id AD0E32C141;
        Fri,  9 Jun 2023 07:09:09 +0000 (UTC)
Date:   Fri, 9 Jun 2023 09:09:05 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     Song Liu <song@kernel.org>
Cc:     live-patching@vger.kernel.org, jpoimboe@kernel.org,
        jikos@kernel.org, mbenes@suse.cz, joe.lawrence@redhat.com,
        kernel-team@meta.com
Subject: Re: [PATCH] livepatch: match symbols exactly in
 klp_find_object_symbol()
Message-ID: <ZILQERU8CJQvn9ix@alley>
References: <20230602232401.3938285-1-song@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230602232401.3938285-1-song@kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri 2023-06-02 16:24:01, Song Liu wrote:
> With CONFIG_LTO_CLANG, kallsyms.c:cleanup_symbol_name() removes symbols
> suffixes during comparison. This is problematic for livepatch, as
> kallsyms_on_each_match_symbol may find multiple matches for the same
> symbol, and fail with:
> 
>   livepatch: unresolvable ambiguity for symbol 'xxx' in object 'yyy'
> 
> Fix this by using kallsyms_on_each_symbol instead, and matching symbols
> exactly.
> 
> --- a/kernel/livepatch/core.c
> +++ b/kernel/livepatch/core.c
> @@ -166,7 +159,7 @@ static int klp_find_object_symbol(const char *objname, const char *name,
>  	if (objname)
>  		module_kallsyms_on_each_symbol(objname, klp_find_callback, &args);
>  	else
> -		kallsyms_on_each_match_symbol(klp_match_callback, name, &args);
> +		kallsyms_on_each_symbol(klp_find_callback, &args);

AFAIK, you have put a lot of effort to optimize the search recently.
The speedup was amazing, see commit 4dc533e0f2c04174e1ae
("kallsyms: Add helper kallsyms_on_each_match_symbol()").

Do we really need to waste this effort completely?

What about creating variants:

  + kallsyms_on_each_match_exact_symbol()
    + kallsyms_lookup_exact_names()
      + compare_exact_symbol_name()

Where compare_exact_symbol_name() would not try comparing with
cleanup_symbol_name()?

>  
>  	/*
>  	 * Ensure an address was found. If sympos is 0, ensure symbol is unique;

Otherwise, the patch looks fine. It is acceptable for me. I just want
to be sure that we considered the above alternative solution.

Best Regards,
Petr
