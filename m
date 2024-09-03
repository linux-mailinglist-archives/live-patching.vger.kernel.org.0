Return-Path: <live-patching+bounces-537-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 73A00969270
	for <lists+live-patching@lfdr.de>; Tue,  3 Sep 2024 06:00:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 31AF5282C94
	for <lists+live-patching@lfdr.de>; Tue,  3 Sep 2024 04:00:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABDEF1CE710;
	Tue,  3 Sep 2024 04:00:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ezFWIhFY"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84C481CE702;
	Tue,  3 Sep 2024 04:00:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725336031; cv=none; b=CXUyP24s6PX003wCBbV2rsQ3PSLLK/F5FF2NBtCpJVjSmfh2FK19riBSPolCXy+ct+aykbaXpfeGLZHPFm0TlDw4WNhcKF7LGxMT7LeevIAiJnMvdlUCB2JAT/FOnxzJS/rpqOZ/IQCz5EfIxbsa0lOP7cAdPiqF5EdSyh905oM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725336031; c=relaxed/simple;
	bh=p+eNZnmbPNAzBwrF+DnHcCqKwjEEMYp4aw6pdpoU2q8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dgmdqMQvlKxRZwMBBNV98bftg6zJSQxp64m73lB/FcvlNBIkKoS2v6Wwnj08pjBmZquQZSg7dlZF0EP5X4/sqkQI1PnUlwvexDh0OMayUgrvqbUjh86Dms5Py7/hzeeAcNdve2Lp2D/Klab44yjamG8Y1YvIvZ4lZ5YrrxeOK6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ezFWIhFY; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2921FC4CED1;
	Tue,  3 Sep 2024 04:00:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725336030;
	bh=p+eNZnmbPNAzBwrF+DnHcCqKwjEEMYp4aw6pdpoU2q8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ezFWIhFYecgcbF3EDR8Yup5jVRKouY6GLGQovs5q4c6ySWIEge1agxqTOrA8zQ3bW
	 hx6YPjG/5JDQGWE0pq3wOuAVCWU8rIUgeF59306zNzQ8m2ZlgCV+xLlnrfFNxZyYrR
	 QmVPCAQVWiBQJNPI9uj9adeAu5NUUZVfJ7b608V/73pY0z74Gp4/web9W461u/JLe+
	 9w2gv7AO3nHCvKDAnGCIBFHwHihkcn0quGCbi2610A9oC944fAF8PghG0HUrTjIn80
	 Vo099bVM+dG49OU23LDtQRcinPMB+2zibxxmL4KURHPokE894sogc8U6CyzXrPmjiZ
	 cVINuU7h1Fz7Q==
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: live-patching@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	x86@kernel.org,
	Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Jiri Kosina <jikos@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Marcos Paulo de Souza <mpdesouza@suse.com>,
	Song Liu <song@kernel.org>
Subject: [RFC 03/31] x86/kprobes: Remove STACK_FRAME_NON_STANDARD annotation
Date: Mon,  2 Sep 2024 20:59:46 -0700
Message-ID: <5902e2e9cfe2ed9224f165585d7e41f93bb04275.1725334260.git.jpoimboe@kernel.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <cover.1725334260.git.jpoimboe@kernel.org>
References: <cover.1725334260.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since commit 877b145f0f47 ("x86/kprobes: Move trampoline code into
RODATA"), the optprobe template code is no longer analyzed by objtool so
it doesn't need to be ignored.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 arch/x86/kernel/kprobes/opt.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/x86/kernel/kprobes/opt.c b/arch/x86/kernel/kprobes/opt.c
index 36d6809c6c9e..e46d1710e785 100644
--- a/arch/x86/kernel/kprobes/opt.c
+++ b/arch/x86/kernel/kprobes/opt.c
@@ -103,7 +103,6 @@ static void synthesize_set_arg1(kprobe_opcode_t *addr, unsigned long val)
 
 asm (
 			".pushsection .rodata\n"
-			"optprobe_template_func:\n"
 			".global optprobe_template_entry\n"
 			"optprobe_template_entry:\n"
 #ifdef CONFIG_X86_64
@@ -160,9 +159,6 @@ asm (
 			"optprobe_template_end:\n"
 			".popsection\n");
 
-void optprobe_template_func(void);
-STACK_FRAME_NON_STANDARD(optprobe_template_func);
-
 #define TMPL_CLAC_IDX \
 	((long)optprobe_template_clac - (long)optprobe_template_entry)
 #define TMPL_MOVE_IDX \
-- 
2.45.2


