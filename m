Return-Path: <live-patching+bounces-1375-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C352EAB1DE6
	for <lists+live-patching@lfdr.de>; Fri,  9 May 2025 22:20:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 124AEB241F8
	for <lists+live-patching@lfdr.de>; Fri,  9 May 2025 20:19:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5A96266B41;
	Fri,  9 May 2025 20:17:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hg92T/Vg"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC2D126656C;
	Fri,  9 May 2025 20:17:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746821875; cv=none; b=dHEqCjgbI/o+Hss2dm7A0YYLno9v/Rt4FSRMdI9jPAsL2WHKitstwDb+CmXNpN6OQYD/ebsK2ubTeYz2F4YEMJmOnPEE4G/1nOHSV1pPUEI87W4sg/eBuURityKD8/xOJairPyuM4YrIKe+6AhQo3dIlXmI36iO97bbvZrs7whs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746821875; c=relaxed/simple;
	bh=YyD6KDvlcm2ljvEKZEc8fYvgEk6IvDo2PvpCUwTOJmE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nmofumJXfjKWU2vB+h8Dg8QvOB+dU1llgz7COU95i/Rilv77zVzPwxHYyXDp0Z7oVhtb+NjiD4eeViPJH3wiPyNro4v8lgDhWbKFcHa7YYmtvwvtykzuXfT1uhaaf4F79BSCeJzRBNrV4VBlAg518Ps5uHfSRztx0JIFtw67ovQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hg92T/Vg; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 920E2C4CEE9;
	Fri,  9 May 2025 20:17:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746821875;
	bh=YyD6KDvlcm2ljvEKZEc8fYvgEk6IvDo2PvpCUwTOJmE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hg92T/VgT4yZHXxpKdOKJJ6R1KDniwxD7sZFosIXAdxZzsGFs6QF32pddr70S/Gsf
	 DluZlRmmMnw7IIXMNJaul7m6DRKRI6E4ucbru3hTccafT/KI2upT766WBr2RaxF1FA
	 G9Lb/doKrZQgH8tXQmfSSYdZxbNxQQh/qjbEu8ssYAgnschaaXslyhFL/1dh96YMO9
	 gSjscF8eLY9eNa+R7sKHko5uxEdfOe4F+xQ6gGTOSbR7EzIjeyzxO68bD52zDR3Cb/
	 v+afeearTstY2r2M7GepBdhXp7WL/QWGSL7736hn+oUhG6KFArrVtRB1ALBOvHx89l
	 vBwZ5qmc4Fxlg==
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
Subject: [PATCH v2 16/62] objtool: Fix interval tree insertion for zero-length symbols
Date: Fri,  9 May 2025 13:16:40 -0700
Message-ID: <ba2b5ce0a24edfdb074d9d6c829c0666be69893c.1746821544.git.jpoimboe@kernel.org>
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

Zero-length symbols get inserted in the wrong spot.  Fix that.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 tools/objtool/elf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/objtool/elf.c b/tools/objtool/elf.c
index a8a78b55d3ec..c024937eb12a 100644
--- a/tools/objtool/elf.c
+++ b/tools/objtool/elf.c
@@ -92,7 +92,7 @@ static inline unsigned long __sym_start(struct symbol *s)
 
 static inline unsigned long __sym_last(struct symbol *s)
 {
-	return s->offset + s->len - 1;
+	return s->offset + (s->len ? s->len - 1 : 0);
 }
 
 INTERVAL_TREE_DEFINE(struct symbol, node, unsigned long, __subtree_last,
-- 
2.49.0


