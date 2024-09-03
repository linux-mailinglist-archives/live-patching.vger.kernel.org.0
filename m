Return-Path: <live-patching+bounces-559-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D73896929B
	for <lists+live-patching@lfdr.de>; Tue,  3 Sep 2024 06:04:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 802E61C21641
	for <lists+live-patching@lfdr.de>; Tue,  3 Sep 2024 04:04:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 519BF1D6C72;
	Tue,  3 Sep 2024 04:00:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MKosp2+X"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 289961D6C66;
	Tue,  3 Sep 2024 04:00:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725336042; cv=none; b=S90HQN0Q2FW3+WhXG9mwAvJgMQygRYNXc+7pNWtA3DlgSNt+a5EFKLwHozgYrBSNKBUqr7JFW8nDfGRplaoeDBRbcddv3MeEBeWKOb8xOvxXuVU/fE9EoJJ+t909/5ya9uTDeZM86cWnNLBn8RpIX12Y2GbWVG59/Mfcj1qpqFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725336042; c=relaxed/simple;
	bh=Sc4bf3ztjo9/6o7oLEQrV45T7l6aiZqsKA2dwcuesFo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dg/A0MoldAiNm0Ym0lv15nSZzUnG8P0F2cQG1GzoguM/fg2BHi3DSQrRro5kM4ktK13T4GrmKxi/2508ZWuG28kwbqWackXbRJpbrQPJu1A7mF3jKPv2jHqHyDX+For6v72TY76xPsoj75csCSd7oh0p9m/qEeOIqQCzKB7b9KA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MKosp2+X; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C7B4C4CEC5;
	Tue,  3 Sep 2024 04:00:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725336042;
	bh=Sc4bf3ztjo9/6o7oLEQrV45T7l6aiZqsKA2dwcuesFo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MKosp2+XsmJIQk4/BTZehZ+u7F8+HtUtBg9voxcg8+cXBQWT08F1090LpLv8coNw+
	 yAm81iQ2dkvyd/rX+1DDCn181CLS5QrBAhl4Mdqd6v141BV5l24cqdpwb06nbLN/78
	 yMZBIcD7OEwMU8p89OmnQfnf2imdHHhsYqDeGcMb/M7+dzM2mWXTenvJL/tTj2oQB4
	 QcjO/2/Du6y8GBSZV/bD7iKvhf33ukexisjU1mn8OImVA/D7GfAn01r8yw3tRk53HV
	 hYmqFdCj4U5F1SpC0IL4RgE3Mg1lQtxh3EK6veJndYxnKaFK0sMrcLAF8ZA8uNcXvF
	 wNWmxe+teGp9g==
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
Subject: [RFC 25/31] objtool: Fix interval tree insertion for zero-length symbols
Date: Mon,  2 Sep 2024 21:00:08 -0700
Message-ID: <5b44cec6fa1b80b7059e557e5b37a3a673e27e90.1725334260.git.jpoimboe@kernel.org>
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

Zero-length symbols get inserted in the wrong spot.  Fix that.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 tools/objtool/elf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/objtool/elf.c b/tools/objtool/elf.c
index 49528e7835aa..42a657268306 100644
--- a/tools/objtool/elf.c
+++ b/tools/objtool/elf.c
@@ -94,7 +94,7 @@ static inline unsigned long __sym_start(struct symbol *s)
 
 static inline unsigned long __sym_last(struct symbol *s)
 {
-	return s->offset + s->len - 1;
+	return s->offset + (s->len ? s->len - 1 : 0);
 }
 
 INTERVAL_TREE_DEFINE(struct symbol, node, unsigned long, __subtree_last,
-- 
2.45.2


