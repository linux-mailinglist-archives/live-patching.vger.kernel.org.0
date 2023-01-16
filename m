Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 472B066BB59
	for <lists+live-patching@lfdr.de>; Mon, 16 Jan 2023 11:12:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230376AbjAPKMR (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 16 Jan 2023 05:12:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230423AbjAPKLr (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 16 Jan 2023 05:11:47 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2770C1C338;
        Mon, 16 Jan 2023 02:10:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 50E1CCE0FCE;
        Mon, 16 Jan 2023 10:10:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9FE4C433EF;
        Mon, 16 Jan 2023 10:10:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673863844;
        bh=5DDT8Sp02eS1UEuJrxq7KZNSFlE8WBC2+6m3PvubtEY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Iib2yqsI9K98A+b1/5n83yg1wvLFR1FV8TAD5jiMPWZO1hXNjmkqAEX5OThpS2MP7
         hA54/st207p32lHNWhVSqHDZ3bhh5iRASVca22fhvj8/y/XwCPf+jMNR7KbPQMbqHL
         s2JfxygBq3KIdNzfMvl40c6buL0wD+o/5Pt2ZW8hFcJnxnkin97XPJhv0k4M4EkiVz
         wwTwyJwzYV1yOQmi5nN25/quxViPdePcjX+Hz/tn89z7IiINaerZVtYhKyO/nUNJwT
         zp0nqXeh6cj7EojkoEYPEXAqyrOEz7BvfEBmAI6iXFSswij5t2cgFzbbC0YIqyPPs0
         1Nb5uax8KS4Wg==
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Zhen Lei <thunder.leizhen@huawei.com>
Cc:     Song Liu <song@kernel.org>, bpf@vger.kernel.org,
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
Subject: [PATCHv3 bpf-next 2/3] selftests/bpf: Add serial_test_kprobe_multi_bench_attach_kernel/module tests
Date:   Mon, 16 Jan 2023 11:10:08 +0100
Message-Id: <20230116101009.23694-3-jolsa@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116101009.23694-1-jolsa@kernel.org>
References: <20230116101009.23694-1-jolsa@kernel.org>
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

Add bench test for module portion of the symbols as well.

  # ./test_progs -v -t kprobe_multi_bench_attach_module
  bpf_testmod.ko is already unloaded.
  Loading bpf_testmod.ko...
  Successfully loaded bpf_testmod.ko.
  test_kprobe_multi_bench_attach:PASS:get_syms 0 nsec
  test_kprobe_multi_bench_attach:PASS:kprobe_multi_empty__open_and_load 0 nsec
  test_kprobe_multi_bench_attach:PASS:bpf_program__attach_kprobe_multi_opts 0 nsec
  test_kprobe_multi_bench_attach: found 26620 functions
  test_kprobe_multi_bench_attach: attached in   0.182s
  test_kprobe_multi_bench_attach: detached in   0.082s
  #96      kprobe_multi_bench_attach_module:OK
  Summary: 1/0 PASSED, 0 SKIPPED, 0 FAILED
  Successfully unloaded bpf_testmod.ko.

It's useful for testing kprobe multi link modules resolving.

Acked-by: Song Liu <song@kernel.org>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 .../bpf/prog_tests/kprobe_multi_test.c        | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/kprobe_multi_test.c b/tools/testing/selftests/bpf/prog_tests/kprobe_multi_test.c
index c6f37e825f11..113dba349a57 100644
--- a/tools/testing/selftests/bpf/prog_tests/kprobe_multi_test.c
+++ b/tools/testing/selftests/bpf/prog_tests/kprobe_multi_test.c
@@ -322,7 +322,7 @@ static bool symbol_equal(long key1, long key2, void *ctx __maybe_unused)
 	return strcmp((const char *) key1, (const char *) key2) == 0;
 }
 
-static int get_syms(char ***symsp, size_t *cntp)
+static int get_syms(char ***symsp, size_t *cntp, bool kernel)
 {
 	size_t cap = 0, cnt = 0, i;
 	char *name = NULL, **syms = NULL;
@@ -349,8 +349,9 @@ static int get_syms(char ***symsp, size_t *cntp)
 	}
 
 	while (fgets(buf, sizeof(buf), f)) {
-		/* skip modules */
-		if (strchr(buf, '['))
+		if (kernel && strchr(buf, '['))
+			continue;
+		if (!kernel && !strchr(buf, '['))
 			continue;
 
 		free(name);
@@ -404,7 +405,7 @@ static int get_syms(char ***symsp, size_t *cntp)
 	return err;
 }
 
-void serial_test_kprobe_multi_bench_attach(void)
+static void test_kprobe_multi_bench_attach(bool kernel)
 {
 	LIBBPF_OPTS(bpf_kprobe_multi_opts, opts);
 	struct kprobe_multi_empty *skel = NULL;
@@ -415,7 +416,7 @@ void serial_test_kprobe_multi_bench_attach(void)
 	char **syms = NULL;
 	size_t cnt = 0, i;
 
-	if (!ASSERT_OK(get_syms(&syms, &cnt), "get_syms"))
+	if (!ASSERT_OK(get_syms(&syms, &cnt, kernel), "get_syms"))
 		return;
 
 	skel = kprobe_multi_empty__open_and_load();
@@ -453,6 +454,14 @@ void serial_test_kprobe_multi_bench_attach(void)
 	}
 }
 
+void serial_test_kprobe_multi_bench_attach(void)
+{
+	if (test__start_subtest("kernel"))
+		test_kprobe_multi_bench_attach(true);
+	if (test__start_subtest("modules"))
+		test_kprobe_multi_bench_attach(false);
+}
+
 void test_kprobe_multi_test(void)
 {
 	if (!ASSERT_OK(load_kallsyms(), "load_kallsyms"))
-- 
2.39.0

