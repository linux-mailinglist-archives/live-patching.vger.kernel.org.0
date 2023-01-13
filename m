Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80063669ACB
	for <lists+live-patching@lfdr.de>; Fri, 13 Jan 2023 15:44:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229505AbjAMOoM (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 13 Jan 2023 09:44:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229778AbjAMOm7 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 13 Jan 2023 09:42:59 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F19D590E7A;
        Fri, 13 Jan 2023 06:33:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 676E0CE20DE;
        Fri, 13 Jan 2023 14:33:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44C7FC4339B;
        Fri, 13 Jan 2023 14:33:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673620429;
        bh=uKdLtu+rCQLafQsfl2r5dCRH8oFNCeZWLd9/++XfXss=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vFlLI//ZEt3VvIWbEqzvFVnP/65DQMrjhmkbLxFFlnnxxDpJLpGdT/muuTOHmekQA
         Xib7ADIAJwrjDjfI4RwqtiSe2Jldqq8ecv0NVO+8IBISsohQrFjPEEuBEQnKFEZg/n
         b0pgEUwqFcppMOZBePHNj4IJG+vK44y24Uhvr5mK5jxzbXoSDuXUFY8YPp90LxcN7I
         gk0ppH3xEpiUJxkZYfuRG+hUvCOQpUQTmZwEhg9Saq3qgZQt5i9na6iBDrQ+r4pj8i
         vKWjY97zENxv6nSgeoavkCTO6Emsj4NXTrTfLO0iiDORL9QvWl0NBjhy4CWrSOEOLE
         uoYEvuoMmlI3Q==
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Zhen Lei <thunder.leizhen@huawei.com>
Cc:     bpf@vger.kernel.org, live-patching@vger.kernel.org,
        linux-modules@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>,
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
Subject: [PATCHv2 bpf-next 3/3] bpf: Change modules resolving for kprobe multi link
Date:   Fri, 13 Jan 2023 15:33:03 +0100
Message-Id: <20230113143303.867580-4-jolsa@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230113143303.867580-1-jolsa@kernel.org>
References: <20230113143303.867580-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

We currently use module_kallsyms_on_each_symbol that iterates all
modules/symbols and we try to lookup each such address in user
provided symbols/addresses to get list of used modules.

This fix instead only iterates provided kprobe addresses and calls
__module_address on each to get list of used modules. This turned
out to be simpler and also bit faster.

On my setup with workload being (executed 10 times):

   # test_progs -t kprobe_multi_bench_attach_module

Current code:

 Performance counter stats for './test.sh' (5 runs):

    76,081,161,596      cycles:k                   ( +-  0.47% )

           18.3867 +- 0.0992 seconds time elapsed  ( +-  0.54% )

With the fix:

 Performance counter stats for './test.sh' (5 runs):

    74,079,889,063      cycles:k                   ( +-  0.04% )

           17.8514 +- 0.0218 seconds time elapsed  ( +-  0.12% )

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 kernel/trace/bpf_trace.c | 95 +++++++++++++++++++++-------------------
 1 file changed, 49 insertions(+), 46 deletions(-)

diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 095f7f8d34a1..90c5d5026831 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -2682,69 +2682,79 @@ static void symbols_swap_r(void *a, void *b, int size, const void *priv)
 	}
 }
 
-struct module_addr_args {
-	unsigned long *addrs;
-	u32 addrs_cnt;
+struct modules_array {
 	struct module **mods;
 	int mods_cnt;
 	int mods_cap;
 };
 
-static int module_callback(void *data, const char *name,
-			   struct module *mod, unsigned long addr)
+static int add_module(struct modules_array *arr, struct module *mod)
 {
-	struct module_addr_args *args = data;
 	struct module **mods;
 
-	/* We iterate all modules symbols and for each we:
-	 * - search for it in provided addresses array
-	 * - if found we check if we already have the module pointer stored
-	 *   (we iterate modules sequentially, so we can check just the last
-	 *   module pointer)
-	 * - take module reference and store it
-	 */
-	if (!bsearch(&addr, args->addrs, args->addrs_cnt, sizeof(addr),
-		       bpf_kprobe_multi_addrs_cmp))
-		return 0;
-
-	if (args->mods && args->mods[args->mods_cnt - 1] == mod)
-		return 0;
-
-	if (args->mods_cnt == args->mods_cap) {
-		args->mods_cap = max(16, args->mods_cap * 3 / 2);
-		mods = krealloc_array(args->mods, args->mods_cap, sizeof(*mods), GFP_KERNEL);
+	if (arr->mods_cnt == arr->mods_cap) {
+		arr->mods_cap = max(16, arr->mods_cap * 3 / 2);
+		mods = krealloc_array(arr->mods, arr->mods_cap, sizeof(*mods), GFP_KERNEL);
 		if (!mods)
 			return -ENOMEM;
-		args->mods = mods;
+		arr->mods = mods;
 	}
 
-	if (!try_module_get(mod))
-		return -EINVAL;
-
-	args->mods[args->mods_cnt] = mod;
-	args->mods_cnt++;
+	arr->mods[arr->mods_cnt] = mod;
+	arr->mods_cnt++;
 	return 0;
 }
 
+static bool has_module(struct modules_array *arr, struct module *mod)
+{
+	int i;
+
+	if (!arr->mods)
+		return false;
+	for (i = arr->mods_cnt; i >= 0; i--) {
+		if (arr->mods[i] == mod)
+			return true;
+	}
+	return false;
+}
+
 static int get_modules_for_addrs(struct module ***mods, unsigned long *addrs, u32 addrs_cnt)
 {
-	struct module_addr_args args = {
-		.addrs     = addrs,
-		.addrs_cnt = addrs_cnt,
-	};
-	int err;
+	struct modules_array arr = {};
+	u32 i, err = 0;
+
+	for (i = 0; i < addrs_cnt; i++) {
+		struct module *mod;
+
+		preempt_disable();
+		mod = __module_address(addrs[i]);
+		/* Either no module or we it's already stored  */
+		if (!mod || (mod && has_module(&arr, mod))) {
+			preempt_enable();
+			continue;
+		}
+		if (!try_module_get(mod))
+			err = -EINVAL;
+		preempt_enable();
+		if (err)
+			break;
+		err = add_module(&arr, mod);
+		if (err) {
+			module_put(mod);
+			break;
+		}
+	}
 
 	/* We return either err < 0 in case of error, ... */
-	err = module_kallsyms_on_each_symbol(NULL, module_callback, &args);
 	if (err) {
-		kprobe_multi_put_modules(args.mods, args.mods_cnt);
-		kfree(args.mods);
+		kprobe_multi_put_modules(arr.mods, arr.mods_cnt);
+		kfree(arr.mods);
 		return err;
 	}
 
 	/* or number of modules found if everything is ok. */
-	*mods = args.mods;
-	return args.mods_cnt;
+	*mods = arr.mods;
+	return arr.mods_cnt;
 }
 
 int bpf_kprobe_multi_link_attach(const union bpf_attr *attr, struct bpf_prog *prog)
@@ -2857,13 +2867,6 @@ int bpf_kprobe_multi_link_attach(const union bpf_attr *attr, struct bpf_prog *pr
 		       bpf_kprobe_multi_cookie_cmp,
 		       bpf_kprobe_multi_cookie_swap,
 		       link);
-	} else {
-		/*
-		 * We need to sort addrs array even if there are no cookies
-		 * provided, to allow bsearch in get_modules_for_addrs.
-		 */
-		sort(addrs, cnt, sizeof(*addrs),
-		       bpf_kprobe_multi_addrs_cmp, NULL);
 	}
 
 	err = get_modules_for_addrs(&link->mods, addrs, cnt);
-- 
2.39.0

