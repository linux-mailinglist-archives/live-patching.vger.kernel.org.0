Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7CA76627A7
	for <lists+live-patching@lfdr.de>; Mon,  9 Jan 2023 14:49:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234756AbjAINs6 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 9 Jan 2023 08:48:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237087AbjAINso (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 9 Jan 2023 08:48:44 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BD9E1EECC;
        Mon,  9 Jan 2023 05:48:43 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id ay12-20020a05600c1e0c00b003d9ea12bafcso3658721wmb.3;
        Mon, 09 Jan 2023 05:48:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=sjM8hOV94cypu49wh5dstQmAlWS++C//GRjTU4M89js=;
        b=kuF0jPfU1UAscJ/zjoV4o3aiOyJLdHX8uCTjK8Y3fTHphmKuozDbGagrYmLT3cRScU
         UHfV4CZnHOHXDIqslfQNrQ24aVJBjA8OGcDD2Ga0FxfOAE1USvznKgqLGFyKgOnaEl1N
         piLhdt3d46Gnc25HPCt8Nv//q5Pi64evsmTyjTl3hguDqAhrpYg7hLyLvS83tiPm3NgU
         jiJXcFkxJ5jEZ9fnnRhoum2vQAOFIfKonm70FVb/lEm9GDpl3FPMwb/9E69tDxuR73DC
         2nrhjNQc22VSchGsdm/gDvllkeUdGF8rY5QLjjCZsidONJ8KzmNIjGVhJpDkV7InQwR5
         xahQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sjM8hOV94cypu49wh5dstQmAlWS++C//GRjTU4M89js=;
        b=iDqGKmRQ8tIqMPb7sRewaxbf3KWuzy+Nl0+ofMy/iHNctPvPz7UAzSKTIXjBlL6KpY
         S1fFVahqgrn0/gC72XXMA+AIy4sP4xySIgsFEUYweR8H9S49C9tbiTm4cbEmvOaEZ9sD
         HsmzYtU+3GVXpm6r+Anac2+JcWpwVdN0ZzOj/Rwz45GCWuPFKW8nIkxqORnhf34O6Zk7
         ltYkzUhiRx2d81+EAGviHeb+NxBIw68oCDHjdiz0mc8I6ZygAAZYnaN7n0POMxWgvhF1
         llP6j9l34Z4B5xlu2TDFRt1U+Xk3GicJE0XuSvX0RRekL2AigiUgnF4e0nCvMnYJWvTH
         7S0w==
X-Gm-Message-State: AFqh2krkjbVrlDhwyOUO5QTc1t3IiVaepAOnLcfSmGYzSiCfOzCCcOnd
        qpL6VCh3RK1m1d8zzyiLdZs=
X-Google-Smtp-Source: AMrXdXt0DAoCSuzsNaAgux29pMWEu5IX5Y7NgvCBZaVgMQKZl1rKa1+RRfp3V+X3kTpEb2gF5gwWXg==
X-Received: by 2002:a1c:4c12:0:b0:3c6:e63e:89a6 with SMTP id z18-20020a1c4c12000000b003c6e63e89a6mr46312893wmf.2.1673272121828;
        Mon, 09 Jan 2023 05:48:41 -0800 (PST)
Received: from krava (2001-1ae9-1c2-4c00-726e-c10f-8833-ff22.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:726e:c10f:8833:ff22])
        by smtp.gmail.com with ESMTPSA id o5-20020a05600c510500b003b4ff30e566sm25387847wms.3.2023.01.09.05.48.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Jan 2023 05:48:40 -0800 (PST)
From:   Jiri Olsa <olsajiri@gmail.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
Date:   Mon, 9 Jan 2023 14:48:38 +0100
To:     "Leizhen (ThunderTown)" <thunder.leizhen@huawei.com>
Cc:     Jiri Olsa <olsajiri@gmail.com>, Petr Mladek <pmladek@suse.com>,
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
Message-ID: <Y7wbNinAXM6O62ZF@krava>
References: <20221230112729.351-1-thunder.leizhen@huawei.com>
 <20221230112729.351-3-thunder.leizhen@huawei.com>
 <Y7WoZARt37xGpjXD@alley>
 <Y7dBoII5kZnHGFdL@krava>
 <Y7ftxIiV35Wd75lZ@krava>
 <652e0eea-1ab2-a4fd-151a-e634bcb4e1da@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <652e0eea-1ab2-a4fd-151a-e634bcb4e1da@huawei.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Mon, Jan 09, 2023 at 04:51:37PM +0800, Leizhen (ThunderTown) wrote:
> 
> 
> On 2023/1/6 17:45, Jiri Olsa wrote:
> > On Thu, Jan 05, 2023 at 10:31:12PM +0100, Jiri Olsa wrote:
> >> On Wed, Jan 04, 2023 at 05:25:08PM +0100, Petr Mladek wrote:
> >>> On Fri 2022-12-30 19:27:28, Zhen Lei wrote:
> >>>> Function __module_address() can quickly return the pointer of the module
> >>>> to which an address belongs. We do not need to traverse the symbols of all
> >>>> modules to check whether each address in addrs[] is the start address of
> >>>> the corresponding symbol, because register_fprobe_ips() will do this check
> >>>> later.
> >>
> >> hum, for some reason I can see only replies to this patch and
> >> not the actual patch.. I'll dig it out of the lore I guess
> >>
> >>>>
> >>>> Assuming that there are m modules, each module has n symbols on average,
> >>>> and the number of addresses 'addrs_cnt' is abbreviated as K. Then the time
> >>>> complexity of the original method is O(K * log(K)) + O(m * n * log(K)),
> >>>> and the time complexity of current method is O(K * (log(m) + M)), M <= m.
> >>>> (m * n * log(K)) / (K * m) ==> n / log2(K). Even if n is 10 and K is 128,
> >>>> the ratio is still greater than 1. Therefore, the new method will
> >>>> generally have better performance.
> >>
> >> could you try to benchmark that? I tried something similar but was not
> >> able to get better performance
> > 
> > hm looks like I tried the smilar thing (below) like you did,
> 
> Yes. I just found out you're working on this improvement, too.
> 
> > but wasn't able to get better performace
> 
> Your implementation below is already the limit that can be optimized.
> If the performance is not improved, it indicates that this place is
> not the bottleneck.
> 
> > 
> > I guess your goal is to get rid of the module arg in
> > module_kallsyms_on_each_symbol callback that we use?
> 
> It's not a bad thing to keep argument 'mod' for function
> module_kallsyms_on_each_symbol(), but for kallsyms_on_each_symbol(),
> it's completely redundant. Now these two functions often use the
> same hook function. So I carefully analyzed get_modules_for_addrs(),
> which is the only place that involves the use of parameter 'mod'.
> Looks like there's a possibility of eliminating parameter 'mod'.
> 
> > I'm ok with the change if the performace is not worse
> 
> OK, thanks.
> 
> > 
> > jirka
> > 
> > 
> > ---
> > diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> > index 5b9008bc597b..3280c22009f1 100644
> > --- a/kernel/trace/bpf_trace.c
> > +++ b/kernel/trace/bpf_trace.c
> > @@ -2692,23 +2692,16 @@ struct module_addr_args {
> >  	int mods_cap;
> >  };
> >  
> > -static int module_callback(void *data, const char *name,
> > -			   struct module *mod, unsigned long addr)
> > +static int add_module(struct module_addr_args *args, struct module *mod)
> >  {
> > -	struct module_addr_args *args = data;
> >  	struct module **mods;
> >  
> > -	/* We iterate all modules symbols and for each we:
> > -	 * - search for it in provided addresses array
> > -	 * - if found we check if we already have the module pointer stored
> > -	 *   (we iterate modules sequentially, so we can check just the last
> > -	 *   module pointer)
> > +	/* We iterate sorted addresses and for each within module we:
> > +	 * - check if we already have the module pointer stored for it
> > +	 *   (we iterate sorted addresses sequentially, so we can check
> > +	 *   just the last module pointer)
> >  	 * - take module reference and store it
> >  	 */
> > -	if (!bsearch(&addr, args->addrs, args->addrs_cnt, sizeof(addr),
> > -		       bpf_kprobe_multi_addrs_cmp))
> > -		return 0;
> > -
> >  	if (args->mods && args->mods[args->mods_cnt - 1] == mod)
> >  		return 0;
> 
> There'll be problems Petr mentioned.
> 
> https://lkml.org/lkml/2023/1/5/191

ok, makes sense.. I guess we could just search args->mods in here?
are you going to send new version, or should I update my patch with that?

thanks,
jirka
