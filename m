Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0B8666A620
	for <lists+live-patching@lfdr.de>; Fri, 13 Jan 2023 23:44:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231177AbjAMWoD (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 13 Jan 2023 17:44:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230391AbjAMWoB (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 13 Jan 2023 17:44:01 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E53B76AE9;
        Fri, 13 Jan 2023 14:44:01 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id az20so36527365ejc.1;
        Fri, 13 Jan 2023 14:44:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=IFIqAJYGRW7+c3hbx21tpFMKu8WPaHzSHG4D71XM1oY=;
        b=emj3043bzTNqzlwOG7mdEgkeXvmc24yXZEgnwdZnjwUzVyKBuE2uvmkvfxJgZy8V0j
         0TqdJv1yxzHqVdMc56ajwdVqkLr7bqW9biFqd+Jeh3+dnypSO1ko8gMzOjuJavlc0lJS
         C9ox0PN43JNz2p4HxgwpCI1DpnehTb04fADlY8tMlmTT2jBOWBrtRzuNp5/Ro0hhBlXQ
         OMRXEOKVCBvzuN0gvarXwd/CxUbcjueMTVwMZUOcJLfBZJmUUEmvKsbwRGWgQpq7+Pui
         uE1ucmFZjQJA+Y9t6RWejFZ4KAHjq2bkBmB1pgW7kCPiLus0rXnPDTqY2cz0LRWviu15
         9lNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IFIqAJYGRW7+c3hbx21tpFMKu8WPaHzSHG4D71XM1oY=;
        b=q/jAtmTOXy9USaGVVniuumrEDLSvh6IDtLAXmBnv8IvAi9+3KvejBHJn4FxS2cM6SA
         By41zHEt4obrMQSxavM4ZtSgaqGgKtN7NiWOH4fiDfT/kVB4g9vqkAEgQ2ApfodHpc/U
         VCncHR2uRKfL/I0TthxiUfge9JcbWubYBdtsw0czkS3x37GP0Wx8vFrzJiQoiY3PjVra
         tv769wCMzf904a6WTIUuoBeFwTW+0vzUP4DFw/3rgInCkcwn7vyUMoAYuHibQPO6rEhe
         YHBmIfiM3rDhqdpmmACVusTbyR/nl4bJ064NJyPbmmWNX3yJnXiN9TKloZmGwLK4qrRi
         F0rA==
X-Gm-Message-State: AFqh2koaHy8HrbXJDLIY6+2pAj0LxAgHUY4597iasibn6Ja9q4KTzwMb
        h6yg/xlark0H2Wj5pjxiQ3rrqw2uA4q1lWRoQRI=
X-Google-Smtp-Source: AMrXdXsEsuFdsnpl9rkXoKeR3bS3rqPdRbtDMJxMkTClqmx8GDiLSNY3Mb+qOrQyem8BEdo6lCJnIXE64UKp5gadCk4=
X-Received: by 2002:a17:906:2ccc:b0:7f3:3b2:314f with SMTP id
 r12-20020a1709062ccc00b007f303b2314fmr6549451ejr.115.1673649839425; Fri, 13
 Jan 2023 14:43:59 -0800 (PST)
MIME-Version: 1.0
References: <20230113143303.867580-1-jolsa@kernel.org> <20230113143303.867580-3-jolsa@kernel.org>
In-Reply-To: <20230113143303.867580-3-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 13 Jan 2023 14:43:47 -0800
Message-ID: <CAEf4BzZSzM0NznnEH0oD9y6Zdd6YDZWEp4HyL1+2hLBrWk=j1w@mail.gmail.com>
Subject: Re: [PATCHv2 bpf-next 2/3] selftests/bpf: Add serial_test_kprobe_multi_bench_attach_kernel/module
 tests
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
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri, Jan 13, 2023 at 6:33 AM Jiri Olsa <jolsa@kernel.org> wrote:
>
> Add bench test for module portion of the symbols as well.
>
>   # ./test_progs -v -t kprobe_multi_bench_attach_module
>   bpf_testmod.ko is already unloaded.
>   Loading bpf_testmod.ko...
>   Successfully loaded bpf_testmod.ko.
>   test_kprobe_multi_bench_attach:PASS:get_syms 0 nsec
>   test_kprobe_multi_bench_attach:PASS:kprobe_multi_empty__open_and_load 0 nsec
>   test_kprobe_multi_bench_attach:PASS:bpf_program__attach_kprobe_multi_opts 0 nsec
>   test_kprobe_multi_bench_attach: found 26620 functions
>   test_kprobe_multi_bench_attach: attached in   0.182s
>   test_kprobe_multi_bench_attach: detached in   0.082s
>   #96      kprobe_multi_bench_attach_module:OK
>   Summary: 1/0 PASSED, 0 SKIPPED, 0 FAILED
>   Successfully unloaded bpf_testmod.ko.
>
> It's useful for testing kprobe multi link modules resolving.
>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  .../bpf/prog_tests/kprobe_multi_test.c        | 21 ++++++++++++++-----
>  1 file changed, 16 insertions(+), 5 deletions(-)
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/kprobe_multi_test.c b/tools/testing/selftests/bpf/prog_tests/kprobe_multi_test.c
> index c6f37e825f11..017a6996f3fa 100644
> --- a/tools/testing/selftests/bpf/prog_tests/kprobe_multi_test.c
> +++ b/tools/testing/selftests/bpf/prog_tests/kprobe_multi_test.c
> @@ -322,7 +322,7 @@ static bool symbol_equal(long key1, long key2, void *ctx __maybe_unused)
>         return strcmp((const char *) key1, (const char *) key2) == 0;
>  }
>
> -static int get_syms(char ***symsp, size_t *cntp)
> +static int get_syms(char ***symsp, size_t *cntp, bool kernel)
>  {
>         size_t cap = 0, cnt = 0, i;
>         char *name = NULL, **syms = NULL;
> @@ -349,8 +349,9 @@ static int get_syms(char ***symsp, size_t *cntp)
>         }
>
>         while (fgets(buf, sizeof(buf), f)) {
> -               /* skip modules */
> -               if (strchr(buf, '['))
> +               if (kernel && strchr(buf, '['))
> +                       continue;
> +               if (!kernel && !strchr(buf, '['))
>                         continue;
>
>                 free(name);
> @@ -404,7 +405,7 @@ static int get_syms(char ***symsp, size_t *cntp)
>         return err;
>  }
>
> -void serial_test_kprobe_multi_bench_attach(void)
> +static void test_kprobe_multi_bench_attach(bool kernel)
>  {
>         LIBBPF_OPTS(bpf_kprobe_multi_opts, opts);
>         struct kprobe_multi_empty *skel = NULL;
> @@ -415,7 +416,7 @@ void serial_test_kprobe_multi_bench_attach(void)
>         char **syms = NULL;
>         size_t cnt = 0, i;
>
> -       if (!ASSERT_OK(get_syms(&syms, &cnt), "get_syms"))
> +       if (!ASSERT_OK(get_syms(&syms, &cnt, kernel), "get_syms"))
>                 return;
>
>         skel = kprobe_multi_empty__open_and_load();
> @@ -453,6 +454,16 @@ void serial_test_kprobe_multi_bench_attach(void)
>         }
>  }
>
> +void serial_test_kprobe_multi_bench_attach_kernel(void)
> +{
> +       test_kprobe_multi_bench_attach(true);
> +}
> +
> +void serial_test_kprobe_multi_bench_attach_module(void)
> +{
> +       test_kprobe_multi_bench_attach(false);
> +}
> +

minor nit: probably would be better to make kernel and module variants
into subtests?



>  void test_kprobe_multi_test(void)
>  {
>         if (!ASSERT_OK(load_kallsyms(), "load_kallsyms"))
> --
> 2.39.0
>
