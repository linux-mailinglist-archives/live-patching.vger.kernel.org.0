Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B2AB5C01B8
	for <lists+live-patching@lfdr.de>; Wed, 21 Sep 2022 17:35:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230511AbiIUPfj (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 21 Sep 2022 11:35:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232052AbiIUPem (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 21 Sep 2022 11:34:42 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 308309F0CE;
        Wed, 21 Sep 2022 08:32:04 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 6005F21B3F;
        Wed, 21 Sep 2022 15:30:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1663774247; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XOTekTN/SuqiQ3r409np/Bru2x8KvP+5v99mZ3qdoUI=;
        b=A/2iYUKksSP2Zg1LjadEKbTd/TuyxXJn2c4AASEMOSJHPPm9lDriBvsIpeTRhcrph3fhyM
        01w8I0wgN2s6ZaLuBudCZMiA/a7DZLS8kV/uL2CSpvhAfGSP4wgAI60OqUW8nbrCahtbkc
        OcO97Ekrw92s7gnzQvMfgMonxU7wc9U=
Received: from suse.cz (unknown [10.100.201.202])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 3A3932C141;
        Wed, 21 Sep 2022 15:30:47 +0000 (UTC)
Date:   Wed, 21 Sep 2022 17:30:46 +0200
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
        linux-modules@vger.kernel.org
Subject: Re: [PATCH v4 5/8] kallsyms: Add helper
 kallsyms_on_each_match_symbol()
Message-ID: <YysuJrpLYkVa2vCg@alley>
References: <20220920071317.1787-1-thunder.leizhen@huawei.com>
 <20220920071317.1787-6-thunder.leizhen@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220920071317.1787-6-thunder.leizhen@huawei.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue 2022-09-20 15:13:14, Zhen Lei wrote:
> Function kallsyms_on_each_symbol() traverses all symbols and submits each
> symbol to the hook 'fn' for judgment and processing. For some cases, the
> hook actually only handles the matched symbol, such as livepatch.
> 
> So that, we can first compress the name being looked up and then use
> it for comparison when traversing 'kallsyms_names', this greatly reduces
> the time consumed by traversing.
> 
> The pseudo code of the test case is as follows:
> static int tst_find(void *data, const char *name,
> 		    struct module *mod, unsigned long addr)
> {
> 	if (strcmp(name, "vmap") == 0)
> 		*(unsigned long *)data = addr;
>         return 0;
> }
> 
> static int tst_match(void *data, unsigned long addr)
> {
>         *(unsigned long *)data = addr;
>         return 0;
> }
> 
> start = sched_clock();
> kallsyms_on_each_match_symbol(tst_match, "vmap", &addr);
> end = sched_clock();
> 
> start = sched_clock();
> kallsyms_on_each_symbol(tst_find, &addr);
> end = sched_clock();
> 
> The test results are as follows (twice):
> kallsyms_on_each_match_symbol:   557400,   583900
> kallsyms_on_each_symbol      : 16659500, 16113950
> 
> kallsyms_on_each_match_symbol() consumes only 3.48% of
> kallsyms_on_each_symbol()'s time.
> 
> --- a/kernel/kallsyms.c
> +++ b/kernel/kallsyms.c
> @@ -305,6 +305,31 @@ int kallsyms_on_each_symbol(int (*fn)(void *, const char *, struct module *,
>  	return 0;
>  }
>  
> +int kallsyms_on_each_match_symbol(int (*fn)(void *, unsigned long),
> +				  const char *name, void *data)
> +{
> +	unsigned int i, off;
> +	int len, ret;
> +	char namebuf[KSYM_NAME_LEN];
> +
> +	len = kallsyms_name_to_tokens(name, namebuf);
> +	for (i = 0, off = 0; len && i < kallsyms_num_syms; i++) {
> +		if ((i & 0xfff) == 0)
> +			cond_resched();
> +
> +		if ((kallsyms_names[off] == len + 1) &&
> +		    !memcmp(&kallsyms_names[off + 2], namebuf, len)) {
> +			ret = fn(data, kallsyms_sym_address(i));
> +			if (ret != 0)
> +				return ret;
> +			cond_resched();
> +		}
> +		off += kallsyms_names[off] + 1;

Similar tricky code is used also in kallsyms_lookup_name(). Please,
avoid code duplication and put this into a helper funtion.

Best Regards,
Petr

> +	}
> +
> +	return 0;
> +}
> +
>  static unsigned long get_symbol_pos(unsigned long addr,
>  				    unsigned long *symbolsize,
>  				    unsigned long *offset)
> -- 
> 2.25.1
