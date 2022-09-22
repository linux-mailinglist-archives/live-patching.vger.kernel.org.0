Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70F2F5E5BC2
	for <lists+live-patching@lfdr.de>; Thu, 22 Sep 2022 09:02:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230004AbiIVHCR (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 22 Sep 2022 03:02:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230019AbiIVHCP (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 22 Sep 2022 03:02:15 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69BE887091;
        Thu, 22 Sep 2022 00:02:14 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 0CEE21F8DA;
        Thu, 22 Sep 2022 07:02:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1663830133; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Tql28FEDZR5AkUvGYGik2Z9q+G8l9Q/77SR1ki9LMrQ=;
        b=PH+m9CqbfIp2VhPw8ZAkmo/lYuHiFjjeHa9aaM0FkmuBHRQD8dO/uUMS96IjSwLOQbN/9l
        HECqR9Iyk/cqDsHEr4fnSm7NjVnZLzfSgd7g6Oc3j50FpmhcW2mh94UtLCDc5k3M/3QtuX
        oXQ/0XbeGK8JTqh+lweIQubnqUWa7js=
Received: from suse.cz (unknown [10.100.201.202])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id D0F222C141;
        Thu, 22 Sep 2022 07:02:12 +0000 (UTC)
Date:   Thu, 22 Sep 2022 09:02:09 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     "Leizhen (ThunderTown)" <thunder.leizhen@huawei.com>
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
Message-ID: <YywIcQzaGmV43zr6@alley>
References: <20220920071317.1787-1-thunder.leizhen@huawei.com>
 <20220920071317.1787-5-thunder.leizhen@huawei.com>
 <Yyss3SWM0nTVnjT7@alley>
 <3c86335e-c5b8-b291-d0c2-9b69f912f900@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3c86335e-c5b8-b291-d0c2-9b69f912f900@huawei.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu 2022-09-22 10:15:22, Leizhen (ThunderTown) wrote:
> 
> 
> On 2022/9/21 23:25, Petr Mladek wrote:
> > On Tue 2022-09-20 15:13:13, Zhen Lei wrote:
> >> Currently, to search for a symbol, we need to expand the symbols in
> >> 'kallsyms_names' one by one, and then use the expanded string for
> >> comparison. This process can be optimized.
> >>
> >> And now scripts/kallsyms no longer compresses the symbol types, each
> >> symbol type always occupies one byte. So we can first compress the
> >> searched symbol and then make a quick comparison based on the compressed
> >> length and content. In this way, for entries with mismatched lengths,
> >> there is no need to expand and compare strings. And for those matching
> >> lengths, there's no need to expand the symbol. This saves a lot of time.
> >> According to my test results, the average performance of
> >> kallsyms_lookup_name() can be improved by 20 to 30 times.
> >>
> >> The pseudo code of the test case is as follows:
> >> static int stat_find_name(...)
> >> {
> >> 	start = sched_clock();
> >> 	(void)kallsyms_lookup_name(name);
> >> 	end = sched_clock();
> >> 	//Update min, max, cnt, sum
> >> }
> >>
> >> /*
> >>  * Traverse all symbols in sequence and collect statistics on the time
> >>  * taken by kallsyms_lookup_name() to lookup each symbol.
> >>  */
> >> kallsyms_on_each_symbol(stat_find_name, NULL);
> >>
> >> The test results are as follows (twice):
> >> After : min=5250, max=  726560, avg= 302132
> >> After : min=5320, max=  726850, avg= 301978
> >> Before: min=170,  max=15949190, avg=7553906
> >> Before: min=160,  max=15877280, avg=7517784
> >>
> >> The average time consumed is only 4.01% and the maximum time consumed is
> >> only 4.57% of the time consumed before optimization.
> >>
> >> Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
> >> ---
> >>  kernel/kallsyms.c | 79 +++++++++++++++++++++++++++++++++++++++++++++--
> >>  1 file changed, 76 insertions(+), 3 deletions(-)
> >>
> >> diff --git a/kernel/kallsyms.c b/kernel/kallsyms.c
> >> index 3e7e2c2ad2f75ef..2d76196cfe89f34 100644
> >> --- a/kernel/kallsyms.c
> >> +++ b/kernel/kallsyms.c
> >> @@ -87,6 +87,71 @@ static unsigned int kallsyms_expand_symbol(unsigned int off,
> >> +{
> >> +	int i, j, k, n;
> >> +	int len, token_len;
> >> +	const char *token;
> >> +	unsigned char token_idx[KSYM_NAME_LEN];
> >> +	unsigned char token_bak[KSYM_NAME_LEN];
> > 
> > Why do we need two buffers? It should be possible to compress the name
> > in the same buffer as it is done in compress_symbols() in scripts/callsyms.c.
> 
> Because the performance would be a little better. Now this function takes
> just over a microsecond. Currently, it takes about 250 microseconds on
> average to lookup a symbol, so adding a little more time to this function
> doesn't affect the overall picture. I'll modify and test it as you suggest
> below.

We need to be careful about a stack overflow. I have seen that
KSYM_NAME_LEN might need to be increased to 512 because of
Rust support, see
https://lore.kernel.org/r/20220805154231.31257-6-ojeda@kernel.org

> >> @@ -192,20 +257,28 @@ unsigned long kallsyms_lookup_name(const char *name)
> >>  	for (i = 0, off = 0; i < kallsyms_num_syms; i++) {
> >>  		off = kallsyms_expand_symbol(off, namebuf, ARRAY_SIZE(namebuf));
> >>  
> >> -		if (strcmp(namebuf, name) == 0)
> >> -			return kallsyms_sym_address(i);
> >> -
> >>  		if (cleanup_symbol_name(namebuf) && strcmp(namebuf, name) == 0)
> >>  			return kallsyms_sym_address(i);
> > 
> > Hmm, it means that the speedup is not usable when kernel is compiled LLVM?
> > It might actually slow down the search because we would need to use
> > both fast and slow search?
> 
> Theoretically, I don't think so. A string comparison was removed from the
> slow search. "if (name_len != len)" is faster than
> "if (strcmp(namebuf, name) == 0)". Even if they're equal,
> kallsyms_compress_symbol_name() only takes 1-2us, it doesn't affect the
> overall picture. The average lookup time before optimization is
> millisecond-level.
>
> Before: min=170,  max=15949190, avg=7553906

Good point! I agree that the potential extra overhead is negligible
when using the old code as a fallback.

Best Regards,
Petr
