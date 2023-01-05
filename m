Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9FB665F5D6
	for <lists+live-patching@lfdr.de>; Thu,  5 Jan 2023 22:32:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235873AbjAEVba (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 5 Jan 2023 16:31:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236000AbjAEVbT (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 5 Jan 2023 16:31:19 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F36E8671BC;
        Thu,  5 Jan 2023 13:31:16 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id x22so92966227ejs.11;
        Thu, 05 Jan 2023 13:31:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=B+QbiATlPmFrXKy6nPSw6HbywpLiFa74L0gMt+w3HXo=;
        b=qj5/VhmYMrx458qhW1RtbNfzF0pB8bER0AZvKuyMddO0TpwpwBvdL+Vfwjn3QpYy0m
         kMKAgUIU5H69cZuJsR0Vu49tuI4u0O9K5b8/BP7qnniAyJh/zDyxsEAZiycNAkkAcyM4
         IsLFhHauY6y127jhEykj04Eyx4ngJ10p1DOGx/aCUSz+Ky8KRhNbKjJ3gPGe0nFB1U4l
         clBUPbVzfS6+dqMd3NrdxXpQbaMkuFUjYaFX99bb0G4VcQr7giqoXp3Wp0wq6MzNzHtc
         TxsPE8x+OD8/d9CknHeaGY2nJCKl3XVh5+/FRCuIVEwZ0xj240JL9dblYgXT0jqaLWfU
         fSsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=B+QbiATlPmFrXKy6nPSw6HbywpLiFa74L0gMt+w3HXo=;
        b=R9ki2ue50att5qkHJlKWJUqLzZcymcXIQPS3Sddy9aKMHTbm0P2+B6ZeQkkVTcLRsF
         Vu4zr6uVR9xNn1409KIzrLMUqOApgIzkcSsKoyPPs1Btr3tuDiyP/orRFsSUTe6b6HYO
         Mno1Fd5z9hZUn0cczGcXzwwK/pB4y9qrpmmZaDkwPP1JlR19D9v9Ze+PiTC3i9sIbikk
         wPLLqekJk3/m4x+Zyy6ANJ7lltzmt5Fb469CZt0IR77pXAkRAwKvcvBKDlyGpAIKCBQj
         GYwRoU2pM2iHtRyQU7vwblUEcvVlZP5Nw9mxJuKNP7c+x7PAHYNpS2R0eUghjE3Gh77N
         gBgw==
X-Gm-Message-State: AFqh2kpb5QAezeD3vjTrHlxbhX5Gj6fUgI9YvSMSXL3Vmz9O06ueMnQq
        oz23IHOR1lCjSbaxHilpzh4=
X-Google-Smtp-Source: AMrXdXvmYnINBuJQtPtPn2mLwtnU7N1wi8jwfdQij6aIk7h717hh+mc372S1TYy8rTIjNfVAJrntuw==
X-Received: by 2002:a17:907:3ea1:b0:7c1:7f84:10ac with SMTP id hs33-20020a1709073ea100b007c17f8410acmr76492493ejc.33.1672954275287;
        Thu, 05 Jan 2023 13:31:15 -0800 (PST)
Received: from krava ([83.240.63.194])
        by smtp.gmail.com with ESMTPSA id o21-20020a170906769500b007b935641971sm16698031ejm.5.2023.01.05.13.31.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Jan 2023 13:31:14 -0800 (PST)
From:   Jiri Olsa <olsajiri@gmail.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
Date:   Thu, 5 Jan 2023 22:31:12 +0100
To:     Zhen Lei <thunder.leizhen@huawei.com>
Cc:     Petr Mladek <pmladek@suse.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
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
        Hao Luo <haoluo@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>, bpf@vger.kernel.org,
        linux-trace-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        linux-kernel@vger.kernel.org, Luis Chamberlain <mcgrof@kernel.org>,
        linux-modules@vger.kernel.org
Subject: Re: [PATCH 2/3] bpf: Optimize get_modules_for_addrs()
Message-ID: <Y7dBoII5kZnHGFdL@krava>
References: <20221230112729.351-1-thunder.leizhen@huawei.com>
 <20221230112729.351-3-thunder.leizhen@huawei.com>
 <Y7WoZARt37xGpjXD@alley>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y7WoZARt37xGpjXD@alley>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, Jan 04, 2023 at 05:25:08PM +0100, Petr Mladek wrote:
> On Fri 2022-12-30 19:27:28, Zhen Lei wrote:
> > Function __module_address() can quickly return the pointer of the module
> > to which an address belongs. We do not need to traverse the symbols of all
> > modules to check whether each address in addrs[] is the start address of
> > the corresponding symbol, because register_fprobe_ips() will do this check
> > later.

hum, for some reason I can see only replies to this patch and
not the actual patch.. I'll dig it out of the lore I guess

> > 
> > Assuming that there are m modules, each module has n symbols on average,
> > and the number of addresses 'addrs_cnt' is abbreviated as K. Then the time
> > complexity of the original method is O(K * log(K)) + O(m * n * log(K)),
> > and the time complexity of current method is O(K * (log(m) + M)), M <= m.
> > (m * n * log(K)) / (K * m) ==> n / log2(K). Even if n is 10 and K is 128,
> > the ratio is still greater than 1. Therefore, the new method will
> > generally have better performance.

could you try to benchmark that? I tried something similar but was not
able to get better performance

I'll review and run my benchmark test tomorrow

thanks,
jirka

> > 
> > Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
> > ---
> >  kernel/trace/bpf_trace.c | 101 ++++++++++++++++-----------------------
> >  1 file changed, 40 insertions(+), 61 deletions(-)
> > 
> > diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> > index 5f3be4bc16403a5..0ff9037098bd241 100644
> > --- a/kernel/trace/bpf_trace.c
> > +++ b/kernel/trace/bpf_trace.c
> > @@ -2684,69 +2684,55 @@ static void symbols_swap_r(void *a, void *b, int size, const void *priv)
> >  	}
> >  }
> >  
> > -struct module_addr_args {
> > -	unsigned long *addrs;
> > -	u32 addrs_cnt;
> > -	struct module **mods;
> > -	int mods_cnt;
> > -	int mods_cap;
> > -};
> > -
> > -static int module_callback(void *data, const char *name,
> > -			   struct module *mod, unsigned long addr)
> > +static int get_modules_for_addrs(struct module ***out_mods, unsigned long *addrs, u32 addrs_cnt)
> >  {
> > -	struct module_addr_args *args = data;
> > -	struct module **mods;
> > -
> > -	/* We iterate all modules symbols and for each we:
> > -	 * - search for it in provided addresses array
> > -	 * - if found we check if we already have the module pointer stored
> > -	 *   (we iterate modules sequentially, so we can check just the last
> > -	 *   module pointer)
> > -	 * - take module reference and store it
> > -	 */
> > -	if (!bsearch(&addr, args->addrs, args->addrs_cnt, sizeof(addr),
> > -		       bpf_kprobe_multi_addrs_cmp))
> > -		return 0;
> > +	int i, j, err;
> > +	int mods_cnt = 0;
> > +	int mods_cap = 0;
> > +	struct module *mod;
> > +	struct module **mods = NULL;
> >  
> > -	if (args->mods && args->mods[args->mods_cnt - 1] == mod)
> > -		return 0;
> > +	for (i = 0; i < addrs_cnt; i++) {
> > +		mod = __module_address(addrs[i]);
> 
> This must be called under module_mutex to make sure that the module
> would not disappear.
> 
> > +		if (!mod)
> > +			continue;
> >  
> > -	if (args->mods_cnt == args->mods_cap) {
> > -		args->mods_cap = max(16, args->mods_cap * 3 / 2);
> > -		mods = krealloc_array(args->mods, args->mods_cap, sizeof(*mods), GFP_KERNEL);
> > -		if (!mods)
> > -			return -ENOMEM;
> > -		args->mods = mods;
> > -	}
> > +		/* check if we already have the module pointer stored */
> > +		for (j = 0; j < mods_cnt; j++) {
> > +			if (mods[j] == mod)
> > +				break;
> > +		}
> 
> This might get optimized like the original code.
> 
> My understanding is that the addresses are sorted in "addrs" array.
> So, the address is either part of the last found module or it belongs
> to a completely new module.
> 
> 	for (i = 0; i < addrs_cnt; i++) {
> 		/*
> 		 * The adresses are sorted. The adress either belongs
> 		 * to the last found module or a new one.
> 		 *
> 		 * This is safe because we already have reference
> 		 * on the found modules.
> 		 */
> 		 if (mods_cnt && within_module(addrs[i], mods[mods_cnt - 1]))
> 			continue;
> 
> 		mutex_lock(&module_mutex);
> 		mod = __module_address(addrs[i]);
> 		if (mod && !try_module_get(mod)) {
> 			mutex_unlock(&module_mutex);
> 			goto failed;
> 		}
> 		mutex_unlock(&module_mutex);
> 
> 		/*
> 		 * Nope when the address was not from a module.
> 		 *
> 		 * Is this correct? What if the module has gone in
> 		 * the meantime? Anyway, the original code
> 		 * worked this way.
> 		 *
> 		 * FIXME: I would personally make sure that it is part
> 		 * of vmlinux or so.
> 		 */
> 		if (!mod)
> 			continue;
> 
> 		/* store the module into mods array */
> 		...
> 
> 
> 
> 
> > +		if (j < mods_cnt)
> > +			continue;
> >  
> > -	if (!try_module_get(mod))
> > -		return -EINVAL;
> > +		if (mods_cnt == mods_cap) {
> > +			struct module **new_mods;
> >  
> > -	args->mods[args->mods_cnt] = mod;
> > -	args->mods_cnt++;
> > -	return 0;
> > -}
> > +			mods_cap = max(16, mods_cap * 3 / 2);
> > +			new_mods = krealloc_array(mods, mods_cap, sizeof(*mods), GFP_KERNEL);
> > +			if (!new_mods) {
> > +				err = -ENOMEM;
> > +				goto failed;
> > +			}
> > +			mods = new_mods;
> > +		}
> >  
> > -static int get_modules_for_addrs(struct module ***mods, unsigned long *addrs, u32 addrs_cnt)
> > -{
> > -	struct module_addr_args args = {
> > -		.addrs     = addrs,
> > -		.addrs_cnt = addrs_cnt,
> > -	};
> > -	int err;
> > +		if (!try_module_get(mod)) {
> > +			err = -EINVAL;
> > +			goto failed;
> > +		}
> >  
> > -	/* We return either err < 0 in case of error, ... */
> > -	err = module_kallsyms_on_each_symbol(NULL, module_callback, &args);
> > -	if (err) {
> > -		kprobe_multi_put_modules(args.mods, args.mods_cnt);
> > -		kfree(args.mods);
> > -		return err;
> > +		mods[mods_cnt] = mod;
> > +		mods_cnt++;
> >  	}
> >  
> > -	/* or number of modules found if everything is ok. */
> > -	*mods = args.mods;
> > -	return args.mods_cnt;
> > +	*out_mods = mods;
> > +	return mods_cnt;
> > +
> > +failed:
> > +	kprobe_multi_put_modules(mods, mods_cnt);
> > +	kfree(mods);
> > +	return err;
> >  }
> >  
> >  int bpf_kprobe_multi_link_attach(const union bpf_attr *attr, struct bpf_prog *prog)
> 
> Otherwise, it looks good. IMHO, the new code looks more straightforward
> than the original one.
> 
> Best Regards,
> Petr
