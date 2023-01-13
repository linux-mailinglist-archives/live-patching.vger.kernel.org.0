Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D45E66A5D8
	for <lists+live-patching@lfdr.de>; Fri, 13 Jan 2023 23:22:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229809AbjAMWWW (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 13 Jan 2023 17:22:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231156AbjAMWWT (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 13 Jan 2023 17:22:19 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F1D878267;
        Fri, 13 Jan 2023 14:22:13 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id m8-20020a05600c3b0800b003d96f801c48so19683349wms.0;
        Fri, 13 Jan 2023 14:22:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=GsuvRKq/ddzaAr5BJSuR5oB3yzmHplRSqMG3aMHnPnw=;
        b=jnnnXt/36KYz93GWmlVXAOHK9zepTaPfaRdFO7pLD3FKrVrAMe+EE3kATU1lKLeEdP
         4vWoP0+McYXoMjKFZug7bKCj011NK3Hyn6dhB9ZekFpTDsX8Dzk1YjeUjenMW4VMstqn
         Cr0zljZhIv5cusAzl8/IpMVxrrOxkwrItI6jYDpVasLR+QnFOuD4ECHHZJo/Sq9VMuGm
         HdN9DEMOZPpQCQXqbM9fQRWk38IUkm+abpkpBAZZMm0hy7+K5tJqXeY24SdsDLgAD5qu
         0o0fnwIAcRBN47h4VwhfXF4PfkDUGEvx3pfsfl3oEneWr3RJYY4cLCpurHQNgry79Z2Y
         OnWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GsuvRKq/ddzaAr5BJSuR5oB3yzmHplRSqMG3aMHnPnw=;
        b=U2uMXs+FAVX3gMgon1WJPSBX0ExLhCF+s5hNWTJJK1iuIqffEF1MJUyDaxzx4KB/zl
         Nie0dg+2Me5qE4p5IY7TmWbwA1iA4jOaeieuowHgggccdxNQnM0ZF47TSf68Scn/KnOq
         AQ5nmZ/cGJWgffJuRtMgl1Kgo27LD9Agtl7mqegeZo32IlIKFsWbRewSAO3YmM2qSxnJ
         jH3QIdOSFEGg6aJk6FJ/9t2n1paVY4mAWvgEcLYOUD6WMuCyRH5Iy4w5PwIMeFA7uG0y
         kMmMn0YH2eMfwmwAknAyd2MEmQ5/z/IN619Q45Y2cdNrLJsa2Ny87hOQe4iDsgt2BlzI
         Fo2g==
X-Gm-Message-State: AFqh2kpWZf5CkiCH6g+fbk4YlYzaV1REn7sEAYx39PTlBsyzY1zqV07C
        mrMkVNKWhzE8pjMmxLubf/xHXaKJELZqhQ==
X-Google-Smtp-Source: AMrXdXv9jRP6UUbvl8BxrNGukcnlbsi1oBUphuRUkDcG60sPqPasf24NH2IySiksUAJIk1r8SopzRg==
X-Received: by 2002:a1c:f607:0:b0:3d3:5027:89a4 with SMTP id w7-20020a1cf607000000b003d3502789a4mr1025407wmc.7.1673648531469;
        Fri, 13 Jan 2023 14:22:11 -0800 (PST)
Received: from krava ([83.240.61.245])
        by smtp.gmail.com with ESMTPSA id f19-20020a1c6a13000000b003d9fb04f658sm12038188wmc.4.2023.01.13.14.22.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Jan 2023 14:22:10 -0800 (PST)
From:   Jiri Olsa <olsajiri@gmail.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
Date:   Fri, 13 Jan 2023 23:22:08 +0100
To:     Song Liu <song@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
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
Subject: Re: [PATCHv2 bpf-next 3/3] bpf: Change modules resolving for kprobe
 multi link
Message-ID: <Y8HZkKmJyT6dgYKS@krava>
References: <20230113143303.867580-1-jolsa@kernel.org>
 <20230113143303.867580-4-jolsa@kernel.org>
 <CAPhsuW5uHZxuhpEZ-_r8piRwUykx4+f9eumw8L8hqdAhmi5CvQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPhsuW5uHZxuhpEZ-_r8piRwUykx4+f9eumw8L8hqdAhmi5CvQ@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri, Jan 13, 2023 at 12:41:50PM -0800, Song Liu wrote:
> On Fri, Jan 13, 2023 at 6:44 AM Jiri Olsa <jolsa@kernel.org> wrote:
> >
> > We currently use module_kallsyms_on_each_symbol that iterates all
> > modules/symbols and we try to lookup each such address in user
> > provided symbols/addresses to get list of used modules.
> >
> > This fix instead only iterates provided kprobe addresses and calls
> > __module_address on each to get list of used modules. This turned
> > out to be simpler and also bit faster.
> >
> > On my setup with workload being (executed 10 times):
> >
> >    # test_progs -t kprobe_multi_bench_attach_module
> >
> > Current code:
> >
> >  Performance counter stats for './test.sh' (5 runs):
> >
> >     76,081,161,596      cycles:k                   ( +-  0.47% )
> >
> >            18.3867 +- 0.0992 seconds time elapsed  ( +-  0.54% )
> >
> > With the fix:
> >
> >  Performance counter stats for './test.sh' (5 runs):
> >
> >     74,079,889,063      cycles:k                   ( +-  0.04% )
> >
> >            17.8514 +- 0.0218 seconds time elapsed  ( +-  0.12% )
> >
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > ---
> >  kernel/trace/bpf_trace.c | 95 +++++++++++++++++++++-------------------
> >  1 file changed, 49 insertions(+), 46 deletions(-)
> >
> > diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> > index 095f7f8d34a1..90c5d5026831 100644
> > --- a/kernel/trace/bpf_trace.c
> > +++ b/kernel/trace/bpf_trace.c
> > @@ -2682,69 +2682,79 @@ static void symbols_swap_r(void *a, void *b, int size, const void *priv)
> >         }
> >  }
> >
> > -struct module_addr_args {
> > -       unsigned long *addrs;
> > -       u32 addrs_cnt;
> > +struct modules_array {
> >         struct module **mods;
> >         int mods_cnt;
> >         int mods_cap;
> >  };
> >
> > -static int module_callback(void *data, const char *name,
> > -                          struct module *mod, unsigned long addr)
> > +static int add_module(struct modules_array *arr, struct module *mod)
> >  {
> > -       struct module_addr_args *args = data;
> >         struct module **mods;
> >
> > -       /* We iterate all modules symbols and for each we:
> > -        * - search for it in provided addresses array
> > -        * - if found we check if we already have the module pointer stored
> > -        *   (we iterate modules sequentially, so we can check just the last
> > -        *   module pointer)
> > -        * - take module reference and store it
> > -        */
> > -       if (!bsearch(&addr, args->addrs, args->addrs_cnt, sizeof(addr),
> > -                      bpf_kprobe_multi_addrs_cmp))
> > -               return 0;
> > -
> > -       if (args->mods && args->mods[args->mods_cnt - 1] == mod)
> > -               return 0;
> > -
> > -       if (args->mods_cnt == args->mods_cap) {
> > -               args->mods_cap = max(16, args->mods_cap * 3 / 2);
> > -               mods = krealloc_array(args->mods, args->mods_cap, sizeof(*mods), GFP_KERNEL);
> > +       if (arr->mods_cnt == arr->mods_cap) {
> > +               arr->mods_cap = max(16, arr->mods_cap * 3 / 2);
> > +               mods = krealloc_array(arr->mods, arr->mods_cap, sizeof(*mods), GFP_KERNEL);
> >                 if (!mods)
> >                         return -ENOMEM;
> > -               args->mods = mods;
> > +               arr->mods = mods;
> >         }
> >
> > -       if (!try_module_get(mod))
> > -               return -EINVAL;
> > -
> > -       args->mods[args->mods_cnt] = mod;
> > -       args->mods_cnt++;
> > +       arr->mods[arr->mods_cnt] = mod;
> > +       arr->mods_cnt++;
> >         return 0;
> >  }
> >
> > +static bool has_module(struct modules_array *arr, struct module *mod)
> > +{
> > +       int i;
> > +
> > +       if (!arr->mods)
> > +               return false;
> > +       for (i = arr->mods_cnt; i >= 0; i--) {
> 
> This should be "i = arr->mods_cnt - 1", no?

right

> 
> > +               if (arr->mods[i] == mod)
> > +                       return true;
> > +       }
> > +       return false;
> > +}
> > +
> >  static int get_modules_for_addrs(struct module ***mods, unsigned long *addrs, u32 addrs_cnt)
> >  {
> > -       struct module_addr_args args = {
> > -               .addrs     = addrs,
> > -               .addrs_cnt = addrs_cnt,
> > -       };
> > -       int err;
> > +       struct modules_array arr = {};
> > +       u32 i, err = 0;
> > +
> > +       for (i = 0; i < addrs_cnt; i++) {
> > +               struct module *mod;
> > +
> > +               preempt_disable();
> > +               mod = __module_address(addrs[i]);
> > +               /* Either no module or we it's already stored  */
> > +               if (!mod || (mod && has_module(&arr, mod))) {
> 
> nit: This can be simplified:
> 
>      if (!mod || has_module(&arr, mod)) {

yep, will change

thanks,
jirka
