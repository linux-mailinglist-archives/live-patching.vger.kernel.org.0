Return-Path: <live-patching+bounces-1842-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id E4DA4C54CF9
	for <lists+live-patching@lfdr.de>; Thu, 13 Nov 2025 00:32:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 8258A346B02
	for <lists+live-patching@lfdr.de>; Wed, 12 Nov 2025 23:32:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6537C2737F3;
	Wed, 12 Nov 2025 23:32:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ACMwwMdR"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D619146588;
	Wed, 12 Nov 2025 23:32:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762990363; cv=none; b=gS3h0PCWJj2M7F106lbpJszIzh6oUfSMv6XlGBaHxZjb+uU9jHo1d0obxJC+0Wd0CzzGdxmOqLLC0hWfgo/rFTBt5NlJrMUNbJ/e0i/K9DrFRSD9v3ikk5eDS9kPqyUxvmIAfRVe8eDB8ZU0OZCKaESGRWbBd1mdNVaUGsO0KPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762990363; c=relaxed/simple;
	bh=OkQXE+lnP5hRJk/Di2siaFj9iXzMJ2ap3je26zizQ7U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SYxLzjO44c2pIsqxL5mX25YiXR5g0oUhcIx/jxYdn5jTjZ55xA3bTGcJIuLq1giWSJJWvyvG8Q+khqVzY6/7SrWKSPNcW/1EGRVKrNv8FnQ98ZV0wSMdRlj1dbHcocbLjptCpVAOqgFgFZtqNkbzBNqmF75+ZCR0oJx7RRZUZ2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ACMwwMdR; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FD6EC113D0;
	Wed, 12 Nov 2025 23:32:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762990362;
	bh=OkQXE+lnP5hRJk/Di2siaFj9iXzMJ2ap3je26zizQ7U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ACMwwMdRxNoxRFsI93puAfaTUkyWOczAKg1cv0DT7mcKYd+eU37iIK1PDY65X8r5S
	 dvuYQhm9DD1dNs9TV+7+K9y2jbTB51qLOgPYGPRXb/I9ri3kcZEg7pU9asbgiPAvPT
	 TFrmPZADdxVvYq+6VbvVQKBU4xKeiEhi9UEYGTq8sDEhxWSf54MjKXPbZJSoIoenwN
	 m9Zle+HpfFeKQp+w66VaEhJi0/Y/EO6VtBbEY5isfAtuoH8ClSeVmJbxysXy6rTJUV
	 3ilG92zTWFRRESeq9CRnuzQ/AukdgPh8Hli0464K1tO2XOwsowuHFlYbXcDm9NjUxU
	 ZS7KMt0pi+Ylg==
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
	Peter Zijlstra <peterz@infradead.org>,
	Michael Kelley <mhklinux@outlook.com>,
	live-patching@vger.kernel.org
Subject: [PATCH 1/2] objtool: Set minimum xxhash version to 0.8
Date: Wed, 12 Nov 2025 15:32:33 -0800
Message-ID: <7227c94692a3a51840278744c7af31b4797c6b96.1762990139.git.jpoimboe@kernel.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <cover.1762990139.git.jpoimboe@kernel.org>
References: <cover.1762990139.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

XXH3 is only supported starting with xxhash 0.8.  Enforce that.

Fixes: 0d83da43b1e1 ("objtool/klp: Add --checksum option to generate per-function checksums")
Reported-by: Michael Kelley <mhklinux@outlook.com>
Closes: https://lore.kernel.org/SN6PR02MB41579B83CD295C9FEE40EED6D4FCA@SN6PR02MB4157.namprd02.prod.outlook.com
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 tools/objtool/Makefile        | 2 +-
 tools/objtool/builtin-check.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/objtool/Makefile b/tools/objtool/Makefile
index 48928c9bebef..021f55b7bd87 100644
--- a/tools/objtool/Makefile
+++ b/tools/objtool/Makefile
@@ -12,7 +12,7 @@ ifeq ($(SRCARCH),loongarch)
 endif
 
 ifeq ($(ARCH_HAS_KLP),y)
-	HAVE_XXHASH = $(shell echo "int main() {}" | \
+	HAVE_XXHASH = $(shell printf "$(pound)include <xxhash.h>\nXXH3_state_t *state;int main() {}" | \
 		      $(HOSTCC) -xc - -o /dev/null -lxxhash 2> /dev/null && echo y || echo n)
 	ifeq ($(HAVE_XXHASH),y)
 		BUILD_KLP	 := y
diff --git a/tools/objtool/builtin-check.c b/tools/objtool/builtin-check.c
index 1e1ea8396eb3..aab7fa9c7e00 100644
--- a/tools/objtool/builtin-check.c
+++ b/tools/objtool/builtin-check.c
@@ -164,7 +164,7 @@ static bool opts_valid(void)
 
 #ifndef BUILD_KLP
 	if (opts.checksum) {
-		ERROR("--checksum not supported; install xxhash-devel/libxxhash-dev and recompile");
+		ERROR("--checksum not supported; install xxhash-devel/libxxhash-dev (version >= 0.8) and recompile");
 		return false;
 	}
 #endif
-- 
2.51.1


