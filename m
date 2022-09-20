Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 588705BEBD9
	for <lists+live-patching@lfdr.de>; Tue, 20 Sep 2022 19:26:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230190AbiITR0u (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 20 Sep 2022 13:26:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbiITR0t (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 20 Sep 2022 13:26:49 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BE3A58DC7;
        Tue, 20 Sep 2022 10:26:48 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id E12DA21B69;
        Tue, 20 Sep 2022 17:26:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1663694806; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=55Y7hJRILYCZSmEl8VFafa6FNPLMA4ET1MSFLD7oFeY=;
        b=KXfCm5+BcMeawj5bdpORhiYS8nKC4KS1vP8VpCW5X1JXHICPRX6MhhHmNtEx6LLR+YDytD
        MTOjRMasjnoMcw1gMsmdnh0BpOOBBJSggcb4z42+PiV5vOt0nQJ02YrUqRBcDyKZZlDmzE
        xwcPznonGc5EVYRQvIHNlocOneaG5sk=
Received: from suse.cz (unknown [10.100.208.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id B49882C141;
        Tue, 20 Sep 2022 17:26:46 +0000 (UTC)
Date:   Tue, 20 Sep 2022 19:26:43 +0200
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
Subject: Re: [PATCH v2 1/8] scripts/kallsyms: don't compress symbol type when
 CONFIG_KALLSYMS_ALL=y
Message-ID: <Yyn305PlgTZixR0V@alley>
References: <20220909130016.727-1-thunder.leizhen@huawei.com>
 <20220909130016.727-2-thunder.leizhen@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220909130016.727-2-thunder.leizhen@huawei.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri 2022-09-09 21:00:09, Zhen Lei wrote:
> Currently, to search for a symbol, we need to expand the symbols in
> 'kallsyms_names' one by one, and then use the expanded string for
> comparison. This is very slow.
> 
> In fact, we can first compress the name being looked up and then use
> it for comparison when traversing 'kallsyms_names'.

This does not explain how this patch modifies the compressed data
and why it is needed.


> This increases the size of 'kallsyms_names'. About 48KiB, 2.67%, on x86
> with defconfig.
> Before: kallsyms_num_syms=131392, sizeof(kallsyms_names)=1823659
> After : kallsyms_num_syms=131392, sizeof(kallsyms_names)=1872418
> 
> However, if CONFIG_KALLSYMS_ALL is not set, the size of 'kallsyms_names'
> does not change.
> 
> Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
> ---
>  scripts/kallsyms.c | 15 ++++++++++++---
>  1 file changed, 12 insertions(+), 3 deletions(-)
> 
> diff --git a/scripts/kallsyms.c b/scripts/kallsyms.c
> index f18e6dfc68c5839..ab6fe7cd014efd1 100644
> --- a/scripts/kallsyms.c
> +++ b/scripts/kallsyms.c
> @@ -60,6 +60,7 @@ static unsigned int table_size, table_cnt;
>  static int all_symbols;
>  static int absolute_percpu;
>  static int base_relative;
> +static int sym_start_idx;
>  
>  static int token_profit[0x10000];
>  
> @@ -511,7 +512,7 @@ static void learn_symbol(const unsigned char *symbol, int len)
>  {
>  	int i;
>  
> -	for (i = 0; i < len - 1; i++)
> +	for (i = sym_start_idx; i < len - 1; i++)
>  		token_profit[ symbol[i] + (symbol[i + 1] << 8) ]++;

This skips the first character in the @symbol string. I do not see how
this is used in the new code, for example, in
kallsyms_on_each_match_symbol(), in the 5th patch. It seems to iterate
the compressed data from the 0th index:

	for (i = 0, off = 0; i < kallsyms_num_syms; i++)

>  }
>  
> @@ -520,7 +521,7 @@ static void forget_symbol(const unsigned char *symbol, int len)
>  {
>  	int i;
>  
> -	for (i = 0; i < len - 1; i++)
> +	for (i = sym_start_idx; i < len - 1; i++)
>  		token_profit[ symbol[i] + (symbol[i + 1] << 8) ]--;
>  }
>  
> @@ -538,7 +539,7 @@ static unsigned char *find_token(unsigned char *str, int len,
>  {
>  	int i;
>  
> -	for (i = 0; i < len - 1; i++) {
> +	for (i = sym_start_idx; i < len - 1; i++) {
>  		if (str[i] == token[0] && str[i+1] == token[1])
>  			return &str[i];
>  	}
> @@ -780,6 +781,14 @@ int main(int argc, char **argv)
>  	} else if (argc != 1)
>  		usage();
>  
> +	/*
> +	 * Skip the symbol type, do not compress it to optimize the performance
> +	 * of finding or traversing symbols in kernel, this is good for modules
> +	 * such as livepatch.

I see. The type is added as the first character here.

in static struct sym_entry *read_symbol(FILE *in)
{
[...]
	/* include the type field in the symbol name, so that it gets
	 * compressed together */
[...]
	sym->sym[0] = type;
	strcpy(sym_name(sym), name);

It sounds a bit crazy. read_symbol() makes a trick so that the type
can be compressed. This patch does another trick to avoid it.


> +	 */
> +	if (all_symbols)
> +		sym_start_idx = 1;

This looks a bit fragile. My understanding is that the new code in
kernel/kallsyms.c and kernel/module/kallsyms.c depends on this change.

The faster search is used when CONFIG_KALLSYMS_ALL is defined.
But the data are compressed this way when this script is called
with --all-symbols.

Is it guaranteed that this script will generate the needed data
when CONFIG_KALLSYMS_ALL is defined?

What about 3rd party modules?

I would personally suggest to store the symbol type into a separate
sym->type entry in struct sym_entry and never compress it.

IMHO, the size win is not worth the code complexity.

Well, people compiling the kernel for small devices might think
different. But they probably disable kallsyms completely.

Best Regards,
Petr
