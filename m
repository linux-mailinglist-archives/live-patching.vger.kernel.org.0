Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 904FA66A40E
	for <lists+live-patching@lfdr.de>; Fri, 13 Jan 2023 21:28:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229819AbjAMU2F (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 13 Jan 2023 15:28:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbjAMU2E (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 13 Jan 2023 15:28:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52D3DD13C;
        Fri, 13 Jan 2023 12:28:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0E31AB821E5;
        Fri, 13 Jan 2023 20:28:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89FC6C433EF;
        Fri, 13 Jan 2023 20:28:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673641680;
        bh=czSgDiYekXN+p6xZa4QnIRmCZCAcWylVkXA/uzRLv/k=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=gYTHIA826ouDWpsNy4zCstPUzaCrXc5huZdb+QukNNq6OQ84cRqvJEYsQsj0ZnDe2
         aavvCXAbUhyC2oLTQdrDni1AwFVTXAzAYHtuBITT08LNxPBC1aW6rxUnZpPd//mCt9
         R5DpCam57CShhVCAlDu4PRjS1lBvdtEURhhFhui/llN1aqL+H/pgR+rFZnNz721GvF
         UTCyQA6KX7ZlGy7K4hAF1I6vie8sKQ7O9edFuu7PftPHufw0sM2Hm+eGSSiLEQmsZf
         av950dAw+z+r1olJCl/6a5QSRf+4ZfBHkinY/HGReKBq5VBJjhvg+PlWewBmdgx/Xj
         ZEJSZpraLyP7Q==
Received: by mail-lf1-f48.google.com with SMTP id g18so1807749lfh.0;
        Fri, 13 Jan 2023 12:28:00 -0800 (PST)
X-Gm-Message-State: AFqh2kq83oCkb4VhYZN2cWgsF/OxTjqMvUx1+yO9WYM9kR3E/uhyb7dZ
        t4M22/CPtjXDOI6Waldrg1UNmweBzBw+2tAa8cQ=
X-Google-Smtp-Source: AMrXdXszjjWIbBqkxgPVJu6+xD9kMTQCNfn6mrincoPEA79h/3lBVmIzC6M3t9YZGODRPh9xB93iarrIlZKv76DE6OA=
X-Received: by 2002:a05:6512:a95:b0:4d1:3e32:5436 with SMTP id
 m21-20020a0565120a9500b004d13e325436mr315336lfu.215.1673641678541; Fri, 13
 Jan 2023 12:27:58 -0800 (PST)
MIME-Version: 1.0
References: <20230113143303.867580-1-jolsa@kernel.org> <20230113143303.867580-3-jolsa@kernel.org>
In-Reply-To: <20230113143303.867580-3-jolsa@kernel.org>
From:   Song Liu <song@kernel.org>
Date:   Fri, 13 Jan 2023 12:27:46 -0800
X-Gmail-Original-Message-ID: <CAPhsuW7PVXSgbn1+ZLRh1tZCoA85pAcfXMK-o_wkecGV6krhNA@mail.gmail.com>
Message-ID: <CAPhsuW7PVXSgbn1+ZLRh1tZCoA85pAcfXMK-o_wkecGV6krhNA@mail.gmail.com>
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

Acked-by: Song Liu <song@kernel.org>

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
>  void test_kprobe_multi_test(void)
>  {
>         if (!ASSERT_OK(load_kallsyms(), "load_kallsyms"))
> --
> 2.39.0
>
