Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E3D95BF875
	for <lists+live-patching@lfdr.de>; Wed, 21 Sep 2022 10:00:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230036AbiIUIAO (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 21 Sep 2022 04:00:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229946AbiIUIAK (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 21 Sep 2022 04:00:10 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60EF15E316;
        Wed, 21 Sep 2022 01:00:09 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 1CF8721A74;
        Wed, 21 Sep 2022 08:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1663747208; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=t+VdmQ/EwFCj7FSxOYsFAjq5Mk52B6+xGoUNKmcmJVw=;
        b=avRdcELgfrFsNuyX2tT4kdgV0LjyVVosaTU4r5qZNb8m2GftC/y+DXumT5EhgzrsdB/ghm
        UvH2PLoFM+QV+cNYeZCMw431ZySy7vjvrRJFrYRHTtAWekh5cgSM4b/+Vs8JsSMlsxuHWE
        EKxX5TnK8cdhJurUWnKZPwO0A7wQqME=
Received: from suse.cz (unknown [10.100.201.202])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id E9E352C142;
        Wed, 21 Sep 2022 08:00:07 +0000 (UTC)
Date:   Wed, 21 Sep 2022 10:00:07 +0200
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
Subject: Re: [PATCH v4 2/8] scripts/kallsyms: ensure that all possible
 combinations are compressed
Message-ID: <YyrEh+fbhYh6ltLp@alley>
References: <20220920071317.1787-1-thunder.leizhen@huawei.com>
 <20220920071317.1787-3-thunder.leizhen@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220920071317.1787-3-thunder.leizhen@huawei.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue 2022-09-20 15:13:11, Zhen Lei wrote:
> For a symbol, there may be more than one place that can be merged. For
> example: nfs_fs_proc_net_init, there are two "f"+"s_" combinations.
> And we're only compressing the first combination at the moment.

Really?

> diff --git a/scripts/kallsyms.c b/scripts/kallsyms.c
> index 8caccc8f4a23703..3319d9f38d7a5f2 100644
> --- a/scripts/kallsyms.c
> +++ b/scripts/kallsyms.c
> @@ -553,7 +553,7 @@ static void compress_symbols(const unsigned char *str, int idx)
>  	unsigned char *p1, *p2;
>  
>  	for (i = 0; i < table_cnt; i++) {
> -
> +retry:
>  		len = table[i]->len;
>  		p1 = table[i]->sym;
>  
> @@ -585,6 +585,9 @@ static void compress_symbols(const unsigned char *str, int idx)
>  
>  		/* increase the counts for this symbol's new tokens */
>  		learn_symbol(table[i]->sym, len);
> +
> +		/* May be more than one place that can be merged, try again */
> +		goto retry;
>  	}
>  }

My understanding is that the code already tries to find the same
token several times. Here are the important parts of the existing
code:

static void compress_symbols(const unsigned char *str, int idx)
{

		p2 = find_token(p1, len, str);

		do {
			/* replace the found token with idx */
			*p2 = idx;
			[...]

			/* find the token on the symbol */
			p2 = find_token(p1, size, str);

		} while (p2);

Best Regards,
Petr
