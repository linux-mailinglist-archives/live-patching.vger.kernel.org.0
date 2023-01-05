Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A9C365E751
	for <lists+live-patching@lfdr.de>; Thu,  5 Jan 2023 10:07:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232186AbjAEJGb (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 5 Jan 2023 04:06:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232239AbjAEJFm (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 5 Jan 2023 04:05:42 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F75B50E4C;
        Thu,  5 Jan 2023 01:05:15 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 45D526BB8B;
        Thu,  5 Jan 2023 09:05:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1672909514; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KjEYGtXHIvu5hfDTBI8PtDhvnl4Ui5seQm0BK9rUcK8=;
        b=oT4Pi+UDQ61FFQ2pvNpb5HDPBMOdDXl/+KeEPQdLvXx8DTxCNt1kvcn7EvJbYumniXfSXP
        UFEZtFAR/xYctcYWIXlevMJxR4zs8vDY9ADm64BI0B1lSG0yW96MGLJ3+zvorUgj3gnkoP
        dtVt4S6G1Oti9+JKmMwbfp4d2TYtUEk=
Received: from suse.cz (unknown [10.100.201.202])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id A8CFD2C17B;
        Thu,  5 Jan 2023 09:05:13 +0000 (UTC)
Date:   Thu, 5 Jan 2023 10:05:13 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     Song Liu <song@kernel.org>
Cc:     Zhen Lei <thunder.leizhen@huawei.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Yonghong Song <yhs@fb.com>,
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
Message-ID: <Y7aSyb0n4B2aCRZH@alley>
References: <20221230112729.351-1-thunder.leizhen@huawei.com>
 <20221230112729.351-3-thunder.leizhen@huawei.com>
 <Y7WoZARt37xGpjXD@alley>
 <CAPhsuW6sZ9yQvZvKLd0g9m4FoabmUzwn-txX6T_A-_VYgJoXFg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPhsuW6sZ9yQvZvKLd0g9m4FoabmUzwn-txX6T_A-_VYgJoXFg@mail.gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed 2023-01-04 09:07:02, Song Liu wrote:
> On Wed, Jan 4, 2023 at 8:25 AM Petr Mladek <pmladek@suse.com> wrote:
> >
> > On Fri 2022-12-30 19:27:28, Zhen Lei wrote:
> > > Function __module_address() can quickly return the pointer of the module
> > > to which an address belongs. We do not need to traverse the symbols of all
> > > modules to check whether each address in addrs[] is the start address of
> > > the corresponding symbol, because register_fprobe_ips() will do this check
> > > later.
> > >
> > > Assuming that there are m modules, each module has n symbols on average,
> > > and the number of addresses 'addrs_cnt' is abbreviated as K. Then the time
> > > complexity of the original method is O(K * log(K)) + O(m * n * log(K)),
> > > and the time complexity of current method is O(K * (log(m) + M)), M <= m.
> > > (m * n * log(K)) / (K * m) ==> n / log2(K). Even if n is 10 and K is 128,
> > > the ratio is still greater than 1. Therefore, the new method will
> > > generally have better performance.
> > >
> > > Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
> > > ---
> > >  kernel/trace/bpf_trace.c | 101 ++++++++++++++++-----------------------
> > >  1 file changed, 40 insertions(+), 61 deletions(-)
> > >
> > > diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> > > index 5f3be4bc16403a5..0ff9037098bd241 100644
> > > --- a/kernel/trace/bpf_trace.c
> > > +++ b/kernel/trace/bpf_trace.c
> > > @@ -2684,69 +2684,55 @@ static void symbols_swap_r(void *a, void *b, int size, const void *priv)
> > >       }
> > >  }
> > >
> > > -struct module_addr_args {
> > > -     unsigned long *addrs;
> > > -     u32 addrs_cnt;
> > > -     struct module **mods;
> > > -     int mods_cnt;
> > > -     int mods_cap;
> > > -};
> > > -
> > > -static int module_callback(void *data, const char *name,
> > > -                        struct module *mod, unsigned long addr)
> > > +static int get_modules_for_addrs(struct module ***out_mods, unsigned long *addrs, u32 addrs_cnt)
> > >  {
> > > -     struct module_addr_args *args = data;
> > > -     struct module **mods;
> > > -
> > > -     /* We iterate all modules symbols and for each we:
> > > -      * - search for it in provided addresses array
> > > -      * - if found we check if we already have the module pointer stored
> > > -      *   (we iterate modules sequentially, so we can check just the last
> > > -      *   module pointer)
> > > -      * - take module reference and store it
> > > -      */
> > > -     if (!bsearch(&addr, args->addrs, args->addrs_cnt, sizeof(addr),
> > > -                    bpf_kprobe_multi_addrs_cmp))
> > > -             return 0;
> > > +     int i, j, err;
> > > +     int mods_cnt = 0;
> > > +     int mods_cap = 0;
> > > +     struct module *mod;
> > > +     struct module **mods = NULL;
> > >
> > > -     if (args->mods && args->mods[args->mods_cnt - 1] == mod)
> > > -             return 0;
> > > +     for (i = 0; i < addrs_cnt; i++) {
> > > +             mod = __module_address(addrs[i]);
> >
> > This must be called under module_mutex to make sure that the module
> > would not disappear.
> 
> module_mutex is not available outside kernel/module/. The common
> practice is to disable preempt before calling __module_address().
> CONFIG_LOCKDEP should catch this.

I see. Sigh, it is always better to take mutex than disable
preemption. But it might be acceptable in this case. We just need
to be careful.

First, the preemption must stay disabled all the time until
try_module_get(). Otherwise the returned struct module could
disappear in the meantime.

Second, krealloc_array() has to be called with preemption
enabled. It is perfectly fine to do it after try_module_get().

Best Regards,
Petr
