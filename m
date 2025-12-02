Return-Path: <live-patching+bounces-1887-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 58541C9C9B0
	for <lists+live-patching@lfdr.de>; Tue, 02 Dec 2025 19:21:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 4C561348A49
	for <lists+live-patching@lfdr.de>; Tue,  2 Dec 2025 18:21:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E31B52D24A0;
	Tue,  2 Dec 2025 18:20:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BJ/ILAX1"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6BB12D1F64;
	Tue,  2 Dec 2025 18:20:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764699646; cv=none; b=nZG1KdjdEvTrhAzNmltIENB815GY4IGtTltZagSRmTq2HMBnUVCBjxvdwLIPZS5KWhUEL+ff7UsggQiBhtcViQNyJnLxIevMItIZOvRr9yA6LLwEZepJ09nVqg2oQaceM4875SHOjPH+6HxQcDR4UUd+EzkLjWab456QIKiyA60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764699646; c=relaxed/simple;
	bh=scklrFrMTQH39Z8x9LkFh0kIoQ2zLYug+90OWuZO7R8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HlhPFlEPpyOg2inrN0liQDFApRmINzo0OsZgK4NxLnYPIVc/s96ELkqb2XKOaC2B5gcV5/Xj/gfproix1+CZj+Da+NruJpbE+nqMDmOW+VUYogQlrdpItw0xAm9ajM3GKZ5dwhEpIvRIkr6AkoUvz7Em4GvfREDk8sFw8YukRVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BJ/ILAX1; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB7F3C16AAE;
	Tue,  2 Dec 2025 18:20:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764699646;
	bh=scklrFrMTQH39Z8x9LkFh0kIoQ2zLYug+90OWuZO7R8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BJ/ILAX1uyfrScOPCfzz7gWlV8c0eNahbecRy30HjEKNKIAbeP4GPrT8HhoP9Qvw3
	 gh9bDjuCZkEYJQDzqguWXvPcfr/lQ+a9ydDradWzGgonHnfibsWxSKxJZTZAXKtuKy
	 wYNFMSYyenDnjeMGGUlPdkgDG6zf9szAD4PYLAShDofnVJhXDrA7n6h3h8FB8850q8
	 4dn1HFkPo0ds96ZdSTp0V6CYBhaEaSg7JBAImcDPiqbfDmT+7JpV04WZgP3JzK1ubl
	 v6DYPsQBIyS0Zc/RMWKL6vWIW+rxBd7N2dc8S9936A+LJozjlOdoznYNYaGGI7PTSo
	 xP4phFVDEvy8w==
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
	live-patching@vger.kernel.org,
	bpf@vger.kernel.org,
	Andrey Grodzovsky <andrey.grodzovsky@crowdstrike.com>,
	Petr Mladek <pmladek@suse.com>,
	Song Liu <song@kernel.org>,
	Raja Khan <raja.khan@crowdstrike.com>,
	Miroslav Benes <mbenes@suse.cz>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 2/2] x86/unwind/orc: Support reliable unwinding through BPF stack frames
Date: Tue,  2 Dec 2025 10:19:19 -0800
Message-ID: <26bf6f9106478d5e5dd447b21ee15ebe84e0f7cd.1764699074.git.jpoimboe@kernel.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <cover.1764699074.git.jpoimboe@kernel.org>
References: <cover.1764699074.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

BPF JIT programs and trampolines use a frame pointer, so the current ORC
unwinder strategy of falling back to frame pointers (when an ORC entry
is missing) usually works in practice when unwinding through BPF JIT
stack frames.

However, that frame pointer fallback is just a guess, so the unwind gets
marked unreliable for live patching, which can cause livepatch
transition stalls.

Make the common case reliable by calling the bpf_has_frame_pointer()
helper to detect the valid frame pointer region of BPF JIT programs and
trampolines.

Fixes: ee9f8fce9964 ("x86/unwind: Add the ORC unwinder")
Reported-by: Andrey Grodzovsky <andrey.grodzovsky@crowdstrike.com>
Closes: https://lore.kernel.org/0e555733-c670-4e84-b2e6-abb8b84ade38@crowdstrike.com
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 arch/x86/kernel/unwind_orc.c | 39 +++++++++++++++++++++++++-----------
 1 file changed, 27 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kernel/unwind_orc.c b/arch/x86/kernel/unwind_orc.c
index 977ee75e047c..f610fde2d5c4 100644
--- a/arch/x86/kernel/unwind_orc.c
+++ b/arch/x86/kernel/unwind_orc.c
@@ -2,6 +2,7 @@
 #include <linux/objtool.h>
 #include <linux/module.h>
 #include <linux/sort.h>
+#include <linux/bpf.h>
 #include <asm/ptrace.h>
 #include <asm/stacktrace.h>
 #include <asm/unwind.h>
@@ -172,6 +173,25 @@ static struct orc_entry *orc_ftrace_find(unsigned long ip)
 }
 #endif
 
+/* Fake frame pointer entry -- used as a fallback for generated code */
+static struct orc_entry orc_fp_entry = {
+	.type		= ORC_TYPE_CALL,
+	.sp_reg		= ORC_REG_BP,
+	.sp_offset	= 16,
+	.bp_reg		= ORC_REG_PREV_SP,
+	.bp_offset	= -16,
+};
+
+static struct orc_entry *orc_bpf_find(unsigned long ip)
+{
+#ifdef CONFIG_BPF_JIT
+	if (bpf_has_frame_pointer(ip))
+		return &orc_fp_entry;
+#endif
+
+	return NULL;
+}
+
 /*
  * If we crash with IP==0, the last successfully executed instruction
  * was probably an indirect function call with a NULL function pointer,
@@ -186,15 +206,6 @@ static struct orc_entry null_orc_entry = {
 	.type = ORC_TYPE_CALL
 };
 
-/* Fake frame pointer entry -- used as a fallback for generated code */
-static struct orc_entry orc_fp_entry = {
-	.type		= ORC_TYPE_CALL,
-	.sp_reg		= ORC_REG_BP,
-	.sp_offset	= 16,
-	.bp_reg		= ORC_REG_PREV_SP,
-	.bp_offset	= -16,
-};
-
 static struct orc_entry *orc_find(unsigned long ip)
 {
 	static struct orc_entry *orc;
@@ -238,6 +249,11 @@ static struct orc_entry *orc_find(unsigned long ip)
 	if (orc)
 		return orc;
 
+	/* BPF lookup: */
+	orc = orc_bpf_find(ip);
+	if (orc)
+		return orc;
+
 	return orc_ftrace_find(ip);
 }
 
@@ -495,9 +511,8 @@ bool unwind_next_frame(struct unwind_state *state)
 	if (!orc) {
 		/*
 		 * As a fallback, try to assume this code uses a frame pointer.
-		 * This is useful for generated code, like BPF, which ORC
-		 * doesn't know about.  This is just a guess, so the rest of
-		 * the unwind is no longer considered reliable.
+		 * This is just a guess, so the rest of the unwind is no longer
+		 * considered reliable.
 		 */
 		orc = &orc_fp_entry;
 		state->error = true;
-- 
2.51.1


