Return-Path: <live-patching+bounces-1380-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AA97FAB1DF5
	for <lists+live-patching@lfdr.de>; Fri,  9 May 2025 22:22:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EA7C11C28689
	for <lists+live-patching@lfdr.de>; Fri,  9 May 2025 20:21:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4109F268FCC;
	Fri,  9 May 2025 20:17:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KEBTdoAC"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17E4D268C49;
	Fri,  9 May 2025 20:17:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746821879; cv=none; b=LWI0uWNs4nKN8UxhwD+v0TvYCZRiyNLOLUKuM+ebWd8EDJkOvcLinW3iQ72SFz/8h/u2LqwPKECCxX3ADJJ+hhYyuOzVZJbnchTVORN1fwxh8f8uGdqOczpV4jdAL0dWBAS8XC9lFrA3jpYN6C0eRNjLt4P95FTECcUMm4C1Jmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746821879; c=relaxed/simple;
	bh=iZPpW5B7vyUX5hbIoVsgCqQOfefHFHuE1LOhfhu9YJA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X8++w96U9lR7tipf738bfWTFPDjB8PPXHBGujrG7qPAXUyMO2oJSLnB793RptkNgkK6rv69Yytcq18NXkmftsqJRoaqIzFxViUB5tDWz5WMB3REBhb3bBc84ijq7fYNZmG6JTgjnVm9iquk/4WsUhrql65O1FYMtpmb7WfXm5ig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KEBTdoAC; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1425AC4CEEE;
	Fri,  9 May 2025 20:17:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746821878;
	bh=iZPpW5B7vyUX5hbIoVsgCqQOfefHFHuE1LOhfhu9YJA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KEBTdoACkOPyw6/6J7N1MGQEj5amg39fjHY3msAcm8rc613gunwTa+LTvCWN4g2Oz
	 NARMK2sY+ijTaTM8LLGXiePQCpBv1FRR2sdxjwaoYxndVaTKtRyJUu57NZLo4XIG9K
	 3w4EFuNLWvt87o9nNeCaap5TSJ1wnjxmwPk1Yqcgzxlscn6FCiBRF7EJNnu0qv2wKK
	 CTFMDnehrWHNiEulTaHLG0HgZYs9wu2AvelEnq88vRYExzc+Cl2OGBwKuhvJTNHZck
	 Y+f3x8iFZz1mJluB9VRkw0UXbddYyBPfkDdBYnBIaBMMaA+R1fgkj+r3OrzTB7GYem
	 RW2o+QRxi/rsA==
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
Subject: [PATCH v2 21/62] objtool: Check for missing annotation entries in read_annotate()
Date: Fri,  9 May 2025 13:16:45 -0700
Message-ID: <ab0c9cae8a5fed5b1fd54eb930f92f5ab7124e62.1746821544.git.jpoimboe@kernel.org>
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

Add a sanity check to make sure none of the relocations for the
.discard.annotate_insn section have gone missing.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 tools/objtool/check.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index 53793b9ea974..0cdc2fc85439 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -2314,6 +2314,11 @@ static int read_annotate(struct objtool_file *file,
 		sec->sh.sh_entsize = 8;
 	}
 
+	if (sec_num_entries(sec) != sec_num_entries(sec->rsec)) {
+		ERROR("bad .discard.annotate_insn section: missing relocs");
+		return -1;
+	}
+
 	for_each_reloc(sec->rsec, reloc) {
 		type = *(u32 *)(sec->data->d_buf + (reloc_idx(reloc) * sec->sh.sh_entsize) + 4);
 
-- 
2.49.0


