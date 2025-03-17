Return-Path: <live-patching+bounces-1281-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 62DEDA65931
	for <lists+live-patching@lfdr.de>; Mon, 17 Mar 2025 17:56:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B351D1657F2
	for <lists+live-patching@lfdr.de>; Mon, 17 Mar 2025 16:54:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 581B5185920;
	Mon, 17 Mar 2025 16:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QmHmxsnd"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 338DA17A2EB
	for <live-patching@vger.kernel.org>; Mon, 17 Mar 2025 16:52:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742230323; cv=none; b=YojEggWyxP6Hh7rkp68NYKiXd3i6lLpmAA93FXwEc4NUp8s8X0pq9uTeo2/x0WB511wGoBNaNwmD16R1wAYpFSiwaI50aeZ5MAxv6YDD8mjgZxYIkOX7xCgdwYOvGprB2pJ6YAKsMYpOyJlcjyX10q6megzypfIVAY+RJsOW8lo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742230323; c=relaxed/simple;
	bh=WndUuMSqZgiLO+wa2saUSvO8KXQanFTndMSxZq3QlnI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=nt/cy1XLptTgpHqxtUgdXQTB93SqXKx2H+i8OgRhVN+NMiEDWSjkJoypwcGPEE3LnxdcHTEs0ixv2QhrrIPYpODeFHW/1WOSuZFrm8OyyVN3Fqbc6OBC+BrQaNyPZpzx7ruTLkM+m++IvZrgVYMPsYN+9+l2a+tfkHxCXXY9cxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QmHmxsnd; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BA42C4CEE3;
	Mon, 17 Mar 2025 16:52:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742230322;
	bh=WndUuMSqZgiLO+wa2saUSvO8KXQanFTndMSxZq3QlnI=;
	h=From:To:Cc:Subject:Date:From;
	b=QmHmxsndv43utRtlgzcfUHMtNueHA2AfCOvHBpfkQLRMwPgH1STPLGQeEaLwbNga0
	 /+mvig6NQ8/4zd6r00nJ4zxiPQxA8cEv0G68lhm05Oln5uoB5LhDdOWauQzwWJo3Gb
	 HWvUoHlNVQkzB4j9whq5vN5uyuZqsrg14C0/8qls8JSA8Tok5KY6K0X0Y4s/I2Lo64
	 OVx6Mndzio0dz5Kp6KITY1AQ+3RVM11Wgb+XCQH16UlfB6XY362ASmWKCu7Jbrl5vf
	 NZp5n6F004ihrOeYPsdAORGktEeyJk5OYst/xJ4HtzNQ0QqyfIO7lwY6bApRraaCDY
	 M/71qWlezJj9A==
From: Song Liu <song@kernel.org>
To: live-patching@vger.kernel.org
Cc: joe.lawrence@redhat.com,
	jpoimboe@kernel.org,
	kernel-team@meta.com,
	song@kernel.org,
	jikos@kernel.org,
	mbenes@suse.cz,
	pmladek@suse.com
Subject: [PATCH] selftest/livepatch: Only run test-kprobe with CONFIG_KPROBES_ON_FTRACE
Date: Mon, 17 Mar 2025 09:51:28 -0700
Message-ID: <20250317165128.2356385-1-song@kernel.org>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

CONFIG_KPROBES_ON_FTRACE is required for test-kprobe. Skip test-kprobe
when CONFIG_KPROBES_ON_FTRACE is not set.

Signed-off-by: Song Liu <song@kernel.org>
---
 tools/testing/selftests/livepatch/test-kprobe.sh | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/livepatch/test-kprobe.sh b/tools/testing/selftests/livepatch/test-kprobe.sh
index 115065156016..fd823dd5dd7f 100755
--- a/tools/testing/selftests/livepatch/test-kprobe.sh
+++ b/tools/testing/selftests/livepatch/test-kprobe.sh
@@ -5,6 +5,8 @@
 
 . $(dirname $0)/functions.sh
 
+zgrep KPROBES_ON_FTRACE /proc/config.gz || skip "test-kprobe requires CONFIG_KPROBES_ON_FTRACE"
+
 MOD_LIVEPATCH=test_klp_livepatch
 MOD_KPROBE=test_klp_kprobe
 
-- 
2.47.1


