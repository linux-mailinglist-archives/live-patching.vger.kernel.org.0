Return-Path: <live-patching+bounces-1389-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E50C9AB1E03
	for <lists+live-patching@lfdr.de>; Fri,  9 May 2025 22:23:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 943DB3B01F4
	for <lists+live-patching@lfdr.de>; Fri,  9 May 2025 20:22:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5D9A291874;
	Fri,  9 May 2025 20:18:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dVomlVuq"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F265290BC2;
	Fri,  9 May 2025 20:18:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746821886; cv=none; b=ToOBkqNUDtfuIKqzJnpRigmQwUULoG4C9QQk0pJ/rfEjNZE1r/87y9YN3Q8h5wwx8m78m5zdqw/QtgfKV0bORoi3g4SKUHAJUNWQtTt/0VmmPHuQgUD9to/vaR7iZmCKP54jiYbVCs39vYJias1p+ZD6cKTeMpIFAZJEHRz/Pp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746821886; c=relaxed/simple;
	bh=TCh7mN1dtaUkmUbKcMUgKaRQzRkSpr6K6e506gWbFxc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R1bpPl067Nt/uhHRb7rt6cGwNp7aqBBmU/kIwJClcVyN3SxYWSDgUNepR9s91h/rzwnkmot2PI5IzoTW735+cQ7U+IV0Ngc9igtZfpTdeabz5NyrBkcoItZ70Df21WE7okgXE8Q3BND8I2mgUJEfDCZatMjqlJmlreL2u9/g+Wc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dVomlVuq; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 749A4C4CEEE;
	Fri,  9 May 2025 20:18:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746821886;
	bh=TCh7mN1dtaUkmUbKcMUgKaRQzRkSpr6K6e506gWbFxc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dVomlVuqWJQIWdDDc3MebpfihTCirAtSplPO1VKcVQZ9HelUbAD/dWpRcj8bVwWlJ
	 CGPvPg7ol7/13NYE0VrYxQMVT6s1TfUqli2qBPVkc2pUDX45Y4IMOFrXuZk5icVafh
	 ZJkTfKCROla4+mY0tbJdfzIV9K/F4UWJwDtvM8fGQb5BqkvxrxqOPdFfTzU1+9I8Tu
	 wycRo7cK0Q7Xzy1HCqbn4Ka3Xa3cJdYVPASHBRQI+YaAScOrGS1OT2gKjvkBvBNLC9
	 UXZlSWNrhNRVpxoBSNWesBFWtf46TdLuIG80F7NbzEsiowpatNKLcqkkcS615dwZH2
	 qr/J1bzZ2LRwA==
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
	Petr Mladek <pmladek@suse.com>,
	Miroslav Benes <mbenes@suse.cz>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	live-patching@vger.kernel.org,
	Song Liu <song@kernel.org>,
	laokz <laokz@foxmail.com>,
	Jiri Kosina <jikos@kernel.org>,
	Marcos Paulo de Souza <mpdesouza@suse.com>,
	Weinan Liu <wnliu@google.com>,
	Fazla Mehrab <a.mehrab@bytedance.com>,
	Chen Zhongjin <chenzhongjin@huawei.com>,
	Puranjay Mohan <puranjay@kernel.org>
Subject: [PATCH v2 30/62] objtool: Simplify reloc offset calculation in unwind_read_hints()
Date: Fri,  9 May 2025 13:16:54 -0700
Message-ID: <c623904b170f2b5337cb8af9fdb32f2843e65812.1746821544.git.jpoimboe@kernel.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1746821544.git.jpoimboe@kernel.org>
References: <cover.1746821544.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Simplify the relocation offset calculation in unwind_read_hints(),
similar to other conversions which have already been done.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 tools/objtool/check.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index 6b2e57d9aaf8..c9f041168bce 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -2221,14 +2221,7 @@ static int read_unwind_hints(struct objtool_file *file)
 			return -1;
 		}
 
-		if (is_sec_sym(reloc->sym)) {
-			offset = reloc_addend(reloc);
-		} else if (reloc->sym->local_label) {
-			offset = reloc->sym->offset;
-		} else {
-			ERROR("unexpected relocation symbol type in %s", sec->rsec->name);
-			return -1;
-		}
+		offset = reloc->sym->offset + reloc_addend(reloc);
 
 		insn = find_insn(file, reloc->sym->sec, offset);
 		if (!insn) {
-- 
2.49.0


