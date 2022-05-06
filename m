Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 807EF51D375
	for <lists+live-patching@lfdr.de>; Fri,  6 May 2022 10:35:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244737AbiEFIiq (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 6 May 2022 04:38:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1390172AbiEFIin (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 6 May 2022 04:38:43 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 598E862BF1;
        Fri,  6 May 2022 01:35:01 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id AB3B021A63;
        Fri,  6 May 2022 08:34:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1651826099; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=E8fz2Qj+5LloVB8vVJMGmoituacjkJeR6Cyj3S17Ync=;
        b=kdq0pyczu0FGQoWPRbX1YpR0o5BSPmfjwNvpAxR1AlStsynwpp7SB/tNoYJxLftFy/aiUv
        TZXJf8hGYPOFT/rqwaq/jR8vnukH8M+voTZMHiaqCo+4BZBydvA2Tph0SGDOBhQj3nX2Vs
        RrOb1FgrjYdDKxGn/SJkjE9UrMN8MUY=
Received: from suse.cz (unknown [10.100.201.202])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id C16E32C142;
        Fri,  6 May 2022 08:34:58 +0000 (UTC)
Date:   Fri, 6 May 2022 10:34:58 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     Miguel Ojeda <ojeda@kernel.org>
Cc:     Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        Helge Deller <deller@gmx.de>,
        Stephen Boyd <swboyd@chromium.org>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Changbin Du <changbin.du@intel.com>,
        Nathan Chancellor <nathan@kernel.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Andi Kleen <ak@linux.intel.com>,
        Kees Cook <keescook@chromium.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        linux-perf-users@vger.kernel.org, rust-for-linux@vger.kernel.org,
        Alex Gaynor <alex.gaynor@gmail.com>,
        Wedson Almeida Filho <wedsonaf@google.com>,
        Gary Guo <gary@garyguo.net>, Boqun Feng <boqun.feng@gmail.com>
Subject: Re: [PATCH v1 3/3] kallsyms: increase maximum kernel symbol length
 to 512
Message-ID: <YnTdslR0jhUNo0lu@alley>
References: <20220505191704.22812-1-ojeda@kernel.org>
 <20220505191704.22812-4-ojeda@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220505191704.22812-4-ojeda@kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu 2022-05-05 21:16:45, Miguel Ojeda wrote:
> Rust symbols can become quite long due to namespacing introduced
> by modules, types, traits, generics, etc. For instance,
> the following code:
> 
>     pub mod my_module {
>         pub struct MyType;
>         pub struct MyGenericType<T>(T);
> 
>         pub trait MyTrait {
>             fn my_method() -> u32;
>         }
> 
>         impl MyTrait for MyGenericType<MyType> {
>             fn my_method() -> u32 {
>                 42
>             }
>         }
>     }
> 
> generates a symbol of length 96 when using the upcoming v0 mangling scheme:
> 
>     _RNvXNtCshGpAVYOtgW1_7example9my_moduleINtB2_13MyGenericTypeNtB2_6MyTypeENtB2_7MyTrait9my_method
> 
> At the moment, Rust symbols may reach up to 300 in length.
> Setting 512 as the maximum seems like a reasonable choice to
> keep some headroom.
> 
> Co-developed-by: Alex Gaynor <alex.gaynor@gmail.com>
> Signed-off-by: Alex Gaynor <alex.gaynor@gmail.com>
> Co-developed-by: Wedson Almeida Filho <wedsonaf@google.com>
> Signed-off-by: Wedson Almeida Filho <wedsonaf@google.com>
> Co-developed-by: Gary Guo <gary@garyguo.net>
> Signed-off-by: Gary Guo <gary@garyguo.net>
> Co-developed-by: Boqun Feng <boqun.feng@gmail.com>
> Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

I was primary interested into the livepatching code.
But the entire patch looks good:

Reviewed-by: Petr Mladek <pmladek@suse.com>

I just hope that it will not cause stack overflows
somewhere.

Best Regards,
Petr
