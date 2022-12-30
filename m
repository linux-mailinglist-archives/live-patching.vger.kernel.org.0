Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7B246597A5
	for <lists+live-patching@lfdr.de>; Fri, 30 Dec 2022 12:29:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234919AbiL3L3K (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 30 Dec 2022 06:29:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234864AbiL3L2w (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 30 Dec 2022 06:28:52 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53D3B1AD86;
        Fri, 30 Dec 2022 03:28:51 -0800 (PST)
Received: from dggpemm500006.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Nk2zj1zSHzbcD6;
        Fri, 30 Dec 2022 19:27:29 +0800 (CST)
Received: from thunder-town.china.huawei.com (10.174.178.55) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Fri, 30 Dec 2022 19:28:48 +0800
From:   Zhen Lei <thunder.leizhen@huawei.com>
To:     Josh Poimboeuf <jpoimboe@kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>, <bpf@vger.kernel.org>,
        <linux-trace-kernel@vger.kernel.org>,
        <live-patching@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        <linux-modules@vger.kernel.org>
CC:     Zhen Lei <thunder.leizhen@huawei.com>
Subject: [PATCH 2/3] bpf: Optimize get_modules_for_addrs()
Date:   Fri, 30 Dec 2022 19:27:28 +0800
Message-ID: <20221230112729.351-3-thunder.leizhen@huawei.com>
X-Mailer: git-send-email 2.37.3.windows.1
In-Reply-To: <20221230112729.351-1-thunder.leizhen@huawei.com>
References: <20221230112729.351-1-thunder.leizhen@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.174.178.55]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemm500006.china.huawei.com (7.185.36.236)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Function __module_address() can quickly return the pointer of the module
to which an address belongs. We do not need to traverse the symbols of all
modules to check whether each address in addrs[] is the start address of
the corresponding symbol, because register_fprobe_ips() will do this check
later.

Assuming that there are m modules, each module has n symbols on average,
and the number of addresses 'addrs_cnt' is abbreviated as K. Then the time
complexity of the original method is O(K * log(K)) + O(m * n * log(K)),
and the time complexity of current method is O(K * (log(m) + M)), M <= m.
(m * n * log(K)) / (K * m) ==> n / log2(K). Even if n is 10 and K is 128,
the ratio is still greater than 1. Therefore, the new method will
generally have better performance.

Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
---
 kernel/trace/bpf_trace.c | 101 ++++++++++++++++-----------------------
 1 file changed, 40 insertions(+), 61 deletions(-)

diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 5f3be4bc16403a5..0ff9037098bd241 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -2684,69 +2684,55 @@ static void symbols_swap_r(void *a, void *b, int size, const void *priv)
 	}
 }
 
-struct module_addr_args {
-	unsigned long *addrs;
-	u32 addrs_cnt;
-	struct module **mods;
-	int mods_cnt;
-	int mods_cap;
-};
-
-static int module_callback(void *data, const char *name,
-			   struct module *mod, unsigned long addr)
+static int get_modules_for_addrs(struct module ***out_mods, unsigned long *addrs, u32 addrs_cnt)
 {
-	struct module_addr_args *args = data;
-	struct module **mods;
-
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
+	int i, j, err;
+	int mods_cnt = 0;
+	int mods_cap = 0;
+	struct module *mod;
+	struct module **mods = NULL;
 
-	if (args->mods && args->mods[args->mods_cnt - 1] == mod)
-		return 0;
+	for (i = 0; i < addrs_cnt; i++) {
+		mod = __module_address(addrs[i]);
+		if (!mod)
+			continue;
 
-	if (args->mods_cnt == args->mods_cap) {
-		args->mods_cap = max(16, args->mods_cap * 3 / 2);
-		mods = krealloc_array(args->mods, args->mods_cap, sizeof(*mods), GFP_KERNEL);
-		if (!mods)
-			return -ENOMEM;
-		args->mods = mods;
-	}
+		/* check if we already have the module pointer stored */
+		for (j = 0; j < mods_cnt; j++) {
+			if (mods[j] == mod)
+				break;
+		}
+		if (j < mods_cnt)
+			continue;
 
-	if (!try_module_get(mod))
-		return -EINVAL;
+		if (mods_cnt == mods_cap) {
+			struct module **new_mods;
 
-	args->mods[args->mods_cnt] = mod;
-	args->mods_cnt++;
-	return 0;
-}
+			mods_cap = max(16, mods_cap * 3 / 2);
+			new_mods = krealloc_array(mods, mods_cap, sizeof(*mods), GFP_KERNEL);
+			if (!new_mods) {
+				err = -ENOMEM;
+				goto failed;
+			}
+			mods = new_mods;
+		}
 
-static int get_modules_for_addrs(struct module ***mods, unsigned long *addrs, u32 addrs_cnt)
-{
-	struct module_addr_args args = {
-		.addrs     = addrs,
-		.addrs_cnt = addrs_cnt,
-	};
-	int err;
+		if (!try_module_get(mod)) {
+			err = -EINVAL;
+			goto failed;
+		}
 
-	/* We return either err < 0 in case of error, ... */
-	err = module_kallsyms_on_each_symbol(NULL, module_callback, &args);
-	if (err) {
-		kprobe_multi_put_modules(args.mods, args.mods_cnt);
-		kfree(args.mods);
-		return err;
+		mods[mods_cnt] = mod;
+		mods_cnt++;
 	}
 
-	/* or number of modules found if everything is ok. */
-	*mods = args.mods;
-	return args.mods_cnt;
+	*out_mods = mods;
+	return mods_cnt;
+
+failed:
+	kprobe_multi_put_modules(mods, mods_cnt);
+	kfree(mods);
+	return err;
 }
 
 int bpf_kprobe_multi_link_attach(const union bpf_attr *attr, struct bpf_prog *prog)
@@ -2859,13 +2845,6 @@ int bpf_kprobe_multi_link_attach(const union bpf_attr *attr, struct bpf_prog *pr
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
2.25.1

