Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49427732BD8
	for <lists+live-patching@lfdr.de>; Fri, 16 Jun 2023 11:32:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344287AbjFPJcN (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 16 Jun 2023 05:32:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344500AbjFPJcB (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 16 Jun 2023 05:32:01 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61D9C30FE
        for <live-patching@vger.kernel.org>; Fri, 16 Jun 2023 02:31:22 -0700 (PDT)
Received: from dggpemm500006.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4QjDS70XW1zqSLr;
        Fri, 16 Jun 2023 17:31:19 +0800 (CST)
Received: from [10.174.178.55] (10.174.178.55) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 16 Jun 2023 17:31:19 +0800
Subject: Re: [PATCH] kallsyms: let kallsyms_on_each_match_symbol match symbols
 exactly
To:     Song Liu <song@kernel.org>, <live-patching@vger.kernel.org>
CC:     <jpoimboe@kernel.org>, <jikos@kernel.org>, <mbenes@suse.cz>,
        <pmladek@suse.com>, <joe.lawrence@redhat.com>,
        <kernel-team@meta.com>, <mcgrof@kernel.org>
References: <20230615170048.2382735-1-song@kernel.org>
From:   "Leizhen (ThunderTown)" <thunder.leizhen@huawei.com>
Message-ID: <3c0ea20b-fae7-af68-4c45-9539812ee198@huawei.com>
Date:   Fri, 16 Jun 2023 17:31:19 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20230615170048.2382735-1-song@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.55]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpemm500006.china.huawei.com (7.185.36.236)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



On 2023/6/16 1:00, Song Liu wrote:
> With CONFIG_LTO_CLANG, kallsyms.c:cleanup_symbol_name() removes symbols
> suffixes during comparison. This is problematic for livepatch, as
> kallsyms_on_each_match_symbol may find multiple matches for the same
> symbol, and fail with:
> 
>   livepatch: unresolvable ambiguity for symbol 'xxx' in object 'yyy'
> 
> Make kallsyms_on_each_match_symbol() to match symbols exactly. Since
> livepatch is the only user of kallsyms_on_each_match_symbol(), this
> change is safe.
> 
> Signed-off-by: Song Liu <song@kernel.org>
> ---
>  kernel/kallsyms.c | 17 +++++++++--------
>  1 file changed, 9 insertions(+), 8 deletions(-)
> 
> diff --git a/kernel/kallsyms.c b/kernel/kallsyms.c
> index 77747391f49b..2ab459b43084 100644
> --- a/kernel/kallsyms.c
> +++ b/kernel/kallsyms.c
> @@ -187,7 +187,7 @@ static bool cleanup_symbol_name(char *s)
>  	return false;
>  }
>  
> -static int compare_symbol_name(const char *name, char *namebuf)
> +static int compare_symbol_name(const char *name, char *namebuf, bool match_exactly)
>  {
>  	int ret;
>  
> @@ -195,7 +195,7 @@ static int compare_symbol_name(const char *name, char *namebuf)
>  	if (!ret)
>  		return ret;
>  
> -	if (cleanup_symbol_name(namebuf) && !strcmp(name, namebuf))
> +	if (!match_exactly && cleanup_symbol_name(namebuf) && !strcmp(name, namebuf))

This may affect the lookup of static functions.

>  		return 0;
>  
>  	return ret;
> @@ -213,7 +213,8 @@ static unsigned int get_symbol_seq(int index)
>  
>  static int kallsyms_lookup_names(const char *name,
>  				 unsigned int *start,
> -				 unsigned int *end)
> +				 unsigned int *end,
> +				 bool match_exactly)
>  {
>  	int ret;
>  	int low, mid, high;
> @@ -228,7 +229,7 @@ static int kallsyms_lookup_names(const char *name,
>  		seq = get_symbol_seq(mid);
>  		off = get_symbol_offset(seq);
>  		kallsyms_expand_symbol(off, namebuf, ARRAY_SIZE(namebuf));
> -		ret = compare_symbol_name(name, namebuf);
> +		ret = compare_symbol_name(name, namebuf, match_exactly);
>  		if (ret > 0)
>  			low = mid + 1;
>  		else if (ret < 0)
> @@ -245,7 +246,7 @@ static int kallsyms_lookup_names(const char *name,
>  		seq = get_symbol_seq(low - 1);
>  		off = get_symbol_offset(seq);
>  		kallsyms_expand_symbol(off, namebuf, ARRAY_SIZE(namebuf));
> -		if (compare_symbol_name(name, namebuf))
> +		if (compare_symbol_name(name, namebuf, match_exactly))
>  			break;
>  		low--;
>  	}
> @@ -257,7 +258,7 @@ static int kallsyms_lookup_names(const char *name,
>  			seq = get_symbol_seq(high + 1);
>  			off = get_symbol_offset(seq);
>  			kallsyms_expand_symbol(off, namebuf, ARRAY_SIZE(namebuf));
> -			if (compare_symbol_name(name, namebuf))
> +			if (compare_symbol_name(name, namebuf, match_exactly))
>  				break;
>  			high++;
>  		}
> @@ -277,7 +278,7 @@ unsigned long kallsyms_lookup_name(const char *name)
>  	if (!*name)
>  		return 0;
>  
> -	ret = kallsyms_lookup_names(name, &i, NULL);
> +	ret = kallsyms_lookup_names(name, &i, NULL, false);
>  	if (!ret)
>  		return kallsyms_sym_address(get_symbol_seq(i));
>  
> @@ -312,7 +313,7 @@ int kallsyms_on_each_match_symbol(int (*fn)(void *, unsigned long),
>  	int ret;
>  	unsigned int i, start, end;
>  
> -	ret = kallsyms_lookup_names(name, &start, &end);
> +	ret = kallsyms_lookup_names(name, &start, &end, true);
>  	if (ret)
>  		return 0;
>  
> 

-- 
Regards,
  Zhen Lei
