Return-Path: <live-patching+bounces-1551-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D35EAEAB2F
	for <lists+live-patching@lfdr.de>; Fri, 27 Jun 2025 02:00:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F0A306415EC
	for <lists+live-patching@lfdr.de>; Thu, 26 Jun 2025 23:59:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71F5126E702;
	Thu, 26 Jun 2025 23:56:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W2UbSC4v"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49E8926E6EB;
	Thu, 26 Jun 2025 23:56:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750982186; cv=none; b=A1xkvQ9NnVVEpaLoSWo/6odhr8LbSEhvf82C6ysr9JfdCPiZx8WB6Bz/0cmrNXjQNbS9Gtdby2kjV00VKQUp2p9ix7aTKu6DC6+PsZwjk9pFTsVqcfE9LgfYlo/cDukJT6jbRFDMTXVjdMekktg+p9AoKjdNjstfngOAH6BWM04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750982186; c=relaxed/simple;
	bh=EEbRNrkZNmc3DOlm0NvHIu3FdyHjAZmbTF0DOJ/GU20=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j6hCXecNTK7IyFrboEQxhoUi9Y9yX996Mske5U8pLypeg9V28Hww7Z4vDgYfRuRJELE3ERlCXw9rKd5EsJeXifl/NCXpqgvuG9WHAkr8z4gUJ6M+7tMQD4ikTcY3xDfxOn2HuiJdqKPKwPqrTiNxBNciA4Vib3gP8UnTweVFb3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=W2UbSC4v; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 947B6C4CEF0;
	Thu, 26 Jun 2025 23:56:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750982186;
	bh=EEbRNrkZNmc3DOlm0NvHIu3FdyHjAZmbTF0DOJ/GU20=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W2UbSC4vng7Msd6+3/MdC4cNeMjLYnxsqbKCCmjlRMMNbv8dVdoys3y4Grx/BsuCM
	 47NGwNtZq2SYX8uvGbp39vw+yqmSikJzjo+V8zAjFFxUcYgJe5X49jeqDQW9lGh+pg
	 3VFKmw0NCic6YI1kQKY+A0Alomb5LvZzN/n9ucaPrw9lbwYCCKd5vZLJKwvvbnyNUs
	 P22QzYrhvN1+xFAePH3gcly6/MfpJSimJntW/FLQPU+1WLGHECdO6Q9RhnN/yQsovP
	 177OS69KmqpUwuK81sc+wg60wIuD0XCPtYQeMasZjMfl9Zd9SbHVbgbQdDlTn8Yo88
	 lEK0EINYS33tw==
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
	Dylan Hatch <dylanbhatch@google.com>
Subject: [PATCH v3 21/64] objtool: Check for missing annotation entries in read_annotate()
Date: Thu, 26 Jun 2025 16:55:08 -0700
Message-ID: <8ccb86bda68d31f29137ee25d027e9d293307327.1750980517.git.jpoimboe@kernel.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1750980516.git.jpoimboe@kernel.org>
References: <cover.1750980516.git.jpoimboe@kernel.org>
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
index b5257a959458..fe18f9f5dbef 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -2292,6 +2292,11 @@ static int read_annotate(struct objtool_file *file,
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


