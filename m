Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8313365FE48
	for <lists+live-patching@lfdr.de>; Fri,  6 Jan 2023 10:49:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229694AbjAFJrL (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 6 Jan 2023 04:47:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233742AbjAFJqT (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 6 Jan 2023 04:46:19 -0500
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 698D869B3B;
        Fri,  6 Jan 2023 01:45:45 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id c65-20020a1c3544000000b003cfffd00fc0so3167204wma.1;
        Fri, 06 Jan 2023 01:45:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=PN8//UfAoVwKaLm31eaWicz8hNpiTUFBXEnuGYY6upA=;
        b=FlwDESQyeNbwEOF9phOaSdZuMcQArQruAlYMTIIZ6+wSGyki259+Z+Sbg2rCI+BVQt
         sn9X3mES4FYL0nwejFeAt+UGU5KL6LpEanaT9TjhL8UDHNtgsndEgp/y8K1EIX3vxA3n
         Z4RlkGCMmQa9J5f+NxM8mSeSlbHjY6+DRna3iodggUIwdycTIXd5f1/VV/VOMKpN4dh3
         4HAHYShdm7RrVrqqnLISKJ9Mp+f0ysYmVu0Q5RJ39oG+0QOQMCFeTmNbH5ljcGBn7WTx
         nOER6ELX9ikWuNZjskCtbq5SEpXtds8xMJ05K3DiU/V5OZy7YAob2+UaBkXAWzBuQVux
         bA2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PN8//UfAoVwKaLm31eaWicz8hNpiTUFBXEnuGYY6upA=;
        b=QRL2oqrjWWXNKZxBt/9+IJ0LvXHs4UYKnoysqqykq+rxLGfbVQGzr7BPZ6NYSWWE4u
         VvAnLgyrRDrHOlS4derW8ACDjB+1wIAXKM+GgeJWwSLmTpAIzGQNmy1o76R8gN37MW8Q
         pBgaQkH1qC5NQ6bSoEFuA8HDusjq5tAq8tt/ntqUzIGETfT6c0N4k/HQufEiRjSmYHq6
         u1tNyHV08dJm67xxCcpBmWno7j2Pih1lRqo4u8DmK8XMbPm/N6PindTP2XmZs0y8KJ91
         eDa5tSidOIwNXr/ZVSUiFzTeaAtFyGMSW6IIqjDe/t/n4xHcsU1Trl0LGhx6SLMT5nED
         psdQ==
X-Gm-Message-State: AFqh2krhoYSkvJPFBC7fQkrVWEKWZQ0THZ3q1l0K7quawcv+Jbp2He6u
        QgAAS8p6mqZr0IgscFfrMw0=
X-Google-Smtp-Source: AMrXdXvGEs46DZ+1Nu9hdjrmPn0yZt8DrEET0vDFvTytRbxXI3AghL6OK5+dJLdJNIH2WxrVI2eIew==
X-Received: by 2002:a05:600c:3ca2:b0:3d9:a5a2:65fa with SMTP id bg34-20020a05600c3ca200b003d9a5a265famr17725332wmb.7.1672998343858;
        Fri, 06 Jan 2023 01:45:43 -0800 (PST)
Received: from krava (2001-1ae9-1c2-4c00-726e-c10f-8833-ff22.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:726e:c10f:8833:ff22])
        by smtp.gmail.com with ESMTPSA id bg24-20020a05600c3c9800b003cfa3a12660sm13739987wmb.1.2023.01.06.01.45.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Jan 2023 01:45:43 -0800 (PST)
From:   Jiri Olsa <olsajiri@gmail.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
Date:   Fri, 6 Jan 2023 10:45:40 +0100
To:     Jiri Olsa <olsajiri@gmail.com>
Cc:     Zhen Lei <thunder.leizhen@huawei.com>,
        Petr Mladek <pmladek@suse.com>,
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
Message-ID: <Y7ftxIiV35Wd75lZ@krava>
References: <20221230112729.351-1-thunder.leizhen@huawei.com>
 <20221230112729.351-3-thunder.leizhen@huawei.com>
 <Y7WoZARt37xGpjXD@alley>
 <Y7dBoII5kZnHGFdL@krava>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y7dBoII5kZnHGFdL@krava>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu, Jan 05, 2023 at 10:31:12PM +0100, Jiri Olsa wrote:
> On Wed, Jan 04, 2023 at 05:25:08PM +0100, Petr Mladek wrote:
> > On Fri 2022-12-30 19:27:28, Zhen Lei wrote:
> > > Function __module_address() can quickly return the pointer of the module
> > > to which an address belongs. We do not need to traverse the symbols of all
> > > modules to check whether each address in addrs[] is the start address of
> > > the corresponding symbol, because register_fprobe_ips() will do this check
> > > later.
> 
> hum, for some reason I can see only replies to this patch and
> not the actual patch.. I'll dig it out of the lore I guess
> 
> > > 
> > > Assuming that there are m modules, each module has n symbols on average,
> > > and the number of addresses 'addrs_cnt' is abbreviated as K. Then the time
> > > complexity of the original method is O(K * log(K)) + O(m * n * log(K)),
> > > and the time complexity of current method is O(K * (log(m) + M)), M <= m.
> > > (m * n * log(K)) / (K * m) ==> n / log2(K). Even if n is 10 and K is 128,
> > > the ratio is still greater than 1. Therefore, the new method will
> > > generally have better performance.
> 
> could you try to benchmark that? I tried something similar but was not
> able to get better performance

hm looks like I tried the smilar thing (below) like you did,
but wasn't able to get better performace

I guess your goal is to get rid of the module arg in
module_kallsyms_on_each_symbol callback that we use?
I'm ok with the change if the performace is not worse

jirka


---
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 5b9008bc597b..3280c22009f1 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -2692,23 +2692,16 @@ struct module_addr_args {
 	int mods_cap;
 };
 
-static int module_callback(void *data, const char *name,
-			   struct module *mod, unsigned long addr)
+static int add_module(struct module_addr_args *args, struct module *mod)
 {
-	struct module_addr_args *args = data;
 	struct module **mods;
 
-	/* We iterate all modules symbols and for each we:
-	 * - search for it in provided addresses array
-	 * - if found we check if we already have the module pointer stored
-	 *   (we iterate modules sequentially, so we can check just the last
-	 *   module pointer)
+	/* We iterate sorted addresses and for each within module we:
+	 * - check if we already have the module pointer stored for it
+	 *   (we iterate sorted addresses sequentially, so we can check
+	 *   just the last module pointer)
 	 * - take module reference and store it
 	 */
-	if (!bsearch(&addr, args->addrs, args->addrs_cnt, sizeof(addr),
-		       bpf_kprobe_multi_addrs_cmp))
-		return 0;
-
 	if (args->mods && args->mods[args->mods_cnt - 1] == mod)
 		return 0;
 
@@ -2734,10 +2727,24 @@ static int get_modules_for_addrs(struct module ***mods, unsigned long *addrs, u3
 		.addrs     = addrs,
 		.addrs_cnt = addrs_cnt,
 	};
-	int err;
+	u32 i, err = 0;
+
+	for (i = 0; !err && i < addrs_cnt; i++) {
+		struct module *mod;
+		bool found = false;
+
+		preempt_disable();
+		mod = __module_text_address(addrs[i]);
+		found = mod && try_module_get(mod);
+		preempt_enable();
+
+		if (found) {
+			err = add_module(&args, mod);
+			module_put(mod);
+		}
+	}
 
 	/* We return either err < 0 in case of error, ... */
-	err = module_kallsyms_on_each_symbol(module_callback, &args);
 	if (err) {
 		kprobe_multi_put_modules(args.mods, args.mods_cnt);
 		kfree(args.mods);
@@ -2862,7 +2869,8 @@ int bpf_kprobe_multi_link_attach(const union bpf_attr *attr, struct bpf_prog *pr
 	} else {
 		/*
 		 * We need to sort addrs array even if there are no cookies
-		 * provided, to allow bsearch in get_modules_for_addrs.
+		 * provided, to allow sequential address walk in
+		 * get_modules_for_addrs.
 		 */
 		sort(addrs, cnt, sizeof(*addrs),
 		       bpf_kprobe_multi_addrs_cmp, NULL);
