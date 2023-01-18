Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1B146710FF
	for <lists+live-patching@lfdr.de>; Wed, 18 Jan 2023 03:16:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229552AbjARCQp (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 17 Jan 2023 21:16:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229827AbjARCQk (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 17 Jan 2023 21:16:40 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B793C51C66;
        Tue, 17 Jan 2023 18:16:35 -0800 (PST)
Received: from dggpemm500006.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4NxTqd3wWCzJrVT;
        Wed, 18 Jan 2023 10:15:09 +0800 (CST)
Received: from [10.174.178.55] (10.174.178.55) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Wed, 18 Jan 2023 10:16:32 +0800
Subject: Re: [PATCHv3 bpf-next 3/3] bpf: Change modules resolving for kprobe
 multi link
To:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
CC:     <bpf@vger.kernel.org>, <live-patching@vger.kernel.org>,
        <linux-modules@vger.kernel.org>, Martin KaFai Lau <kafai@fb.com>,
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
References: <20230116101009.23694-1-jolsa@kernel.org>
 <20230116101009.23694-4-jolsa@kernel.org>
From:   "Leizhen (ThunderTown)" <thunder.leizhen@huawei.com>
Message-ID: <85fedce4-cd27-02f4-7f8b-7aa7c0fb0780@huawei.com>
Date:   Wed, 18 Jan 2023 10:16:20 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20230116101009.23694-4-jolsa@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.55]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpemm500006.china.huawei.com (7.185.36.236)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



On 2023/1/16 18:10, Jiri Olsa wrote:
> We currently use module_kallsyms_on_each_symbol that iterates all
> modules/symbols and we try to lookup each such address in user
> provided symbols/addresses to get list of used modules.
> 
> This fix instead only iterates provided kprobe addresses and calls
> __module_address on each to get list of used modules. This turned
> out ot be simpler and also bit faster.

ot --> to

Reviewed-by: Zhen Lei <thunder.leizhen@huawei.com>

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
> ---
>  kernel/trace/bpf_trace.c | 93 ++++++++++++++++++++--------------------
>  1 file changed, 47 insertions(+), 46 deletions(-)
> 
> diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> index 095f7f8d34a1..8124f1ad0d4a 100644
> --- a/kernel/trace/bpf_trace.c
> +++ b/kernel/trace/bpf_trace.c
> @@ -2682,69 +2682,77 @@ static void symbols_swap_r(void *a, void *b, int size, const void *priv)
>  	}
>  }
>  
> -struct module_addr_args {
> -	unsigned long *addrs;
> -	u32 addrs_cnt;
> +struct modules_array {
>  	struct module **mods;
>  	int mods_cnt;
>  	int mods_cap;
>  };
>  
> -static int module_callback(void *data, const char *name,
> -			   struct module *mod, unsigned long addr)
> +static int add_module(struct modules_array *arr, struct module *mod)
>  {
> -	struct module_addr_args *args = data;
>  	struct module **mods;
>  
> -	/* We iterate all modules symbols and for each we:
> -	 * - search for it in provided addresses array
> -	 * - if found we check if we already have the module pointer stored
> -	 *   (we iterate modules sequentially, so we can check just the last
> -	 *   module pointer)
> -	 * - take module reference and store it
> -	 */
> -	if (!bsearch(&addr, args->addrs, args->addrs_cnt, sizeof(addr),
> -		       bpf_kprobe_multi_addrs_cmp))
> -		return 0;
> -
> -	if (args->mods && args->mods[args->mods_cnt - 1] == mod)
> -		return 0;
> -
> -	if (args->mods_cnt == args->mods_cap) {
> -		args->mods_cap = max(16, args->mods_cap * 3 / 2);
> -		mods = krealloc_array(args->mods, args->mods_cap, sizeof(*mods), GFP_KERNEL);
> +	if (arr->mods_cnt == arr->mods_cap) {
> +		arr->mods_cap = max(16, arr->mods_cap * 3 / 2);
> +		mods = krealloc_array(arr->mods, arr->mods_cap, sizeof(*mods), GFP_KERNEL);
>  		if (!mods)
>  			return -ENOMEM;
> -		args->mods = mods;
> +		arr->mods = mods;
>  	}
>  
> -	if (!try_module_get(mod))
> -		return -EINVAL;
> -
> -	args->mods[args->mods_cnt] = mod;
> -	args->mods_cnt++;
> +	arr->mods[arr->mods_cnt] = mod;
> +	arr->mods_cnt++;
>  	return 0;
>  }
>  
> +static bool has_module(struct modules_array *arr, struct module *mod)
> +{
> +	int i;
> +
> +	for (i = arr->mods_cnt - 1; i >= 0; i--) {
> +		if (arr->mods[i] == mod)
> +			return true;
> +	}
> +	return false;
> +}
> +
>  static int get_modules_for_addrs(struct module ***mods, unsigned long *addrs, u32 addrs_cnt)
>  {
> -	struct module_addr_args args = {
> -		.addrs     = addrs,
> -		.addrs_cnt = addrs_cnt,
> -	};
> -	int err;
> +	struct modules_array arr = {};
> +	u32 i, err = 0;
> +
> +	for (i = 0; i < addrs_cnt; i++) {
> +		struct module *mod;
> +
> +		preempt_disable();
> +		mod = __module_address(addrs[i]);
> +		/* Either no module or we it's already stored  */
> +		if (!mod || has_module(&arr, mod)) {
> +			preempt_enable();
> +			continue;
> +		}
> +		if (!try_module_get(mod))
> +			err = -EINVAL;
> +		preempt_enable();
> +		if (err)
> +			break;
> +		err = add_module(&arr, mod);
> +		if (err) {
> +			module_put(mod);
> +			break;
> +		}
> +	}
>  
>  	/* We return either err < 0 in case of error, ... */
> -	err = module_kallsyms_on_each_symbol(NULL, module_callback, &args);
>  	if (err) {
> -		kprobe_multi_put_modules(args.mods, args.mods_cnt);
> -		kfree(args.mods);
> +		kprobe_multi_put_modules(arr.mods, arr.mods_cnt);
> +		kfree(arr.mods);
>  		return err;
>  	}
>  
>  	/* or number of modules found if everything is ok. */
> -	*mods = args.mods;
> -	return args.mods_cnt;
> +	*mods = arr.mods;
> +	return arr.mods_cnt;
>  }
>  
>  int bpf_kprobe_multi_link_attach(const union bpf_attr *attr, struct bpf_prog *prog)
> @@ -2857,13 +2865,6 @@ int bpf_kprobe_multi_link_attach(const union bpf_attr *attr, struct bpf_prog *pr
>  		       bpf_kprobe_multi_cookie_cmp,
>  		       bpf_kprobe_multi_cookie_swap,
>  		       link);
> -	} else {
> -		/*
> -		 * We need to sort addrs array even if there are no cookies
> -		 * provided, to allow bsearch in get_modules_for_addrs.
> -		 */
> -		sort(addrs, cnt, sizeof(*addrs),
> -		       bpf_kprobe_multi_addrs_cmp, NULL);
>  	}
>  
>  	err = get_modules_for_addrs(&link->mods, addrs, cnt);
> 

-- 
Regards,
  Zhen Lei
