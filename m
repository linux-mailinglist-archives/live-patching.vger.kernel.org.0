Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D109D65D751
	for <lists+live-patching@lfdr.de>; Wed,  4 Jan 2023 16:36:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235044AbjADPgd (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 4 Jan 2023 10:36:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230420AbjADPgc (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 4 Jan 2023 10:36:32 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94C54167EF;
        Wed,  4 Jan 2023 07:36:31 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 4D1873FBE0;
        Wed,  4 Jan 2023 15:36:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1672846590; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Y3eRToaXVdN3AVocHxVVeVyr8FyHyxT3hbSrQcFTokM=;
        b=Z8o1DceIPDjGkidYTGzhocEhLkBXzXqqcguZQC+zUMSqmtR1isNtL7jsRs2WGOlbP41GoT
        Vw2CcOg1XWYvqtEXK0Ge9hfVYay6Fxwdzh8y3d9hs4SusTG8QNm5RshQFPkhA0IfXb2+ZJ
        7e+oRqulsuvmHTT1QxbrpVaTIsLC3MU=
Received: from suse.cz (unknown [10.100.208.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id D36CD2C141;
        Wed,  4 Jan 2023 15:36:29 +0000 (UTC)
Date:   Wed, 4 Jan 2023 16:36:28 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     Zhen Lei <thunder.leizhen@huawei.com>
Cc:     Josh Poimboeuf <jpoimboe@kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>, bpf@vger.kernel.org,
        linux-trace-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        linux-kernel@vger.kernel.org, Luis Chamberlain <mcgrof@kernel.org>,
        linux-modules@vger.kernel.org
Subject: Re: [PATCH 1/3] livepatch: Improve the search performance of
 module_kallsyms_on_each_symbol()
Message-ID: <Y7Wc/G8a+pv6iV7G@alley>
References: <20221230112729.351-1-thunder.leizhen@huawei.com>
 <20221230112729.351-2-thunder.leizhen@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221230112729.351-2-thunder.leizhen@huawei.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri 2022-12-30 19:27:27, Zhen Lei wrote:
> Currently we traverse all symbols of all modules to find the specified
> function for the specified module. But in reality, we just need to find
> the given module and then traverse all the symbols in it.
> 
> Let's add a new parameter 'const char *modname' to function
> module_kallsyms_on_each_symbol(), then we can compare the module names
> directly in this function and call hook 'fn' after matching. If 'modname'
> is NULL, the symbols of all modules are still traversed for compatibility
> with other usage cases.
> 
> Phase1: mod1-->mod2..(subsequent modules do not need to be compared)
>                 |
> Phase2:          -->f1-->f2-->f3
> 
> Assuming that there are m modules, each module has n symbols on average,
> then the time complexity is reduced from O(m * n) to O(m) + O(n).
> 
> Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>

Looks good to me:

Reviewed-by: Petr Mladek <pmladek@suse.com>

Best Regards,
Petr
