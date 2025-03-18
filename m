Return-Path: <live-patching+bounces-1292-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A79F2A67BC2
	for <lists+live-patching@lfdr.de>; Tue, 18 Mar 2025 19:15:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CBB583B195F
	for <lists+live-patching@lfdr.de>; Tue, 18 Mar 2025 18:15:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DDE1C2135A3;
	Tue, 18 Mar 2025 18:15:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iJTcEjJt"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA3E521325D
	for <live-patching@vger.kernel.org>; Tue, 18 Mar 2025 18:15:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742321729; cv=none; b=QoFZ+orRn7o/zEfKUEamnVi0t677u4EY36AntuPb6K8zVLtVRQTprFMENFmytS/J68tTIWFAKYUwxuGEK4eKQ6z5n/LhvrlOG80MLpgUKSxBFpX3ipfT56NtfaeEP83fVaZVoui+3BwaKfJ4MgD79ZLq5TMGaD/zEql25EN2XYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742321729; c=relaxed/simple;
	bh=vvqhkGPgJ3H/mH1A2xH31AdXx7j4JktQBI8OH44Yc84=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=lA+HVqjpHR0LOpW3PcDa12fHYqt8eTyFA7OYaFlD6uFF5IG1TBv4uuGy/Ti/Q0dg8ncRZdEJWa+o3gc6DUNFdieR5j5ilZGiqNr/lvH4KIoseX510hiFJzlsTDwBGIEpKptTPcpWbokobZaf9N3Dxfup/VYe9gN7moOtOX0X6aE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iJTcEjJt; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C00D2C4CEE9;
	Tue, 18 Mar 2025 18:15:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742321728;
	bh=vvqhkGPgJ3H/mH1A2xH31AdXx7j4JktQBI8OH44Yc84=;
	h=From:To:Cc:Subject:Date:From;
	b=iJTcEjJtSLRT9EEfeUZHihCekH8djR3JkI8/k5SjmT9sLxQhI9DWp9jVJJYI5KKkS
	 DcdccNQ5ulvzg2FKNbg1Q/pjy5hpZpnpdXdDnVzedXQXGA6YtJ5uFgzj56J4ZUwun4
	 ECTlS0lLbRMkevyiCJn9GKQhrNxHkRmAyoubeXOtBWcwuQ2guIrZRT3mXShsBJQz3Q
	 nnlrEKpgXRWpMvqFqP6Jeym9ayzr7VWgRJj4sh4z0ewU2In9bQT4OTY6ssJSmgdZ1H
	 s9MRtWV/mjko6B2livvjI/vVd67ZKYy2eoswrasw+DtIAQxGfE804M9HyGer0fiPKN
	 y0Rt9nfwq1WTw==
From: Song Liu <song@kernel.org>
To: live-patching@vger.kernel.org
Cc: joe.lawrence@redhat.com,
	jpoimboe@kernel.org,
	kernel-team@meta.com,
	song@kernel.org,
	jikos@kernel.org,
	mbenes@suse.cz,
	pmladek@suse.com
Subject: [PATCH v2] selftest/livepatch: Only run test-kprobe with CONFIG_KPROBES_ON_FTRACE
Date: Tue, 18 Mar 2025 11:15:18 -0700
Message-ID: <20250318181518.1055532-1-song@kernel.org>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

CONFIG_KPROBES_ON_FTRACE is required for test-kprobe. Skip test-kprobe
when CONFIG_KPROBES_ON_FTRACE is not set. Since some kernel may not have
/proc/config.gz, grep for kprobe_ftrace_ops from /proc/kallsyms to check
whether CONFIG_KPROBES_ON_FTRACE is enabled.

Signed-off-by: Song Liu <song@kernel.org>

---

Changes v1 => v2:
1. Grep for kprobe_ftrace_ops in /proc/kallsyms, as some systems may not
   have /proc/config.gz
---
 tools/testing/selftests/livepatch/test-kprobe.sh | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/livepatch/test-kprobe.sh b/tools/testing/selftests/livepatch/test-kprobe.sh
index 115065156016..e514391c5454 100755
--- a/tools/testing/selftests/livepatch/test-kprobe.sh
+++ b/tools/testing/selftests/livepatch/test-kprobe.sh
@@ -5,6 +5,8 @@
 
 . $(dirname $0)/functions.sh
 
+grep kprobe_ftrace_ops /proc/kallsyms || skip "test-kprobe requires CONFIG_KPROBES_ON_FTRACE"
+
 MOD_LIVEPATCH=test_klp_livepatch
 MOD_KPROBE=test_klp_kprobe
 
-- 
2.47.1


