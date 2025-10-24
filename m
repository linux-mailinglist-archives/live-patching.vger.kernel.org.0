Return-Path: <live-patching+bounces-1795-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8624DC04A72
	for <lists+live-patching@lfdr.de>; Fri, 24 Oct 2025 09:15:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E44F61A6876A
	for <lists+live-patching@lfdr.de>; Fri, 24 Oct 2025 07:15:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68DE62BE7BE;
	Fri, 24 Oct 2025 07:13:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eE9dPGYl"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D17729C327;
	Fri, 24 Oct 2025 07:13:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761290003; cv=none; b=NyPL6HFdUI9ypYs8K6DDcr7lChSATWobD8QhydI7Mx5pe0kUndAl4gAJMDCL9hyWgVyHCy28CnhyEIQLirLj+j3tw8XRD8oyLI7kipazTfhccxFs1HRyi7/ZwCYKn06UG45rAkWdmWJh1bW4JNJrq+OzSyiP9EJArUJeeh8TxBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761290003; c=relaxed/simple;
	bh=euNXfmHSdLMS8YZpkPG5vNkUc0h98/CM2xKpVLwz8dA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NZfIH03qZkUJud0S91eGj239xE95egNb9+EUjxulXyHWrMhQf+8DkBfOjrNFvhm4GhReJHolnwA8vy9n964EwYeLpN3hyaOY2bWmkmwxDzoSgACG2zH62t+W6PyWDpWbwpYoYtH7HjBpm7+BKqUxyiYEtFgOX9Kf4e2ajfI3wJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eE9dPGYl; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3910C4CEF1;
	Fri, 24 Oct 2025 07:13:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761290002;
	bh=euNXfmHSdLMS8YZpkPG5vNkUc0h98/CM2xKpVLwz8dA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eE9dPGYlk5IdHIOGVkazj4pTfCGy1tXfT0umTTPanA/tJ/e6/bZhJMERzocVBIxC7
	 ollgTfe8Z6ZIoeygzT/mUrj+nFTIUjbCcxPd2JW/M5IjsIXSHE2w+d3tYGuy317Fwx
	 VO+wTAViaGkRzGQmJM5WuvjDhvRXqZG2ctR6rgrDBHP7olc7x5VTZlEbWVGqWfsWgp
	 umm3oJ2npVk9OhSL3P+9iEMNY5OAwfaoCin+Bi//Qeno8t04Zibhqj3MWPSyWIm08r
	 V/wfWfiGwPvLQ4wIv6pV5PTAvqPRPBaMRpGLOU0vc5rofzSo6qd8LhhmGoW5edmOS8
	 0YG5DxfqRwT+w==
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
	Song Liu <song@kernel.org>
Subject: [PATCH bpf-next 3/3] selftests/bpf: Add tests for livepatch + bpf trampoline
Date: Fri, 24 Oct 2025 00:12:57 -0700
Message-ID: <20251024071257.3956031-4-song@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251024071257.3956031-1-song@kernel.org>
References: <20251024071257.3956031-1-song@kernel.org>
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
---
 tools/testing/selftests/bpf/config            |   3 +
 .../bpf/prog_tests/livepatch_trampoline.c     | 113 ++++++++++++++++++
 .../bpf/progs/livepatch_trampoline.c          |  30 +++++
 3 files changed, 146 insertions(+)
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
index 000000000000..6326f957dbcd
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/livepatch_trampoline.c
@@ -0,0 +1,113 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2025 Meta Platforms, Inc. and affiliates. */
+
+#include <test_progs.h>
+#include "testing_helpers.h"
+#include "livepatch_trampoline.skel.h"
+
+static int load_livepatch(void)
+{
+	const char *livepatch_paths[] = {
+		"../../../../samples/livepatch/livepatch-sample.ko",
+		/* This is the path used by CI */
+		"/tmp/work/bpf/bpf/kbuild-output/samples/livepatch/livepatch-sample.ko",
+	};
+	int ret, i;
+
+	for (i = 0; i < sizeof(livepatch_paths) / sizeof(char *); i++) {
+		ret = load_module(livepatch_paths[i], env_verbosity > VERBOSE_NONE);
+		if (!ret)
+			break;
+	}
+	return ret;
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


