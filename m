Return-Path: <live-patching+bounces-1383-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AA1D3AB1DFE
	for <lists+live-patching@lfdr.de>; Fri,  9 May 2025 22:23:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8098C18999D7
	for <lists+live-patching@lfdr.de>; Fri,  9 May 2025 20:22:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A31026B0BF;
	Fri,  9 May 2025 20:18:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L1qAnbxk"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7134E25F7A2;
	Fri,  9 May 2025 20:18:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746821881; cv=none; b=cMlZ01sA6apE3oPH56XveKeR5hiz7wSSGmaaOBP2sA3MLsfS4UBy7QbaFOlSuUpEM75UjjUZwivXxljpdjfhIs2fWCXJftNFv9xQtoNbLvx3Q3YjxtyTlHAXf4C0yvbXo4MHTvKhSey1stjvj/rowQjI5SYLoBS75VS3GjfbnHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746821881; c=relaxed/simple;
	bh=zUNMQu1kVpk4KDqVdNxQAeQ0l+ZQ+8XZPtXWEdwjJGA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eotE6G/KS53IMu3WbrM9+Cy8zql8ATd1z2+HLEfbYk8Bg5P9WogcRAJqee0pV8z15ZCkaLQAGRq/DGOy2Jlnp+aa0aBBtjwA5QOwFn5Ei6QZpFM1y78/mZuH7odhDLwH38bj226TPcmCgvXw/Fvh9GkVZTxMzfCP2mxqGFONKKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L1qAnbxk; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E1DAC4CEEE;
	Fri,  9 May 2025 20:18:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746821881;
	bh=zUNMQu1kVpk4KDqVdNxQAeQ0l+ZQ+8XZPtXWEdwjJGA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L1qAnbxkYpsWxUom8K6GZrD6a5lUqxLrVEKxamEfM54xuz/4ZfEkO2P8Ew/tTT0W3
	 ScZsgVHBegkJW4LgVwYPZCRlmqoFfT+sV/7dd7DXuDy7ch9PlpTZjNr8qi6iJweArJ
	 FAT74062IIuFxYX6lAMh4UM6buLnpiMUeYFK9lgDTWlaeKjboxCNb3GRrjbHt6+tRD
	 DwZXKOIfal+R8qutYevbtkZOls47f5J9bNMNIi/P8mp/3o5aC3b1S0rAm6vCE1RKRf
	 pmr5xUrFOyEyU/QI3hmOuyU9lP6PB6ESnBxkB3PAkB2AH4OEW1mnMzwxPA+MxZxVhy
	 k9lwgQXxcWDCQ==
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
Subject: [PATCH v2 24/62] objtool: Remove .parainstructions reference
Date: Fri,  9 May 2025 13:16:48 -0700
Message-ID: <07c7b78e8589731fd808897bb67c8252765b3fa4.1746821544.git.jpoimboe@kernel.org>
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

The .parainstructions section no longer exists since the following
commit:

  60bc276b129e ("x86/paravirt: Switch mixed paravirt/alternative calls to alternatives").

Remove the reference to it.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 tools/objtool/check.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index 5e62d3ce3cc6..8a87c38516fc 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -4468,7 +4468,6 @@ static int validate_ibt(struct objtool_file *file)
 		    !strcmp(sec->name, ".altinstructions")		||
 		    !strcmp(sec->name, ".ibt_endbr_seal")		||
 		    !strcmp(sec->name, ".orc_unwind_ip")		||
-		    !strcmp(sec->name, ".parainstructions")		||
 		    !strcmp(sec->name, ".retpoline_sites")		||
 		    !strcmp(sec->name, ".smp_locks")			||
 		    !strcmp(sec->name, ".static_call_sites")		||
-- 
2.49.0


