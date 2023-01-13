Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3D7A66A434
	for <lists+live-patching@lfdr.de>; Fri, 13 Jan 2023 21:42:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229834AbjAMUmJ (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 13 Jan 2023 15:42:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbjAMUmI (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 13 Jan 2023 15:42:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FEEF6C07A;
        Fri, 13 Jan 2023 12:42:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5D7C562325;
        Fri, 13 Jan 2023 20:42:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEF6BC4339B;
        Fri, 13 Jan 2023 20:42:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673642524;
        bh=cOWsW9nKUXsxUCQsnLiBDmgLrf2dfGEbA185Yv8G/OM=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=EamK5LuKysSNTlprMypnnQYY0nKEllXUFv8OvOr3uXnTQRVTsJ2y95LRRer2I5qiR
         WkGRwEpMZPxh3rUtRC3+04I5TEmzn2Aaoa8HmudaQQ6d7MMChkFMXd+jcN/E9oVV0+
         pvxPQYDoXwtuv73xRpWBbsW89L2GrBFsAikxELeGfCxnSnvf6vJi8HL/IAH7b1ay24
         xyJZ/f06Olfkr+cOOYYte0YLNY5Cxc6040LrCI4tgdEnrrqWYH1oxSD1wCyVauX5j/
         SpgTtwIIiyX2fU1vkYI12VLFYWSrhYjX4YKA3mhW/uYidwGMxUwnnnZr9o0up6+V+/
         eoKjt+9jdFqww==
Received: by mail-lf1-f52.google.com with SMTP id d30so29796400lfv.8;
        Fri, 13 Jan 2023 12:42:04 -0800 (PST)
X-Gm-Message-State: AFqh2kovbS3qRsHGZyZhQeS/HzT3G8YYmaQCc5QtfAclJ7IdcIHwU+lU
        j8fmtrxPv9VuR1Q0bMRs4/1iQGkIgUp5eaPmMYs=
X-Google-Smtp-Source: AMrXdXtUxGGBxPDmt324svw/wEu8AD6SJCZg4y1IhBptsbul96Bb8AseeNQicd8hWXu0i6VLPki8OTtgziMrTsM3RPw=
X-Received: by 2002:a05:6512:3f07:b0:4ca:f873:7cf3 with SMTP id
 y7-20020a0565123f0700b004caf8737cf3mr6114773lfa.89.1673642522760; Fri, 13 Jan
 2023 12:42:02 -0800 (PST)
MIME-Version: 1.0
References: <20230113143303.867580-1-jolsa@kernel.org> <20230113143303.867580-4-jolsa@kernel.org>
In-Reply-To: <20230113143303.867580-4-jolsa@kernel.org>
From:   Song Liu <song@kernel.org>
Date:   Fri, 13 Jan 2023 12:41:50 -0800
X-Gmail-Original-Message-ID: <CAPhsuW5uHZxuhpEZ-_r8piRwUykx4+f9eumw8L8hqdAhmi5CvQ@mail.gmail.com>
Message-ID: <CAPhsuW5uHZxuhpEZ-_r8piRwUykx4+f9eumw8L8hqdAhmi5CvQ@mail.gmail.com>
Subject: Re: [PATCHv2 bpf-next 3/3] bpf: Change modules resolving for kprobe
 multi link
To:     Jiri Olsa <jolsa@kernel.org>
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
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri, Jan 13, 2023 at 6:44 AM Jiri Olsa <jolsa@kernel.org> wrote:
>
> We currently use module_kallsyms_on_each_symbol that iterates all
> modules/symbols and we try to lookup each such address in user
> provided symbols/addresses to get list of used modules.
>
> This fix instead only iterates provided kprobe addresses and calls
> __module_address on each to get list of used modules. This turned
> out to be simpler and also bit faster.
>
> On my setup with workload being (executed 10 times):
>
>    # test_progs -t kprobe_multi_bench_attach_module
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
>  kernel/trace/bpf_trace.c | 95 +++++++++++++++++++++-------------------
>  1 file changed, 49 insertions(+), 46 deletions(-)
>
> diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> index 095f7f8d34a1..90c5d5026831 100644
> --- a/kernel/trace/bpf_trace.c
> +++ b/kernel/trace/bpf_trace.c
> @@ -2682,69 +2682,79 @@ static void symbols_swap_r(void *a, void *b, int size, const void *priv)
>         }
>  }
>
> -struct module_addr_args {
> -       unsigned long *addrs;
> -       u32 addrs_cnt;
> +struct modules_array {
>         struct module **mods;
>         int mods_cnt;
>         int mods_cap;
>  };
>
> -static int module_callback(void *data, const char *name,
> -                          struct module *mod, unsigned long addr)
> +static int add_module(struct modules_array *arr, struct module *mod)
>  {
> -       struct module_addr_args *args = data;
>         struct module **mods;
>
> -       /* We iterate all modules symbols and for each we:
> -        * - search for it in provided addresses array
> -        * - if found we check if we already have the module pointer stored
> -        *   (we iterate modules sequentially, so we can check just the last
> -        *   module pointer)
> -        * - take module reference and store it
> -        */
> -       if (!bsearch(&addr, args->addrs, args->addrs_cnt, sizeof(addr),
> -                      bpf_kprobe_multi_addrs_cmp))
> -               return 0;
> -
> -       if (args->mods && args->mods[args->mods_cnt - 1] == mod)
> -               return 0;
> -
> -       if (args->mods_cnt == args->mods_cap) {
> -               args->mods_cap = max(16, args->mods_cap * 3 / 2);
> -               mods = krealloc_array(args->mods, args->mods_cap, sizeof(*mods), GFP_KERNEL);
> +       if (arr->mods_cnt == arr->mods_cap) {
> +               arr->mods_cap = max(16, arr->mods_cap * 3 / 2);
> +               mods = krealloc_array(arr->mods, arr->mods_cap, sizeof(*mods), GFP_KERNEL);
>                 if (!mods)
>                         return -ENOMEM;
> -               args->mods = mods;
> +               arr->mods = mods;
>         }
>
> -       if (!try_module_get(mod))
> -               return -EINVAL;
> -
> -       args->mods[args->mods_cnt] = mod;
> -       args->mods_cnt++;
> +       arr->mods[arr->mods_cnt] = mod;
> +       arr->mods_cnt++;
>         return 0;
>  }
>
> +static bool has_module(struct modules_array *arr, struct module *mod)
> +{
> +       int i;
> +
> +       if (!arr->mods)
> +               return false;
> +       for (i = arr->mods_cnt; i >= 0; i--) {

This should be "i = arr->mods_cnt - 1", no?

> +               if (arr->mods[i] == mod)
> +                       return true;
> +       }
> +       return false;
> +}
> +
>  static int get_modules_for_addrs(struct module ***mods, unsigned long *addrs, u32 addrs_cnt)
>  {
> -       struct module_addr_args args = {
> -               .addrs     = addrs,
> -               .addrs_cnt = addrs_cnt,
> -       };
> -       int err;
> +       struct modules_array arr = {};
> +       u32 i, err = 0;
> +
> +       for (i = 0; i < addrs_cnt; i++) {
> +               struct module *mod;
> +
> +               preempt_disable();
> +               mod = __module_address(addrs[i]);
> +               /* Either no module or we it's already stored  */
> +               if (!mod || (mod && has_module(&arr, mod))) {

nit: This can be simplified:

     if (!mod || has_module(&arr, mod)) {

> +                       preempt_enable();
> +                       continue;
> +               }

[...]
