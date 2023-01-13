Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 113E0669AC5
	for <lists+live-patching@lfdr.de>; Fri, 13 Jan 2023 15:43:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229789AbjAMOnK (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 13 Jan 2023 09:43:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229682AbjAMOmn (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 13 Jan 2023 09:42:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC59D42E2D;
        Fri, 13 Jan 2023 06:33:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5743561E1B;
        Fri, 13 Jan 2023 14:33:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6394DC433EF;
        Fri, 13 Jan 2023 14:33:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673620416;
        bh=2J0aMTFCQbEQOHeAHIEVXW0hTFVGR9Cw2MSUZwhnyFk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SKjs3HRUwC3u9jl5Nn4KbCsxxMWZSEcl7ptvQ+HtkDjIG2Ux6jEP7vCZYnu9X4lFD
         QTkwdDlijt/80oeVdP78lFdyET6NpyGVoi2SKPaU4vSAJ5X9qRfi4P3EKJVsGYx0fh
         VMWwyawjVMBZBLxlIoS0ra3xs8MvNGb5GsVey1bGXilwlo88xnfGU7vzwg6FKMJPMU
         EQiae7/6gwpDWWSRgbx+N8p1U7DsZ6F3FnbVmXGeO5NMO8llxGm8VLTSkjzOjxftEK
         a1t3HE/UtXOeB1BhCWmaVpxxPvtyLofV+Uh3Fq2puPVOYdiNww/I+ZtXKtfHaYCKEO
         CdqwG+sK0G5sg==
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
Subject: [PATCHv2 bpf-next 2/3] selftests/bpf: Add serial_test_kprobe_multi_bench_attach_kernel/module tests
Date:   Fri, 13 Jan 2023 15:33:02 +0100
Message-Id: <20230113143303.867580-3-jolsa@kernel.org>
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

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 .../bpf/prog_tests/kprobe_multi_test.c        | 21 ++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/kprobe_multi_test.c b/tools/testing/selftests/bpf/prog_tests/kprobe_multi_test.c
index c6f37e825f11..017a6996f3fa 100644
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
@@ -453,6 +454,16 @@ void serial_test_kprobe_multi_bench_attach(void)
 	}
 }
 
+void serial_test_kprobe_multi_bench_attach_kernel(void)
+{
+	test_kprobe_multi_bench_attach(true);
+}
+
+void serial_test_kprobe_multi_bench_attach_module(void)
+{
+	test_kprobe_multi_bench_attach(false);
+}
+
 void test_kprobe_multi_test(void)
 {
 	if (!ASSERT_OK(load_kallsyms(), "load_kallsyms"))
-- 
2.39.0

