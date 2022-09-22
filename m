Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E136C5E6368
	for <lists+live-patching@lfdr.de>; Thu, 22 Sep 2022 15:18:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230078AbiIVNRu (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 22 Sep 2022 09:17:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231415AbiIVNRm (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 22 Sep 2022 09:17:42 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D5FDECCD3;
        Thu, 22 Sep 2022 06:17:38 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id C8DB121982;
        Thu, 22 Sep 2022 13:17:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1663852656; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5VxXvVs0YdYO3sD0aUgYp7qqqpQnVQA/2ZsAJ0zdeDo=;
        b=j0srfyICy6WIjrVcwpembz4gXsiclktb0/Y4yfVYyjSCvgiHG0V8LjrcAbAsJxlmP8takY
        lqv4S7533VbkvX/ASvFYXBMDXxevueLbwuVtMA4UJgnuZdYR9tygho367XX0Jrp7WQ+VC9
        WfB8xm7VcGw/Lmnwv00UpIiFZF/VLCw=
Received: from suse.cz (unknown [10.100.208.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id C68262C141;
        Thu, 22 Sep 2022 13:17:32 +0000 (UTC)
Date:   Thu, 22 Sep 2022 15:17:33 +0200
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
Message-ID: <YyxgbZBORARoOIWf@alley>
References: <20220920071317.1787-1-thunder.leizhen@huawei.com>
 <20220920071317.1787-5-thunder.leizhen@huawei.com>
 <Yyss3SWM0nTVnjT7@alley>
 <3c86335e-c5b8-b291-d0c2-9b69f912f900@huawei.com>
 <YywIcQzaGmV43zr6@alley>
 <ba8979fb-df77-c387-3c7b-cf5c46050c43@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ba8979fb-df77-c387-3c7b-cf5c46050c43@huawei.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu 2022-09-22 15:21:57, Leizhen (ThunderTown) wrote:
> 
> 
> On 2022/9/22 15:02, Petr Mladek wrote:
> > On Thu 2022-09-22 10:15:22, Leizhen (ThunderTown) wrote:
> >>
> >>
> >> On 2022/9/21 23:25, Petr Mladek wrote:
> >>> On Tue 2022-09-20 15:13:13, Zhen Lei wrote:
> >>>> Currently, to search for a symbol, we need to expand the symbols in
> >>>> 'kallsyms_names' one by one, and then use the expanded string for
> >>>> comparison. This process can be optimized.
> >>>>
> >>>> And now scripts/kallsyms no longer compresses the symbol types, each
> >>>> symbol type always occupies one byte. So we can first compress the
> >>>> searched symbol and then make a quick comparison based on the compressed
> >>>> length and content. In this way, for entries with mismatched lengths,
> >>>> there is no need to expand and compare strings. And for those matching
> >>>> lengths, there's no need to expand the symbol. This saves a lot of time.
> >>>> According to my test results, the average performance of
> >>>> kallsyms_lookup_name() can be improved by 20 to 30 times.
> >>>>
> >>>> The pseudo code of the test case is as follows:
> >>>> static int stat_find_name(...)
> >>>> {
> >>>> 	start = sched_clock();
> >>>> 	(void)kallsyms_lookup_name(name);
> >>>> 	end = sched_clock();
> >>>> 	//Update min, max, cnt, sum
> >>>> }
> >>>>
> >>>> /*
> >>>>  * Traverse all symbols in sequence and collect statistics on the time
> >>>>  * taken by kallsyms_lookup_name() to lookup each symbol.
> >>>>  */
> >>>> kallsyms_on_each_symbol(stat_find_name, NULL);
> >>>>
> >>>> The test results are as follows (twice):
> >>>> After : min=5250, max=  726560, avg= 302132
> >>>> After : min=5320, max=  726850, avg= 301978
> >>>> Before: min=170,  max=15949190, avg=7553906
> >>>> Before: min=160,  max=15877280, avg=7517784
> >>>>
> >>>> The average time consumed is only 4.01% and the maximum time consumed is
> >>>> only 4.57% of the time consumed before optimization.
> >>>>
> >>>> Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
> >>>> ---
> >>>>  kernel/kallsyms.c | 79 +++++++++++++++++++++++++++++++++++++++++++++--
> >>>>  1 file changed, 76 insertions(+), 3 deletions(-)
> >>>>
> >>>> diff --git a/kernel/kallsyms.c b/kernel/kallsyms.c
> >>>> index 3e7e2c2ad2f75ef..2d76196cfe89f34 100644
> >>>> --- a/kernel/kallsyms.c
> >>>> +++ b/kernel/kallsyms.c
> >>>> @@ -87,6 +87,71 @@ static unsigned int kallsyms_expand_symbol(unsigned int off,
> >>>> +{
> >>>> +	int i, j, k, n;
> >>>> +	int len, token_len;
> >>>> +	const char *token;
> >>>> +	unsigned char token_idx[KSYM_NAME_LEN];
> >>>> +	unsigned char token_bak[KSYM_NAME_LEN];
> >>>
> >>> Why do we need two buffers? It should be possible to compress the name
> >>> in the same buffer as it is done in compress_symbols() in scripts/callsyms.c.
> >>
> >> Because the performance would be a little better. Now this function takes
> >> just over a microsecond. Currently, it takes about 250 microseconds on
> >> average to lookup a symbol, so adding a little more time to this function
> >> doesn't affect the overall picture. I'll modify and test it as you suggest
> >> below.
> > 
> > We need to be careful about a stack overflow. I have seen that
> > KSYM_NAME_LEN might need to be increased to 512 because of
> > Rust support, see
> > https://lore.kernel.org/r/20220805154231.31257-6-ojeda@kernel.org
> 
> OK. Thanks for your information. I decided to add kallsyms_best_token_table[],
> kallsyms_best_token_table_len, so that we only need one namebuf[], like
> kallsyms_expand_symbol().

Thanks for the effort. Adding kallsyms_best_token_table[] sounds like
the right solution.

Best Regards,
Petr
