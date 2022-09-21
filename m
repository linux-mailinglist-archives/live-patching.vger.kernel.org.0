Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B1595BF74E
	for <lists+live-patching@lfdr.de>; Wed, 21 Sep 2022 09:13:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229563AbiIUHNo (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 21 Sep 2022 03:13:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbiIUHNn (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 21 Sep 2022 03:13:43 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70003DEA4;
        Wed, 21 Sep 2022 00:13:42 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 18FCB21AC7;
        Wed, 21 Sep 2022 07:13:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1663744421; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zP9Fpa7PASRGajKoVnCpCT04C3FBGHn5IhRuCoFQgSM=;
        b=hvvAg7SlryF9sPfsBE5rjYlV7Cynfttq7s1g0iHqcO7LADixZUcAjFETOmCfW/nCnq+oZ4
        1Xwi4hHddLCcLS2j87ZTtkzhJ0FEEGGQnPDaD1KMW1oHpaxtnrprNjUieesnS5Za/UGxd9
        sq7RWEC5h6RT0iA2tEh5SkG8f9vUTGY=
Received: from suse.cz (unknown [10.100.208.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id D7EA32C141;
        Wed, 21 Sep 2022 07:13:40 +0000 (UTC)
Date:   Wed, 21 Sep 2022 09:13:40 +0200
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
Subject: Re: [PATCH v2 1/8] scripts/kallsyms: don't compress symbol type when
 CONFIG_KALLSYMS_ALL=y
Message-ID: <Yyq5pNA2dEcW4h6Q@alley>
References: <20220909130016.727-1-thunder.leizhen@huawei.com>
 <20220909130016.727-2-thunder.leizhen@huawei.com>
 <Yyn305PlgTZixR0V@alley>
 <42cdce86-8ccd-3cc1-9e30-13485a183d98@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <42cdce86-8ccd-3cc1-9e30-13485a183d98@huawei.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed 2022-09-21 10:42:56, Leizhen (ThunderTown) wrote:
> 
> 
> On 2022/9/21 1:26, Petr Mladek wrote:
> > On Fri 2022-09-09 21:00:09, Zhen Lei wrote:
> >> Currently, to search for a symbol, we need to expand the symbols in
> >> 'kallsyms_names' one by one, and then use the expanded string for
> >> comparison. This is very slow.
> >>
> >> In fact, we can first compress the name being looked up and then use
> >> it for comparison when traversing 'kallsyms_names'.
> > 
> > This does not explain how this patch modifies the compressed data
> > and why it is needed.
> 
> Yes, I have updated the description from the v3 version.

Ah, there is even v4. I have missed that. The commit message looks
much better there.

> So if we don't compress the symbol type, we can first compress the
> searched symbol and then make a quick comparison based on the compressed
> length and content. In this way, for entries with mismatched lengths,
> there is no need to expand and compare strings. And for those matching
> lengths, there's no need to expand the symbol. This saves a lot of time.
> 
> > 
> > 
> >> This increases the size of 'kallsyms_names'. About 48KiB, 2.67%, on x86
> >> with defconfig.
> >> Before: kallsyms_num_syms=131392, sizeof(kallsyms_names)=1823659
> >> After : kallsyms_num_syms=131392, sizeof(kallsyms_names)=1872418
> >>
> >> However, if CONFIG_KALLSYMS_ALL is not set, the size of 'kallsyms_names'
> >> does not change.
> >>
> >> Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
> >> ---
> >>  scripts/kallsyms.c | 15 ++++++++++++---
> >>  1 file changed, 12 insertions(+), 3 deletions(-)
> >>
> >> diff --git a/scripts/kallsyms.c b/scripts/kallsyms.c
> >> index f18e6dfc68c5839..ab6fe7cd014efd1 100644
> >> --- a/scripts/kallsyms.c
> >> +++ b/scripts/kallsyms.c
> >> +	 */
> >> +	if (all_symbols)
> >> +		sym_start_idx = 1;
> > 
> > This looks a bit fragile. My understanding is that the new code in
> > kernel/kallsyms.c and kernel/module/kallsyms.c depends on this change.
> 
> They do not depend on this change, because the index in
> insert_real_symbols_in_table() is still starting from 0. kallsyms_expand_symbol()
> shows that it uses every byte of the compressed data to look up the token table.
> The index in insert_real_symbols_in_table() starting from 0 make sure that the
> raw character of 'type' occupies a separate position in kallsyms_token_table[].
> So that kallsyms_expand_symbol() can still work well.

I guess that we are talking about different things. Anyway, please
ignore my concern about that it is fragile. The change in
scripts/kallsyms.c does not longer depend on --all-symbols parameter
in the last v4 patchset.

> > I would personally suggest to store the symbol type into a separate
> > sym->type entry in struct sym_entry and never compress it.
> 
> Yes，I've also considered this, for the purpose of increasing the
> compression ratio. See below, if the sorting is performed based on
> the address and then based on the type. We can record all the symbol
> type information in less than 100 bytes. Of course, this makes the
> functions that look up symbols based on the address loop serveral
> times more. However, I would like to wait until the current patch
> series is accepted. Otherwise, I'll have to rework a lot of patches
> and it's too much work. To be honest, I've been coding for it these days.
> 
> cat /proc/kallsyms | awk '{print $2}' | sort | uniq -c | sort -r
>   44678 r
>   38299 t
>   28315 T
>   11644 d
>    3768 D
>    2778 b
>     778 R
>     641 B
>     282 A
>     178 W
>      37 V

This is another optimization. I agree that we could do it later after
this patchset is accepted.

Best Regards,
Petr
