Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05FD9671F87
	for <lists+live-patching@lfdr.de>; Wed, 18 Jan 2023 15:26:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231178AbjARO0p (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 18 Jan 2023 09:26:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231239AbjARO02 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 18 Jan 2023 09:26:28 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CD2F302A8;
        Wed, 18 Jan 2023 06:10:35 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id BD0193EF47;
        Wed, 18 Jan 2023 14:10:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1674051033; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GGYhHqk9lAfnC0oeawDzo48jNfxg1s75ZFbKqNg+POw=;
        b=OVjneds/B14mHveueZZ//I+0ccc7E/FG+o+Z/xavu7kdORWyymsAQ4k5ZRUMlTdzqy9Gtd
        Ck4aM3Jh/AQmgwjPBpNTMVJQj3rJNEmf/3S/7zBfWZZwkjwMjDbafT8s8Y5bNHmltmG0hv
        1rusI+rrQ37oKvcuNeAaJEq/XblG+oQ=
Received: from suse.cz (unknown [10.100.201.202])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 032772C141;
        Wed, 18 Jan 2023 14:10:33 +0000 (UTC)
Date:   Wed, 18 Jan 2023 15:10:32 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Zhen Lei <thunder.leizhen@huawei.com>, bpf@vger.kernel.org,
        live-patching@vger.kernel.org, linux-modules@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Luis Chamberlain <mcgrof@kernel.org>
Subject: Re: [PATCHv3 bpf-next 3/3] bpf: Change modules resolving for kprobe
 multi link
Message-ID: <Y8f92N1AjLM0hYis@alley>
References: <20230116101009.23694-1-jolsa@kernel.org>
 <20230116101009.23694-4-jolsa@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230116101009.23694-4-jolsa@kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Mon 2023-01-16 11:10:09, Jiri Olsa wrote:
> We currently use module_kallsyms_on_each_symbol that iterates all
> modules/symbols and we try to lookup each such address in user
> provided symbols/addresses to get list of used modules.
> 
> This fix instead only iterates provided kprobe addresses and calls
> __module_address on each to get list of used modules. This turned
> out ot be simpler and also bit faster.
> 
> On my setup with workload (executed 10 times):
> 
>    # test_progs -t kprobe_multi_bench_attach/modules
> 
> Current code:
> 
>  Performance counter stats for './test.sh' (5 runs):
> 
>     76,081,161,596      cycles:k                   ( +-  0.47% )
> 
>            18.3867 +- 0.0992 seconds time elapsed  ( +-  0.54% )
> 
> With the fix:
> 
>  Performance counter stats for './test.sh' (5 runs):
> 
>     74,079,889,063      cycles:k                   ( +-  0.04% )
> 
>            17.8514 +- 0.0218 seconds time elapsed  ( +-  0.12% )
> 
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>

The change looks good to me:

Reviewed-by: Petr Mladek <pmladek@suse.com>

Best Regards,
Petr
