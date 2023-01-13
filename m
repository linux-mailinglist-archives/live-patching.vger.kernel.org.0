Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0013066A408
	for <lists+live-patching@lfdr.de>; Fri, 13 Jan 2023 21:25:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229844AbjAMUZU (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 13 Jan 2023 15:25:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229712AbjAMUZT (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 13 Jan 2023 15:25:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70D6A1056C;
        Fri, 13 Jan 2023 12:25:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B4BF1B8206B;
        Fri, 13 Jan 2023 20:25:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40C2CC433F1;
        Fri, 13 Jan 2023 20:25:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673641514;
        bh=0zuo2ReHk/qBisRDEsv6RcAlXByJD1MbSHCODEVSW64=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=KEiVSPIGhwO2J/wfA2l7UGVqcXC8NfhvSqM2FM9pGefdfExYXhtZ90NsQhAGZwGRy
         FcGyYQu/xIwjdJVE+avMbAWGaUdG/v56B3hj2gRaxRYw08VKibqiATci/y3Dp75HE/
         GUjTDMXTFg/U2tNDZ3bbs2qC6O9Gk79/fJTlS/FJEdCK2bm+D9HPkOCxnu7GbMq0ZH
         ABtKUbTa+0HgpSV8W9DkHLWFX93re7K7+pjCS9QfcPZikgGVfmzlhqDhEPRme8r3qF
         uO4/BJh5VsMrQscFVN64xU2IAknG8m4fy6OkF+cf1IQvY6u27Xjth1IXg4uy7XPfQf
         a4Padhf2Lr4Gw==
Received: by mail-lf1-f46.google.com with SMTP id m6so34643830lfj.11;
        Fri, 13 Jan 2023 12:25:14 -0800 (PST)
X-Gm-Message-State: AFqh2kr4m47Ul1GzpLbgiXApDjDkhh+hrwZKNpYa+GPic/6zsPuqUSHG
        9hN3fKxkFrmGgDwpIV33GA4NokOdQRxGNmbOZHg=
X-Google-Smtp-Source: AMrXdXuxggMgAa9N8FObjsy0riYurZfI0hDzvhp5VDjzQJhi8XnFra8NZ6swkaqzZU0a8ouMMyNzt01Ecz+jz1/5Tb4=
X-Received: by 2002:a05:6512:1152:b0:4c7:6601:e3b1 with SMTP id
 m18-20020a056512115200b004c76601e3b1mr3887868lfg.548.1673641512102; Fri, 13
 Jan 2023 12:25:12 -0800 (PST)
MIME-Version: 1.0
References: <20230113143303.867580-1-jolsa@kernel.org> <20230113143303.867580-2-jolsa@kernel.org>
In-Reply-To: <20230113143303.867580-2-jolsa@kernel.org>
From:   Song Liu <song@kernel.org>
Date:   Fri, 13 Jan 2023 12:24:59 -0800
X-Gmail-Original-Message-ID: <CAPhsuW4M0whQDMJ9eU4YF_r8ABsQe3thkhWePg6E3DFSk_3ruA@mail.gmail.com>
Message-ID: <CAPhsuW4M0whQDMJ9eU4YF_r8ABsQe3thkhWePg6E3DFSk_3ruA@mail.gmail.com>
Subject: Re: [PATCHv2 bpf-next 1/3] livepatch: Improve the search performance
 of module_kallsyms_on_each_symbol()
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

On Fri, Jan 13, 2023 at 6:43 AM Jiri Olsa <jolsa@kernel.org> wrote:
>
> From: Zhen Lei <thunder.leizhen@huawei.com>
>
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
> Reviewed-by: Petr Mladek <pmladek@suse.com>
> Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>

Acked-by: Song Liu <song@kernel.org>

> ---
>  include/linux/module.h   |  6 ++++--
>  kernel/livepatch/core.c  | 10 +---------
>  kernel/module/kallsyms.c | 13 ++++++++++++-
>  kernel/trace/bpf_trace.c |  2 +-
>  kernel/trace/ftrace.c    |  2 +-
>  5 files changed, 19 insertions(+), 14 deletions(-)
>
> diff --git a/include/linux/module.h b/include/linux/module.h
> index 8c5909c0076c..514bc81568c5 100644
> --- a/include/linux/module.h
> +++ b/include/linux/module.h
> @@ -879,11 +879,13 @@ static inline bool module_sig_ok(struct module *module)
>  #endif /* CONFIG_MODULE_SIG */
>
>  #if defined(CONFIG_MODULES) && defined(CONFIG_KALLSYMS)
> -int module_kallsyms_on_each_symbol(int (*fn)(void *, const char *,
> +int module_kallsyms_on_each_symbol(const char *modname,
> +                                  int (*fn)(void *, const char *,
>                                              struct module *, unsigned long),
>                                    void *data);
>  #else
> -static inline int module_kallsyms_on_each_symbol(int (*fn)(void *, const char *,
> +static inline int module_kallsyms_on_each_symbol(const char *modname,
> +                                                int (*fn)(void *, const char *,
>                                                  struct module *, unsigned long),
>                                                  void *data)
>  {
> diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
> index 201f0c0482fb..c973ed9e42f8 100644
> --- a/kernel/livepatch/core.c
> +++ b/kernel/livepatch/core.c
> @@ -118,7 +118,6 @@ static struct klp_object *klp_find_object(struct klp_patch *patch,
>  }
>
>  struct klp_find_arg {
> -       const char *objname;
>         const char *name;
>         unsigned long addr;
>         unsigned long count;
> @@ -148,15 +147,9 @@ static int klp_find_callback(void *data, const char *name,
>  {
>         struct klp_find_arg *args = data;
>
> -       if ((mod && !args->objname) || (!mod && args->objname))
> -               return 0;
> -
>         if (strcmp(args->name, name))
>                 return 0;
>
> -       if (args->objname && strcmp(args->objname, mod->name))
> -               return 0;
> -
>         return klp_match_callback(data, addr);
>  }
>
> @@ -164,7 +157,6 @@ static int klp_find_object_symbol(const char *objname, const char *name,
>                                   unsigned long sympos, unsigned long *addr)
>  {
>         struct klp_find_arg args = {
> -               .objname = objname,
>                 .name = name,
>                 .addr = 0,
>                 .count = 0,
> @@ -172,7 +164,7 @@ static int klp_find_object_symbol(const char *objname, const char *name,
>         };
>
>         if (objname)
> -               module_kallsyms_on_each_symbol(klp_find_callback, &args);
> +               module_kallsyms_on_each_symbol(objname, klp_find_callback, &args);
>         else
>                 kallsyms_on_each_match_symbol(klp_match_callback, name, &args);
>
> diff --git a/kernel/module/kallsyms.c b/kernel/module/kallsyms.c
> index 4523f99b0358..ab2376a1be88 100644
> --- a/kernel/module/kallsyms.c
> +++ b/kernel/module/kallsyms.c
> @@ -494,7 +494,8 @@ unsigned long module_kallsyms_lookup_name(const char *name)
>         return ret;
>  }
>
> -int module_kallsyms_on_each_symbol(int (*fn)(void *, const char *,
> +int module_kallsyms_on_each_symbol(const char *modname,
> +                                  int (*fn)(void *, const char *,
>                                              struct module *, unsigned long),
>                                    void *data)
>  {
> @@ -509,6 +510,9 @@ int module_kallsyms_on_each_symbol(int (*fn)(void *, const char *,
>                 if (mod->state == MODULE_STATE_UNFORMED)
>                         continue;
>
> +               if (modname && strcmp(modname, mod->name))
> +                       continue;
> +
>                 /* Use rcu_dereference_sched() to remain compliant with the sparse tool */
>                 preempt_disable();
>                 kallsyms = rcu_dereference_sched(mod->kallsyms);
> @@ -525,6 +529,13 @@ int module_kallsyms_on_each_symbol(int (*fn)(void *, const char *,
>                         if (ret != 0)
>                                 goto out;
>                 }
> +
> +               /*
> +                * The given module is found, the subsequent modules do not
> +                * need to be compared.
> +                */
> +               if (modname)
> +                       break;
>         }
>  out:
>         mutex_unlock(&module_mutex);
> diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> index 23ce498bca97..095f7f8d34a1 100644
> --- a/kernel/trace/bpf_trace.c
> +++ b/kernel/trace/bpf_trace.c
> @@ -2735,7 +2735,7 @@ static int get_modules_for_addrs(struct module ***mods, unsigned long *addrs, u3
>         int err;
>
>         /* We return either err < 0 in case of error, ... */
> -       err = module_kallsyms_on_each_symbol(module_callback, &args);
> +       err = module_kallsyms_on_each_symbol(NULL, module_callback, &args);
>         if (err) {
>                 kprobe_multi_put_modules(args.mods, args.mods_cnt);
>                 kfree(args.mods);
> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> index 442438b93fe9..d249a55d9005 100644
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -8324,7 +8324,7 @@ int ftrace_lookup_symbols(const char **sorted_syms, size_t cnt, unsigned long *a
>         found_all = kallsyms_on_each_symbol(kallsyms_callback, &args);
>         if (found_all)
>                 return 0;
> -       found_all = module_kallsyms_on_each_symbol(kallsyms_callback, &args);
> +       found_all = module_kallsyms_on_each_symbol(NULL, kallsyms_callback, &args);
>         return found_all ? 0 : -ESRCH;
>  }
>
> --
> 2.39.0
>
