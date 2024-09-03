Return-Path: <live-patching+bounces-558-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8428B969299
	for <lists+live-patching@lfdr.de>; Tue,  3 Sep 2024 06:04:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4207D2823A5
	for <lists+live-patching@lfdr.de>; Tue,  3 Sep 2024 04:04:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2EBA1D6C4E;
	Tue,  3 Sep 2024 04:00:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nOZ/0hSz"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96EC41D6C41;
	Tue,  3 Sep 2024 04:00:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725336041; cv=none; b=D8+n/OPVJa0u+iBcBWhkRb2iOUKDSCh8c6DZgwHCNiWe7gV6rOHQ9dPwWY5qlcSZ6qnHsBnYOnro0lbY1IV2Q/M6wUmRjKDY3oxQ5FVOizTqosjoCS92W/uhmiA9bHuhRZcmi2RhPiVES0GIdwXQvEaiCaUvc78zkZ06Uig1qwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725336041; c=relaxed/simple;
	bh=XXdyiXX1GCdB3j+QVtVXuuqcqiTXMHJpdUI+rw+aD2A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sn2XxXdbx5xzpvwcl7XjaTUkJ++ITqAooEL2/1BPoMZWazFfEn3Mrs8d1OOAnslrQgy4YeS1be77zo/vRt7Uvt1hEg28l3lMsTTr8b73F9W3oVW+Rotl3p7dvTUIS3Jz2v5Bu6xcbnAJ3D3381B74Z0mrg4QZIOQIQGyBFjw/uQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nOZ/0hSz; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20D38C4CEC7;
	Tue,  3 Sep 2024 04:00:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725336041;
	bh=XXdyiXX1GCdB3j+QVtVXuuqcqiTXMHJpdUI+rw+aD2A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nOZ/0hSzrhoDJ1VxreT/niydB1BKi8c0ddJX2Q5wgb2YqQa3bl/5Oytkyz/uXv05r
	 P5jFSjUUNAg2xJUmWvnU+gGet5QfcA2DuYhqp1XZpcP5tKXEaR6oWaPG4BjWfJdOFB
	 qOU+V21nyr0Rk7W2gKCrJu0mv+Nl5XCt0uM5abFcMG7U3lHK9NFWzwzCesS3ej/Bnd
	 ntoS5iTJsYfu9iLgRPJqmRU+Cr1cLdi/aQxFUwV0upWhy3umvurRrZb9EeT3faOUe4
	 5wNwdJAxL/0u3c6aSx7Oj6GD8GAUoMuCkkEtuBOanFvGT4gD+WVzh8RvcPu8L2rj0u
	 dHhnyM2u15Ljw==
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
Subject: [RFC 24/31] objtool: Make STACK_FRAME_NON_STANDARD consistent
Date: Mon,  2 Sep 2024 21:00:07 -0700
Message-ID: <e06778646fdcf3013a6a64978971d88cfaafd35c.1725334260.git.jpoimboe@kernel.org>
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

The C version of STACK_FRAME_NON_STANDARD differs from its asm
counterpart:

- it uses an 8-byte entry (vs 4-byte)
- it creates a superfluous temporary variable

Make it identical to the asm version.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 include/linux/objtool.h | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/include/linux/objtool.h b/include/linux/objtool.h
index b3b8d3dab52d..5e66b6d26df5 100644
--- a/include/linux/objtool.h
+++ b/include/linux/objtool.h
@@ -30,9 +30,10 @@
  *
  * For more information, see tools/objtool/Documentation/objtool.txt.
  */
-#define STACK_FRAME_NON_STANDARD(func) \
-	static void __used __section(".discard.func_stack_frame_non_standard") \
-		*__func_stack_frame_non_standard_##func = func
+#define STACK_FRAME_NON_STANDARD(func)						\
+	asm(".pushsection .discard.func_stack_frame_non_standard, \"aw\"\n\t"	\
+	    ".long " __stringify(func) " - .\n\t"						\
+	    ".popsection")
 
 /*
  * STACK_FRAME_NON_STANDARD_FP() is a frame-pointer-specific function ignore
-- 
2.45.2


