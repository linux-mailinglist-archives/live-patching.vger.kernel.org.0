Return-Path: <live-patching+bounces-1681-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E6F80B80DA6
	for <lists+live-patching@lfdr.de>; Wed, 17 Sep 2025 18:08:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9D8AA3B3162
	for <lists+live-patching@lfdr.de>; Wed, 17 Sep 2025 16:08:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B67A301472;
	Wed, 17 Sep 2025 16:04:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qEiP77Ya"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E753830102E;
	Wed, 17 Sep 2025 16:04:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758125075; cv=none; b=Cw+owAJ6W28j7zRitSQ/3KfY8JFRlB76sS7pZg41FrXwNdXy4whAmV+c2lp84QQVWSxm7l58dqY3OknrmQ1BHsyVw6dfY/afyzj34SJ5fER9FG1W05GDi1z7/JN5PMa33TzCaJfYgcjuXcCYC+gtOeOcfxdgyw+rCdmMeyFMEs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758125075; c=relaxed/simple;
	bh=lFJ9YxQpZt3X8KlnmSlyDMIz/NXceeCehMslUZeYpNw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d+R3rCpp6vOj/hLdq9BtRPN7/DzJK+7k6lPc9c8+VMxI7waVici9vMy3Ugf3gJ3Xio9h7LJ9sywi8zoZHTT2OsovYCHyIiWvogfp/HEr+PC+If4p1JfoxeC8l1J6aHB4DRclChNzDwBYtcCsW4iTAMiOcylCToRJwDad0GU2Ml0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qEiP77Ya; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42246C4CEFA;
	Wed, 17 Sep 2025 16:04:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758125074;
	bh=lFJ9YxQpZt3X8KlnmSlyDMIz/NXceeCehMslUZeYpNw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qEiP77Ya7e0rf5++37dvumJRAVdANegvQrh7wNnTTSmAAdwcnNMGRPdtrqnOg24AY
	 X7UNN4c9mZ5Z9NDfu7tlkvXVAyE0Ca9Bk6oBv2CTWTpsS/diRsN0lsN7R4DfRi5mXl
	 fF8f1CYh8N/7RlwpLN4tDKa0w5TjRHYR/6ciSoSugi8+NiRyj6oOQfcuxH7P0Paqf8
	 iQZb7QGCz975GWJd/bM6HehuO1md9GzoyMryo9XxCGe/ITj2jTdSZH5Vjeov0LX6RX
	 SoCKXo7v41DVlt9yPxbmVYAeqNpZkm8uGy42wrQFx0M4sAnbVrKA1Cfqt39h6iVFdn
	 kto0/ZQwPZfZg==
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
	Puranjay Mohan <puranjay@kernel.org>,
	Dylan Hatch <dylanbhatch@google.com>,
	Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH v4 26/63] objtool: Remove .parainstructions reference
Date: Wed, 17 Sep 2025 09:03:34 -0700
Message-ID: <f126692adacc8be58d6cbc264e2181650812750c.1758067943.git.jpoimboe@kernel.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <cover.1758067942.git.jpoimboe@kernel.org>
References: <cover.1758067942.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The .parainstructions section no longer exists since the following
commit:

  60bc276b129e ("x86/paravirt: Switch mixed paravirt/alternative calls to alternatives").

Remove the reference to it.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 tools/objtool/check.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index 48b90836ed4a5..253d52205616a 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -4477,7 +4477,6 @@ static int validate_ibt(struct objtool_file *file)
 		    !strcmp(sec->name, ".altinstructions")		||
 		    !strcmp(sec->name, ".ibt_endbr_seal")		||
 		    !strcmp(sec->name, ".orc_unwind_ip")		||
-		    !strcmp(sec->name, ".parainstructions")		||
 		    !strcmp(sec->name, ".retpoline_sites")		||
 		    !strcmp(sec->name, ".smp_locks")			||
 		    !strcmp(sec->name, ".static_call_sites")		||
-- 
2.50.0


