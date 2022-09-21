Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3EB75C0142
	for <lists+live-patching@lfdr.de>; Wed, 21 Sep 2022 17:26:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231150AbiIUP0r (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 21 Sep 2022 11:26:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230489AbiIUPZ6 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 21 Sep 2022 11:25:58 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F31D832C6;
        Wed, 21 Sep 2022 08:25:25 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 7D3D621B28;
        Wed, 21 Sep 2022 15:25:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1663773921; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kxsF4VjEoXrMK952QJoBUDpJa++xS44NF/ZmR9CjAOw=;
        b=Q878JEnKqlbuqSVtne5ZBFojJI3TKld2FgLM/PWEFu19zeIX4Trd9YH2X9KKi3gkeCzMbu
        6n1bF68oaKikhGOsOT80NtH0ZDabaPnuKhpeKi/lm1Brn5OgK1l3SAq8KAjQMmzbSRjEm2
        GK8k1KJzMguf6RIG8TvV1F+FXxwA8PQ=
Received: from suse.cz (unknown [10.100.201.202])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 543792C143;
        Wed, 21 Sep 2022 15:25:21 +0000 (UTC)
Date:   Wed, 21 Sep 2022 17:25:17 +0200
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
Subject: Re: [PATCH v4 4/8] kallsyms: Improve the performance of
 kallsyms_lookup_name()
Message-ID: <Yyss3SWM0nTVnjT7@alley>
References: <20220920071317.1787-1-thunder.leizhen@huawei.com>
 <20220920071317.1787-5-thunder.leizhen@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220920071317.1787-5-thunder.leizhen@huawei.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue 2022-09-20 15:13:13, Zhen Lei wrote:
> Currently, to search for a symbol, we need to expand the symbols in
> 'kallsyms_names' one by one, and then use the expanded string for
> comparison. This process can be optimized.
> 
> And now scripts/kallsyms no longer compresses the symbol types, each
> symbol type always occupies one byte. So we can first compress the
> searched symbol and then make a quick comparison based on the compressed
> length and content. In this way, for entries with mismatched lengths,
> there is no need to expand and compare strings. And for those matching
> lengths, there's no need to expand the symbol. This saves a lot of time.
> According to my test results, the average performance of
> kallsyms_lookup_name() can be improved by 20 to 30 times.
> 
> The pseudo code of the test case is as follows:
> static int stat_find_name(...)
> {
> 	start = sched_clock();
> 	(void)kallsyms_lookup_name(name);
> 	end = sched_clock();
> 	//Update min, max, cnt, sum
> }
> 
> /*
>  * Traverse all symbols in sequence and collect statistics on the time
>  * taken by kallsyms_lookup_name() to lookup each symbol.
>  */
> kallsyms_on_each_symbol(stat_find_name, NULL);
> 
> The test results are as follows (twice):
> After : min=5250, max=  726560, avg= 302132
> After : min=5320, max=  726850, avg= 301978
> Before: min=170,  max=15949190, avg=7553906
> Before: min=160,  max=15877280, avg=7517784
> 
> The average time consumed is only 4.01% and the maximum time consumed is
> only 4.57% of the time consumed before optimization.
> 
> Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
> ---
>  kernel/kallsyms.c | 79 +++++++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 76 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/kallsyms.c b/kernel/kallsyms.c
> index 3e7e2c2ad2f75ef..2d76196cfe89f34 100644
> --- a/kernel/kallsyms.c
> +++ b/kernel/kallsyms.c
> @@ -87,6 +87,71 @@ static unsigned int kallsyms_expand_symbol(unsigned int off,
>  	return off;
>  }
>  
> +static int kallsyms_name_to_tokens(const char *name, char *buf)

This is not safe API. It is always needed to pass the size of the
buffer.

Also it should be called "compress". "token" is just an implementation
detail.

I would do:

static int kallsyms_compress_symbol_name(const char *name,
					 char *buf, size_t size)


> +{
> +	int i, j, k, n;
> +	int len, token_len;
> +	const char *token;
> +	unsigned char token_idx[KSYM_NAME_LEN];
> +	unsigned char token_bak[KSYM_NAME_LEN];

Why do we need two buffers? It should be possible to compress the name
in the same buffer as it is done in compress_symbols() in scripts/callsyms.c.

> +
> +	/*
> +	 * n, number of tokens in the string name.
> +	 * token_idx[i], the start index of the ith token.
> +	 * token_idx[n] is used to calculate the length of the last token.
> +	 */
> +	n = strlen(name);
> +	if (n >= KSYM_NAME_LEN) {
> +		buf[0] = 0;
> +		return 0;
> +	}
> +	for (i = 0; i <= n; i++)
> +		token_idx[i] = (unsigned char)i;
> +
> +	/*
> +	 * For tokens whose token_len >= 2, a larger index value indicates
> +	 * a higher occurrence frequency. See scripts/kallsyms.c
> +	 */
> +	for (i = 255; i >= 0; i--) {
> +		token = &kallsyms_token_table[kallsyms_token_index[i]];
> +		token_len = strlen(token);
> +		if (token_len <= 1)
> +			continue;
> +
> +		/*
> +		 * Find and merge two tokens into one.
> +		 *
> +		 *                |<-- new_token -->|
> +		 *                | token1 | token2 |
> +		 * token_idx[]:   j       j+1      j+2
> +		 */
> +		for (j = 0; j < n - 1; j++) {
> +			len = token_idx[j + 2] - token_idx[j];
> +			if (len == token_len &&
> +			    !strncmp(name + token_idx[j], token, len)) {
> +				token_bak[token_idx[j]] = (unsigned char)i;
> +				for (k = j + 1; k < n; k++)
> +					token_idx[k] = token_idx[k + 1];
> +				n--;
> +			}
> +		}
> +	}
> +
> +	for (j = 0; j < n; j++) {
> +		len = token_idx[j + 1] - token_idx[j];
> +		if (len <= 1) {
> +			buf[j] = name[token_idx[j]];
> +			continue;
> +		}
> +
> +		buf[j] = token_bak[token_idx[j]];

Maybe, I do not understand the compression format correctly but
this code looks too complicated. Honestly, I even did not try to
understand it.

My understanding is the we just need to find all tokens and
replace them with index.

It should be even easier than compress_symbols() in scripts/callsyms.c.
The token_table already exists and we do not need to handle the token_profit...

The following looks more strigtforward (not even compile tested):

	ssize_t len, size;

	len = strscpy(buf, symname, size);
	if (WARN_ON_ONCE(len < 0))
		return -EINVAL;

	/* the tokens with higher index are used first */
	for (idx = 255; idx >= 0; idx--) {
		token =	&kallsyms_token_table[kallsyms_token_index[i]];
		token_len = strlen(token);

		p1 = buf;
		/* length of the remaining symname including the trailing '\0' */
		remaining = len + 1;

		/* find the token in the symbol name */
		p2 = strstr(token, p1);

		while (p2) {
			/* replace token with index */
			*p2 = idx;
			remaining -= ((p2 - p1) + token_len);
			memmove(p2 + 1, p2 + token_len, remaining);
			len -= (token_len - 1);
			p1 = p2;

			/* find the token in the rest of the symbol name */
			p2 = strstr(token, p1);
		}
	}

	return len;

> +	}
> +	buf[n] = 0;
> +
> +	return n;
> +}
> +
>  /*
>   * Get symbol type information. This is encoded as a single char at the
>   * beginning of the symbol name.
> @@ -192,20 +257,28 @@ unsigned long kallsyms_lookup_name(const char *name)
>  	char namebuf[KSYM_NAME_LEN];
>  	unsigned long i;
>  	unsigned int off;
> +	int len;
>  
>  	/* Skip the search for empty string. */
>  	if (!*name)
>  		return 0;
>  
> +	len = kallsyms_name_to_tokens(name, namebuf);
> +	for (i = 0, off = 0; len && i < kallsyms_num_syms; i++) {
> +		if (kallsyms_names[off] == len + 1 &&
> +		    !memcmp(&kallsyms_names[off + 2], namebuf, len))
> +			return kallsyms_sym_address(i);
> +
> +		off += kallsyms_names[off] + 1;

These complicated checks are hard to review. The following looks much
more readable to me:

	for (i = 0, off = 0; len && i < kallsyms_num_syms; i++) {
		/* the stored symbol name is prefixed by symbol type */
		name_len = kallsyms_names[off] - 1;
		name = &kallsyms_names[off + 2];
		off += name_len + 2;

		if (name_len != len)
			continue;

		if (!memcmp(name, namebuf, len))
			return kallsyms_sym_address(i);
	}


> +	}
> +
>  	for (i = 0, off = 0; i < kallsyms_num_syms; i++) {
>  		off = kallsyms_expand_symbol(off, namebuf, ARRAY_SIZE(namebuf));
>  
> -		if (strcmp(namebuf, name) == 0)
> -			return kallsyms_sym_address(i);
> -
>  		if (cleanup_symbol_name(namebuf) && strcmp(namebuf, name) == 0)
>  			return kallsyms_sym_address(i);

Hmm, it means that the speedup is not usable when kernel is compiled LLVM?
It might actually slow down the search because we would need to use
both fast and slow search?

Best Regards,
Petr
