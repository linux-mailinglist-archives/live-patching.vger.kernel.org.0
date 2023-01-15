Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C488B66B445
	for <lists+live-patching@lfdr.de>; Sun, 15 Jan 2023 22:49:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231318AbjAOVtP (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Sun, 15 Jan 2023 16:49:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231320AbjAOVtN (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Sun, 15 Jan 2023 16:49:13 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FE6B18152;
        Sun, 15 Jan 2023 13:49:11 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id p1-20020a05600c1d8100b003d8c9b191e0so20951308wms.4;
        Sun, 15 Jan 2023 13:49:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=gd7Ow2nPrEWd6lZ2zmUT7J4z0TLG/anTssBGwzt00Nc=;
        b=UIl9Gprhiq5HCUZZup59Kkv+RXKDVsYOAXEAxEes7WEAImXJ2xVcxAdKA0R98q3nKh
         inuXNmPXwE0hs+3pjZ24JVPIht4gbMfjpH8U0TRyJvlyDWWMgsAOYzR+KYS3OXd0soiC
         ArPUNwYD2T082+UFZaB2/AE6EwAe3EmIDVZTWESaBcKExPjcznHRKuRFYp9a4tIMcF5V
         P0bSPQEhc2VOnYgws+qrhbc1nkx53RPpBe+9fO02kDUjEc9db9KGc4UYSiASB5oXeRMp
         HiIO3rzuKxqbP1dZojGal/Fp9+DK5oeb0g1sS6IPzDsZepgIguxjSn7NS1iq7B1i2hrW
         n5eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gd7Ow2nPrEWd6lZ2zmUT7J4z0TLG/anTssBGwzt00Nc=;
        b=ALVfZU9i8hpurt/tN2BM8ucvd27cOU1kJYVS9YyIshTB4PTKAKVpjUNqxsGtF3s7p2
         RKIrsCxAOY8sCy9pVSmTEBKcfSKACWcHgsNjd6x7u5tIwlh0GKrtzNrLo1BqF9XtkIMo
         t2UGG/LuWoyEviKXMUlPOst3EmIewQFFZ6A2YmHA0Z2gcIRMgx04sk28D/cgd7TWlFTr
         +PItWqOPD2PBtdVCiKeyUGgxr/yhoS9OXWzZ+sGmpsZkq/3TQurNMEcGuII4Wg+gQQJM
         /bwsE3RJ0ONCAWGqb4gBy+vCt43hvJAj048WezQ4mBIqF47a9oUQBEhpnYxRFfG/sX8N
         mW2g==
X-Gm-Message-State: AFqh2kq0JKbbUaQLF+bcQxsEoC8SQtupqeBpU9/Ivrw/HVhPb/KGW41m
        EGnc8dmtFJ8P+27KngTiytA=
X-Google-Smtp-Source: AMrXdXuwLlvobMgpyjk0yf7rfKUiaQcWvz2pRA5JHlX/iVn9xPH66Ik3FuDSLw1s9XtZiGUFB7Yh0w==
X-Received: by 2002:a05:600c:4d11:b0:3da:f97b:2a95 with SMTP id u17-20020a05600c4d1100b003daf97b2a95mr2143498wmp.36.1673819349645;
        Sun, 15 Jan 2023 13:49:09 -0800 (PST)
Received: from krava ([83.240.63.124])
        by smtp.gmail.com with ESMTPSA id z22-20020a7bc7d6000000b003cfa81e2eb4sm4441311wmk.38.2023.01.15.13.49.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Jan 2023 13:49:08 -0800 (PST)
From:   Jiri Olsa <olsajiri@gmail.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
Date:   Sun, 15 Jan 2023 22:49:06 +0100
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
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
Subject: Re: [PATCHv2 bpf-next 2/3] selftests/bpf: Add
 serial_test_kprobe_multi_bench_attach_kernel/module tests
Message-ID: <Y8R00sRwznbKlJV3@krava>
References: <20230113143303.867580-1-jolsa@kernel.org>
 <20230113143303.867580-3-jolsa@kernel.org>
 <CAEf4BzZSzM0NznnEH0oD9y6Zdd6YDZWEp4HyL1+2hLBrWk=j1w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzZSzM0NznnEH0oD9y6Zdd6YDZWEp4HyL1+2hLBrWk=j1w@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri, Jan 13, 2023 at 02:43:47PM -0800, Andrii Nakryiko wrote:
> On Fri, Jan 13, 2023 at 6:33 AM Jiri Olsa <jolsa@kernel.org> wrote:
> >
> > Add bench test for module portion of the symbols as well.
> >
> >   # ./test_progs -v -t kprobe_multi_bench_attach_module
> >   bpf_testmod.ko is already unloaded.
> >   Loading bpf_testmod.ko...
> >   Successfully loaded bpf_testmod.ko.
> >   test_kprobe_multi_bench_attach:PASS:get_syms 0 nsec
> >   test_kprobe_multi_bench_attach:PASS:kprobe_multi_empty__open_and_load 0 nsec
> >   test_kprobe_multi_bench_attach:PASS:bpf_program__attach_kprobe_multi_opts 0 nsec
> >   test_kprobe_multi_bench_attach: found 26620 functions
> >   test_kprobe_multi_bench_attach: attached in   0.182s
> >   test_kprobe_multi_bench_attach: detached in   0.082s
> >   #96      kprobe_multi_bench_attach_module:OK
> >   Summary: 1/0 PASSED, 0 SKIPPED, 0 FAILED
> >   Successfully unloaded bpf_testmod.ko.
> >
> > It's useful for testing kprobe multi link modules resolving.
> >
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > ---
> >  .../bpf/prog_tests/kprobe_multi_test.c        | 21 ++++++++++++++-----
> >  1 file changed, 16 insertions(+), 5 deletions(-)
> >
> > diff --git a/tools/testing/selftests/bpf/prog_tests/kprobe_multi_test.c b/tools/testing/selftests/bpf/prog_tests/kprobe_multi_test.c
> > index c6f37e825f11..017a6996f3fa 100644
> > --- a/tools/testing/selftests/bpf/prog_tests/kprobe_multi_test.c
> > +++ b/tools/testing/selftests/bpf/prog_tests/kprobe_multi_test.c
> > @@ -322,7 +322,7 @@ static bool symbol_equal(long key1, long key2, void *ctx __maybe_unused)
> >         return strcmp((const char *) key1, (const char *) key2) == 0;
> >  }
> >
> > -static int get_syms(char ***symsp, size_t *cntp)
> > +static int get_syms(char ***symsp, size_t *cntp, bool kernel)
> >  {
> >         size_t cap = 0, cnt = 0, i;
> >         char *name = NULL, **syms = NULL;
> > @@ -349,8 +349,9 @@ static int get_syms(char ***symsp, size_t *cntp)
> >         }
> >
> >         while (fgets(buf, sizeof(buf), f)) {
> > -               /* skip modules */
> > -               if (strchr(buf, '['))
> > +               if (kernel && strchr(buf, '['))
> > +                       continue;
> > +               if (!kernel && !strchr(buf, '['))
> >                         continue;
> >
> >                 free(name);
> > @@ -404,7 +405,7 @@ static int get_syms(char ***symsp, size_t *cntp)
> >         return err;
> >  }
> >
> > -void serial_test_kprobe_multi_bench_attach(void)
> > +static void test_kprobe_multi_bench_attach(bool kernel)
> >  {
> >         LIBBPF_OPTS(bpf_kprobe_multi_opts, opts);
> >         struct kprobe_multi_empty *skel = NULL;
> > @@ -415,7 +416,7 @@ void serial_test_kprobe_multi_bench_attach(void)
> >         char **syms = NULL;
> >         size_t cnt = 0, i;
> >
> > -       if (!ASSERT_OK(get_syms(&syms, &cnt), "get_syms"))
> > +       if (!ASSERT_OK(get_syms(&syms, &cnt, kernel), "get_syms"))
> >                 return;
> >
> >         skel = kprobe_multi_empty__open_and_load();
> > @@ -453,6 +454,16 @@ void serial_test_kprobe_multi_bench_attach(void)
> >         }
> >  }
> >
> > +void serial_test_kprobe_multi_bench_attach_kernel(void)
> > +{
> > +       test_kprobe_multi_bench_attach(true);
> > +}
> > +
> > +void serial_test_kprobe_multi_bench_attach_module(void)
> > +{
> > +       test_kprobe_multi_bench_attach(false);
> > +}
> > +
> 
> minor nit: probably would be better to make kernel and module variants
> into subtests?

ok, will change that

thanks,
jirka
