Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10B1165D978
	for <lists+live-patching@lfdr.de>; Wed,  4 Jan 2023 17:26:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239677AbjADQZ5 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 4 Jan 2023 11:25:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240020AbjADQZV (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 4 Jan 2023 11:25:21 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D9EA33D4B;
        Wed,  4 Jan 2023 08:25:11 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 293763FA17;
        Wed,  4 Jan 2023 16:25:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1672849510; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6GQ6UHmHAob56A0XyaQkcaVX94yZAzVcA1wdn/Ca/O0=;
        b=L13945ce5FCvCOYSsZEg3TncOluR7Tk6GFbbmhIFbwbUy5EHY9FfqsOu2+grE5jDpWmOml
        soEp+pk9taMih5G9w8C5rWDIJ3faXGtFVzBv5EIP0WY3OYbZ8ykcyK2fAjeE7DDI5oC8Ty
        FLXoQacpLGZj6m3bFR0DwkYu6rm1d74=
Received: from suse.cz (unknown [10.100.208.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id A0A7C2C141;
        Wed,  4 Jan 2023 16:25:08 +0000 (UTC)
Date:   Wed, 4 Jan 2023 17:25:08 +0100
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
Subject: Re: [PATCH 2/3] bpf: Optimize get_modules_for_addrs()
Message-ID: <Y7WoZARt37xGpjXD@alley>
References: <20221230112729.351-1-thunder.leizhen@huawei.com>
 <20221230112729.351-3-thunder.leizhen@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221230112729.351-3-thunder.leizhen@huawei.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri 2022-12-30 19:27:28, Zhen Lei wrote:
> Function __module_address() can quickly return the pointer of the module
> to which an address belongs. We do not need to traverse the symbols of all
> modules to check whether each address in addrs[] is the start address of
> the corresponding symbol, because register_fprobe_ips() will do this check
> later.
> 
> Assuming that there are m modules, each module has n symbols on average,
> and the number of addresses 'addrs_cnt' is abbreviated as K. Then the time
> complexity of the original method is O(K * log(K)) + O(m * n * log(K)),
> and the time complexity of current method is O(K * (log(m) + M)), M <= m.
> (m * n * log(K)) / (K * m) ==> n / log2(K). Even if n is 10 and K is 128,
> the ratio is still greater than 1. Therefore, the new method will
> generally have better performance.
> 
> Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
> ---
>  kernel/trace/bpf_trace.c | 101 ++++++++++++++++-----------------------
>  1 file changed, 40 insertions(+), 61 deletions(-)
> 
> diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> index 5f3be4bc16403a5..0ff9037098bd241 100644
> --- a/kernel/trace/bpf_trace.c
> +++ b/kernel/trace/bpf_trace.c
> @@ -2684,69 +2684,55 @@ static void symbols_swap_r(void *a, void *b, int size, const void *priv)
>  	}
>  }
>  
> -struct module_addr_args {
> -	unsigned long *addrs;
> -	u32 addrs_cnt;
> -	struct module **mods;
> -	int mods_cnt;
> -	int mods_cap;
> -};
> -
> -static int module_callback(void *data, const char *name,
> -			   struct module *mod, unsigned long addr)
> +static int get_modules_for_addrs(struct module ***out_mods, unsigned long *addrs, u32 addrs_cnt)
>  {
> -	struct module_addr_args *args = data;
> -	struct module **mods;
> -
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
> +	int i, j, err;
> +	int mods_cnt = 0;
> +	int mods_cap = 0;
> +	struct module *mod;
> +	struct module **mods = NULL;
>  
> -	if (args->mods && args->mods[args->mods_cnt - 1] == mod)
> -		return 0;
> +	for (i = 0; i < addrs_cnt; i++) {
> +		mod = __module_address(addrs[i]);

This must be called under module_mutex to make sure that the module
would not disappear.

> +		if (!mod)
> +			continue;
>  
> -	if (args->mods_cnt == args->mods_cap) {
> -		args->mods_cap = max(16, args->mods_cap * 3 / 2);
> -		mods = krealloc_array(args->mods, args->mods_cap, sizeof(*mods), GFP_KERNEL);
> -		if (!mods)
> -			return -ENOMEM;
> -		args->mods = mods;
> -	}
> +		/* check if we already have the module pointer stored */
> +		for (j = 0; j < mods_cnt; j++) {
> +			if (mods[j] == mod)
> +				break;
> +		}

This might get optimized like the original code.

My understanding is that the addresses are sorted in "addrs" array.
So, the address is either part of the last found module or it belongs
to a completely new module.

	for (i = 0; i < addrs_cnt; i++) {
		/*
		 * The adresses are sorted. The adress either belongs
		 * to the last found module or a new one.
		 *
		 * This is safe because we already have reference
		 * on the found modules.
		 */
		 if (mods_cnt && within_module(addrs[i], mods[mods_cnt - 1]))
			continue;

		mutex_lock(&module_mutex);
		mod = __module_address(addrs[i]);
		if (mod && !try_module_get(mod)) {
			mutex_unlock(&module_mutex);
			goto failed;
		}
		mutex_unlock(&module_mutex);

		/*
		 * Nope when the address was not from a module.
		 *
		 * Is this correct? What if the module has gone in
		 * the meantime? Anyway, the original code
		 * worked this way.
		 *
		 * FIXME: I would personally make sure that it is part
		 * of vmlinux or so.
		 */
		if (!mod)
			continue;

		/* store the module into mods array */
		...




> +		if (j < mods_cnt)
> +			continue;
>  
> -	if (!try_module_get(mod))
> -		return -EINVAL;
> +		if (mods_cnt == mods_cap) {
> +			struct module **new_mods;
>  
> -	args->mods[args->mods_cnt] = mod;
> -	args->mods_cnt++;
> -	return 0;
> -}
> +			mods_cap = max(16, mods_cap * 3 / 2);
> +			new_mods = krealloc_array(mods, mods_cap, sizeof(*mods), GFP_KERNEL);
> +			if (!new_mods) {
> +				err = -ENOMEM;
> +				goto failed;
> +			}
> +			mods = new_mods;
> +		}
>  
> -static int get_modules_for_addrs(struct module ***mods, unsigned long *addrs, u32 addrs_cnt)
> -{
> -	struct module_addr_args args = {
> -		.addrs     = addrs,
> -		.addrs_cnt = addrs_cnt,
> -	};
> -	int err;
> +		if (!try_module_get(mod)) {
> +			err = -EINVAL;
> +			goto failed;
> +		}
>  
> -	/* We return either err < 0 in case of error, ... */
> -	err = module_kallsyms_on_each_symbol(NULL, module_callback, &args);
> -	if (err) {
> -		kprobe_multi_put_modules(args.mods, args.mods_cnt);
> -		kfree(args.mods);
> -		return err;
> +		mods[mods_cnt] = mod;
> +		mods_cnt++;
>  	}
>  
> -	/* or number of modules found if everything is ok. */
> -	*mods = args.mods;
> -	return args.mods_cnt;
> +	*out_mods = mods;
> +	return mods_cnt;
> +
> +failed:
> +	kprobe_multi_put_modules(mods, mods_cnt);
> +	kfree(mods);
> +	return err;
>  }
>  
>  int bpf_kprobe_multi_link_attach(const union bpf_attr *attr, struct bpf_prog *prog)

Otherwise, it looks good. IMHO, the new code looks more straightforward
than the original one.

Best Regards,
Petr
