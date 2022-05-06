Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03BBB51D506
	for <lists+live-patching@lfdr.de>; Fri,  6 May 2022 11:56:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349344AbiEFJ7n (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 6 May 2022 05:59:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236473AbiEFJ7l (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 6 May 2022 05:59:41 -0400
X-Greylist: delayed 433 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 06 May 2022 02:55:57 PDT
Received: from rosa.stappers.it (rosa.stappers.it [77.72.145.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5E3B24754F;
        Fri,  6 May 2022 02:55:56 -0700 (PDT)
Received: by rosa.stappers.it (Postfix, from userid 1000)
        id 5B06F2014; Fri,  6 May 2022 11:45:36 +0200 (CEST)
Date:   Fri, 6 May 2022 11:45:36 +0200
From:   Geert Stappers <stappers@stappers.nl>
To:     Miguel Ojeda <ojeda@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
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
Message-ID: <20220506094536.GL1551@rosa.stappers.it>
References: <20220505191704.22812-1-ojeda@kernel.org>
 <20220505191704.22812-4-ojeda@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220505191704.22812-4-ojeda@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu, May 05, 2022 at 09:16:45PM +0200, Miguel Ojeda wrote:
> 
> generates a symbol of length 96 when using the upcoming v0 mangling scheme:
> 
>     _RNvXNtCshGpAVYOtgW1_7example9my_moduleINtB2_13MyGenericTypeNtB2_6MyTypeENtB2_7MyTrait9my_method
> 
> At the moment, Rust symbols may reach up to 300 in length.
> Setting 512 as the maximum seems like a reasonable choice to
> keep some headroom.
> 
> diff --git a/include/linux/kallsyms.h b/include/linux/kallsyms.h
> index ce1bd2fbf23e..e5ad6e31697d 100644
> --- a/include/linux/kallsyms.h
> +++ b/include/linux/kallsyms.h
> @@ -15,7 +15,7 @@
>  
>  #include <asm/sections.h>
>  
> -#define KSYM_NAME_LEN 128
> +#define KSYM_NAME_LEN 512

multiplication factor is four


> --- a/kernel/livepatch/core.c
> +++ b/kernel/livepatch/core.c
> @@ -213,7 +213,7 @@ static int klp_resolve_symbols(Elf_Shdr *sechdrs, const char *strtab,
>  	 * we use the smallest/strictest upper bound possible (56, based on
>  	 * the current definition of MODULE_NAME_LEN) to prevent overflows.
>  	 */
> -	BUILD_BUG_ON(MODULE_NAME_LEN < 56 || KSYM_NAME_LEN != 128);
> +	BUILD_BUG_ON(MODULE_NAME_LEN < 56 || KSYM_NAME_LEN != 512);

factor four


> @@ -227,7 +227,7 @@ static int klp_resolve_symbols(Elf_Shdr *sechdrs, const char *strtab,
>  
>  		/* Format: .klp.sym.sym_objname.sym_name,sympos */
>  		cnt = sscanf(strtab + sym->st_name,
> -			     ".klp.sym.%55[^.].%127[^,],%lu",
> +			     ".klp.sym.%55[^.].%511[^,],%lu",

4 * ( 127 + 1 )  =  511 + 1


> --- a/scripts/kallsyms.c
> +++ b/scripts/kallsyms.c
> @@ -30,10 +30,10 @@
>  #define _stringify_1(x)	#x
>  #define _stringify(x)	_stringify_1(x)
>  
> -#define KSYM_NAME_LEN		128
> +#define KSYM_NAME_LEN		512

factor four


> --- a/tools/include/linux/kallsyms.h
> +++ b/tools/include/linux/kallsyms.h
> @@ -6,7 +6,7 @@
>  #include <stdio.h>
>  #include <unistd.h>
>  
> -#define KSYM_NAME_LEN 128
> +#define KSYM_NAME_LEN 512

factor four


> --- a/tools/lib/perf/include/perf/event.h
> +++ b/tools/lib/perf/include/perf/event.h
> @@ -95,7 +95,7 @@ struct perf_record_throttle {
>  };
>  
>  #ifndef KSYM_NAME_LEN
> -#define KSYM_NAME_LEN 256
> +#define KSYM_NAME_LEN 512

Here is the multiplication factor  two.


> --- a/tools/lib/symbol/kallsyms.h
> +++ b/tools/lib/symbol/kallsyms.h
> @@ -7,7 +7,7 @@
>  #include <linux/types.h>
>  
>  #ifndef KSYM_NAME_LEN
> -#define KSYM_NAME_LEN 256
> +#define KSYM_NAME_LEN 512

Another  "factor two"



It feels good to unify all the KSYM_NAME_LEN to 512.

Thing that feels less good is doubling 256 versus quadrupling 128.

I felt the need to report that.


Feel free to ignore this remark.



Groeten
Geert Stappers
-- 
Silence is hard to parse
