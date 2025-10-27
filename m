Return-Path: <live-patching+bounces-1826-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 7FC67C0FCB5
	for <lists+live-patching@lfdr.de>; Mon, 27 Oct 2025 18:54:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id A83704FD64E
	for <lists+live-patching@lfdr.de>; Mon, 27 Oct 2025 17:51:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B633631987D;
	Mon, 27 Oct 2025 17:50:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YlJVXXb4"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E2A73191C0;
	Mon, 27 Oct 2025 17:50:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761587457; cv=none; b=uqEtRg93JLvH7IGslyXxv9yEY469GfFc8tWBbPEqczPWnq2kLk9T8r2xHL6qVxVBh4GIWYlS72lIUMozLqJXPP/VnfChIwsGEmVNNyt9KYBHcSOGepcd2hjXEcXi47i2kgpm/jBD4pfCSHxkOck5VadDFFSm2Pdp7b7sQtbACOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761587457; c=relaxed/simple;
	bh=VoFt1eWIRvU9K7JtarVvwZrLTy++5akKeuRJHTwEHk4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pcuvrVxdsMeF0HNOsVqdd/h96HIl2v8MCEZKoecPlxSMOecfroPRN1uQGqy2bJ6e5x7/dZUxsEb/1tBsED+JsKiSSi6YVJk/BiYxxSmuSXWItjuPOB6kgRare8AiSYVl4Iz1Oj+VcNE1VQGSO1Ugg3Tp/MBnkWaanigwWeFjoWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YlJVXXb4; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32D1EC4CEF1;
	Mon, 27 Oct 2025 17:50:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761587457;
	bh=VoFt1eWIRvU9K7JtarVvwZrLTy++5akKeuRJHTwEHk4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YlJVXXb4Y2ZztGQtGLH+RPMmjAbEvKyRTL45dcDcWg9wg/J/eBmLMpAMxXEC2CH4W
	 RyVK0WhQ5srGzC7cG5chJBw3MlpAtDrcL3giv19eP97BkmmC+ZCnj3gus79Heh+g/a
	 r44kt6V3YESP0WknV/ed8CxdoquDfyXThx3QjR45DcLlROZksHAQal0AM4gV5yupLc
	 ubTLP1nQYR3wEO7omh4R4VbZ+++SD9R7yLvalL7JhZLeSbrBRGmG9m10oK40394uGY
	 lp4yJ533CSJvCLQb+uxUjbu3rCqUvXteNfrwA+pZ/gviCfi/se2bfMOFA0Tfn8jby3
	 B+5dmKCTbZSHQ==
From: Song Liu <song@kernel.org>
To: bpf@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	live-patching@vger.kernel.org
Cc: ast@kernel.org,
	daniel@iogearbox.net,
	andrii@kernel.org,
	rostedt@goodmis.org,
	andrey.grodzovsky@crowdstrike.com,
	mhiramat@kernel.org,
	kernel-team@meta.com,
	olsajiri@gmail.com,
	Song Liu <song@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>
Subject: [PATCH v4 bpf 3/3] selftests/bpf: Add tests for livepatch + bpf trampoline
Date: Mon, 27 Oct 2025 10:50:23 -0700
Message-ID: <20251027175023.1521602-4-song@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251027175023.1521602-1-song@kernel.org>
References: <20251027175023.1521602-1-song@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Both livepatch and BPF trampoline use ftrace. Special attention is needed
when livepatch and fexit program touch the same function at the same
time, because livepatch updates a kernel function and the BPF trampoline
need to call into the right version of the kernel function.

Use samples/livepatch/livepatch-sample.ko for the test.

The test covers two cases:
  1) When a fentry program is loaded first. This exercises the
     modify_ftrace_direct code path.
  2) When a fentry program is loaded first. This exercises the
     register_ftrace_direct code path.

Signed-off-by: Song Liu <song@kernel.org>
Reviewed-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/testing/selftests/bpf/config            |   3 +
 .../bpf/prog_tests/livepatch_trampoline.c     | 107 ++++++++++++++++++
 .../bpf/progs/livepatch_trampoline.c          |  30 +++++
 3 files changed, 140 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/livepatch_trampoline.c
 create mode 100644 tools/testing/selftests/bpf/progs/livepatch_trampoline.c

diff --git a/tools/testing/selftests/bpf/config b/tools/testing/selftests/bpf/config
index 70b28c1e653e..f2a2fd236ca8 100644
--- a/tools/testing/selftests/bpf/config
+++ b/tools/testing/selftests/bpf/config
@@ -50,6 +50,7 @@ CONFIG_IPV6_SIT=y
 CONFIG_IPV6_TUNNEL=y
 CONFIG_KEYS=y
 CONFIG_LIRC=y
+CONFIG_LIVEPATCH=y
 CONFIG_LWTUNNEL=y
 CONFIG_MODULE_SIG=y
 CONFIG_MODULE_SRCVERSION_ALL=y
@@ -111,6 +112,8 @@ CONFIG_IP6_NF_FILTER=y
 CONFIG_NF_NAT=y
 CONFIG_PACKET=y
 CONFIG_RC_CORE=y
+CONFIG_SAMPLES=y
+CONFIG_SAMPLE_LIVEPATCH=m
 CONFIG_SECURITY=y
 CONFIG_SECURITYFS=y
 CONFIG_SYN_COOKIES=y
diff --git a/tools/testing/selftests/bpf/prog_tests/livepatch_trampoline.c b/tools/testing/selftests/bpf/prog_tests/livepatch_trampoline.c
new file mode 100644
index 000000000000..72aa5376c30e
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/livepatch_trampoline.c
@@ -0,0 +1,107 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2025 Meta Platforms, Inc. and affiliates. */
+
+#include <test_progs.h>
+#include "testing_helpers.h"
+#include "livepatch_trampoline.skel.h"
+
+static int load_livepatch(void)
+{
+	char path[4096];
+
+	/* CI will set KBUILD_OUTPUT */
+	snprintf(path, sizeof(path), "%s/samples/livepatch/livepatch-sample.ko",
+		 getenv("KBUILD_OUTPUT") ? : "../../../..");
+
+	return load_module(path, env_verbosity > VERBOSE_NONE);
+}
+
+static void unload_livepatch(void)
+{
+	/* Disable the livepatch before unloading the module */
+	system("echo 0 > /sys/kernel/livepatch/livepatch_sample/enabled");
+
+	unload_module("livepatch_sample", env_verbosity > VERBOSE_NONE);
+}
+
+static void read_proc_cmdline(void)
+{
+	char buf[4096];
+	int fd, ret;
+
+	fd = open("/proc/cmdline", O_RDONLY);
+	if (!ASSERT_OK_FD(fd, "open /proc/cmdline"))
+		return;
+
+	ret = read(fd, buf, sizeof(buf));
+	if (!ASSERT_GT(ret, 0, "read /proc/cmdline"))
+		goto out;
+
+	ASSERT_OK(strncmp(buf, "this has been live patched", 26), "strncmp");
+
+out:
+	close(fd);
+}
+
+static void __test_livepatch_trampoline(bool fexit_first)
+{
+	struct livepatch_trampoline *skel = NULL;
+	int err;
+
+	skel = livepatch_trampoline__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "skel_open_and_load"))
+		goto out;
+
+	skel->bss->my_pid = getpid();
+
+	if (!fexit_first) {
+		/* fentry program is loaded first by default */
+		err = livepatch_trampoline__attach(skel);
+		if (!ASSERT_OK(err, "skel_attach"))
+			goto out;
+	} else {
+		/* Manually load fexit program first. */
+		skel->links.fexit_cmdline = bpf_program__attach(skel->progs.fexit_cmdline);
+		if (!ASSERT_OK_PTR(skel->links.fexit_cmdline, "attach_fexit"))
+			goto out;
+
+		skel->links.fentry_cmdline = bpf_program__attach(skel->progs.fentry_cmdline);
+		if (!ASSERT_OK_PTR(skel->links.fentry_cmdline, "attach_fentry"))
+			goto out;
+	}
+
+	read_proc_cmdline();
+
+	ASSERT_EQ(skel->bss->fentry_hit, 1, "fentry_hit");
+	ASSERT_EQ(skel->bss->fexit_hit, 1, "fexit_hit");
+out:
+	livepatch_trampoline__destroy(skel);
+}
+
+void test_livepatch_trampoline(void)
+{
+	int retry_cnt = 0;
+
+retry:
+	if (load_livepatch()) {
+		if (retry_cnt) {
+			ASSERT_OK(1, "load_livepatch");
+			goto out;
+		}
+		/*
+		 * Something else (previous run of the same test?) loaded
+		 * the KLP module. Unload the KLP module and retry.
+		 */
+		unload_livepatch();
+		retry_cnt++;
+		goto retry;
+	}
+
+	if (test__start_subtest("fentry_first"))
+		__test_livepatch_trampoline(false);
+
+	if (test__start_subtest("fexit_first"))
+		__test_livepatch_trampoline(true);
+out:
+	unload_livepatch();
+}
diff --git a/tools/testing/selftests/bpf/progs/livepatch_trampoline.c b/tools/testing/selftests/bpf/progs/livepatch_trampoline.c
new file mode 100644
index 000000000000..15579d5bcd91
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/livepatch_trampoline.c
@@ -0,0 +1,30 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2025 Meta Platforms, Inc. and affiliates. */
+
+#include <linux/bpf.h>
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+
+int fentry_hit;
+int fexit_hit;
+int my_pid;
+
+SEC("fentry/cmdline_proc_show")
+int BPF_PROG(fentry_cmdline)
+{
+	if (my_pid != (bpf_get_current_pid_tgid() >> 32))
+		return 0;
+
+	fentry_hit = 1;
+	return 0;
+}
+
+SEC("fexit/cmdline_proc_show")
+int BPF_PROG(fexit_cmdline)
+{
+	if (my_pid != (bpf_get_current_pid_tgid() >> 32))
+		return 0;
+
+	fexit_hit = 1;
+	return 0;
+}
-- 
2.47.3


